# 菜谱账本 - 项目规则

## 🎯 项目目标
- 开发一个跨平台的菜品单价查询与菜谱管理应用
- 支持离线使用和富文本编辑
- 遵循Flutter现代化最佳实践，避免嵌套地狱

## 📚 技术栈规范
### Flutter开发（现代化实践）
- **状态管理**：使用Provider，避免setState滥用导致嵌套
- **代码结构**：按功能模块组织，单一职责原则
- **命名规范**：
  - Dart文件：snake_case.dart
  - 类名：PascalCase（如：Dish, Recipe, RecipeIngredient）
  - 变量/函数：camelCase
  - 常量：UPPER_CASE_WITH_UNDERSCORES
  - 私有成员：_privateVariable

### 代码质量
- **注释要求**：公共API必须包含文档注释（///）
- **错误处理**：所有异步操作必须包含try-catch，提供用户友好的错误提示
- **空安全**：启用null safety，避免使用!强制解包
- **类型推断**：优先使用final和const，避免var
- **函数长度**：单个函数不超过30行，超过则应拆分

### 嵌套规范（防止嵌套地狱）
- **最大嵌套深度**：Widget树嵌套不超过5层
- **解决方案**：
  1. 使用`extract widget`快捷键（VS Code: Ctrl+. → Extract Widget）
  2. 复杂UI拆分为多个StatelessWidget
  3. 使用Builder模式（如ListView.builder）
  4. 避免在build方法中直接写大量布局代码
- **检查标准**：
  ```dart
  // ❌ 避免：嵌套过深
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  child: Text('...'), // 已嵌套5层
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 推荐：提取子组件
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: const [
          _TitleSection(),
          _ContentSection(),
          _ActionSection(),
        ],
      ),
    );
  }
  ```

### 依赖管理
- **版本锁定**：pubspec.yaml中使用具体版本号（如：^4.0.0）
- **新增依赖**：需评估包大小、活跃度和兼容性
- **禁止**：使用已废弃或不再维护的包

## 🔧 开发流程规则
### Git协作（简化版）
- **分支策略**：
  - `main`: 稳定版本分支，保护分支
  - `develop`: 开发分支，所有功能合并到此分支
  - 直接在develop分支开发，或创建短期功能分支
- **提交信息**：使用中文描述，格式：`类型: 描述`
  - `feat:` 新功能
  - `fix:` 修复bug
  - `docs:` 文档更新
  - `style:` 代码格式调整（不影响功能）
  - `refactor:` 重构代码
  - `test:` 添加或修改测试
  - `chore:` 构建过程或辅助工具的变动

### 代码审查
- **PR要求**：
  1. 必须有测试覆盖（新功能）
  2. 必须通过`flutter analyze`
  3. 必须通过`flutter test`
  4. UI变更需提供截图
  5. 符合CLAUDE.md中的编码规范，特别是嵌套深度

## 📱 项目特定规则
### 数据层规范
- **模型类**：必须实现`toJson()`和`fromJson()`方法，支持序列化
- **Hive存储**：
  - 每个模型定义唯一TypeId，从100开始递增
  - Dish: 100, Recipe: 101, RecipeIngredient: 102, UserSettings: 103
- **单位换算**：
  - 所有价格统一存储为"元/克"
  - 显示时根据UserSettings进行转换
  - 转换公式：1斤=500克，1公斤=1000克
- **数据验证**：用户输入必须进行验证（非空、范围、格式）

### UI/UX规范（现代化Flutter）
- **响应式设计**：使用LayoutBuilder、MediaQuery、FractionallySizedBox
- **主题一致**：
  - 使用ThemeData统一管理主题
  - 使用TextTheme定义文本样式
- **组件提取**：任何超过30行build方法的Widget必须提取为独立组件
- **状态分离**：UI组件尽量使用StatelessWidget，状态交给Provider
- **加载状态**：使用FutureBuilder/StreamBuilder处理异步状态

### 目录结构
```
lib/
├── models/           # 数据模型（Dish, Recipe等）
├── services/         # 业务逻辑（DishService, RecipeService等）
├── providers/        # 状态管理（AppProvider, SettingsProvider等）
├── pages/            # 页面组件
│   ├── dish/         # 菜品相关页面
│   ├── recipe/       # 菜谱相关页面
│   └── settings/     # 设置页面
├── widgets/          # 可复用组件（避免嵌套的关键）
├── utils/            # 工具类（单位转换、格式化等）
├── constants/        # 常量定义
└── main.dart         # 应用入口
```

## 🚫 禁止事项
- 禁止直接修改main分支（必须通过PR合并develop）
- 禁止提交.env、.key等敏感文件
- 禁止使用过时的API（如已弃用的Flutter方法）
- 禁止硬编码字符串（使用intl国际化或constants）
- 禁止在UI层编写复杂业务逻辑（应放在services层）
- 禁止魔法数字（使用命名常量）
- **禁止嵌套地狱**：超过5层嵌套必须重构

## 🤖 Claude Code 特定指令
### 代码生成偏好
- 优先使用StatelessWidget，除非需要内部状态
- 使用const构造函数优化性能
- 避免不必要的重建（使用const、shouldRepaint）
- **优先提取组件**：当发现嵌套超过3层时，主动建议提取widget

### 重构建议
- 当发现嵌套超过5层时，必须重构
- 当方法过长时（>30行），建议拆分为多个小方法
- 当组件职责不单一（超过2个主要功能），建议拆分
- 当发现多个相似组件时，建议提取基类或使用参数化组件

### 测试要求
- 所有模型类必须有单元测试
- 核心业务逻辑（services）测试覆盖率>80%
- Widget测试覆盖主要交互流程
- 测试嵌套组件时，使用find.byType或find.byKey

## 📞 紧急处理
如遇以下情况，先询问用户：
1. 涉及重大架构变更（如更换状态管理方案）
2. 删除超过100行代码
3. 引入新的第三方包（特别是大型依赖）
4. 修改数据库迁移逻辑
5. 发现无法解决的嵌套问题

## 🔍 现代化Flutter技巧（针对长期未开发用户）
### 1. 避免嵌套的新特性
- **使用`..`级联操作符**：减少临时变量
- **使用`const`构造函数**：减少重建
- **使用`late`关键字**：延迟初始化，避免空检查嵌套
- **使用空安全操作符`?.`、`??`**：简化空值处理

### 2. 布局优化
- **使用`Expanded`和`Flexible`**：替代复杂的嵌套
- **使用`ListView.builder`**：处理长列表，避免Column+List
- **使用`Stack`和`Positioned`**：替代多层Container定位
- **使用`Align`和`Center`**：替代Container+alignment

### 3. 状态管理现代化
- **使用`Consumer`选择性重建**：替代整个页面重建
- **使用`Selector`精确监听**：只监听需要的状态变化
- **使用`ChangeNotifier`+`ValueNotifier`**：简化状态更新

## 💡 编码示例
### 现代化实践
```dart
// ✅ 使用const和提取组件
class DishCard extends StatelessWidget {
  const DishCard({super.key, required this.dish});
  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _DishImage(dish: dish),  // 提取的组件
        title: Text(dish.name),
        subtitle: _PriceDisplay(price: dish.price),  // 提取的组件
        trailing: _Actions(dish: dish),  // 提取的组件
      ),
    );
  }
}

// ✅ 使用空安全操作符
String? getUserName() => user?.name ?? '未知用户';

// ✅ 使用late初始化
class RecipeService {
  late final ApiClient _client;

  RecipeService() {
    _client = ApiClient(); // 延迟初始化
  }
}
```

### 嵌套重构示例
```dart
// ❌ 重构前：嵌套地狱
Widget _buildOldStyle() {
  return Container(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Row(
          children: [
            Icon(Icons.restaurant),
            SizedBox(width: 8),
            Text('菜品详情', style: TextStyle(fontSize: 18)),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('名称: ${dish.name}'),
              SizedBox(height: 8),
              Text('价格: ${dish.price} 元/g'),
              // 更多嵌套...
            ],
          ),
        ),
      ],
    ),
  );
}

// ✅ 重构后：提取组件
Widget _buildModernStyle() {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: const [
        _TitleSection(),
        SizedBox(height: 16),
        _DishInfoCard(),
      ],
    ),
  );
}
```
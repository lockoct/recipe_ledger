# 菜谱账本应用

基于Flutter开发的菜谱账本应用，支持菜品单价查询、菜谱管理、富文本做法编辑及离线数据支持。

## 功能特点

- 🥘 **菜品管理**：菜品单价查询、价格趋势展示、分类筛选
- 📖 **菜谱管理**：菜谱创建、编辑、封面上传、原材料管理
- ✏️ **富文本编辑**：支持格式化文本、列表、图片插入
- 💰 **多单位切换**：支持元/斤、元/公斤等价格单位
- 💾 **离线支持**：本地数据存储，无网络时正常使用

## 技术栈

- **Flutter** - 跨平台移动应用框架
- **Dart** - 开发语言
- **Provider** - 状态管理
- **Hive** - 本地数据存储
- **flutter_quill** - 富文本编辑器

## 项目结构

```
lib/
├── pages/           # 页面模块
│   ├── dish/        # 菜品模块（详情参考 pages/dish/README.md）
│   ├── recipe/      # 菜谱模块（详情参考 pages/recipe/README.md）
│   ├── profile/     # 个人中心模块（详情参考 pages/profile/README.md）
│   └── settings/    # 设置模块（详情参考 pages/settings/README.md）
├── providers/       # 状态管理
├── models/          # 数据模型
├── services/        # 业务服务
├── widgets/         # 通用组件
├── constants/       # 常量定义
└── utils/           # 工具函数
```

## 页面导航

应用采用底部导航栏设计，包含三个主要入口：

| 导航项 | 页面 | 功能 |
|--------|------|------|
| 菜品 | DishListPage | 菜品列表、搜索、分类筛选 |
| 菜谱 | RecipeGridPage | 菜谱网格、添加新菜谱 |
| 我的 | ProfilePage | 用户中心、设置入口 |

## 模块指引

各模块的详细实现说明请参考对应目录下的 README.md：

- **菜品模块**：[pages/dish/README.md](lib/pages/dish/README.md)
- **菜谱模块**：[pages/recipe/README.md](lib/pages/recipe/README.md)
- **个人中心模块**：[pages/profile/README.md](lib/pages/profile/README.md)
- **设置模块**：[pages/settings/README.md](lib/pages/settings/README.md)
- **页面架构总览**：[pages/README.md](lib/pages/README.md)

## 快速开始

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run

# 构建发布版本
flutter build apk
```

## 开发计划

- ✅ 基础架构搭建
- ✅ 菜品列表页面
- ✅ 菜谱管理功能
- ✅ 富文本编辑器集成
- ✅ 单位切换功能
- ✅ 离线数据存储

## 后续扩展

- 后端API对接
- 用户认证系统
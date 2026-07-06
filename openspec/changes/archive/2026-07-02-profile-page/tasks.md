## 1. 页面框架搭建

- [x] 1.1 创建 `lib/pages/profile/profile_page.dart`，定义 `ProfilePage` StatelessWidget
- [x] 1.2 使用 AnnotatedRegion 配置状态栏样式（主题色背景、浅色图标）
- [x] 1.3 搭建 Scaffold + Container 渐变背景 + SingleChildScrollView + Column 布局结构
- [x] 1.4 配置 LinearGradient 渐变（stops: [0.0, 0.25, 0.8, 1.0]，主题色 → 主题色 → #F6F6F6 → #F6F6F6）

## 2. 用户信息卡片实现

- [x] 2.1 实现用户信息卡片 Container（padding: top 40, left 16, right 16, bottom 16）
- [x] 2.2 实现白色圆形头像 Container（64x64，BoxShape.circle，内含主题色 Icons.person 图标）
- [x] 2.3 显示用户名"用户"（titleLarge 白色字体）和欢迎语"欢迎使用菜谱账本"（bodyMedium 90%白色不透明度）

## 3. 功能列表实现

- [x] 3.1 实现白色卡片容器（margin: horizontal 16，borderRadius: 12，boxShadow）
- [x] 3.2 实现单位切换 ListTile（Icons.tune、"单位切换"、"切换价格显示单位"、Icons.chevron_right）
- [x] 3.3 实现初始化模拟数据 ListTile（Icons.refresh、"初始化模拟数据"、"清空并重新生成菜品和菜谱数据"）
- [x] 3.4 实现关于 ListTile（Icons.info_outline、"关于"、"应用信息和版本"）
- [x] 3.5 实现帮助 ListTile（Icons.help_outline、"帮助"、"使用帮助和常见问题"）
- [x] 3.6 每项之间添加 0.5px 灰色 Divider（indent: 16, endIndent: 16）

## 4. 单位切换导航

- [x] 4.1 点击单位切换时通过 Navigator.push 导航至 UnitSwitchPage

## 5. 初始化模拟数据对话框

- [x] 5.1 使用 showDialog + StatefulBuilder 实现多状态对话框
- [x] 5.2 实现确认对话框：标题"初始化模拟数据"，内容"此操作将清空所有菜品和菜谱数据，并重新生成模拟数据。确定继续吗？"，取消/确定按钮
- [x] 5.3 实现加载中状态：CircularProgressIndicator + "正在清空并重新生成数据..."文案
- [x] 5.4 调用 DataInitializationService().initializeAllMockData() 执行初始化
- [x] 5.5 实现成功状态：显示"模拟数据已初始化完成。"，点击确定关闭
- [x] 5.6 实现失败状态：显示"初始化过程中发生错误: {error}"，点击确定关闭

## 6. 关于对话框

- [x] 6.1 点击关于时弹出 AlertDialog，标题"关于菜谱账本"
- [x] 6.2 内容显示版本号"1.0.0"、应用介绍、离线使用说明

## 7. 帮助对话框

- [x] 7.1 点击帮助时弹出 AlertDialog，标题"使用帮助"
- [x] 7.2 内容显示"如何使用菜谱账本:"及三条使用步骤

## 8. 底部导航集成

- [x] 8.1 将 ProfilePage 注册到底部导航栏"我的"标签页
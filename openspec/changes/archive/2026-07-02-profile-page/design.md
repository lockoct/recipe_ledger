## Context

个人中心页是 RecipeLedger Flutter 应用底部导航的第三个标签页（"我的"），作为用户设置和应用信息的统一入口。页面采用 Flutter + Provider 架构，整体风格简洁，顶部为主题色渐变背景过渡到底部灰色，功能列表使用白色卡片样式。

## Goals / Non-Goals

**Goals:**
- 展示用户信息卡片（圆形头像、用户名、欢迎语），背景主题色渐变
- 提供功能列表：单位切换、初始化模拟数据、关于、帮助
- 单位切换导航至 `UnitSwitchPage`
- 初始化模拟数据支持确认对话框、加载中、成功、失败四种状态
- 关于和帮助以 AlertDialog 展示
- 状态栏颜色与主题色一致，图标为浅色

**Non-Goals:**
- 用户登录/注册功能
- 用户头像上传功能
- 用户资料编辑功能
- 消息通知功能
- 数据同步/备份功能

## Decisions

### 1. 页面架构：StatelessWidget + AnnotatedRegion

使用 StatelessWidget 构建页面，通过 AnnotatedRegion 配置状态栏样式。主体布局使用 Scaffold + Container（渐变背景）+ SingleChildScrollView + Column。

**理由**：ProfilePage 没有需要管理的内部状态，所有交互通过对话框（showDialog）处理，不需要 StatefulWidget。AnnotatedRegion 是 Flutter 中配置状态栏样式的标准方式。

### 2. 背景渐变：LinearGradient + stops 控制

使用 LinearGradient 从顶部主题色渐变到底部灰色（#F6F6F6），通过 stops 参数控制渐变位置：顶部 0-25% 保持主题色，25%-80% 过渡，80%-100% 为灰色。Scaffold 的 backgroundColor 同样设置为 #F6F6F6，与渐变底部保持一致。

**理由**：stops 参数可以精确控制渐变过渡区域，让用户信息卡片区域保持主题色，功能列表区域为灰色背景，视觉层次清晰。

### 3. 用户信息卡片：Container + Row

用户信息卡片使用 Container 包裹 Row 布局，左侧为白色圆形头像（带主题色图标），右侧为用户名和欢迎语。卡片顶部 padding 为 40px 以考虑状态栏高度。

**理由**：简单的 Row 布局足以满足需求，无需额外的卡片组件。40px 顶部 padding 确保内容不被状态栏遮挡。

### 4. 功能列表：Container + Column + ListTile

功能列表使用白色 Container 包裹，圆角 12px，包含 4 个 ListTile 项，每项之间用 Divider 分隔。每个 ListTile 包含图标、标题、副标题和右侧箭头。

**理由**：ListTile 是 Flutter 内置的列表项组件，自带图标、标题、副标题和 trailing 布局，完全满足需求。白色卡片 + 圆角 + 轻微阴影的设计与菜品列表页风格一致。

### 5. 初始化模拟数据：StatefulBuilder 嵌套对话框

初始化模拟数据使用 StatefulBuilder 包裹 AlertDialog，在对话框内部管理加载状态。点击确认后显示加载中状态（CircularProgressIndicator），完成后显示成功或失败。

**理由**：StatefulBuilder 允许在 StatelessWidget 的 showDialog 回调中使用 setState 管理对话框内部状态，无需创建额外的 StatefulWidget。

### 6. 关于/帮助对话框：AlertDialog

关于和帮助功能使用简单的 AlertDialog，前者展示版本号和应用介绍，后者展示使用步骤。

**理由**：AlertDialog 是 Flutter 标准对话框组件，API 简洁，适合展示静态信息内容。

## Risks / Trade-offs

- **[Risk] 初始化模拟数据耗时较长** → 在对话框中显示 CircularProgressIndicator 加载状态，告知用户正在处理
- **[Risk] 初始化过程中用户关闭对话框** → 初始化操作是异步的，关闭对话框不会中断操作，极端情况下可能出现数据不一致。当前假设用户会等待完成，后续可考虑添加取消机制
- **[Trade-off] 用户信息为静态展示** → 当前用户名写死为"用户"，头像为固定图标。这样做简化了实现，但后续如需支持用户登录，需要重构用户信息卡片
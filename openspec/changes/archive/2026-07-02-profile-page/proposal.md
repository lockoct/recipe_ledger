## Why

个人中心页是底部导航栏的第三个标签页，作为用户设置和应用信息的统一入口。用户需要一个清晰、简洁的页面来访问单位切换、查看应用信息和使用帮助。

## What Changes

- 新增个人中心页 `ProfilePage`，作为底部导航"我的"标签页
- 顶部展示用户信息卡片（圆形头像、用户名、欢迎语），背景为主题色渐变过渡到底部灰色
- 提供功能列表入口：单位切换、初始化模拟数据、关于、帮助
- 单位切换可跳转至 `UnitSwitchPage`
- 初始化模拟数据弹出确认对话框，支持加载中/成功/失败三种状态
- 关于对话框展示版本号和应用介绍
- 帮助对话框展示使用步骤说明
- 状态栏颜色与主题色一致，图标为浅色

## Capabilities

### New Capabilities

- `profile-page`: 个人中心页，展示用户信息卡片和功能列表入口，提供单位切换、模拟数据初始化、关于和帮助功能

### Modified Capabilities

<!-- 无现有 specs 需要修改 -->

## Impact

- 新增文件：`lib/pages/profile/profile_page.dart`（页面组件）
- 依赖现有页面：`UnitSwitchPage`（单位切换页面）
- 依赖现有 Provider：`AppProvider`（主题色/应用状态）
- 依赖现有服务：`DataInitializationService`（模拟数据初始化）
- 依赖底部导航：`NavigationProvider` 中已注册"我的"标签页
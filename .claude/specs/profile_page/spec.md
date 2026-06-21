# 个人中心页 (ProfilePage) - 产品需求文档

## Overview
- **Summary**: 个人中心页是 RecipeLedger 应用的用户中心页面
- **Purpose**: 为用户提供统一的个人设置和应用信息入口
- **Target Users**: 所有应用用户

## Goals
- [x] 展示用户信息卡片
- [x] 提供单位切换功能入口
- [x] 提供初始化模拟数据功能
- [x] 提供关于对话框
- [x] 提供帮助对话框
- [x] 支持底部导航切换

## Non-Goals (Out of Scope)
- [ ] 用户登录/注册功能
- [ ] 用户头像上传功能
- [ ] 用户资料编辑功能
- [ ] 消息通知功能
- [ ] 数据同步/备份功能

## Background & Context
- 个人中心页是底部导航三个标签页之一
- 采用 Flutter + Provider 架构
- 顶部使用渐变背景设计

## Functional Requirements
- FR-1: 页面顶部展示用户信息卡片
- FR-2: 头像使用圆形设计
- FR-3: 用户名显示用户
- FR-4: 欢迎语显示欢迎使用菜谱账本
- FR-5: 页面提供功能列表
- FR-6: 点击单位切换跳转页面
- FR-7: 点击初始化模拟数据弹出确认对话框
- FR-8: 点击关于弹出关于对话框
- FR-9: 点击帮助弹出帮助对话框
- FR-10: 状态栏颜色与主题色一致

## Non-Functional Requirements
- NFR-1: 页面加载时间 < 1秒
- NFR-2: 适配不同屏幕尺寸
- NFR-3: 点击响应时间 < 200ms
- NFR-4: 对话框显示流畅

## Constraints
- Technical: Flutter 3.x、Dart 3.x、Provider
- Business: 初始化模拟数据仅供开发测试
- Dependencies: AppProvider、DataInitializationService

## Assumptions
- [x] 用户已进入主界面
- [x] 应用主题色已配置
- [x] 用户数据存储在本地

## Acceptance Criteria

### AC-1: 用户信息卡片显示
- Given: 用户进入个人中心页
- When: 页面加载完成
- Then: 显示用户信息卡片
- Verification: human-judgment

### AC-2: 头像设计
- Given: 用户进入个人中心页
- When: 页面展示用户信息卡片
- Then: 头像为白色圆形背景
- Verification: human-judgment

### AC-3: 单位切换功能
- Given: 用户在个人中心页
- When: 用户点击单位切换
- Then: 跳转到单位切换页面
- Verification: human-judgment

### AC-4: 初始化模拟数据
- Given: 用户在个人中心页
- When: 用户点击初始化模拟数据
- Then: 弹出确认对话框
- Verification: human-judgment

### AC-5: 初始化失败处理
- Given: 用户确认初始化
- When: 初始化过程发生错误
- Then: 显示失败提示对话框
- Verification: human-judgment

### AC-6: 关于对话框
- Given: 用户在个人中心页
- When: 用户点击关于
- Then: 弹出关于对话框
- Verification: human-judgment

### AC-7: 帮助对话框
- Given: 用户在个人中心页
- When: 用户点击帮助
- Then: 弹出帮助对话框
- Verification: human-judgment

### AC-8: 状态栏样式
- Given: 用户进入个人中心页
- When: 页面显示
- Then: 状态栏颜色为主题色
- Verification: human-judgment

### AC-9: 页面背景设计
- Given: 用户进入个人中心页
- When: 页面显示
- Then: 顶部主题色渐变，底部灰色
- Verification: human-judgment

### AC-10: 底部导航切换
- Given: 用户在其他标签页
- When: 用户点击底部我的
- Then: 切换到个人中心页
- Verification: human-judgment

## Open Questions
- [ ] 是否需要添加用户登录功能？
- [ ] 是否需要添加用户头像上传功能？
- [ ] 是否需要添加数据同步/备份功能？
- [ ] 是否需要添加消息通知入口？

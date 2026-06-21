# 菜谱详情页 (RecipeDetailPage) - 实现计划

## [x] Task 1: 页面框架搭建
- Priority: P0
- Depends On: None
- Description: 创建 recipe_detail_page.dart 页面组件，配置 StatefulWidget，搭建整体布局结构
- Acceptance Criteria Addressed: [AC-1, AC-2, AC-25]
- Test Requirements:
  - human-judgement TR-1.1: 页面能正常启动
  - human-judgement TR-1.2: 页面布局结构清晰

## [x] Task 2: 封面图片展示
- Priority: P0
- Depends On: Task 1
- Description: 实现封面图片展示（网络图片、本地文件、默认图标）
- Acceptance Criteria Addressed: [AC-3, AC-4]
- Test Requirements:
  - human-judgement TR-2.1: 网络图片正确展示
  - human-judgement TR-2.2: 本地文件正确展示
  - human-judgement TR-2.3: 无封面时显示默认图标

## [x] Task 3: 浮动操作按钮
- Priority: P0
- Depends On: Task 1
- Description: 实现返回、编辑、删除三个浮动按钮
- Acceptance Criteria Addressed: [AC-5, AC-6, AC-8]
- Test Requirements:
  - human-judgement TR-3.1: 返回按钮功能正常
  - human-judgement TR-3.2: 编辑按钮跳转正常
  - human-judgement TR-3.3: 删除按钮弹出确认对话框

## [x] Task 4: 菜谱信息展示
- Priority: P0
- Depends On: Task 1
- Description: 展示菜谱名称和更新时间
- Acceptance Criteria Addressed: [AC-12, AC-13]
- Test Requirements:
  - human-judgement TR-4.1: 菜谱名称正确显示
  - human-judgement TR-4.2: 更新时间格式正确

## [x] Task 5: 原材料列表展示
- Priority: P0
- Depends On: Task 1
- Description: 展示原材料列表，包含名称、用量和成本
- Acceptance Criteria Addressed: [AC-14, AC-15, AC-16, AC-17, AC-18, AC-19, AC-20, AC-21]
- Test Requirements:
  - human-judgement TR-5.1: 原材料列表正确展示
  - human-judgement TR-5.2: 成本计算正确

## [x] Task 6: 做法步骤展示
- Priority: P0
- Depends On: Task 1
- Description: 实现只读富文本展示做法步骤
- Acceptance Criteria Addressed: [AC-22]
- Test Requirements:
  - human-judgement TR-6.1: 做法步骤正确展示

## [x] Task 7: 注意事项展示
- Priority: P0
- Depends On: Task 1
- Description: 实现只读富文本展示注意事项（可选）
- Acceptance Criteria Addressed: [AC-23, AC-24]
- Test Requirements:
  - human-judgement TR-7.1: 有注意事项时正确展示
  - human-judgement TR-7.2: 无注意事项时隐藏区域

## [x] Task 8: 编辑功能
- Priority: P0
- Depends On: Task 3
- Description: 实现编辑跳转和返回刷新
- Acceptance Criteria Addressed: [AC-6, AC-7]
- Test Requirements:
  - human-judgement TR-8.1: 编辑页面跳转正常
  - human-judgement TR-8.2: 返回后自动刷新

## [x] Task 9: 删除功能
- Priority: P0
- Depends On: Task 3
- Description: 实现删除确认、删除操作和提示
- Acceptance Criteria Addressed: [AC-8, AC-9, AC-10, AC-11]
- Test Requirements:
  - human-judgement TR-9.1: 删除确认对话框正常
  - human-judgement TR-9.2: 删除成功返回并提示
  - human-judgement TR-9.3: 删除失败显示错误提示

## [x] Task 10: 成本计算逻辑
- Priority: P0
- Depends On: Task 5
- Description: 实现原材料成本计算（用量转换为斤）
- Acceptance Criteria Addressed: [AC-19, AC-20]
- Test Requirements:
  - human-judgement TR-10.1: 成本计算正确
  - human-judgement TR-10.2: 合计成本正确显示

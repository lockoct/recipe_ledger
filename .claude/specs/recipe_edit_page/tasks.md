# 菜谱编辑页 (RecipeEditPage) - 实现计划

## [x] Task 1: 页面框架搭建
- Priority: P0
- Depends On: None
- Description: 创建 recipe_edit_page.dart 页面组件，配置 StatefulWidget，搭建整体布局结构
- Acceptance Criteria Addressed: [AC-1, AC-2, AC-4]
- Test Requirements:
  - human-judgement TR-1.1: 页面能正常启动
  - human-judgement TR-1.2: 页面布局结构清晰

## [x] Task 2: 封面图片选择实现
- Priority: P0
- Depends On: Task 1
- Description: 实现封面图片选择和显示
- Acceptance Criteria Addressed: [AC-5, AC-6]
- Test Requirements:
  - human-judgement TR-2.1: 点击封面能打开图片选择器
  - human-judgement TR-2.2: 选择后封面正确显示

## [x] Task 3: 菜谱名称输入
- Priority: P0
- Depends On: Task 1
- Description: 实现菜谱名称输入和验证
- Acceptance Criteria Addressed: [AC-7, AC-8]
- Test Requirements:
  - human-judgement TR-3.1: 输入框能正常输入
  - human-judgement TR-3.2: 名称为空时验证失败

## [x] Task 4: 原材料管理
- Priority: P0
- Depends On: Task 1
- Description: 实现原材料的添加、编辑、删除
- Acceptance Criteria Addressed: [AC-9, AC-13, AC-14, AC-15]
- Test Requirements:
  - human-judgement TR-4.1: 原材料能正常添加
  - human-judgement TR-4.2: 原材料能正常编辑
  - human-judgement TR-4.3: 原材料能正常删除

## [x] Task 5: AddIngredientDialog 实现
- Priority: P0
- Depends On: Task 4
- Description: 实现添加原材料对话框，支持菜品和自定义两种类型
- Acceptance Criteria Addressed: [AC-10, AC-11, AC-12]
- Test Requirements:
  - human-judgement TR-5.1: 菜品模式能选择菜品
  - human-judgement TR-5.2: 自定义模式能输入名称

## [x] Task 6: 富文本编辑器
- Priority: P0
- Depends On: Task 1
- Description: 集成 flutter_quill 实现做法步骤和注意事项富文本编辑
- Acceptance Criteria Addressed: [AC-16, AC-17, AC-19]
- Test Requirements:
  - human-judgement TR-6.1: 富文本编辑流畅
  - human-judgement TR-6.2: 工具栏在聚焦时显示

## [x] Task 7: 图片插入功能
- Priority: P0
- Depends On: Task 6
- Description: 实现富文本中插入图片功能
- Acceptance Criteria Addressed: [AC-18]
- Test Requirements:
  - human-judgement TR-7.1: 能从相册选择图片插入

## [x] Task 8: 表单验证和提交
- Priority: P0
- Depends On: Task 1
- Description: 实现表单验证和提交保存
- Acceptance Criteria Addressed: [AC-20, AC-21, AC-22, AC-23]
- Test Requirements:
  - human-judgement TR-8.1: 验证失败显示提示
  - human-judgement TR-8.2: 保存成功返回并提示

## [x] Task 9: 编辑模式数据加载
- Priority: P0
- Depends On: Task 1
- Description: 实现编辑模式下的数据加载
- Acceptance Criteria Addressed: [AC-3, AC-24]
- Test Requirements:
  - human-judgement TR-9.1: 编辑模式正确加载数据
  - human-judgement TR-9.2: 加载失败显示提示

## [x] Task 10: RecipeIngredient 模型
- Priority: P0
- Depends On: None
- Description: 定义 RecipeIngredient 模型类
- Acceptance Criteria Addressed: [AC-11, AC-12]
- Test Requirements:
  - human-judgement TR-10.1: 模型字段完整
  - human-judgement TR-10.2: 序列化正常

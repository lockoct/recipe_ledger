## Why

菜品列表页展示的是菜品摘要信息，用户需要进入详情页才能查看菜品的完整信息（多张图片、基本信息标签）和价格趋势图表。详情页是用户从浏览到深度了解菜品价格走势的关键入口。

## What Changes

- 新增菜品详情页 `DishDetailPage`，从列表页点击菜品卡片进入
- 新增 `PriceTrendChart` 价格趋势图表组件，基于 fl_chart 实现折线图，支持数据点触摸提示和价格单位跟随
- 新增 `DateRangePicker` 日期范围选择器，基于 syncfusion_flutter_datepicker 二次封装，从顶部弹出，支持范围选择和快捷按钮（近7天/近30天）
- 顶部展示菜品图片轮播（CarouselSlider），支持自动播放和指示器
- 展示菜品名称（大字体）和当前价格（红色，跟随全局价格单位设置）
- 展示菜品基本信息标签（城市、分类）
- 支持四种页面状态：加载中、加载完成、加载失败、菜品不存在
- 左上角浮动返回按钮，半透明白色圆形背景

## Capabilities

### New Capabilities

- `dish-detail-page`: 菜品详情页，展示菜品完整信息（图片轮播、名称、价格、基本信息标签）和价格趋势图表，支持自定义日期范围查询价格历史

### Modified Capabilities

<!-- 无现有 specs 需要修改 -->

## Impact

- 新增文件：
  - `lib/pages/dish/dish_detail_page.dart`（页面组件）
  - `lib/widgets/price_trend_chart.dart`（价格趋势图表组件）
  - `lib/widgets/date_range_picker.dart`（日期范围选择器组件）
- 依赖现有模型：`Dish`（菜品详情模型）、`DishPriceHistory`（价格历史模型）
- 依赖现有 Provider：`DishProvider`（get/getPriceHistory）、`AppProvider`（价格单位偏好）
- 新增第三方依赖：`carousel_slider`、`fl_chart`、`syncfusion_flutter_datepicker`
- 路由：从菜品列表页通过 `dishId` 参数导航进入
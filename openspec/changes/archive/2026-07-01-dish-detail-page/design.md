## Context

菜品详情页是 RecipeLedger Flutter 应用的二级页面，用户从菜品列表页点击菜品卡片后导航进入。页面需要展示菜品的图片轮播、基本信息、价格以及价格趋势图表。页面采用 Provider 状态管理，图片轮播使用 carousel_slider，图表使用 fl_chart，日期选择器使用 syncfusion_flutter_datepicker。

## Goals / Non-Goals

**Goals:**
- 通过 dishId 参数加载并展示单个菜品的完整信息
- 图片轮播支持自动播放（3秒间隔）和指示器
- 价格展示跟随全局价格单位设置（AppProvider）
- 价格趋势图表默认展示最近7天数据，支持自定义日期范围
- 日期范围选择器支持快捷选择（近7天/近30天）和手动选择
- 覆盖所有页面状态：加载中、加载完成、加载失败、菜品不存在
- 浮动返回按钮，避免传统 AppBar 遮挡轮播图

**Non-Goals:**
- 菜品编辑、删除功能
- 菜品图片全屏预览
- 多价格来源对比
- 价格预警
- 图片缓存策略（使用网络图片直接加载，后续可优化）

## Decisions

### 1. 页面布局：Stack + SingleChildScrollView

使用 Stack 布局，主体内容使用 SingleChildScrollView 包裹 Column，返回按钮通过 Positioned 浮动在左上角。轮播图高度为 `280 + statusBarHeight`，保证状态栏下方显示完整轮播图。

**理由**：轮播图延伸到状态栏区域是常见的设计模式，视觉效果好。浮动返回按钮不会遮挡轮播图内容。

### 2. 状态管理：FutureBuilder + Provider

使用 FutureBuilder 包裹整个页面内容，根据 snapshot 的 connectionState 和 hasError 判断显示不同状态。价格展示和图表通过 Consumer/context.watch 监听 AppProvider 的价格单位变化。

**理由**：DishDetailPage 的数据加载是一次性的（加载单个菜品详情），不需要像列表页那样的复杂分页状态管理，FutureBuilder 是最简洁的方案。

### 3. 图片轮播：CarouselSlider

使用 carousel_slider 库实现轮播，配置 viewportFraction=1.0（全屏宽）、autoPlay=true、autoPlayInterval=3秒。通过 onPageChanged 回调更新当前索引，驱动指示器状态。

**理由**：carousel_slider 是 Flutter 社区最成熟的轮播组件库，API 简洁，性能良好。

### 4. 价格趋势图表：新建 PriceTrendChart 组件

PriceTrendChart 作为独立 StatefulWidget，接收 dishId、region、startDate、endDate 参数，内部自行调用 DishProvider.getPriceHistory() 加载数据。通过 didUpdateWidget 检测参数变化自动重新加载。使用 fl_chart 的 LineChart 绘制折线图，数据点超过15个时隐藏圆点只显示折线，图表支持触摸显示数据点详情。

**理由**：fl_chart 是 Flutter 生态中最灵活的图表库，支持自定义触摸交互和样式。将图表逻辑封装为独立组件，职责清晰，后续其他页面也可复用。

### 5. 日期范围选择器：新建 DateRangePicker 组件

原生 Flutter 日期选择器不支持范围选择且样式不够美观。基于 syncfusion_flutter_datepicker 的 SfDateRangePicker 进行二次封装，实现以下特性：

- **从顶部弹出**：使用 showGeneralDialog + SlideTransition 实现从顶部向下滑入，而非标准底部弹出
- **范围选择**：SfDateRangePicker 原生支持 range 模式，日历上直接拖选起止日期
- **快捷按钮**：提供"近7天"和"近30天"按钮，点击后自动选中对应日期范围，再次点击取消选中
- **确定/取消**：底部固定的确定和取消按钮，用户确认后才触发回调

**理由**：syncfusion_flutter_datepicker 提供了现成的 range 选择能力，省去从零实现日历的复杂度。从顶部弹出是因为详情页价格趋势在下方，顶部弹出不会遮挡用户正在查看的内容。快捷按钮减少用户手动计算日期的操作成本。

### 6. 页面状态处理：Four-state pattern

页面支持四种状态：
- **加载中**：显示带 AppBar 的 Scaffold + CircularProgressIndicator
- **加载失败**：显示错误信息文本
- **菜品不存在**：显示"菜品不存在"提示
- **加载完成**：显示完整内容（轮播图 + 信息 + 图表）

**理由**：覆盖所有可能的加载结果，提供清晰的用户反馈。每种状态都有独立的 UI，避免空白页面。

## Risks / Trade-offs

- **[Risk] 网络图片加载失败** → 轮播图中使用 errorBuilder 显示占位图标；无封面图片时显示默认图标
- **[Risk] 价格趋势数据为空** → PriceTrendChart 内部处理空数据状态，显示"暂无价格数据"
- **[Risk] 日期范围过大导致图表性能下降** → 后端接口限制查询范围；图表端数据点超过15个时隐藏数据点圆圈，仅显示折线
- **[Trade-off] 不缓存菜品详情数据** → 每次进入详情页都重新请求，保证数据新鲜度，但增加网络请求。考虑到详情页访问频率远低于列表页，此取舍合理
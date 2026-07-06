## 1. 页面框架搭建

- [x] 1.1 创建 `dish_detail_page.dart`，定义 `DishDetailPage` StatefulWidget，接收 `dishId` 参数
- [x] 1.2 使用 FutureBuilder 包裹页面主体，根据 snapshot 状态切换显示内容
- [x] 1.3 在 initState 中初始化默认日期范围（最近7天），调用 `DishProvider.get(dishId)` 加载菜品数据

## 2. 图片轮播实现

- [x] 2.1 使用 CarouselSlider 实现图片轮播，配置 viewportFraction=1.0、autoPlay=true、autoPlayInterval=3秒
- [x] 2.2 实现轮播图指示器，Positioned 定位在轮播图底部，当前图片为白色圆点，其余为半透明白色
- [x] 2.3 处理无封面图片场景（显示灰色背景 + 占位图标）和网络图片加载失败场景（errorBuilder 显示破损图标）
- [x] 2.4 轮播图高度设置为 `280 + statusBarHeight`，延伸至状态栏下方

## 3. 菜品名称和价格展示

- [x] 3.1 展示菜品名称，使用 `Theme.of(context).textTheme.titleLarge` 字体，最多2行，超出省略
- [x] 3.2 展示菜品价格，红色字体，使用 Consumer\<AppProvider\> 监听价格单位变化
- [x] 3.3 价格为空时显示"--"，价格单位通过 `PriceUnits.getDisplayName()` 和 `UnitConverter.convertPrice()` 转换

## 4. 菜品基本信息标签

- [x] 4.1 展示城市和分类信息标签，灰色背景（Colors.grey.shade100）、圆角4px
- [x] 4.2 城市或分类字段为 null 时显示"未知"

## 5. 价格趋势图表组件创建

- [x] 5.1 创建 `price_trend_chart.dart`，定义 PriceTrendChart StatefulWidget，接收 dishId、region、startDate、endDate 参数
- [x] 5.2 在 initState 中通过 DishProvider.getPriceHistory() 加载价格历史数据
- [x] 5.3 使用 didUpdateWidget 检测参数变化，自动重新加载数据
- [x] 5.4 使用 fl_chart 的 LineChart 绘制折线图，配置曲线平滑、数据点圆点、触摸提示
- [x] 5.5 数据点超过15个时隐藏圆点，仅显示折线
- [x] 5.6 图表坐标轴跟随价格单位（AppProvider）自动转换
- [x] 5.7 处理空数据状态：显示"暂无价格数据"
- [x] 5.8 计算合理的 X 轴和 Y 轴间隔，避免标签重叠

## 6. 日期范围选择器组件创建

- [x] 6.1 创建 `date_range_picker.dart`，定义 DateRangePicker StatefulWidget
- [x] 6.2 基于 SfDateRangePicker 实现日历组件，配置 range 选择模式、中文月份格式、周一为起始日
- [x] 6.3 实现"近7天"和"近30天"快捷按钮，点击后自动选中日期范围，再次点击取消
- [x] 6.4 实现确定/取消按钮，确定后通过回调返回 DateTimeRange，取消返回 null
- [x] 6.5 实现 `showDateRangePickerBottomSheet()` 函数，使用 showGeneralDialog + SlideTransition 从顶部向下滑入
- [x] 6.6 日历样式：当天日期使用主题色，选中范围使用主题色高亮，半透明遮罩背景

## 7. 价格趋势图表集成到详情页

- [x] 7.1 在详情页中嵌入 PriceTrendChart，传入 dishId、region、startDate、endDate
- [x] 7.2 在价格趋势区域右上角放置日期范围选择按钮，显示当前选中日期范围
- [x] 7.3 点击按钮调用 showDateRangePickerBottomSheet()，选择后更新 startDate/endDate，图表自动刷新

## 8. 页面状态处理

- [x] 8.1 加载中状态：显示带 AppBar（标题"菜品详情"）的 Scaffold + CircularProgressIndicator
- [x] 8.2 加载失败状态：显示"加载失败: {error}"错误信息
- [x] 8.3 菜品不存在状态：显示"菜品不存在"提示
- [x] 8.4 加载完成状态：显示完整内容（轮播图 + 名称价格 + 信息标签 + 价格趋势）

## 9. 返回按钮实现

- [x] 9.1 使用 Positioned 在左上角放置浮动返回按钮，半透明白色圆形背景（`Colors.white.withAlpha(180)`）
- [x] 9.2 按钮位置：`top: MediaQuery.of(context).padding.top + 8, left: 16`
- [x] 9.3 点击按钮调用 `Navigator.of(context).pop()` 返回上一级页面
- [x] 9.4 配置状态栏样式：透明背景（statusBarColor: Colors.transparent）、深色图标（statusBarIconBrightness: Brightness.dark）
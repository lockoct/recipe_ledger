import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:carousel_slider/carousel_slider.dart";

import "package:recipe_ledger/providers/dish_provider.dart";
import "package:recipe_ledger/providers/app_provider.dart";
import "package:recipe_ledger/models/dish.dart";
import "package:recipe_ledger/utils/unit_converter.dart";
import "package:recipe_ledger/constants/app_constants.dart";
import "package:recipe_ledger/widgets/date_range_picker.dart";
import "package:recipe_ledger/widgets/price_trend_chart.dart";

/// 菜品详情页面
///
/// 显示菜品的详细信息和价格趋势图表。
class DishDetailPage extends StatefulWidget {
  /// 菜品ID
  final String dishId;

  const DishDetailPage({
    super.key,
    required this.dishId,
  });

  @override
  State<DishDetailPage> createState() => _DishDetailPageState();
}

class _DishDetailPageState extends State<DishDetailPage> {
  /// 开始日期
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));

  /// 结束日期
  DateTime _endDate = DateTime.now();

  /// 当前轮播索引
  int _currentImageIndex = 0;

  Future<Dish?>? _dishFuture;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day);
    _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59);
    _dishFuture = Provider.of<DishProvider>(context, listen: false).get(widget.dishId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: FutureBuilder<Dish?>(
        future: _dishFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }

          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          final dish = snapshot.data;
          if (dish == null) {
            return _buildNotFound();
          }

          return _buildContent(context, dish);
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("菜品详情"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(String error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("菜品详情"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(child: Text("加载失败: $error")),
    );
  }

  Widget _buildNotFound() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("菜品详情"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: const Center(child: Text("菜品不存在")),
    );
  }

  /// 构建菜品详情内容
  /// 
  /// 包括菜品图片轮播、名称、价格、信息、价格趋势图表
  Widget _buildContent(BuildContext context, Dish dish) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDishImage(context, dish),
                _buildNameAndPrice(context, dish),
                _buildDishInfo(context, dish),
                const SizedBox(height: 12),
                _buildPriceTrend(context, dish),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(180),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建菜品图片轮播
  Widget _buildDishImage(BuildContext context, Dish dish) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final covers = dish.covers ?? [];
    
    return SizedBox(
      width: double.infinity,
      height: 280 + statusBarHeight,
      child: covers.isEmpty
          ? Container(
              color: Colors.grey.shade200,
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
              ),
            )
          : Stack(
              children: [
                // 轮播图
                CarouselSlider(
                  options: CarouselOptions(
                    height: 280 + statusBarHeight,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                  ),
                  items: covers.map((coverPath) {
                    return Image.network(
                      coverPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                // 指示器
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: covers.asMap().entries.map((entry) {
                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == entry.key
                              ? Colors.white
                              : Colors.white.withAlpha(100),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  /// 构建菜品名称和价格
  Widget _buildNameAndPrice(BuildContext context, Dish dish) {
    final titleStyle = Theme.of(context).textTheme.titleLarge ?? const TextStyle();
    final titleFontSize = titleStyle.fontSize ?? 22;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          // 菜品名称
          Expanded(
            child: Text(
              dish.name ?? "未知菜品",
              style: titleStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          // 价格
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              final targetUnit = appProvider.userSettings.priceUnit;
              final unitText = PriceUnits.getDisplayName(targetUnit);
              final price = dish.price;
              final priceText = price == null ? "--" : UnitConverter.convertPrice(price.toDouble(), targetUnit).toStringAsFixed(2);
              
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: priceText,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: unitText,
                      style: TextStyle(
                        fontSize: titleFontSize * 0.7,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建菜品信息
  Widget _buildDishInfo(BuildContext context, Dish dish) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      color: Colors.white,
      child: Row(
        children: [
          _buildInfoTag("城市", dish.region ?? "未知"),
          const SizedBox(width: 8),
          _buildInfoTag("分类", dish.categoryId ?? "未知"),
        ],
      ),
    );
  }

  /// 构建信息标签
  Widget _buildInfoTag(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// 构建价格趋势
  Widget _buildPriceTrend(BuildContext context, Dish dish) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和日期选择
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "价格趋势",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // 日期范围选择
              GestureDetector(
                onTap: _selectDateRange,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    "${_formatDate(_startDate)}  —  ${_formatDate(_endDate)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 价格趋势图表
          SizedBox(
            height: 200,
            child: PriceTrendChart(
              dishId: dish.dishId ?? "",
              region: dish.region ?? "",
              startDate: _startDate,
              endDate: _endDate, 
            ),
          ),
        ],
      ),
    );
  }

  /// 选择日期范围
  Future<void> _selectDateRange() async {
    final picked = await showDateRangePickerBottomSheet(
      context,
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
    );

    if (picked != null) {
      setState(() {
        _startDate = DateTime(picked.start.year, picked.start.month, picked.start.day);
        _endDate = DateTime(picked.end.year, picked.end.month, picked.end.day, 23, 59, 59);
      });
    }
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return "${date.year}.${date.month.toString().padLeft(2, "0")}.${date.day.toString().padLeft(2, "0")}";
  }
}
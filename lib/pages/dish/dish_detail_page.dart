import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:recipe_ledger/providers/dish_provider.dart';
import 'package:recipe_ledger/providers/app_provider.dart';
import 'package:recipe_ledger/models/dish.dart';
import 'package:recipe_ledger/utils/unit_converter.dart';
import 'package:recipe_ledger/constants/app_constants.dart';
import 'package:recipe_ledger/widgets/date_range_picker.dart';
import 'package:recipe_ledger/widgets/price_trend_chart.dart';

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

  @override
  void initState() {
    super.initState();
    // 将日期规范化为当天的开始和结束时间
    _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day);
    _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59);
  }

  /// 当前轮播索引
  int _currentImageIndex = 0;

  /// 模拟图片列表（后续可从菜品数据中获取）
  final List<String> _imageList = [
    'assets/demo.jpeg',
    'assets/demo.jpeg',
    'assets/demo.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    final dishProvider = Provider.of<DishProvider>(context);
    final dish = dishProvider.getDishById(widget.dishId);

    if (dish == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('菜品详情'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        body: const Center(child: Text('菜品不存在')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
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
                  // 菜品图片
                  _buildDishImage(context),

                  // 菜品名称和价格
                  _buildNameAndPrice(context, dish),

                  // 菜品信息
                  _buildDishInfo(context, dish),

                  const SizedBox(height: 12),

                  // 价格趋势
                  _buildPriceTrend(context, dish),
                ],
              ),
            ),
            // 左上角返回按钮
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
      ),
    );
  }

  /// 构建菜品图片轮播
  Widget _buildDishImage(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return SizedBox(
      width: double.infinity,
      height: 280 + statusBarHeight,
      child: Stack(
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
            items: _imageList.map((imagePath) {
              return Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
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
              children: _imageList.asMap().entries.map((entry) {
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
              dish.name,
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
              final convertedPrice = UnitConverter.convertPrice(dish.price, targetUnit);
              final unitText = PriceUnits.getDisplayName(targetUnit);
              
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: convertedPrice.toStringAsFixed(2),
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
          _buildInfoTag('城市', dish.city),
          const SizedBox(width: 8),
          _buildInfoTag('分类', dish.category),
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
        '$label: $value',
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
                '价格趋势',
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
                    '${_formatDate(_startDate)}  —  ${_formatDate(_endDate)}',
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
              dishId: dish.id,
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
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

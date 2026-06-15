import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:fl_chart/fl_chart.dart";
import "package:intl/intl.dart";

import "package:recipe_ledger/models/dish_price_history.dart";
import "package:recipe_ledger/providers/dish_provider.dart";
import "package:recipe_ledger/providers/app_provider.dart";
import "package:recipe_ledger/constants/app_constants.dart";

/// 价格趋势图表组件
class PriceTrendChart extends StatefulWidget {
  /// 菜品ID
  final String dishId;

  /// 区域
  final String region;

  /// 开始日期
  final DateTime startDate;

  /// 结束日期
  final DateTime endDate;

  const PriceTrendChart({
    super.key,
    required this.dishId,
    required this.region,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<PriceTrendChart> createState() => _PriceTrendChartState();
}

class _PriceTrendChartState extends State<PriceTrendChart> {
  List<DishPriceHistory> _priceRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPriceRecords();
    });
  }

  @override
  void didUpdateWidget(PriceTrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dishId != widget.dishId ||
        oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPriceRecords();
      });
    }
  }

  Future<void> _loadPriceRecords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<DishProvider>();
      final records = await provider.getPriceHistory(
        dishId: widget.dishId,
        region: widget.region,
        startDate: widget.startDate,
        endDate: widget.endDate,
      );

      if (mounted) {
        setState(() {
          _priceRecords = records;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final targetUnit = appProvider.userSettings.priceUnit;
    final conversionFactor = PriceUnits.getConversionFactor(targetUnit);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_priceRecords.isEmpty) {
      return Center(
        child: Text("暂无价格数据", style: TextStyle(color: Colors.grey[500])),
      );
    }

    final chartData = _priceRecords
        .where((record) => record.price != null && record.recordDate != null)
        .map((record) {
          return _ChartData(
            date: record.recordDate!,
            price: record.price! * conversionFactor,
          );
        })
        .toList();

    if (chartData.isEmpty) {
      return Center(
        child: Text("暂无价格数据", style: TextStyle(color: Colors.grey[500])),
      );
    }

    final primaryColor = Theme.of(context).primaryColor;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _calculateYInterval(chartData),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 0.5,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: _calculateYInterval(chartData),
              getTitlesWidget: (value, meta) {
                final min = _getMinY(chartData);
                final max = _getMaxY(chartData);
                final range = max - min;
                int decimalPlaces = 2;
                if (range < 0.001) {
                  decimalPlaces = 4;
                } else if (range < 0.01) {
                  decimalPlaces = 3;
                } else if (range < 0.1) {
                  decimalPlaces = 2;
                }
                return Text(
                  value.toStringAsFixed(decimalPlaces),
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _calculateXInterval(),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= chartData.length) {
                  return const SizedBox.shrink();
                }
                final date = chartData[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat("MM.dd").format(date),
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (chartData.length - 1).toDouble(),
        minY: _getMinY(chartData),
        maxY: _getMaxY(chartData),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.grey.shade800,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index < 0 || index >= chartData.length) {
                  return null;
                }
                final date = chartData[index].date;
                return LineTooltipItem(
                  "${DateFormat("MM/dd").format(date)}: ${spot.y.toStringAsFixed(3)}",
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: chartData.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.price);
            }).toList(),
            isCurved: true,
            curveSmoothness: 0.3,
            color: primaryColor,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: chartData.length <= 15,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: primaryColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: primaryColor.withAlpha(30),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateXInterval() {
    final days = widget.endDate.difference(widget.startDate).inDays;
    if (days <= 7) return 1;
    if (days <= 14) return 2;
    if (days <= 30) return 5;
    return 7;
  }

  double _calculateYInterval(List<_ChartData> data) {
    if (data.isEmpty) return 0.001;
    final min = _getMinY(data);
    final max = _getMaxY(data);
    final range = max - min;
    if (range < 0.001) return 0.0001;
    if (range < 0.005) return 0.0005;
    if (range < 0.01) return 0.001;
    if (range < 0.05) return 0.005;
    if (range < 0.1) return 0.01;
    return (range / 4).ceilToDouble();
  }

  double _getMinY(List<_ChartData> data) {
    if (data.isEmpty) return 0;
    final minPrice = data.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final buffer = minPrice * 0.05;
    return minPrice - buffer;
  }

  double _getMaxY(List<_ChartData> data) {
    if (data.isEmpty) return 0.01;
    final maxPrice = data.map((e) => e.price).reduce((a, b) => a > b ? a : b);
    final buffer = maxPrice * 0.05;
    return maxPrice + buffer;
  }
}

/// 图表数据类
class _ChartData {
  final DateTime date;
  final double price;

  _ChartData({required this.date, required this.price});
}

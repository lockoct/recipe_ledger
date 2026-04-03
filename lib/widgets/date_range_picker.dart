import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePicker extends StatefulWidget {
  final ValueChanged<DateTimeRange?>? onDateRangeSelected;
  final DateTimeRange? initialDateRange;

  const DateRangePicker({
    super.key,
    this.onDateRangeSelected,
    this.initialDateRange,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _currentMonth = DateTime.now();
  int? _selectedQuickButton; // 选中的快捷按钮：null、7 或 30
  late DateRangePickerController _controller;
  bool _isQuickButtonSelection = false; // 标记是否是快捷按钮触发的选择

  @override
  void initState() {
    super.initState();
    _controller = DateRangePickerController();
    // 默认不选中任何范围
    _currentMonth = DateTime.now();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectDateRange(int days) {
    setState(() {
      // 如果已选中，则取消选中
      if (_selectedQuickButton == days) {
        _selectedQuickButton = null;
        _startDate = null;
        _endDate = null;
        _isQuickButtonSelection = true;
        _controller.selectedRange = null;
      } else {
        // 否则选中该按钮
        _selectedQuickButton = days;
        _endDate = DateTime.now();
        _startDate = _endDate!.subtract(Duration(days: days - 1));
        _currentMonth = _startDate!;
        _isQuickButtonSelection = true;
        _controller.selectedRange = PickerDateRange(_startDate, _endDate);
      }
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final range = args.value as PickerDateRange;
      setState(() {
        _startDate = range.startDate;
        _endDate = range.endDate;
        // 只有不是快捷按钮触发的选择，才取消快捷按钮的选中状态
        if (!_isQuickButtonSelection) {
          _selectedQuickButton = null;
        }
        _isQuickButtonSelection = false; // 重置标志
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 日历和快捷按钮容器（带背景色）
        Container(
          padding: const EdgeInsets.only(top: 30, bottom: 2),
          color: const Color(0xFFF6F6F6), // 菜品列表背景色
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Syncfusion 日历组件
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SfDateRangePicker(
                  controller: _controller,
                  view: DateRangePickerView.month,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialDisplayDate: _currentMonth,
                  minDate: DateTime(2020, 1, 1),
                  maxDate: DateTime.now(),
                  backgroundColor: Colors.transparent,
                  monthViewSettings: const DateRangePickerMonthViewSettings(
                    firstDayOfWeek: 1, // 周一开始
                    showTrailingAndLeadingDates: true, // 显示上个月和下个月的日期
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(color: Colors.grey),
                    ),
                    weekNumberStyle: DateRangePickerWeekNumberStyle(
                      textStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  headerStyle: const DateRangePickerHeaderStyle(
                    textAlign: TextAlign.left,
                    backgroundColor: Colors.transparent,
                    textStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  monthFormat: 'M月',
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    textStyle: const TextStyle(color: Colors.black),
                    todayTextStyle: TextStyle(
                      color: primaryColor, // 当天日期使用主题色
                      fontWeight: FontWeight.bold,
                    ),
                    trailingDatesTextStyle: const TextStyle(color: Colors.grey),
                    leadingDatesTextStyle: const TextStyle(color: Colors.grey),
                  ),
                  selectionTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  rangeTextStyle: const TextStyle(color: Colors.black),
                  startRangeSelectionColor: primaryColor,
                  endRangeSelectionColor: primaryColor,
                  rangeSelectionColor: primaryColor.withAlpha(51), // 0.2 opacity
                  todayHighlightColor: primaryColor,
                  onSelectionChanged: _onSelectionChanged,
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Divider(height: 1, color: Colors.grey[200]!),
              ),

              // 快捷选择按钮
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: _buildQuickButton(7, '近7天', primaryColor),
                    ),
                    _buildQuickButton(30, '近30天', primaryColor),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 底部按钮
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onDateRangeSelected?.call(null);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_startDate != null && _endDate != null) {
                      widget.onDateRangeSelected?.call(
                        DateTimeRange(start: _startDate!, end: _endDate!),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0, // 去除阴影
                    shadowColor: Colors.transparent, // 去除阴影
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('确定'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickButton(int days, String label, Color primaryColor) {
    final isSelected = _selectedQuickButton == days;

    return OutlinedButton(
      onPressed: () => _selectDateRange(days),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return isSelected ? primaryColor : Colors.white;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return isSelected ? Colors.white : Colors.black;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          return BorderSide(
            color: isSelected ? primaryColor : Colors.grey[300]!,
          );
        }),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        )),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        )),
      ),
      child: Text(label),
    );
  }
}

// 显示日期范围选择器的方法（从顶部弹出）
Future<DateTimeRange?> showDateRangePickerBottomSheet(
  BuildContext context, {
  DateTimeRange? initialDateRange,
}) {
  return showGeneralDialog<DateTimeRange>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '关闭',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: DateRangePicker(
              initialDateRange: initialDateRange,
              onDateRangeSelected: (dateRange) {
                Navigator.pop(context, dateRange);
              },
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}

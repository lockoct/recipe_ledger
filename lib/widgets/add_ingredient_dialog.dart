import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:recipe_ledger/models/dish_list_item.dart';
import 'package:recipe_ledger/models/recipe_ingredient.dart';
import 'package:recipe_ledger/providers/dish_provider.dart';

class AddIngredientDialog extends StatefulWidget {
  final Function(RecipeIngredient) onAdd;
  final RecipeIngredient? initialIngredient;

  const AddIngredientDialog({
    super.key,
    required this.onAdd,
    this.initialIngredient,
  });

  @override
  State<AddIngredientDialog> createState() => AddIngredientDialogState();
}

class AddIngredientDialogState extends State<AddIngredientDialog> {
  bool _isDish = true;
  DishListItem? _selectedDish;
  String _customName = '';
  double _amount = 0;
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _searchController = TextEditingController();

  bool get _isEditing => widget.initialIngredient != null;

  bool get _canSubmit {
    if (_amount <= 0) {
      return false;
    }
    if (_isDish && _selectedDish == null) {
      return false;
    }
    if (!_isDish && _customName.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final ingredient = widget.initialIngredient!;
      _isDish = ingredient.isDish;
      if (ingredient.isDish && ingredient.dishId != null) {
        _loadDishById(ingredient.dishId!);
      }
      _customName = ingredient.customName ?? '';
      _amount = ingredient.amount;
      _nameController.text = _customName;
      _amountController.text = _amount.toString();
    }
  }

  void _loadDishById(String dishId) {
    final dishProvider = context.read<DishProvider>();
    setState(() {
      _selectedDish = dishProvider.dishes.firstWhere(
        (d) => d.dishId == dishId,
        orElse: () => dishProvider.dishes.first,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_isDish && _selectedDish == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择菜品')));
      return;
    }

    if (!_isDish && _customName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入原材料名称')));
      return;
    }

    if (_amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的用量')));
      return;
    }

    final ingredient = RecipeIngredient(
      id: _isEditing ? widget.initialIngredient!.id : const Uuid().v4(),
      dishId: _isDish ? _selectedDish!.dishId : null,
      customName: _isDish ? null : _customName,
      amount: _amount,
      unit: '克',
      isDish: _isDish,
    );

    widget.onAdd(ingredient);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.80,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 切换按钮
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isDish = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _isDish ? themeColor : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          border: Border(
                            left: BorderSide(color: _isDish ? themeColor : Colors.grey.shade300),
                            top: BorderSide(color: _isDish ? themeColor : Colors.grey.shade300),
                            bottom: BorderSide(color: _isDish ? themeColor : Colors.grey.shade300),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '菜品',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _isDish ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isDish = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: !_isDish ? themeColor : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          border: Border(
                            right: BorderSide(color: !_isDish ? themeColor : Colors.grey.shade300),
                            top: BorderSide(color: !_isDish ? themeColor : Colors.grey.shade300),
                            bottom: BorderSide(color: !_isDish ? themeColor : Colors.grey.shade300),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '其他',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: !_isDish ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 只在选择菜品时显示搜索栏
            if (_isDish) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: '搜索菜品',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            // 内容区域
            Flexible(
              child: Consumer<DishProvider>(
                builder: (context, provider, child) {
                  if (_isDish) {
                    // 菜品模式 - 网格列表
                    final dishes = provider.dishes
                        .where(
                          (d) =>
                              _searchController.text.isEmpty ||
                              d.name.contains(_searchController.text),
                        )
                        .toList();

                    if (dishes.isEmpty) {
                      return Container(
                        constraints: const BoxConstraints(minHeight: double.maxFinite),
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: const Center(child: Text('未找到匹配的菜品')),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      constraints: const BoxConstraints(minHeight: double.maxFinite),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 150,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.3,
                            ),
                        itemCount: dishes.length,
                        itemBuilder: (context, index) {
                          final dish = dishes[index];
                          final isSelected = _selectedDish?.dishId == dish.dishId;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedDish = dish),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? themeColor
                                    : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? themeColor.withValues(alpha: 0.1)
                                        : Colors.purple.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.restaurant,
                                    color: isSelected
                                        ? themeColor
                                        : Colors.purple.shade300,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  dish.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? themeColor
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        },
                      ),
                    );
                  }
                  // 其他模式 - 输入框
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: '原材料名称',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) => _customName = value,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),
            ),
            // 底部操作区
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: '用量（克）',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _amount = double.tryParse(value) ?? 0,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '取消',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _canSubmit ? _submit : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _canSubmit ? themeColor : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _isEditing ? '保存' : '添加',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

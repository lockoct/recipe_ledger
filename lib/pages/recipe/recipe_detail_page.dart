import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:provider/provider.dart';

import 'package:recipe_ledger/models/recipe.dart';
import 'package:recipe_ledger/models/dish_list_item.dart';
import 'package:recipe_ledger/models/recipe_ingredient.dart';
import 'package:recipe_ledger/providers/recipe_provider.dart';
import 'package:recipe_ledger/providers/dish_provider.dart';
import 'package:recipe_ledger/pages/recipe/recipe_edit_page.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  const RecipeDetailPage({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  QuillController? _instructionsController;
  QuillController? _notesController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final recipe = context.read<RecipeProvider>().getRecipeById(widget.recipeId);
    if (recipe == null) return;

    _instructionsController = _createQuillController(recipe.instructions);

    if (recipe.notes != null && recipe.notes!.isNotEmpty) {
      _notesController = _createQuillController(recipe.notes!);
    }
  }

  QuillController _createQuillController(String content) {
    if (content.isEmpty) {
      final controller = QuillController.basic();
      controller.readOnly = true;
      return controller;
    }

    try {
      final deltaJson = jsonDecode(content) as List<dynamic>;
      final controller = QuillController(
        document: Document.fromJson(deltaJson.cast<Map<String, dynamic>>()),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );
      return controller;
    } catch (_) {
      final controller = QuillController.basic();
      controller.readOnly = true;
      controller.document.insert(0, content);
      return controller;
    }
  }

  @override
  void dispose() {
    _instructionsController?.dispose();
    _notesController?.dispose();
    super.dispose();
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeEditPage(recipeId: widget.recipeId),
      ),
    );

    if (result == true && mounted) {
      context.read<RecipeProvider>().loadRecipes();
      _instructionsController?.dispose();
      _notesController?.dispose();
      _initControllers();
      setState(() {});
    }
  }

  Future<void> _deleteRecipe() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('删除后无法恢复，确定要删除这个菜谱吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<RecipeProvider>().deleteRecipe(widget.recipeId);
        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('菜谱已删除')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('删除失败: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final recipe = recipeProvider.getRecipeById(widget.recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('菜谱详情'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('菜谱不存在')),
      );
    }

    final statusBarHeight = MediaQuery.of(context).padding.top;

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
                  _buildCoverImage(context, recipe, statusBarHeight),
                  _buildNameSection(context, recipe),
                  const SizedBox(height: 12),
                  _buildIngredientsSection(context, recipe),
                  const SizedBox(height: 12),
                  _buildInstructionsSection(context),
                  if (_notesController != null) ...[
                    const SizedBox(height: 12),
                    _buildNotesSection(context),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
            _buildFloatingButtons(context, statusBarHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context, Recipe recipe, double statusBarHeight) {
    return SizedBox(
      width: double.infinity,
      height: 280 + statusBarHeight,
      child: recipe.coverImage != null && recipe.coverImage!.isNotEmpty
          ? _buildCoverWithImage(recipe)
          : _buildCoverPlaceholder(context),
    );
  }

  Widget _buildCoverWithImage(Recipe recipe) {
    final imagePath = recipe.coverImage!;
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _buildCoverPlaceholder(context),
      );
    }
    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _buildCoverPlaceholder(context),
    );
  }

  Widget _buildCoverPlaceholder(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blue.shade100,
      child: const Icon(
        Icons.menu_book,
        size: 64,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildFloatingButtons(BuildContext context, double statusBarHeight) {
    return Positioned(
      top: statusBarHeight + 8,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _navigateToEdit,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _deleteRecipe,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection(BuildContext context, Recipe recipe) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '更新于 ${_formatDate(recipe.updateTime)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(BuildContext context, Recipe recipe) {
    if (recipe.ingredients.isEmpty) {
      return Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('原材料'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: Text(
                  '暂无原材料',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final dishProvider = context.read<DishProvider>();

    double totalCost = 0;
    for (final ingredient in recipe.ingredients) {
      totalCost += _calculateIngredientCost(ingredient, dishProvider);
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('原材料'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: recipe.ingredients.map((ingredient) {
                return _buildIngredientItem(context, ingredient, dishProvider);
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Colors.grey.shade300),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '合计：',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '￥${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateIngredientCost(RecipeIngredient ingredient, DishProvider dishProvider) {
    if (!ingredient.isDish || ingredient.dishId == null) return 0;

    final dish = dishProvider.dishes.where((d) => d.dishId == ingredient.dishId).firstOrNull;
    if (dish == null) return 0;

    final amountInJin = _convertAmountToJin(ingredient.amount, ingredient.unit);
    return dish.price * amountInJin;
  }

  Widget _buildIngredientItem(BuildContext context, RecipeIngredient ingredient, DishProvider dishProvider) {
    DishListItem? dish;
    if (ingredient.isDish && ingredient.dishId != null) {
      dish = dishProvider.dishes.where((d) => d.dishId == ingredient.dishId).firstOrNull;
    }

    final name = ingredient.isDish ? (dish?.name ?? '未知菜品') : (ingredient.customName ?? '未命名');

    String? costText;
    if (dish != null) {
      final amountInJin = _convertAmountToJin(ingredient.amount, ingredient.unit);
      final cost = dish.price * amountInJin;
      costText = '￥${cost.toStringAsFixed(2)}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          _buildIngredientIcon(ingredient, dish),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${ingredient.amount}${ingredient.unit}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          if (costText != null)
            Text(
              costText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade700,
              ),
            ),
        ],
      ),
    );
  }

  double _convertAmountToJin(double amount, String unit) {
    switch (unit) {
      case 'g':
      case '克':
        return amount / 500.0;
      case '斤':
        return amount;
      case 'kg':
      case '公斤':
        return amount * 2.0;
      default:
        if (unit.contains('克')) {
          return amount / 500.0;
        } else if (unit.contains('斤')) {
          return amount;
        } else if (unit.contains('公斤') || unit.contains('kg')) {
          return amount * 2.0;
        }
        return amount / 500.0;
    }
  }

  Widget _buildIngredientIcon(RecipeIngredient ingredient, DishListItem? dish) {
    if (ingredient.isDish) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.restaurant,
          size: 20,
          color: Colors.blue,
        ),
      );
    }
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.category,
        size: 20,
        color: Colors.orange.shade400,
      ),
    );
  }

  Widget _buildInstructionsSection(BuildContext context) {
    if (_instructionsController == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('做法步骤'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: QuillEditor.basic(
              controller: _instructionsController!,
              config: QuillEditorConfig(
                showCursor: false,
                padding: const EdgeInsets.all(12),
                autoFocus: false,
                expands: false,
                customStyles: const DefaultStyles(
                  indent: DefaultTextBlockStyle(
                    TextStyle(fontSize: 16),
                    HorizontalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    null,
                  ),
                  lists: DefaultListBlockStyle(
                    TextStyle(fontSize: 16),
                    HorizontalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    null,
                    null,
                  ),
                ),
                embedBuilders: FlutterQuillEmbeds.editorBuilders(
                  imageEmbedConfig: const QuillEditorImageEmbedConfig(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    if (_notesController == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('注意事项'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: QuillEditor.basic(
              controller: _notesController!,
              config: QuillEditorConfig(
                showCursor: false,
                padding: const EdgeInsets.all(12),
                autoFocus: false,
                expands: false,
                customStyles: const DefaultStyles(
                  indent: DefaultTextBlockStyle(
                    TextStyle(fontSize: 16),
                    HorizontalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    null,
                  ),
                  lists: DefaultListBlockStyle(
                    TextStyle(fontSize: 16),
                    HorizontalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    VerticalSpacing(0, 0),
                    null,
                    null,
                  ),
                ),
                embedBuilders: FlutterQuillEmbeds.editorBuilders(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:recipe_ledger/models/recipe.dart';
import 'package:recipe_ledger/models/recipe_ingredient.dart';
import 'package:recipe_ledger/models/dish.dart';
import 'package:recipe_ledger/providers/recipe_provider.dart';
import 'package:recipe_ledger/providers/dish_provider.dart';
import 'package:recipe_ledger/widgets/add_ingredient_dialog.dart';

/// 菜谱编辑页面
class RecipeEditPage extends StatefulWidget {
  /// 编辑的菜谱ID（可选，为空表示新增）
  final String? recipeId;

  const RecipeEditPage({super.key, this.recipeId});

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scrollController = ScrollController();

  late QuillController _instructionsController;
  late QuillController _notesController;
  late FocusNode _instructionsFocusNode;
  late FocusNode _notesFocusNode;

  final _instructionsEditorKey = GlobalKey<QuillEditorState>();
  final _notesEditorKey = GlobalKey<QuillEditorState>();
  final _instructionsContainerKey = GlobalKey();
  final _notesContainerKey = GlobalKey();

  String? _coverImagePath;
  List<RecipeIngredient> _ingredients = [];
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isNotesFocused = false;
  bool _activeEditorFocused = false;
  double _lastBottomInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _instructionsController = QuillController.basic();
    _notesController = QuillController.basic();
    _instructionsFocusNode = FocusNode();
    _notesFocusNode = FocusNode();

    _instructionsFocusNode.addListener(_onFocusChange);
    _notesFocusNode.addListener(_onFocusChange);

    _loadData();
  }

  QuillController get _currentController {
    if (_isNotesFocused) {
      return _notesController;
    }
    return _instructionsController;
  }

  void _onFocusChange() {
    final hasFocus =
        _instructionsFocusNode.hasFocus || _notesFocusNode.hasFocus;
    final isNotesFocused = _notesFocusNode.hasFocus;

    setState(() {
      _isNotesFocused = isNotesFocused;
      _activeEditorFocused = hasFocus;
    });

    if (hasFocus) {
      _scrollToFocusedEditor(isNotesFocused);
    }
  }

  void _insertImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final controller = _currentController;
      controller.document.insert(
        controller.selection.extentOffset,
        BlockEmbed.image(pickedFile.path),
      );
      // 插入图片后，将光标移动到图片后面
      controller.updateSelection(
        TextSelection.collapsed(
          offset: controller.selection.extentOffset + 1,
        ),
        ChangeSource.local,
      );
    }
  }

  void _scrollToFocusedEditor(bool isNotesFocused) {
    if (!mounted) return;

    final containerKey = isNotesFocused
        ? _notesContainerKey
        : _instructionsContainerKey;
    final containerContext = containerKey.currentContext;

    if (containerContext == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        Scrollable.ensureVisible(
          containerContext,
          alignment: 0.6,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nameController.dispose();
    _scrollController.dispose();
    _instructionsController.dispose();
    _notesController.dispose();
    _instructionsFocusNode.removeListener(_onFocusChange);
    _notesFocusNode.removeListener(_onFocusChange);
    _instructionsFocusNode.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > _lastBottomInset && _activeEditorFocused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToFocusedEditor(_isNotesFocused);
      });
    }
    _lastBottomInset = bottomInset;
  }

  // 加载数据
  Future<void> _loadData() async {
    if (widget.recipeId == null) return;

    setState(() => _isLoading = true);

    try {
      final recipeProvider = context.read<RecipeProvider>();
      final recipe = recipeProvider.recipes.firstWhere(
        (r) => r.id == widget.recipeId,
        orElse: () => throw Exception('菜谱不存在'),
      );

      _nameController.text = recipe.name;
      _coverImagePath = recipe.coverImage;
      _ingredients = List.from(recipe.ingredients);

      if (recipe.instructions.isNotEmpty) {
        try {
          final deltaJson = jsonDecode(recipe.instructions) as List<dynamic>;
          _instructionsController = QuillController(
            document: Document.fromJson(deltaJson.cast<Map<String, dynamic>>()),
            selection: const TextSelection.collapsed(offset: 0),
          );
        } catch (_) {
          _instructionsController.document.insert(0, recipe.instructions);
        }
      }

      if (recipe.notes != null && recipe.notes!.isNotEmpty) {
        try {
          final deltaJson = jsonDecode(recipe.notes!) as List<dynamic>;
          _notesController = QuillController(
            document: Document.fromJson(deltaJson.cast<Map<String, dynamic>>()),
            selection: const TextSelection.collapsed(offset: 0),
          );
        } catch (_) {
          _notesController.document.insert(0, recipe.notes!);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载菜谱失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 上传封面
  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _coverImagePath = pickedFile.path;
      });
    }
  }

  // 获取原材料名称
  Future<String> _getIngredientName(RecipeIngredient ingredient) async {
    if (ingredient.isDish && ingredient.dishId != null) {
      final dishProvider = context.read<DishProvider>();
      final dish = dishProvider.dishes.firstWhere(
        (d) => d.id == ingredient.dishId,
        orElse: () => Dish(
          id: '',
          name: '未知菜品',
          price: 0,
          city: '',
          updateTime: DateTime.now(),
          category: '',
        ),
      );
      return dish.name;
    }
    return ingredient.customName ?? '未命名';
  }

  // 添加原材料
  void _addIngredient() {
    showDialog(
      context: context,
      builder: (context) => AddIngredientDialog(
        onAdd: (ingredient) {
          setState(() {
            _ingredients.add(ingredient);
          });
        },
      ),
    );
  }

  // 删除原材料
  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  // 编辑原材料
  void _editIngredient(int index) {
    final ingredient = _ingredients[index];
    showDialog(
      context: context,
      builder: (context) => AddIngredientDialog(
        onAdd: (updated) {
          setState(() {
            _ingredients[index] = updated;
          });
        },
        initialIngredient: ingredient,
      ),
    );
  }

  // 保存
  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请至少添加一个原材料')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final recipeProvider = context.read<RecipeProvider>();
      final now = DateTime.now();

      final instructionsJson = jsonEncode(
        _instructionsController.document.toDelta().toJson(),
      );
      final notesJson = _notesController.document.toDelta().isEmpty
          ? null
          : jsonEncode(_notesController.document.toDelta().toJson());

      final recipe = Recipe(
        id: widget.recipeId ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        coverImage: _coverImagePath,
        ingredients: _ingredients,
        instructions: instructionsJson,
        notes: notesJson,
        createTime: widget.recipeId == null ? now : now,
        updateTime: now,
      );

      if (widget.recipeId == null) {
        await recipeProvider.addRecipe(recipe);
      } else {
        await recipeProvider.updateRecipe(recipe);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.recipeId == null ? '菜谱创建成功' : '菜谱更新成功'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final showToolbar = _activeEditorFocused && bottomInset > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.recipeId == null ? '新增菜谱' : '编辑菜谱'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: showToolbar ? 60 : 16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: _buildCoverSection(),
                      ),
                      const SizedBox(height: 16),
                      _buildNameSection(),
                      const SizedBox(height: 16),
                      _buildIngredientsSection(),
                      const SizedBox(height: 16),
                      _buildInstructionsSection(),
                      const SizedBox(height: 16),
                      _buildNotesSection(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _saveRecipe,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    '提交',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                if (showToolbar)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 44,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: QuillSimpleToolbar(
                          controller: _currentController,
                          config: QuillSimpleToolbarConfig(
                            color: Colors.white,
                            showAlignmentButtons: false,
                            showBackgroundColorButton: false,
                            showCodeBlock: false,
                            showColorButton: false,
                            showDirection: false,
                            showFontFamily: false,
                            showFontSize: false,
                            showHeaderStyle: false,
                            showIndent: true,
                            showInlineCode: false,
                            showLink: false,
                            showListCheck: false,
                            showListBullets: true,
                            showListNumbers: true,
                            showQuote: false,
                            showRedo: true,
                            showSearchButton: false,
                            showSmallButton: false,
                            showStrikeThrough: false,
                            showSubscript: false,
                            showSuperscript: false,
                            showUnderLineButton: false,
                            showUndo: true,
                            multiRowsDisplay: false,
                            showItalicButton: false,
                            showClearFormat: false,
                            customButtons: [
                              QuillToolbarCustomButtonOptions(
                                icon: const Icon(Icons.image),
                                onPressed: _insertImage,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  // 封面图片区域
  Widget _buildCoverSection() {
    return GestureDetector(
      onTap: _pickCoverImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: _coverImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_coverImagePath!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击上传封面图片',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
      ),
    );
  }

  // 菜谱名称卡片
  Widget _buildNameSection() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('菜谱名称'),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '请输入',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入菜谱名称';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  // 原材料卡片
  Widget _buildIngredientsSection() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('原材料', onAdd: _addIngredient),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_ingredients.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        '暂无原材料，点击添加',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = _ingredients[index];
                      final isLast = index == _ingredients.length - 1;
                      return _buildIngredientItem(ingredient, index, isLast);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 做法步骤卡片
  Widget _buildInstructionsSection() {
    return Container(
      key: _instructionsContainerKey,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('做法步骤'),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Container(
              constraints: const BoxConstraints(minHeight: 150),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: QuillEditor.basic(
                key: _instructionsEditorKey,
                controller: _instructionsController,
                focusNode: _instructionsFocusNode,
                config: QuillEditorConfig(
                  padding: const EdgeInsets.all(12),
                  placeholder: '请输入',
                  autoFocus: false,
                  expands: false,
                  customStyles: const DefaultStyles(
                    placeHolder: DefaultTextBlockStyle(
                      TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
                      HorizontalSpacing(0, 0),
                      VerticalSpacing.zero,
                      VerticalSpacing.zero,
                      null,
                    ),
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
          ),
        ],
      ),
    );
  }

  // 注意事项卡片
  Widget _buildNotesSection() {
    return Container(
      key: _notesContainerKey,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('注意事项'),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Container(
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: QuillEditor.basic(
                key: _notesEditorKey,
                controller: _notesController,
                focusNode: _notesFocusNode,
                config: QuillEditorConfig(
                  padding: const EdgeInsets.all(12),
                  placeholder: '请输入',
                  autoFocus: false,
                  expands: false,
                  customStyles: const DefaultStyles(
                    placeHolder: DefaultTextBlockStyle(
                      TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
                      HorizontalSpacing(0, 0),
                      VerticalSpacing.zero,
                      VerticalSpacing.zero,
                      null,
                    ),
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
          ),
        ],
      ),
    );
  }

  // 标题
  Widget _buildSectionTitle(String title, {VoidCallback? onAdd}) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          if (onAdd != null)
            GestureDetector(
              onTap: onAdd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 2),
                  Text(
                    '添加',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 原材料项
  Widget _buildIngredientItem(RecipeIngredient ingredient, int index, bool isLast) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<String>(
                      future: _getIngredientName(ingredient),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? '加载中...',
                          style: const TextStyle(fontSize: 16),
                        );
                      },
                    ),
                    Text(
                      '${ingredient.amount}克',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _editIngredient(index),
                child: Icon(Icons.edit_outlined, color: Colors.blue.shade300, size: 20),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _removeIngredient(index),
                child: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 20),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}

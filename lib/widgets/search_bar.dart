import 'package:flutter/material.dart';

/// 通用搜索栏组件
///
/// 提供搜索输入、清除、取消功能，支持防抖搜索。
class SearchBar extends StatefulWidget {
  /// 搜索提示文本
  final String hintText;

  /// 初始搜索文本
  final String initialText;

  /// 搜索回调函数
  final ValueChanged<String> onSearch;

  /// 取消搜索回调函数
  final VoidCallback? onCancel;

  /// 是否自动聚焦
  final bool autofocus;

  /// 搜索框是否处于激活状态
  final bool enabled;

  /// 构造函数
  const SearchBar({
    super.key,
    this.hintText = '搜索...',
    this.initialText = '',
    required this.onSearch,
    this.onCancel,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _isSearching = widget.initialText.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialText != widget.initialText) {
      _controller.text = widget.initialText;
      _isSearching = widget.initialText.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 文本变化监听
  void _onTextChanged() {
    final text = _controller.text;
    setState(() {
      _isSearching = text.isNotEmpty;
    });
    widget.onSearch(text);
  }

  /// 清除搜索文本
  void _clearSearch() {
    _controller.clear();
  }

  /// 取消搜索
  void _cancelSearch() {
    _controller.clear();
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 搜索图标和输入框
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.search, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: widget.autofocus,
                      enabled: widget.enabled,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (value) {
                        // 文本变化已经在监听器中处理
                      },
                      onSubmitted: (value) {
                        // 搜索提交
                        widget.onSearch(value);
                      },
                    ),
                  ),
                  // 清除按钮
                  if (_isSearching)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: _clearSearch,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          // 取消按钮（在搜索时有文本时显示）
          if (_isSearching) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: _cancelSearch,
              child: const Text('取消'),
            ),
          ],
        ],
      ),
    );
  }
}

/// 带历史记录的搜索栏
///
/// 扩展基本搜索栏，增加搜索历史记录功能。
class SearchBarWithHistory extends StatefulWidget {
  /// 搜索提示文本
  final String hintText;

  /// 初始搜索文本
  final String initialText;

  /// 搜索回调函数
  final ValueChanged<String> onSearch;

  /// 取消搜索回调函数
  final VoidCallback? onCancel;

  /// 是否自动聚焦
  final bool autofocus;

  /// 构造函数
  const SearchBarWithHistory({
    super.key,
    this.hintText = '搜索...',
    this.initialText = '',
    required this.onSearch,
    this.onCancel,
    this.autofocus = false,
  });

  @override
  State<SearchBarWithHistory> createState() => _SearchBarWithHistoryState();
}

class _SearchBarWithHistoryState extends State<SearchBarWithHistory> {
  final List<String> _searchHistory = [];
  bool _showHistory = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 搜索栏
        SearchBar(
          hintText: widget.hintText,
          initialText: widget.initialText,
          onSearch: (text) {
            widget.onSearch(text);
            if (text.isNotEmpty && !_searchHistory.contains(text)) {
              setState(() {
                _searchHistory.insert(0, text);
                // 限制历史记录数量
                if (_searchHistory.length > 10) {
                  _searchHistory.removeLast();
                }
              });
            }
          },
          onCancel: () {
            widget.onCancel?.call();
            setState(() {
              _showHistory = false;
            });
          },
          autofocus: widget.autofocus,
        ),
        // 搜索历史（仅在搜索框有焦点且无文本时显示）
        if (_showHistory && _searchHistory.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('搜索历史', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ..._searchHistory.map((history) {
                  return ListTile(
                    leading: const Icon(Icons.history, size: 20),
                    title: Text(history),
                    onTap: () {
                      widget.onSearch(history);
                      setState(() {
                        _showHistory = false;
                      });
                    },
                  );
                }),
                // 清除历史按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _searchHistory.clear();
                      });
                    },
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text('清除搜索历史'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// 静态搜索栏（无状态版本）
///
/// 适用于不需要状态管理的简单搜索场景。
class StaticSearchBar extends StatelessWidget {
  /// 搜索提示文本
  final String hintText;

  /// 搜索回调函数
  final ValueChanged<String> onSearch;

  /// 是否启用搜索
  final bool enabled;

  /// 构造函数
  const StaticSearchBar({
    super.key,
    this.hintText = '搜索...',
    required this.onSearch,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                enabled: enabled,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: onSearch,
                onSubmitted: onSearch,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
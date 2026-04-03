import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:recipe_ledger/providers/app_provider.dart';
import 'package:recipe_ledger/services/data_initialization_service.dart';
import 'package:recipe_ledger/pages/settings/unit_switch_page.dart';

/// 个人中心页面
///
/// 显示用户信息和个人设置入口。
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    final primaryColor = Theme.of(context).primaryColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: primaryColor, // 状态栏颜色匹配用户信息卡片
        statusBarIconBrightness: Brightness.light, // 状态栏图标亮度（浅色背景用深色图标）
        statusBarBrightness: Brightness.light, // 状态栏亮度
        systemNavigationBarColor: Colors.white, // 导航栏颜色保持白色
        systemNavigationBarIconBrightness: Brightness.dark, // 导航栏图标亮度
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6), // 与菜品、菜谱页面保持一致
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFF6F6F6),
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.25, 0.8, 1.0], // 控制渐变位置
              colors: [
                primaryColor, // 顶部主题色
                primaryColor, // 保持主题色 
                const Color(0xFFF6F6F6),
                const Color(0xFFF6F6F6), // 底部灰色背景
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户信息卡片（与状态栏融为一体）
                _buildUserInfoCard(context, appProvider),
                const SizedBox(height: 10),

                // 功能列表
                _buildFunctionList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserInfoCard(BuildContext context, AppProvider appProvider) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16), // 顶部填充考虑状态栏高度
      child: Row(
        children: [
          // 头像（白色背景，主题色图标）
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, size: 36, color: primaryColor),
          ),
          const SizedBox(width: 16),

          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '用户', // TODO: 后续可以添加用户名功能
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '欢迎使用菜谱账本',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xE6FFFFFF), // 白色，90%不透明度
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建功能列表
  Widget _buildFunctionList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // 单位切换项
          _buildFunctionListItem(
            context,
            icon: Icons.tune,
            title: '单位切换',
            subtitle: '切换价格显示单位',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UnitSwitchPage()),
              );
            },
          ),
          // 分隔线
          Divider(
            height: 0,
            color: Colors.grey.shade300, // 更淡的分割线颜色
            thickness: 0.5,
            indent: 16, // 左边距
            endIndent: 16, // 右边距
          ),
          // 初始化模拟数据项（开发用）
          _buildFunctionListItem(
            context,
            icon: Icons.refresh,
            title: '初始化模拟数据',
            subtitle: '清空并重新生成菜品和菜谱数据',
            onTap: () => _initializeMockData(context),
          ),
          // 分隔线
          Divider(
            height: 0,
            color: Colors.grey.shade300, // 更淡的分割线颜色
            thickness: 0.5,
            indent: 16, // 左边距
            endIndent: 16, // 右边距
          ),
          // 关于项
          _buildFunctionListItem(
            context,
            icon: Icons.info_outline,
            title: '关于',
            subtitle: '应用信息和版本',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          // 分隔线
          Divider(
            height: 0,
            color: Colors.grey.shade300, // 更淡的分割线颜色
            thickness: 0.5,
            indent: 16, // 左边距
            endIndent: 16, // 右边距
          ),
          // 帮助项
          _buildFunctionListItem(
            context,
            icon: Icons.help_outline,
            title: '帮助',
            subtitle: '使用帮助和常见问题',
            onTap: () {
              _showHelpDialog(context);
            },
          ),
        ],
      ),
    );
  }

  /// 构建功能列表项
  Widget _buildFunctionListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// 显示关于对话框
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于菜谱账本'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('版本: 1.0.0'),
            SizedBox(height: 8),
            Text('菜谱账本是一个帮助您管理菜品价格和菜谱的应用。'),
            SizedBox(height: 8),
            Text('支持离线使用，所有数据存储在本地。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示帮助对话框
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('使用帮助'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('如何使用菜谱账本:'),
            SizedBox(height: 8),
            Text('1. 在"菜品"页面添加和管理菜品价格'),
            Text('2. 在"菜谱"页面创建和管理菜谱'),
            Text('3. 在"设置"中调整应用偏好'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 初始化模拟数据
  void _initializeMockData(BuildContext context) {
    final initializationService = DataInitializationService();

    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;
        bool isComplete = false;
        String? errorMessage;

        return StatefulBuilder(
          builder: (context, setState) {
            if (isLoading) {
              return const AlertDialog(
                title: Text('初始化中'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('正在清空并重新生成数据...'),
                  ],
                ),
              );
            }

            if (isComplete) {
              return AlertDialog(
                title: const Text('初始化成功'),
                content: const Text('模拟数据已初始化完成。'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('确定'),
                  ),
                ],
              );
            }

            if (errorMessage != null) {
              return AlertDialog(
                title: const Text('初始化失败'),
                content: Text('初始化过程中发生错误: $errorMessage'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('确定'),
                  ),
                ],
              );
            }

            // 初始确认对话框
            return AlertDialog(
              title: const Text('初始化模拟数据'),
              content: const Text('此操作将清空所有菜品和菜谱数据，并重新生成模拟数据。确定继续吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      // 执行数据初始化
                      await initializationService.initializeAllMockData();

                      setState(() {
                        isLoading = false;
                        isComplete = true;
                      });
                    } catch (error) {
                      setState(() {
                        isLoading = false;
                        errorMessage = error.toString();
                      });
                    }
                  },
                  child: const Text('确定'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

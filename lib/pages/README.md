# 页面模块总览 (Pages Overview)

## 模块结构

本应用采用模块化页面结构，主要包含以下模块：

| 模块 | 页面 | 功能描述 |
|------|------|----------|
| **dish** | DishListPage, DishDetailPage | 菜品列表和详情，价格趋势展示 |
| **recipe** | RecipeGridPage, RecipeEditPage | 菜谱网格和编辑，富文本支持 |
| **profile** | ProfilePage | 个人中心和功能入口 |
| **settings** | UnitSwitchPage | 应用设置和配置 |

## 页面导航

应用使用底部导航栏（BottomNavigationBar）实现三个主要标签页的切换：

```
底部导航栏
    ├── 菜品 (DishListPage)
    ├── 菜谱 (RecipeGridPage)
    └── 我的 (ProfilePage)
```

### 页面间导航关系

```
MainNavigation (主导航容器)
    ├── DishListPage ──(点击菜品)──> DishDetailPage
    ├── RecipeGridPage ──(点击添加)──> RecipeEditPage
    │                   └──(点击菜谱)──> RecipeDetailPage (待开发)
    └── ProfilePage ──(点击单位切换)──> UnitSwitchPage
                    └──(点击其他功能)──> 各类对话框
```

## 状态管理架构

页面层使用 Provider 进行状态管理：

| Provider | 作用域 | 管理数据 |
|----------|--------|----------|
| NavigationProvider | 全局 | 当前选中的导航标签 |
| AppProvider | 全局 | 用户设置（如价格单位） |
| DishProvider | 菜品模块 | 菜品列表和筛选状态 |
| RecipeProvider | 菜谱模块 | 菜谱列表和编辑状态 |

## 核心设计模式

1. **IndexedStack 状态保持**：使用 `IndexedStack` 保持三个主页面的状态，切换时不重建
2. **Consumer 模式**：通过 `Consumer` 组件监听状态变化，局部刷新
3. **路由管理**：使用 `Navigator.push` 和 `MaterialPageRoute` 实现页面跳转
4. **对话框模式**：使用 `showDialog` 实现弹窗交互

## 页面生命周期

```
应用启动
    └── main.dart
            └── MultiProvider (注入所有 Provider)
                    └── MainNavigation
                            └── IndexedStack
                                    ├── DishListPage
                                    ├── RecipeGridPage
                                    └── ProfilePage
```

每个子页面在首次进入时初始化，通过 `IndexedStack` 保持状态，直到应用退出。
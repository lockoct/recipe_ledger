## Why

当前菜品列表页采用"网络优先、失败兜底缓存"策略，每次打开 App 都发起网络请求，即使数据当天没有变化。改为"本地优先、按天过期"策略，同一天内重复打开 App 实现零网络请求，提升加载速度和离线体验。同时菜品卡片封面从占位图标改为网络图片加载。

## What Changes

- 菜品列表缓存策略从"网络优先"改为"本地优先，按天过期"：新增 `cache_meta_box` 存储缓存同步日期和全量加载标记
- 缓存过期时清空全部缓存，重新请求第一页；加载更多时追加数据到缓存
- 全量加载后标记 `fully_loaded`，避免今天内重复触发加载更多
- 筛选/搜索直接请求网络，不走缓存
- 下拉刷新清空缓存和元数据，重新请求
- 菜品卡片封面从占位图标改为 `Image.network` 加载，无封面或加载失败时显示占位图标

## Capabilities

### New Capabilities
- `dish-list-cache`: 菜品列表本地优先缓存策略，按天过期判断，支持全量加载标记和网络失败兜底

### Modified Capabilities
<!-- No existing capabilities modified -->

## Impact

- Affected code: `dish_service.dart`, `dish_provider.dart`, `dish_list_page.dart`, `app_constants.dart`
- Dependencies: Hive 本地缓存、Dio 网络请求、Provider 状态管理
- No breaking changes to existing API or data models
## Why

当前菜品详情页采用"网络优先、失败兜底缓存"策略，每次打开页面都发起网络请求，即使数据当天没有变化。改为"本地优先、按天过期"策略，同一天内重复打开页面实现零网络请求，提升加载速度和离线体验。参考已实现的菜品列表页缓存策略进行设计。

## What Changes

- 菜品详情缓存策略从"网络优先"改为"本地优先，按天过期"：复用 `cache_meta_box` 存储缓存同步日期
- 缓存过期时清空该菜品的缓存，重新请求网络数据
- 页面首次加载（initState）使用本地优先策略，不走强制刷新
- 网络失败时返回旧缓存数据兜底

## Capabilities

### New Capabilities
- `dish-detail-cache`: 菜品详情本地优先缓存策略，按天过期判断，支持网络失败兜底

### Modified Capabilities
<!-- No existing capabilities modified -->

## Impact

- Affected code: `dish_service.dart`, `dish_detail_page.dart`
- Dependencies: Hive 本地缓存、Dio 网络请求、Provider 状态管理
- No breaking changes to existing API or data models
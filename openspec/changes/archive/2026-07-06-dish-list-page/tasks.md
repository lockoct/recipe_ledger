## 1. 缓存元数据基础设施

- [x] 1.1 在 `app_constants.dart` 的 `HiveConstants` 中新增 `static const String cacheMetaBox = 'cache_meta_box';` 常量

## 2. DishService 缓存逻辑重构

- [x] 2.1 新增缓存元数据方法：`_getMeta`、`_setMeta`、`_isCacheFresh`、`_isFullyLoaded`
- [x] 2.2 重构 `getList` 方法，实现本地优先策略：无筛选 + pageNum=1 + 缓存新鲜 → 直接返回本地缓存；缓存过期/无缓存 → 清空缓存请求网络第一页；pageNum>1 → 追加到缓存
- [x] 2.3 更新 `saveListToCache`：pageNum=1 时 `clear()` 后写入，pageNum>1 时追加写入
- [x] 2.4 更新 `clearListCache`：同时清除 `dish_list_sync_date` 和 `dish_list_fully_loaded` 元数据

## 3. DishProvider 状态管理适配

- [x] 3.1 更新 `getList` 方法：refresh=true 时清空缓存和元数据后请求网络；从缓存返回时根据缓存数量和 `fully_loaded` 计算 pageNum 和 hasMore
- [x] 3.2 更新 `getMore` 方法：网络返回 pageNum==pages 时写入 `fully_loaded = "true"`

## 4. 封面图网络加载

- [x] 4.1 菜品卡片封面从占位图标改为 `Image.network` 加载，无封面或加载失败时显示占位图标
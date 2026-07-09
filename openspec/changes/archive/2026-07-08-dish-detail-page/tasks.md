## 1. DishService 缓存逻辑重构

- [x] 1.1 在 `DishService` 中新增缓存元数据 key 生成方法：`_getSyncDateKey(String dishId)` 返回 `"dish_detail_<dishId>_sync_date"`
- [x] 1.2 重构 `get(String dishId)` 方法，实现本地优先策略：缓存新鲜 → 返回本地缓存；缓存过期/无缓存 → 清空缓存请求网络；网络失败 → 返回旧缓存兜底
- [x] 1.3 更新 `saveToCache` 方法：保存菜品数据后，同时更新同步日期为今天
- [x] 1.4 新增 `clearDetailCache(String dishId)` 方法：删除该菜品的缓存数据和对应的同步日期元数据

## 2. 错误处理和日志

- [x] 2.1 在 `get` 方法中添加 debugPrint 日志，跟踪缓存/网络路径（如"缓存新鲜，返回本地缓存"、"缓存过期，请求网络"）
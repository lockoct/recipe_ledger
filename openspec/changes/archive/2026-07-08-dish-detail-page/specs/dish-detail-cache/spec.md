## ADDED Requirements

### Requirement: 本地优先缓存策略
菜品详情页 SHALL 优先从本地缓存读取数据，根据缓存同步日期（`yyyy-MM-dd`）判断数据新鲜度。缓存元数据存储在 `cache_meta_box`（`Box<String>`）中，使用 `"dish_detail_<dishId>_sync_date"` 作为 key。

#### Scenario: 缓存新鲜直接返回
- **WHEN** 用户打开菜品详情页，且 `dish_detail_<dishId>_sync_date` 等于今天日期
- **THEN** 系统 SHALL 直接返回本地缓存数据，不发起任何网络请求

#### Scenario: 缓存过期重新请求
- **WHEN** 用户打开菜品详情页，且 `dish_detail_<dishId>_sync_date` 不等于今天日期
- **THEN** 系统 SHALL 请求网络数据，覆盖写入缓存数据并更新同步日期为今天

#### Scenario: 无缓存首次请求
- **WHEN** 用户首次打开菜品详情页，且本地无该菜品的缓存数据
- **THEN** 系统 SHALL 请求网络数据，写入缓存和同步日期为今天

#### Scenario: 网络失败有缓存兜底
- **WHEN** 网络请求失败，且本地有旧缓存数据（即使是过期的）
- **THEN** 系统 SHALL 返回旧缓存数据兜底，不显示错误提示

#### Scenario: 网络失败无缓存报错
- **WHEN** 网络请求失败，且本地无任何缓存数据
- **THEN** 系统 SHALL 抛出异常，显示加载失败提示
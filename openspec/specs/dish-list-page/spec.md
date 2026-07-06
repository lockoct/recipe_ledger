# Dish List Page

## Purpose

菜品列表页是应用的核心入口页面，提供菜品列表展示、搜索、分类筛选、区域筛选、分页加载、下拉刷新等功能。采用本地优先缓存策略，按天过期刷新，提升加载速度和离线体验。

## Requirements

### Requirement: 本地优先缓存策略

系统 SHALL 优先从本地缓存读取数据，根据缓存同步日期（`yyyy-MM-dd`）判断数据新鲜度。缓存元数据存储在 `cache_meta_box`（`Box<String>`）中，包含 `"dish_list_sync_date"` 和 `"dish_list_fully_loaded"` 两个 key。

#### Scenario: 缓存新鲜直接返回
- **WHEN** 用户打开菜品列表页，无筛选条件，且 `dish_list_sync_date` 等于今天日期
- **THEN** 系统 SHALL 直接返回全部本地缓存数据，不发起任何网络请求

#### Scenario: 缓存过期清空重启
- **WHEN** 用户打开菜品列表页，无筛选条件，且 `dish_list_sync_date` 不等于今天日期
- **THEN** 系统 SHALL 清空全部缓存数据，请求网络第一页，更新缓存和同步日期为今天，并设置 `fully_loaded` 为 `"false"`

#### Scenario: 无缓存首次请求
- **WHEN** 用户首次打开菜品列表页，无筛选条件，且本地无任何缓存数据
- **THEN** 系统 SHALL 请求网络第一页，写入缓存和同步日期为今天，并设置 `fully_loaded` 为 `"false"`

#### Scenario: 网络失败有缓存兜底
- **WHEN** 网络请求失败，且本地有旧缓存数据（即使是过期的）
- **THEN** 系统 SHALL 返回旧缓存数据兜底，不显示错误提示

#### Scenario: 网络失败无缓存报错
- **WHEN** 网络请求失败，且本地无任何缓存数据
- **THEN** 系统 SHALL 抛出异常，显示加载失败提示

### Requirement: 加载更多追加缓存

系统 SHALL 在加载更多时将新页数据追加到本地缓存，并在全量加载完毕后标记，避免重复请求。

#### Scenario: 加载更多追加数据
- **WHEN** 用户滚动到底部触发加载更多（pageNum > 1），网络请求成功
- **THEN** 系统 SHALL 将新页数据追加到本地缓存（不清空已有缓存），若 pageNum 等于 pages 则设置 `fully_loaded` 为 `"true"`

#### Scenario: 全量加载后不再触发
- **WHEN** `fully_loaded` 为 `"true"`，用户再次打开 App 并滚动到列表底部
- **THEN** 系统 SHALL 设置 hasMore 为 false，不触发任何网络请求

### Requirement: 下拉刷新清空缓存

系统 SHALL 在下拉刷新时清空全部缓存数据和元数据，重新请求网络第一页。

#### Scenario: 下拉刷新
- **WHEN** 用户执行下拉刷新操作
- **THEN** 系统 SHALL 清空缓存数据、同步日期和 `fully_loaded` 标记，请求网络第一页，并更新缓存和同步日期

### Requirement: 筛选搜索不走缓存

系统 SHALL 在用户进行搜索或筛选时直接请求网络，不使用本地缓存。

#### Scenario: 搜索或筛选时直接请求网络
- **WHEN** 用户输入搜索关键词，或按分类/区域筛选菜品
- **THEN** 系统 SHALL 直接请求网络获取数据，不读取本地缓存，不缓存筛选结果

### Requirement: 封面图网络加载

系统 SHALL 使用 `Image.network` 从链接加载菜品封面图，加载失败时显示占位图标。

#### Scenario: 封面加载成功
- **WHEN** 菜品 cover 字段包含有效 URL
- **THEN** 系统 SHALL 显示网络封面图

#### Scenario: 封面为空或加载失败
- **WHEN** 菜品 cover 字段为空，或网络图片加载失败
- **THEN** 系统 SHALL 显示默认占位图标
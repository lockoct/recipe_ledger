/// 分页
class Pagination {
  /// 当前页码
  int pageNum;

  /// 分页大小
  final int pageSize;

  /// 总页数
  int pages;

  /// 总数量
  int total;

  Pagination({
    this.pageNum = 1,
    this.pageSize = 10,
    this.pages = 0,
    this.total = 0,
  });

  /// 是否有更多数据
  bool get hasMore => pageNum < pages;

  /// 重置
  void reset() {
    pageNum = 1;
    pages = 0;
    total = 0;
  }
}

/// 分页响应
class ResponsePagination<T> extends Pagination {
  /// 数据列表
  final List<T> list;

  ResponsePagination({
    required this.list,
    required super.pageNum,
    required super.pageSize,
    required super.pages,
    required super.total,
  });

  factory ResponsePagination.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ResponsePagination(
      list: (json["list"] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      pageNum: json["pageNum"] as int,
      pageSize: json["pageSize"] as int,
      pages: json["pages"] as int,
      total: json["total"] as int,
    );
  }
}

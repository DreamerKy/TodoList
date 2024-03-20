/*
 * @Description:页面状态枚举类
 */
enum PageState {
  /// 初始状态
  initializeState,

  /// 加载状态
  loadingState,

  /// 错误状态,显示失败界面
  errorState,

  /// 错误状态,只弹错误信息
  erroronlyTotal,

  /// 错误状态,显示刷新按钮
  errorshowRelesh,

  /// 没有更多数据
  noMoreDataState,

  /// 是否还有更多数据
  hasMoreDataState,

  /// 空数据状态
  emptyDataState,

  /// 数据获取成功状态
  dataSussessState,
}

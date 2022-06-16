import 'package:get/get.dart';
import 'package:paged_view/paged.dart';
import 'package:paged_view/src/model/paging_state.dart';
import 'package:paged_view/src/model/paging_status.dart';

typedef PagePullDownCallback<PageKeyType, ItemType> = Future<void>? Function(
    PagingController<PageKeyType, ItemType> pagingController);
typedef PageRequestCallback<PageKeyType, ItemType>
    = Future<List<ItemType>?> Function(PageKeyType pageKey,
        PagingController<PageKeyType, ItemType> pagingController);
typedef NextPageKeyCallback<PageKeyType, ItemType> = PageKeyType? Function(
    PageKeyType currentPageKey,
    int currentSize,
    int appendSize,
    PagingController<PageKeyType, ItemType> pagingController);

class PagingController<PageKeyType, ItemType> extends GetxController {
  /// 分页初始索引
  final PageKeyType firstPageKey;

  final ViewType viewType;

  /// 预加载索引
  int? invisibleItemsThreshold;

  PagingState<PageKeyType, ItemType> paging;

  PagePullDownCallback<PageKeyType, ItemType>? onPullDown;
  PageRequestCallback<PageKeyType, ItemType>? onPageRequest;
  NextPageKeyCallback<PageKeyType, ItemType>? onNextPageKey;

  PagingController({
    required this.firstPageKey,
    required this.viewType,
    required this.onNextPageKey,
    this.onPullDown,
    this.onPageRequest,
    this.invisibleItemsThreshold,
  }) : paging = PagingState<PageKeyType, ItemType>(firstPageKey);

  PagingController.fromValue(
    PagingState<PageKeyType, ItemType> value, {
    required this.firstPageKey,
    required this.viewType,
    this.invisibleItemsThreshold,
  }) : paging = value;

  PagingStatus get status => paging.status;

  List<ItemType>? get itemList => paging.itemList;

  int get itemSize => itemList?.length ?? 0;

  void appendItems(List<ItemType> appendItems) {
    appendItemsWithoutRefresh(appendItems);
    refresh();
  }

  void appendItemsWithoutRefresh(List<ItemType>? appendItems) {
    if (appendItems == null) {
      return;
    }
    final previousItems = itemList;
    if (previousItems == null) {
      paging.itemList = appendItems;
      paging.error = null;
      return;
    }
    final newItems = previousItems + appendItems;
    paging.itemList = newItems;
    paging.error = null;
  }

  dynamic get error => paging.error;

  PageKeyType? get nextPageKey => paging.nextPageKey;

  Future<void> loadFirstPage() async {
    paging.reset();
    await loadNextPage();
  }

  Future<void> loadNextPage() async {
    final currentPage = nextPageKey;
    if (currentPage == null) {
      return;
    }
    try {
      List<ItemType> newItems =
          await onPageRequest?.call(currentPage, this) ?? List.empty();
      final nextPage = onNextPageKey?.call(
        currentPage,
        itemSize,
        newItems.length,
        this,
      );
      paging.nextPageKey = nextPage == currentPage ? null : nextPage;
      appendItemsWithoutRefresh(newItems);
      refresh();
    } catch (e) {
      paging.error = e;
      refresh();
    }
  }

  /// Erases the current error.
  void retryLastFailedRequest() {
    paging.error = null;
    refresh();
  }

  /// Resets [value] to its initial state.
  Future<void> requestRefresh() async {
    paging.reset();
    await onPullDown?.call(this);
    refresh();
  }

  @override
  void onClose() {
    onPageRequest = null;
    onNextPageKey = null;
    onPullDown = null;
    super.onClose();
  }
}

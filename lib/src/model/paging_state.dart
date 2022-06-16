import 'package:paged_view/src/model/paging_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PagingState<PageKeyType, ItemType> {
  /// List with all items loaded so far.
  List<ItemType>? itemList;

  /// The current error, if any.
  dynamic error;

  /// The key for the next page to be fetched.
  PageKeyType? nextPageKey;

  final PageKeyType firstPageKey;

  PagingState(this.firstPageKey) {
    nextPageKey = firstPageKey;
  }

  void reset() {
    error = null;
    itemList = null;
    nextPageKey = firstPageKey;
  }

  /// The current pagination status.
  PagingStatus get status {
    if (_isOngoing) {
      return PagingStatus.ongoing;
    }

    if (_isCompleted) {
      return PagingStatus.completed;
    }

    if (_isLoadingFirstPage) {
      return PagingStatus.loadingFirstPage;
    }

    if (_hasSubsequentPageError) {
      return PagingStatus.subsequentPageError;
    }

    if (_isEmpty) {
      return PagingStatus.noItemsFound;
    } else {
      return PagingStatus.firstPageError;
    }
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'PagingState')}(itemList: \u2524'
      '$itemList\u251C, error: $error, nextPageKey: $nextPageKey)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PagingState &&
        other.itemList == itemList &&
        other.error == error &&
        other.nextPageKey == nextPageKey;
  }

  @override
  int get hashCode => hashValues(
        itemList.hashCode,
        error.hashCode,
        nextPageKey.hashCode,
      );

  int? get _itemCount => itemList?.length;

  bool get _hasNextPage => nextPageKey != null;

  bool get _hasItems {
    final itemCount = _itemCount;
    return itemCount != null && itemCount > 0;
  }

  bool get _hasError => error != null;

  bool get _isListingUnfinished => _hasItems && _hasNextPage;

  bool get _isOngoing => _isListingUnfinished && !_hasError;

  bool get _isCompleted => _hasItems && !_hasNextPage;

  bool get _isLoadingFirstPage => _itemCount == null && !_hasError;

  bool get _hasSubsequentPageError => _isListingUnfinished && _hasError;

  bool get _isEmpty => _itemCount != null && _itemCount == 0;
}

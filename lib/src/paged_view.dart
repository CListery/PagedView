import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide RefreshIndicator;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paged_view/src/core/paged_child_builder_delegate.dart';
import 'package:paged_view/src/core/paging_controller.dart';
import 'package:paged_view/src/ui/paged_grid_view.dart';
import 'package:paged_view/src/ui/paged_list_view.dart';

enum ViewType {
  list,
  grid,
}

class FastLoader<PageKeyType, ItemType> extends StatelessWidget {
  final PagingController<PageKeyType, ItemType> controller;
  final PagedChildBuilderDelegate<ItemType> builderDelegate;
  final IndexedWidgetBuilder? separatorBuilder;
  final SliverGridDelegate? gridDelegate;

  // Corresponds to [ScrollView.controller].
  final ScrollController? scrollController;

  // Corresponds to [ScrollView.scrollDirection].
  final Axis scrollDirection;

  // Corresponds to [ScrollView.reverse].
  final bool reverse;

  // Corresponds to [ScrollView.primary].
  final bool? primary;

  // Corresponds to [ScrollView.physics].
  final ScrollPhysics? physics;

  // Corresponds to [ScrollView.shrinkWrap].
  final bool shrinkWrap;

  // Corresponds to [BoxScrollView.padding].
  final EdgeInsetsGeometry? padding;
  final bool? itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  // Corresponds to [ScrollView.cacheExtent]
  final double? cacheExtent;

  // Corresponds to [ScrollView.dragStartBehavior]
  final DragStartBehavior dragStartBehavior;

  // Corresponds to [ScrollView.keyboardDismissBehavior]
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  // Corresponds to [ScrollView.restorationId]
  final String? restorationId;

  // Corresponds to [ScrollView.clipBehavior]
  final Clip clipBehavior;

  /// Corresponds to [PagedSliverGrid.showNewPageProgressIndicatorAsGridChild].
  final bool showNewPageProgressIndicatorAsGridChild;

  /// Corresponds to [PagedSliverGrid.showNewPageErrorIndicatorAsGridChild].
  final bool showNewPageErrorIndicatorAsGridChild;

  /// Corresponds to [PagedSliverGrid.showNoMoreItemsIndicatorAsGridChild].
  final bool showNoMoreItemsIndicatorAsGridChild;

  FastLoader.list({
    Key? key,
    required PageKeyType firstPageKey,
    required this.builderDelegate,
    required NextPageKeyCallback<PageKeyType, ItemType> onNextPageKey,
    PagePullDownCallback<PageKeyType, ItemType>? onPullDown,
    PageRequestCallback<PageKeyType, ItemType>? onPageRequest,
    this.separatorBuilder,
    // Corresponds to [ScrollView.controller].
    this.scrollController,
    // Corresponds to [ScrollView.scrollDirection].
    this.scrollDirection = Axis.vertical,
    // Corresponds to [ScrollView.reverse].
    this.reverse = false,
    // Corresponds to [ScrollView.primary].
    this.primary,
    // Corresponds to [ScrollView.physics].
    this.physics,
    // Corresponds to [ScrollView.shrinkWrap].
    this.shrinkWrap = false,
    // Corresponds to [BoxScrollView.padding].
    this.padding,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    // Corresponds to [ScrollView.cacheExtent]
    this.cacheExtent,
    // Corresponds to [ScrollView.dragStartBehavior]
    this.dragStartBehavior = DragStartBehavior.start,
    // Corresponds to [ScrollView.keyboardDismissBehavior]
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    // Corresponds to [ScrollView.restorationId]
    this.restorationId,
    // Corresponds to [ScrollView.clipBehavior]
    this.clipBehavior = Clip.hardEdge,
  })  : controller = Get.put(
          PagingController<PageKeyType, ItemType>(
            firstPageKey: firstPageKey,
            viewType: ViewType.list,
            onPullDown: onPullDown,
            onPageRequest: onPageRequest,
            onNextPageKey: onNextPageKey,
          ),
        ),
        gridDelegate = null,
        showNewPageProgressIndicatorAsGridChild = false,
        showNewPageErrorIndicatorAsGridChild = false,
        showNoMoreItemsIndicatorAsGridChild = false,
        super(key: key);

  FastLoader.grid({
    Key? key,
    required PageKeyType firstPageKey,
    required this.builderDelegate,
    required this.gridDelegate,
    required NextPageKeyCallback<PageKeyType, ItemType> onNextPageKey,
    PagePullDownCallback<PageKeyType, ItemType>? onPullDown,
    PageRequestCallback<PageKeyType, ItemType>? onPageRequest,
    // Corresponds to [ScrollView.controller].
    this.scrollController,
    // Corresponds to [ScrollView.scrollDirection].
    this.scrollDirection = Axis.vertical,
    // Corresponds to [ScrollView.reverse].
    this.reverse = false,
    // Corresponds to [ScrollView.primary].
    this.primary,
    // Corresponds to [ScrollView.physics].
    this.physics,
    // Corresponds to [ScrollView.shrinkWrap].
    this.shrinkWrap = false,
    // Corresponds to [BoxScrollView.padding].
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    // Corresponds to [ScrollView.cacheExtent].
    this.cacheExtent,
    this.showNewPageProgressIndicatorAsGridChild = true,
    this.showNewPageErrorIndicatorAsGridChild = true,
    this.showNoMoreItemsIndicatorAsGridChild = true,
    // Corresponds to [ScrollView.dragStartBehavior].
    this.dragStartBehavior = DragStartBehavior.start,
    // Corresponds to [ScrollView.keyboardDismissBehavior].
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    // Corresponds to [ScrollView.restorationId].
    this.restorationId,
    // Corresponds to [ScrollView.clipBehavior].
    this.clipBehavior = Clip.hardEdge,
  })  : controller = Get.put(
          PagingController<PageKeyType, ItemType>(
            firstPageKey: firstPageKey,
            viewType: ViewType.grid,
            onPullDown: onPullDown,
            onPageRequest: onPageRequest,
            onNextPageKey: onNextPageKey,
          ),
        ),
        separatorBuilder = null,
        itemExtent = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.onPullDown == null) {
      return _buildView();
    }
    return RefreshIndicator(
      onRefresh: () => controller.requestRefresh(),
      child: _buildView(),
    );
  }

  Widget _buildView() {
    switch (controller.viewType) {
      case ViewType.list:
        return separatorBuilder == null
            ? PagedListView<PageKeyType, ItemType>(
                builderDelegate: builderDelegate,
                scrollDirection: scrollDirection,
                reverse: reverse,
                scrollController: scrollController,
                primary: primary,
                physics: physics,
                shrinkWrap: shrinkWrap,
                padding: padding,
                cacheExtent: cacheExtent,
                dragStartBehavior: dragStartBehavior,
                keyboardDismissBehavior: keyboardDismissBehavior,
                restorationId: restorationId,
                clipBehavior: clipBehavior,
              )
            : PagedListView<PageKeyType, ItemType>.separated(
                builderDelegate: builderDelegate,
                separatorBuilder: separatorBuilder!,
                scrollDirection: scrollDirection,
                reverse: reverse,
                scrollController: scrollController,
                primary: primary,
                physics: physics,
                shrinkWrap: shrinkWrap,
                padding: padding,
                cacheExtent: cacheExtent,
                dragStartBehavior: dragStartBehavior,
                keyboardDismissBehavior: keyboardDismissBehavior,
                restorationId: restorationId,
                clipBehavior: clipBehavior,
              );
      case ViewType.grid:
        return PagedGridView<PageKeyType, ItemType>(
          builderDelegate: builderDelegate,
          gridDelegate: gridDelegate!,
          scrollDirection: scrollDirection,
          reverse: reverse,
          scrollController: scrollController,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );
    }
  }
}

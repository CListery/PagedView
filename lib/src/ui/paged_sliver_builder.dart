import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paged_view/src/core/paged_child_builder_delegate.dart';
import 'package:paged_view/src/core/paged_configure_controller.dart';
import 'package:paged_view/src/core/paging_controller.dart';
import 'package:paged_view/src/model/paging_status.dart';
import 'package:paged_view/src/ui/default_indicators/first_page_error_indicator.dart';
import 'package:paged_view/src/ui/default_indicators/first_page_progress_indicator.dart';
import 'package:paged_view/src/ui/default_indicators/new_page_error_indicator.dart';
import 'package:paged_view/src/ui/default_indicators/new_page_progress_indicator.dart';
import 'package:paged_view/src/ui/default_indicators/no_items_found_indicator.dart';
import 'package:paged_view/src/ui/default_indicators/no_more_items_indicator.dart';

typedef CompletedListingBuilder = Widget Function(
  BuildContext context,
  IndexedWidgetBuilder itemWidgetBuilder,
  int itemCount,
  WidgetBuilder? noMoreItemsIndicatorBuilder,
);

typedef ErrorListingBuilder = Widget Function(
  BuildContext context,
  IndexedWidgetBuilder itemWidgetBuilder,
  int itemCount,
  WidgetBuilder newPageErrorIndicatorBuilder,
);

typedef LoadingListingBuilder = Widget Function(
  BuildContext context,
  IndexedWidgetBuilder itemWidgetBuilder,
  int itemCount,
  WidgetBuilder newPageProgressIndicatorBuilder,
);

/// Assists the creation of infinitely scrolled paged sliver widgets.
///
/// Combines a [PagingController] with a
/// [PagedChildBuilderDelegate] and calls the supplied
/// [loadingListingBuilder], [errorListingBuilder] or
/// [completedListingBuilder] for filling in the gaps.
///
/// For ordinary cases, this widget shouldn't be used directly. Instead, take a
/// look at [PagedSliverList], [PagedSliverGrid],
/// [PagedGridView] and [PagedListView].
class PagedSliverBuilder<PageKeyType, ItemType>
    extends GetWidget<PagingController<PageKeyType, ItemType>> {
  const PagedSliverBuilder({
    required this.builderDelegate,
    required this.loadingListingBuilder,
    required this.errorListingBuilder,
    required this.completedListingBuilder,
    this.gridDelegate,
    this.shrinkWrapFirstPageIndicators = false,
    Key? key,
  }) : super(key: key);

  /// The delegate for building the UI pieces of scrolling paged listings.
  final PagedChildBuilderDelegate<ItemType> builderDelegate;

  /// The builder for an in-progress listing.
  final LoadingListingBuilder loadingListingBuilder;

  /// The builder for an in-progress listing with a failed request.
  final ErrorListingBuilder errorListingBuilder;

  /// The builder for a completed listing.
  final CompletedListingBuilder completedListingBuilder;

  final SliverGridDelegate? gridDelegate;

  /// Whether the extent of the first page indicators should be determined by
  /// the contents being viewed.
  ///
  /// If the paged sliver builder does not shrink wrap, then the first page
  /// indicators will expand to the maximum allowed size. If the paged sliver
  /// builder has unbounded constraints, then [shrinkWrapFirstPageIndicators]
  /// must be true.
  ///
  /// Defaults to false.
  final bool shrinkWrapFirstPageIndicators;

  // PagingController<PageKeyType, ItemType> get _pagingController => controller;

  PagedChildBuilderDelegate<ItemType> get _builderDelegate => builderDelegate;

  bool get _shrinkWrapFirstPageIndicators => shrinkWrapFirstPageIndicators;

  WidgetBuilder get _firstPageErrorIndicatorBuilder =>
      _builderDelegate.firstPageErrorIndicatorBuilder ??
      Get.find<PagedConfigureController>().firstPageErrorIndicatorBuilder ??
      (_) => FirstPageErrorIndicator(
            onTryAgain: controller.retryLastFailedRequest,
          );

  WidgetBuilder get _newPageErrorIndicatorBuilder =>
      _builderDelegate.newPageErrorIndicatorBuilder ??
      Get.find<PagedConfigureController>().newPageErrorIndicatorBuilder ??
      (_) => NewPageErrorIndicator(
            onTap: controller.retryLastFailedRequest,
          );

  WidgetBuilder get _firstPageProgressIndicatorBuilder =>
      (_) => FirstPageProgressIndicator(
            viewType: controller.viewType,
            gridDelegate: gridDelegate,
            itemBuilder: _builderDelegate.firstPageProgressShimmerBuilder ??
                Get.find<PagedConfigureController>()
                    .firstPageProgressShimmerBuilder,
          );

  WidgetBuilder get _newPageProgressIndicatorBuilder =>
      _builderDelegate.newPageProgressIndicatorBuilder ??
      Get.find<PagedConfigureController>().newPageProgressIndicatorBuilder ??
      (_) => const NewPageProgressIndicator();

  WidgetBuilder get _noItemsFoundIndicatorBuilder =>
      _builderDelegate.noItemsFoundIndicatorBuilder ??
      Get.find<PagedConfigureController>().noItemsFoundIndicatorBuilder ??
      (_) => const NoItemsFoundIndicator();

  WidgetBuilder? get _noMoreItemsIndicatorBuilder =>
      _builderDelegate.noMoreItemsIndicatorBuilder ??
      Get.find<PagedConfigureController>().noMoreItemsIndicatorBuilder ??
      (_) => const NoMoreItemsIndicator();

  int get _invisibleItemsThreshold => controller.invisibleItemsThreshold ?? 3;

  int get _itemCount => controller.itemSize;

  bool get _hasNextPage => controller.hasNextPage;

  @override
  Widget build(BuildContext context) {
    // The SliverPadding is used to avoid changing the topmost item inside a
    // CustomScrollView.
    // https://github.com/flutter/flutter/issues/55170
    return SliverPadding(
      padding: const EdgeInsets.all(0),
      sliver: GetBuilder<PagingController<PageKeyType, ItemType>>(
        builder: (controller) {
          Widget sliver;
          switch (controller.status) {
            case PagingStatus.ongoing:
              sliver = loadingListingBuilder(
                context,
                _buildListItemWidget,
                _itemCount,
                _newPageProgressIndicatorBuilder,
              );
              break;
            case PagingStatus.completed:
              sliver = completedListingBuilder(
                context,
                _buildListItemWidget,
                _itemCount,
                _noMoreItemsIndicatorBuilder,
              );
              break;
            case PagingStatus.loadingFirstPage:
              sliver = _FirstPageStatusIndicatorBuilder(
                builder: _firstPageProgressIndicatorBuilder,
                shrinkWrap: _shrinkWrapFirstPageIndicators,
              );
              controller.loadFirstPage();
              break;
            case PagingStatus.subsequentPageError:
              sliver = errorListingBuilder(
                context,
                _buildListItemWidget,
                _itemCount,
                (context) => _newPageErrorIndicatorBuilder(context),
              );
              break;
            case PagingStatus.noItemsFound:
              sliver = _FirstPageStatusIndicatorBuilder(
                builder: _noItemsFoundIndicatorBuilder,
                shrinkWrap: _shrinkWrapFirstPageIndicators,
              );
              break;
            case PagingStatus.firstPageError:
              sliver = _FirstPageStatusIndicatorBuilder(
                builder: _firstPageErrorIndicatorBuilder,
                shrinkWrap: _shrinkWrapFirstPageIndicators,
              );
              break;
          }
          return sliver;
        },
      ),
    );
  }

  /// Connects the [_pagingController] with the [_builderDelegate] in order to
  /// create a list item widget and request more items if needed.
  Widget _buildListItemWidget(
    BuildContext context,
    int index,
  ) {
    final newPageRequestTriggerIndex =
        max(0, _itemCount - _invisibleItemsThreshold);

    final isBuildingTriggerIndexItem = index == newPageRequestTriggerIndex;

    if (_hasNextPage && isBuildingTriggerIndexItem) {
      // Schedules the request for the end of this frame.
      controller.loadNextPage();
    }

    final item = controller.itemList![index];
    return _builderDelegate.itemBuilder(context, item, index);
  }
}

extension on PagingController {
  /// Tells whether there's a next page to request.
  bool get hasNextPage => nextPageKey != null;
}

class _FirstPageStatusIndicatorBuilder extends StatelessWidget {
  const _FirstPageStatusIndicatorBuilder({
    required this.builder,
    this.shrinkWrap = false,
    Key? key,
  }) : super(key: key);

  final WidgetBuilder builder;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    if (shrinkWrap) {
      return SliverToBoxAdapter(
        child: builder(context),
      );
    } else {
      return SliverFillRemaining(
        hasScrollBody: true,
        child: builder(context),
      );
    }
  }
}

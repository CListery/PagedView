import 'package:flutter/widgets.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

typedef ItemWidgetBuilder<ItemType> = Widget Function(
  BuildContext context,
  ItemType item,
  int index,
);

typedef GFShimmerBuilder = GFShimmer Function(
  BuildContext context,
  int index,
);

/// Supplies builders for the visual components of paged views.
///
/// The generic type [ItemType] must be specified in order to properly identify
/// the list item’s type.
class PagedChildBuilderDelegate<ItemType> {
  PagedChildBuilderDelegate({
    required this.itemBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageProgressShimmerBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
  });

  /// The builder for list items.
  final ItemWidgetBuilder<ItemType> itemBuilder;

  /// The builder for the first page's error indicator.
  final WidgetBuilder? firstPageErrorIndicatorBuilder;

  /// The builder for a new page's error indicator.
  final WidgetBuilder? newPageErrorIndicatorBuilder;

  /// The builder for the first page's progress indicator.
  final GFShimmerBuilder? firstPageProgressShimmerBuilder;

  /// The builder for a new page's progress indicator.
  final WidgetBuilder? newPageProgressIndicatorBuilder;

  /// The builder for a no items list indicator.
  final WidgetBuilder? noItemsFoundIndicatorBuilder;

  /// The builder for an indicator that all items have been fetched.
  final WidgetBuilder? noMoreItemsIndicatorBuilder;
}

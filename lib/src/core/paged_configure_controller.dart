import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paged_view/paged.dart';

class PagedConfigureController extends GetxController {
  WidgetBuilder? firstPageErrorIndicatorBuilder;

  WidgetBuilder? newPageErrorIndicatorBuilder;

  GFShimmerBuilder? firstPageProgressShimmerBuilder;

  WidgetBuilder? newPageProgressIndicatorBuilder;

  WidgetBuilder? noItemsFoundIndicatorBuilder;

  WidgetBuilder? noMoreItemsIndicatorBuilder;

  PagedConfigureController({
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageProgressShimmerBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
  });
}

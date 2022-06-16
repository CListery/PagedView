import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paged_view/src/lang/paged_localizations.dart';
import 'package:paged_view/src/ui/default_indicators/first_page_exception_indicator.dart';

class NoItemsFoundIndicator extends StatelessWidget {
  const NoItemsFoundIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PagedString strings = PagedLocalizations.of(context)?.currentLocalization ?? EnPagedString();
    return FirstPageExceptionIndicator(
      title: strings.noItemsFoundTitle,
    );
  }
}

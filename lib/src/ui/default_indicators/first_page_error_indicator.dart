import 'package:flutter/material.dart';
import 'package:paged_view/src/lang/paged_localizations.dart';
import 'package:paged_view/src/ui/default_indicators/first_page_exception_indicator.dart';

class FirstPageErrorIndicator extends StatelessWidget {
  const FirstPageErrorIndicator({
    this.onTryAgain,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    PagedString strings = PagedLocalizations.of(context)?.currentLocalization ?? EnPagedString();
    return FirstPageExceptionIndicator(
      title: strings.firstPageExceptionTitle,
      message: strings.firstPageExceptionMessage,
      onTryAgain: onTryAgain,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paged_view/src/lang/paged_localizations.dart';
import 'package:paged_view/src/ui/default_indicators/footer_tile.dart';

class NoMoreItemsIndicator extends StatelessWidget {
  const NoMoreItemsIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PagedString strings = PagedLocalizations.of(context)?.currentLocalization ?? EnPagedString();
    return FooterTile(
      child: Text(
        strings.noMoreItems,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:paged_view/src/lang/paged_localizations.dart';
import 'package:paged_view/src/ui/default_indicators/footer_tile.dart';

class NewPageProgressIndicator extends StatelessWidget {
  const NewPageProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PagedString strings = PagedLocalizations.of(context)?.currentLocalization ?? EnPagedString();
    return FooterTile(
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox.square(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
            dimension: 16,
          ),
          const SizedBox(width: 5),
          Text(
            strings.loading,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

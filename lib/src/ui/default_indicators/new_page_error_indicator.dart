import 'package:flutter/material.dart';
import 'package:paged_view/src/lang/paged_localizations.dart';
import 'package:paged_view/src/ui/default_indicators/footer_tile.dart';

class NewPageErrorIndicator extends StatelessWidget {
  const NewPageErrorIndicator({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    PagedString strings = PagedLocalizations.of(context)?.currentLocalization ?? EnPagedString();
    return InkWell(
      onTap: onTap,
      child: FooterTile(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              strings.newPageError,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 4,
            ),
            const Icon(
              Icons.refresh,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:paged_view/paged.dart';
import 'package:paged_view/src/paged_view.dart';

class FirstPageProgressIndicator extends StatelessWidget {
  final ViewType viewType;
  final SliverGridDelegate? gridDelegate;
  final GFShimmerBuilder? itemBuilder;

  const FirstPageProgressIndicator({
    Key? key,
    required this.viewType,
    this.gridDelegate,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewType) {
      case ViewType.list:
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: itemBuilder ?? _listItemBuilder,
        );
      case ViewType.grid:
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: gridDelegate!,
          itemBuilder: itemBuilder ?? _gridItemBuilder,
        );
    }
  }

  GFShimmer _listItemBuilder(BuildContext context, int index) {
    return GFShimmer(
      showGradient: true,
      gradient: LinearGradient(
        colors: <Color>[
          Colors.grey.shade400,
          Colors.blueGrey.shade600,
          Colors.grey.shade400,
          Colors.blueGrey.shade600,
        ],
        tileMode: TileMode.mirror,
      ),
      child: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  GFShimmer _gridItemBuilder(BuildContext context, int index) {
    return GFShimmer(
      showGradient: true,
      gradient: LinearGradient(
        colors: <Color>[
          Colors.grey.shade400,
          Colors.blueGrey.shade600,
          Colors.grey.shade400,
          Colors.blueGrey.shade600,
        ],
        tileMode: TileMode.mirror,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Container(
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

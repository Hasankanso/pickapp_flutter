import 'package:flutter/material.dart';
import 'package:just_miles/ads/MainNativeAd.dart';

class ListBuilder extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final List<Object> list;
  final bool reverse;
  final double nativeAdHeight;
  bool isAdShown = false;
  double nativeAdElevation;
  double nativeAdRoundCorner;
  ListController listController = new ListController();
  ScrollController controller = new ScrollController(initialScrollOffset: 1.1);
  ListBuilder(
      {this.list,
      this.itemBuilder,
      this.controller,
      this.reverse = false,
      this.nativeAdHeight,
      this.nativeAdElevation,
      this.nativeAdRoundCorner});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      child: nativeAdHeight != null
          ? ListView.separated(
              controller: controller,
              separatorBuilder: (BuildContext context, int index) {
                if (!isAdShown && index % 1 == 0) {
                  isAdShown = true;
                  return Card(
                    elevation:
                        nativeAdElevation == null ? 3.0 : nativeAdElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          nativeAdRoundCorner == null
                              ? 15.0
                              : nativeAdRoundCorner),
                    ),
                    child: Container(
                      height: nativeAdHeight,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(
                            nativeAdRoundCorner == null
                                ? 15.0
                                : nativeAdRoundCorner)),
                      ),
                      child: MainNativeAd(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(
                              nativeAdRoundCorner == null
                                  ? 15.0
                                  : nativeAdRoundCorner)),
                        ),
                      ),
                    ),
                  );
                }
                return Divider();
              },
              reverse: reverse,
              itemBuilder: itemBuilder,
              itemCount: list.length)
          : ListView.builder(
              controller: controller,
              reverse: reverse,
              itemBuilder: itemBuilder,
              itemCount: list.length),
    );
  }
}

class ListController {
  int selected = -1;
}

import 'package:flutter/material.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/utilities/Spinner.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListBuilder extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final VoidFutureCallBack onPullRefresh;
  final List<Object> list;
  final bool reverse;
  final double nativeAdHeight;
  bool isAdShown = false;
  double nativeAdElevation;
  double nativeAdRoundCorner;
  ListController listController = new ListController();
  ScrollController controller = new ScrollController(initialScrollOffset: 1.1);
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ListBuilder(
      {this.list,
      this.itemBuilder,
      this.controller,
      this.reverse = false,
      this.nativeAdHeight,
      this.nativeAdElevation,
      this.nativeAdRoundCorner,
      this.onPullRefresh});

  Widget buildList() {
    if (nativeAdHeight != null) {
      return ListView.separated(
          controller: controller,
          separatorBuilder: (BuildContext context, int index) {
            if (!isAdShown && index % 1 == 0) {
              isAdShown = true;
              return Card(
                elevation: nativeAdElevation == null ? 3.0 : nativeAdElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      nativeAdRoundCorner == null ? 15.0 : nativeAdRoundCorner),
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
          itemCount: list.length);
    } else {
      return ListView.builder(
          controller: controller,
          reverse: reverse,
          itemBuilder: itemBuilder,
          itemCount: list.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      child: onPullRefresh != null
          ? SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                waterDropColor: Styles.primaryColor(),
                refresh: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Styles.labelColor().withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Spinner(),
                      )),
                ),
                complete: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.done,
                      color: Styles.primaryColor(),
                    ),
                  ],
                ),
              ),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              controller: _refreshController,
              onRefresh: () async {
                await onPullRefresh();
                _refreshController.refreshCompleted();
                _refreshController.loadComplete();
              },
              child: buildList(),
            )
          : buildList(),
    );
  }
}

class ListController {
  int selected = -1;
}

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dancers_map/pages/views/view_loadmore_widget.dart';
import 'package:flutter/material.dart';

class FetchMoreIndicator extends StatelessWidget {
  final Widget child;
  final VoidCallback onAction;

  const FetchMoreIndicator({
    super.key,
    required this.child,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    const height = 150.0;
    return CustomRefreshIndicator(
      onRefresh: () async => onAction(),
      trigger: IndicatorTrigger.trailingEdge,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      durations: const RefreshIndicatorDurations(
        completeDuration: Duration(seconds: 1),
      ),
      child: child,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final dy = controller.value.clamp(0.0, 1.25) *
                  -(height - (height * 0.25));
              return Stack(
                children: [
                  child,
                  PositionedIndicatorContainer(
                    controller: controller,
                    displacement: 0,
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        transform: Matrix4.translationValues(0.0, dy, 0.0),
                        child: switch (controller.state) {
                          IndicatorState.idle => null,
                          IndicatorState.dragging ||
                          IndicatorState.canceling ||
                          IndicatorState.armed ||
                          IndicatorState.settling =>
                            LoadMoreView(
                              icon: SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/imgs/png_arrow_up.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              msg: '上拉更多！',
                            ),
                          IndicatorState.loading =>
                              LoadMoreView(
                                icon: SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/imgs/png_loading.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                msg: '加载中！',
                              ),
                          IndicatorState.complete ||
                          IndicatorState.finalizing =>
                              LoadMoreView(
                                icon: SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/imgs/png_ok.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                msg: '加载完毕！',
                              ),
                        }),
                  ),
                ],
              );
            });
      },
    );
  }
}

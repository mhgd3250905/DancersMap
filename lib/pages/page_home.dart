import 'package:auto_animated/auto_animated.dart';
import 'package:dancers_map/ctrl/ctrl_query.dart';
import 'package:dancers_map/data/bean_dancers.dart';
import 'package:dancers_map/network/enum_connect_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  final int listItemCount = 4;
  final Duration listShowItemDuration = Duration(milliseconds: 250);

  final options = const LiveOptions(
    // Start animation after (default zero)
    delay: Duration(milliseconds: 100),
    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 100),
    // Animation duration (default 250)
    showItemDuration: Duration(milliseconds: 100),
    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.05,
    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );

  @override
  void initState() {
    super.initState();
    QueryCtrl.to.queryDancers();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: buildMainBody(),
      ),
    );
  }

  Widget buildMainBody() {
    return Obx(() {
      var queryState = QueryCtrl.to.dancersState.value;
      Widget body = Container();
      switch (queryState) {
        case ConnectState.waiting:
          //等待界面
          break;
        case ConnectState.err:
          break;
        case ConnectState.done:
          //完成界面
          var dancers = QueryCtrl.to.dancersLive.value.data ?? [];
          if(dancers.isEmpty){

          }else if(dancers.length==1){
            body=buildDancerItem(dancers[0]!);
          }else {
            body = Flexible(
              child: CardSwiper(
                cardsCount: dancers.length,
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) {
                  return buildDancerItem(dancers[index]!);
                },
              ),
            );
          }
          break;
        case ConnectState.none:
          break;
      }
      return body;
    });
  }

  Widget buildDancerItem(Dancer dancer) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 1.0),
        color: Colors.blueGrey,
      ),
      child: Column(
        children: [
          Container(
            child: Text(
              '${dancer.nick_name}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Widget buildMainBody() {
//   return CustomScrollView(
//     // Must add scrollController to sliver root
//     controller: scrollController,
//     slivers: <Widget>[
//       LiveSliverGrid.options(
//         options: options,
//         // And attach root sliver scrollController to widgets
//         controller: scrollController,
//
//         itemCount: 24,
//         itemBuilder: buildAnimatedItem,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//         ),
//       ),
//     ],
//   );
// }

// Widget buildAnimatedItem(
//     BuildContext context, int index, Animation<double> animation) {
//   return FadeTransition(
//     opacity: Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(animation),
//     // And slide transition
//     child: SlideTransition(
//       position: Tween<Offset>(
//         begin: Offset(0, -0.1),
//         end: Offset.zero,
//       ).animate(animation),
//       // Paste you Widget
//       child: Container(
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.black87, width: 1.0),
//             color: Colors.blueGrey),
//       ),
//     ),
//   );
// }
}

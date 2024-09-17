import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dancers_map/ctrl/ctrl_query.dart';
import 'package:dancers_map/data/bean_dancers.dart';
import 'package:dancers_map/network/enum_connect_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

const colorizeTextStyle = TextStyle(
  fontSize: 50.0,
  fontFamily: 'Horizon',
);

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
          if (dancers.isEmpty) {
          } else if (dancers.length == 1) {
            body = buildDancerItem(dancers[0]!);
          } else {
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
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurStyle: BlurStyle.normal,
              spreadRadius: 5.0,
              blurRadius: 10.0,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: dancer.avatar!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/imgs/head.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '${dancer.nick_name}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            child: Text(
              dancer.getDesc(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w100),
            ),
          ),
          buildDancerPhotos(dancer.photos),
        ],
      ),
    );
  }

  Widget buildDancerPhotos(List<String>? photos) {
    if (photos == null||photos.isEmpty) return Container();
    List<Widget> imgWidgets = [];
    if (photos.length == 1) {
      return buildPhotoItem(photos[0]);
    } else {
      return Flexible(
        child: CardSwiper(
          cardsCount: photos.length,
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
            return buildPhotoItem(photos[index]);
          },
        ),
      );
    }
  }

  Widget buildPhotoItem(String photoPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: CachedNetworkImage(
        imageUrl: photoPath,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Image.asset(
          'assets/imgs/head.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dancers_map/ctrl/ctrl_home.dart';
import 'package:dancers_map/ctrl/ctrl_query.dart';
import 'package:dancers_map/ctrl/ctrl_spider_dancer.dart';
import 'package:dancers_map/data/bean_dancers.dart';
import 'package:dancers_map/data/bean_dancers_spider.dart';
import 'package:dancers_map/network/enum_connect_state.dart';
import 'package:dancers_map/refresh/fetch_more_indicator.dart';
import 'package:dancers_map/refresh/warp_indicator.dart';
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

  final _controller = IndicatorController();

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
    SpiderDancerCtrl.to.queryDancers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.yellowAccent,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          accentColor: Colors.redAccent,
        ),
      ),
      home: Material(
        child: SafeArea(
          child: buildSliver(),
        ),
      ),
    );
  }

  Widget buildSliver() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      HomeCtrl.to.checkIndex.value=0;
                      HomeCtrl.to.checkIndex.refresh();
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildBboyCheckImage(),
                          SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: Image.asset(
                              'assets/imgs/png_boy.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            child: Text(
                              'Bboy',
                              style: TextStyle(
                                fontFamily: "KuaiKan",
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      HomeCtrl.to.checkIndex.value=1;
                      HomeCtrl.to.checkIndex.refresh();
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildBgirlCheckImage(),
                          SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: Image.asset(
                              'assets/imgs/png_girl.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            child: Text(
                              'Bgirl',
                              style: TextStyle(
                                fontFamily: "KuaiKan",
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(0.0),
          sliver: buildMainBody(),
        ),
      ],
    );
  }

  Widget buildBboyCheckImage() {
    return Obx(() {
      var index = HomeCtrl.to.checkIndex.value;
      return Visibility(
        visible: index == 0,
        child: SizedBox(
          width: 30.0,
          height: 30.0,
          child: Image.asset(
            'assets/imgs/png_check.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  Widget buildBgirlCheckImage() {
    return Obx(() {
      var index = HomeCtrl.to.checkIndex.value;
      return Visibility(
        visible: index == 1,
        child: SizedBox(
          width: 30.0,
          height: 30.0,
          child: Image.asset(
            'assets/imgs/png_check.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  Widget buildMainBody() {
    return Obx(() {
      var queryState = SpiderDancerCtrl.to.dancersState.value;
      Widget body = SliverToBoxAdapter(
        child: Container(),
      );
      switch (queryState) {
        case ConnectState.waiting:
          //等待界面
          break;
        case ConnectState.err:
          break;
        case ConnectState.done:
          //完成界面
          var dancers = SpiderDancerCtrl.to.dancersLive.value.data ?? [];
          body = SliverFillRemaining(
            child: WarpIndicator(
              controller: _controller,
              onRefresh: () async {
                await Future.delayed(
                  const Duration(seconds: 2),
                  () => SpiderDancerCtrl.to.queryDancers(reset: true),
                );
              },
              child: FetchMoreIndicator(
                onAction: _fetchMore,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 每行2列
                    crossAxisSpacing: 10.0, // 列间距
                    mainAxisSpacing: 10.0, // 行间距
                    childAspectRatio: 1, // 方形图片
                  ),
                  itemCount: dancers.length,
                  itemBuilder: (context, index) {
                    return buildHiphopItem(dancers[index]!);
                  },
                ),
              ),
            ),
          );
          break;
        case ConnectState.none:
          break;
      }
      return body;
    });
  }

  Future<void> _fetchMore() async {
    // Simulate fetch time
    SpiderDancerCtrl.to.queryDancers();
  }

  Widget buildDancerItem(SDancer dancer) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // 圆角
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent.shade100,
            Colors.orangeAccent.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(4, 4), // 阴影的偏移量
            blurRadius: 10, // 模糊半径
            spreadRadius: 1, // 阴影扩散半径
          ),
        ],
      ),
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
                      imageUrl: dancer.img_url!,
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
                      '${dancer.nickname}',
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
              "",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w100),
            ),
          ),
          // buildDancerPhotos(dancer.photos),
        ],
      ),
    );
  }

  Widget buildDancerPhotos(List<String>? photos) {
    if (photos == null || photos.isEmpty) return Container();
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

  Widget buildHiphopItem(SDancer dancer) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.redAccent, // 粗线条边框
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orangeAccent.withOpacity(0.6),
            blurRadius: 8,
            offset: Offset(4, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.yellowAccent, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              dancer.img_url!,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                dancer.nickname!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KuaiKan',
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      blurRadius: 6.0,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

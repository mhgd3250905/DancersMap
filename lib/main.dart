import 'package:dancers_map/ctrl/ctrl_home.dart';
import 'package:dancers_map/ctrl/ctrl_query.dart';
import 'package:dancers_map/ctrl/ctrl_spider_dancer.dart';
import 'package:dancers_map/pages/page_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String BASE_HOST = 'http://1.15.227.145';

void main() {

  runApp(
    GetMaterialApp(
      home: App(),
      theme: ThemeData(fontFamily: 'KuaiKan'),
      routingCallback: (routing) {},
      onInit: () {

      },
      builder: (context, widget) {
        return MediaQuery(
          //设置文字大小不随系统设置改变
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
      // theme: ThemeData.dark().copyWith(
      //   shadowColor: Colors.black87,
      //   bottomAppBarColor: Colors.blueGrey[900],
      //   backgroundColor: Colors.grey[300],
      // ),
    ),
  );
}


class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(QueryCtrl());
    Get.put(SpiderDancerCtrl());
    Get.put(HomeCtrl());
    return const  HomePage();
  }
}
import 'package:dancers_map/data/bean_dancers.dart';
import 'package:dancers_map/data/bean_dancers_spider.dart';
import 'package:dancers_map/main.dart';
import 'package:dancers_map/network/enum_connect_state.dart';
import 'package:dancers_map/network/http_client.dart';
import 'package:dancers_map/network/state_request.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;

class SpiderDancerCtrl extends GetxController {
  static SpiderDancerCtrl get to => Get.find();

  final dancersState = ConnectState.none.obs; //刷新的状态
  final dancersLive=SpiderDancersBean.fromParams(data: []).obs;


  Future<void> queryDancers({bool reset=false}) async {
    if (reset) {
      dancersLive.value.cursor = 0;
      dancersLive.refresh();
    }

    try {
      var formData = DIO.FormData.fromMap({
        'limit': 10,
        'cursor': dancersLive.value.cursor ?? 0,
        // 'token':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjYzODMwNzQsImlhdCI6MTcyNjI5NjY3NCwicGFzc3dvcmQiOiIxMjMiLCJhY2NvdW50IjoiYWJjIiwicGVybWlzc2lvbnMiOltdfQ.GHmeajOrdSNu0XUlaihA9hTdkZAmruhtzzUxDAdHaiQ'
      });

      String url = '$BASE_HOST/dancer/spider/bboy/query';

      print('url:$url');

      //这里为了显示加载过程，可退
      var response = await HttpManager.getInstance().dio!.post(
            url,
            data: formData,
          );

      SpiderDancersBean result = SpiderDancersBean.fromJson(response.data);

      if (result.err == RequestState.SUCCESS) {
        dancersLive.update((tempDancers) {
          List<SDancer?> dancers = result.data!;
          if (reset) {
            tempDancers!.data = dancers;
            tempDancers.data?.removeWhere((element) => element == null);
          } else {
            tempDancers!.data?.removeWhere((element) => element == null);
            tempDancers.data?.addAll(dancers);
          }
          tempDancers.err = result.err;
          tempDancers.err_msg = result.err_msg;
          tempDancers.cursor = result.cursor;
          tempDancers.token = result.token;
        });

        dancersState.value = ConnectState.done;
        dancersState.refresh();
      } else{
        dancersState.value = ConnectState.err;
        dancersState.refresh();
      }
    } catch (e) {
      print(e);
      dancersState.value = ConnectState.err;
      dancersState.refresh();
    }
    print('查询dancers完毕');
  }


}

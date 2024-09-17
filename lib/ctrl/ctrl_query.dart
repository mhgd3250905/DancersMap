import 'package:dancers_map/data/bean_dancers.dart';
import 'package:dancers_map/main.dart';
import 'package:dancers_map/network/enum_connect_state.dart';
import 'package:dancers_map/network/http_client.dart';
import 'package:dancers_map/network/state_request.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;

class QueryCtrl extends GetxController {
  static QueryCtrl get to => Get.find();

  final dancersState = ConnectState.none.obs; //刷新的状态
  final dancersLive=DancersBean.fromParams().obs;


  Future<void> queryDancers() async {
    dancersState.value = ConnectState.waiting;
    dancersState.refresh();

    try {
      var formData = DIO.FormData.fromMap({
        'limit': 10,
        'cursor': dancersLive.value.cursor ?? 0,
        'token':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjYzODMwNzQsImlhdCI6MTcyNjI5NjY3NCwicGFzc3dvcmQiOiIxMjMiLCJhY2NvdW50IjoiYWJjIiwicGVybWlzc2lvbnMiOltdfQ.GHmeajOrdSNu0XUlaihA9hTdkZAmruhtzzUxDAdHaiQ'
      });

      String url = '$BASE_HOST/dancer/query';

      print('url:$url');

      //这里为了显示加载过程，可退
      var response = await HttpManager.getInstance().dio!.post(
            url,
            data: formData,
          );

      DancersBean result = DancersBean.fromJson(response.data);

      if (result.err == RequestState.SUCCESS) {
        dancersLive.value = result;
        dancersLive.refresh();
        dancersState.value = ConnectState.done;
        dancersState.refresh();
      }else{
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

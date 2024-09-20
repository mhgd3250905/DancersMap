import 'package:dancers_map/data/bean_dancers.dart';
import 'package:dancers_map/main.dart';
import 'package:dancers_map/network/enum_connect_state.dart';
import 'package:dancers_map/network/http_client.dart';
import 'package:dancers_map/network/state_request.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;

class HomeCtrl extends GetxController {
  static HomeCtrl get to => Get.find();

  final checkIndex=0.obs;

}

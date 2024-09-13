import 'package:dancers_map/main.dart';
import 'package:dio/dio.dart';

class HttpManager {
  static final _instance = HttpManager._();

  factory HttpManager.getInstance() => _instance;

  Dio? _dio;

  HttpManager._() {
    BaseOptions options = BaseOptions(
      // headers: {
      //   HttpHeaders.userAgentHeader:
      //       'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Mobile Safari/537.36',
      // },
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    );
    _dio = new Dio(options);

  }

  Dio? get dio => _dio;
}

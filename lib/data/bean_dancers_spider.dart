import 'dart:convert' show json;

class SpiderDancersBean {

  int? cursor;
  int? err;
  String? err_msg;
  String? token;
  List<SDancer?>? data;

  SpiderDancersBean.fromParams({this.cursor, this.err, this.err_msg, this.token, this.data});

  factory SpiderDancersBean(Object jsonStr) => jsonStr is String ? SpiderDancersBean.fromJson(json.decode(jsonStr)) : SpiderDancersBean.fromJson(jsonStr);

  static SpiderDancersBean? parse(jsonStr) => ['null', '', null].contains(jsonStr) ? null : SpiderDancersBean(jsonStr);

  SpiderDancersBean.fromJson(jsonRes) {
    cursor = jsonRes['cursor'];
    err = jsonRes['err'];
    err_msg = jsonRes['err_msg'];
    token = jsonRes['token'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']){
      data!.add(dataItem == null ? null : SDancer.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"cursor": $cursor, "err": $err, "err_msg": ${err_msg != null?'${json.encode(err_msg)}':'null'}, "token": ${token != null?'${json.encode(token)}':'null'}, "data": $data}';
  }

  String toJson() => this.toString();
}

class SDancer {

  int? click_count;
  int? publish_time;
  int? score;
  String? detail_id;
  String? detail_url;
  String? id;
  String? img_url;
  String? name;
  String? nickname;
  String? relation_ship_id;

  SDancer.fromParams({this.click_count, this.publish_time, this.score, this.detail_id, this.detail_url, this.id, this.img_url, this.name, this.nickname, this.relation_ship_id});

  SDancer.fromJson(jsonRes) {
    click_count = jsonRes['click_count'];
    publish_time = jsonRes['publish_time'];
    score = jsonRes['score'];
    detail_id = jsonRes['detail_id'];
    detail_url = jsonRes['detail_url'];
    id = jsonRes['id'];
    img_url = jsonRes['img_url'];
    name = jsonRes['name'];
    nickname = jsonRes['nickname'];
    relation_ship_id = jsonRes['relation_ship_id'];
  }

  @override
  String toString() {
    return '{"click_count": $click_count, "publish_time": $publish_time, "score": $score, "detail_id": ${detail_id != null?'${json.encode(detail_id)}':'null'}, "detail_url": ${detail_url != null?'${json.encode(detail_url)}':'null'}, "id": ${id != null?'${json.encode(id)}':'null'}, "img_url": ${img_url != null?'${json.encode(img_url)}':'null'}, "name": ${name != null?'${json.encode(name)}':'null'}, "nickname": ${nickname != null?'${json.encode(nickname)}':'null'}, "relation_ship_id": ${relation_ship_id != null?'${json.encode(relation_ship_id)}':'null'}}';
  }

  String toJson() => this.toString();
}
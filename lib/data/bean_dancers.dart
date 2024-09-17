import 'dart:convert' show json;

class DancersBean {

  int? cursor;
  int? err;
  String? err_msg;
  String? token;
  List<Dancer?>? data;

  DancersBean.fromParams({this.cursor, this.err, this.err_msg, this.token, this.data});

  factory DancersBean(Object jsonStr) => jsonStr is String ? DancersBean.fromJson(json.decode(jsonStr)) : DancersBean.fromJson(jsonStr);

  static DancersBean? parse(jsonStr) => ['null', '', null].contains(jsonStr) ? null : DancersBean(jsonStr);

  DancersBean.fromJson(jsonRes) {
    cursor = jsonRes['cursor'];
    err = jsonRes['err'];
    err_msg = jsonRes['err_msg'];
    token = jsonRes['token'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']){
            data!.add(dataItem == null ? null : Dancer.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"cursor": $cursor, "err": $err, "err_msg": ${err_msg != null?'${json.encode(err_msg)}':'null'}, "token": ${token != null?'${json.encode(token)}':'null'}, "data": $data}';
  }

  String toJson() => this.toString();
}

class Dancer {

  int? age;
  int? rate;
  String? avatar;
  String? desc;
  String? key;
  String? name;
  String? nick_name;
  String? province;
  int? update_time;
  List<String>? photos;

  Dancer.fromParams({this.age, this.rate, this.avatar, this.desc, this.key, this.name, this.nick_name, this.province, this.update_time, this.photos});

  Dancer.fromJson(jsonRes) {
    age = jsonRes['age'];
    rate = jsonRes['rate'];
    avatar = jsonRes['avatar'];
    desc = jsonRes['desc'];
    key = jsonRes['key'];
    name = jsonRes['name'];
    nick_name = jsonRes['nick_name'];
    province = jsonRes['province'];
    update_time = jsonRes['update_time'];
    photos = jsonRes['photos'] == null ? null : [];

    for (var photosItem in photos == null ? [] : jsonRes['photos']){
            photos!.add(photosItem);
    }
  }

  @override
  String toString() {
    return '{"age": $age, "rate": $rate, "avatar": ${avatar != null?'${json.encode(avatar)}':'null'}, "desc": ${desc != null?'${json.encode(desc)}':'null'}, "key": ${key != null?'${json.encode(key)}':'null'}, "name": ${name != null?'${json.encode(name)}':'null'}, "nick_name": ${nick_name != null?'${json.encode(nick_name)}':'null'}, "province": ${province != null?'${json.encode(province)}':'null'}, "update_time": $update_time, "photos": $photos}';
  }

  String getDesc(){
    if((desc??"").isNotEmpty){
      return desc??"";
    }
    return "他还没有留下任何信息...";
  }

  String toJson() => this.toString();
}
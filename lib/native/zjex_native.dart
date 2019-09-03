import 'dart:collection';
import 'dart:convert';
import 'package:flutter_gqtg/net/result_data.dart';
import 'package:flutter_gqtg/net/zjex_api.dart';
import 'package:flutter_gqtg/util/sp_util.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gqtg/res/element_icon_all.dart';
import 'package:uuid/uuid_util.dart';

class ZjexNative {
  static const String _channel = 'com.zjex.equity.json/face';
  static const BasicMessageChannel<dynamic> jsonPlatformChannel =
      BasicMessageChannel<dynamic>(_channel, JSONMessageCodec());
  static const MethodChannel methodChannel =
      MethodChannel('com.zjex.equity/faceAll');
  static const EventChannel eventChannel =
      EventChannel('com.zjex.equity/faceEvt');
  String msg;
  static List<PublishSubject<Map<String, dynamic>>> subjects = [];
  static Map<String, PublishSubject<Map<String, dynamic>>> subjectMap = {};
  static ZjexNative instance;
  static ZjexNative getInstance() {
    if (instance == null) {
      instance = ZjexNative();
      PublishSubject<Map<String, dynamic>> subject =
          PublishSubject<Map<String, dynamic>>();
      subject.listen(onData);
      ZjexNative.subjects.add(subject);
    }
    return instance;
  }

  static addSubject(String key, PublishSubject<Map<String, dynamic>> subj) {
    ZjexNative.subjectMap.putIfAbsent(key, () => subj);
  }

  static removeSubject(String key) {
    ZjexNative.subjectMap.remove(key);
  }

  static void onData(Map<String, dynamic> event) {
    subjectMap.forEach((String key, dynamic val) {
      {
        PublishSubject<Map<String, dynamic>> subjectUC = subjectMap[key];
        subjectUC.add(event);
      }
    });
  }

  ZjexNative() {
    jsonPlatformChannel.setMessageHandler(jsonMsgH);
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  static Future<dynamic> jsonMsgH(dynamic msg) async {
    //TODO
    print('channel get reply msg : $msg');
    return '';
  }

  void sendMsg() {
    Map data = HashMap();
    data.putIfAbsent('custId', () => '290666');
    data.putIfAbsent('orderId', () => 'jshdagkjhgjkhfhjhdh38475j2hb4jh');
    data.putIfAbsent('signTime', () => '2019070101222');
    data.putIfAbsent('sign', () => '29987458677370666');
    var message = JsonCodec().encode(data);
    jsonPlatformChannel.send(message);
  }

  void _onEvent(Object event) {
    msg = " receive msg : ${event.toString()} .";
    var data = JsonCodec().decode(event.toString());
    var datar = data['data'];
    String methodName = data['methodName'];
    String currentBizType = datar['currentBizType'];
    var event0 = <String, dynamic>{
      'code': 200,
      'message': '实名认证成功',
      'success': true,
      'method': 'doFullAuth',
      'data': datar,
      'currentBizType': currentBizType,
    };
    // var event1 = {};
    if (methodName == 'doFullAuth' || methodName == 'onFullAuthSuccess') {
      event = <String, dynamic>{
        'message': '实名认证成功',
        'success': true,
        'method': 'doFullAuth',
      };
      String id_name = datar['id_name'];
      String id_number = datar['id_number'];
      String idcard_back_photo = datar['idcard_back_photo'];
      String idcard_front_photo = datar['idcard_front_photo'];
      String living_photo = datar['living_photo'];
      // print('[on event ] ${event.toString()} , $event');
      print('name $id_name , id $id_number ');
      print('photo $idcard_front_photo , back $idcard_back_photo ');
      print('methodName $methodName , living_photo $living_photo ');
      SpUtil.putString('id_name', id_name);
      SpUtil.putString('id_number', id_number);
      SpUtil.putString('idcard_back_photo', idcard_back_photo);
      SpUtil.putString('idcard_front_photo', idcard_front_photo);
      SpUtil.putString('living_photo', living_photo);
    } else if (methodName == 'doIDcardOcr' || methodName == 'onOcrSuccess') {
      String id_name = datar['id_name'];
      String id_number = datar['id_number'];
      String idcard_back_photo = datar['idcard_back_photo'];
      String idcard_front_photo = datar['idcard_front_photo'];
      print('name $id_name , id $id_number ');
      print('photo $idcard_front_photo , back $idcard_back_photo ');
      SpUtil.putString('id_name', id_name);
      SpUtil.putString('id_number', id_number);
      SpUtil.putString('idcard_back_photo', idcard_back_photo);
      SpUtil.putString('idcard_front_photo', idcard_front_photo);

      event = <String, dynamic>{
        'message': '身份证识别成功',
        'success': true,
        'method': 'doIDcardOcr',
      };
    } else if (methodName == 'doLivingAuth' ||
        methodName == 'onLivingAuthSuccess') {
      String living_photo = datar['living_photo'];
      print('methodName $methodName , living_photo $living_photo ');
      SpUtil.putString('living_photo', living_photo);

      event = <String, dynamic>{
        'message': 'id 识别成功',
        'success': true,
        'method': 'doLivingAuth',
      };
    } else if (methodName == 'doLiving' || methodName == 'onLivingSuccess') {
      String living_photo = datar['living_photo'];
      print('methodName $methodName , living_photo $living_photo ');
      SpUtil.putString('living_photo', living_photo);
      event = <String, dynamic>{
        'message': 'living 识别成功',
        'success': true,
        'method': 'doLivingness',
      };
    }
    event0.addAll(event);
    // if (subjects.length > 0) {
    //   subjects[0].add(event0);
    // }
    subjects.forEach((sub) {
      sub.add(event0);
    });
  }

  void _onError(Object error) {
    msg = 'receive error ${error}.';
    print('[on error ] ${error.toString()} , $error');
    PlatformException e = error;
    Map<String, dynamic> event;
    var data = JsonCodec().decode(e.details);
    var datar = data['data'];
    if (datar == null) {
      datar = data;
    }
    var message = datar['message'];
    String methodName = data['methodName'];
    String currentBizType = datar['currentBizType'];
    var event0 = <String, dynamic>{
      'code': 200,
      'message': '实名认证失败',
      'success': false,
      'method': 'doFullAuth',
      'data': datar,
      'currentBizType': currentBizType,
    };
    // var event1 = {};
    if (methodName == 'doFullAuth' || methodName == 'onFullAuthFail') {
      event = <String, dynamic>{
        'message': '实名认证失败 $message ',
        'success': false,
        'method': 'doFullAuth',
      };
    } else if (methodName == 'doIDcardOcr' || methodName == 'onOcrFail') {
      event = <String, dynamic>{
        'message': '身份证识别失败 $message ',
        'success': false,
        'method': 'doIDcardOcr',
      };
    } else if (methodName == 'doLivingAuth' ||
        methodName == 'onLivingAuthFail') {
      event = <String, dynamic>{
        'message': 'id 识别失败 $message ',
        'success': false,
        'method': 'doLivingAuth',
      };
      String code = e.code;
      String living_photo = datar['living_photo'];
      String msg = datar['message'];
      if (code == '-101') {
        //TODO 发起审核
        Map<String, dynamic> params = <String, dynamic>{
          'code': 200,
          'code1': '-101',
          'living_photo': living_photo,
        };
        event.addAll(params);
      }
    } else if (methodName == 'doLiving' || methodName == 'onLivingFail') {
      String living_photo = datar['living_photo'];
      print('methodName $methodName , living_photo $living_photo ');
      SpUtil.putString('living_photo', living_photo);
      event = <String, dynamic>{
        'message': 'living 识别失败 $message ',
        'success': false,
        'method': 'doLivingness',
      };
    }
    event0.addAll(event);
    // if (subjects.length > 0) {
    //   subjects[0].add(event0);
    // }
    subjects.forEach((sub) {
      sub.add(event0);
    });
  }

  Future<String> doFullAuth(String currentBizType) async {
    String res = await doNative(currentBizType, 'doFullAuth');
    return res;
  }

  Future<String> doEncrypt(String password, String username) async {
    String res;
    try {
      final String result = await methodChannel.invokeMethod(
        'doEncrypt',
        <String, String>{
          'password': password,
          'username': username,
        },
      );
      res = result;
      return res;
    } on PlatformException {
      res = 'Failed to doFullAuth.';
    }
    return null;
  }

  /**
  * doIDcardOcr
  */
  Future<String> doIDcardOcr(String currentBizType) async {
    String res = await doNative(currentBizType, 'doIDcardOcr');
    return res;
  }

  Future<String> doLivingness(String currentBizType) async {
    String res = await doNative(currentBizType, 'doLivingness');
    return res;
  }

  /**
  * doLivingAuth
  */
  Future<String> doLivingAuth(String currentBizType) async {
    String res = await doNative(currentBizType, 'doLivingAuth');
    return res;
  }

  /**
  * doNative
  */
  /// doLivingness  doLivingAuth   doIDcardOcr   doFullAuth
  Future<String> doNative(String currentBizType, String method) async {
    String res;
    try {
      Uuid uuid = new Uuid();
      String orderId = uuid.v4(
        options: {
          'rng': UuidUtil.cryptoRNG,
        },
      );
      DateTime now = new DateTime.now();
      var format = new DateFormat('yyyyMMddHHmmss');
      var signTime = format.format(now);
      ZjexAPI api = ZjexAPI();
      ResultData resData = await api.getSign(<String, dynamic>{
        'partnerOrderId': orderId,
        'timestap': signTime,
      }, null);
      String sign = '';
      if (resData?.code == 200) {
        var data = resData.data;
        if (data['successful']) {
          sign = data['data'];
        } else {
          var msgg = data['statusMessage'];
          return '获取签名参数失败 $msgg';
        }
      } else {
        subjects.forEach((sub) {
          var event = <String, dynamic>{
            'code': 200,
            'message': '实名认证失败,网络异常',
            'data': ' ',
          };
          sub.add(event);
        });
        return '网络异常';
      }

      print(
          'all params ready orderId $orderId  , timpestamp $signTime , sign $sign .');
      Map<String, dynamic> queryParams = <String, dynamic>{
        'orderId': orderId,
        'signTime': signTime, //'20180901151111',
        'sign': sign,
        'currentBizType': currentBizType,
      };
      if ('doLivingAuth' == method) {
        String idName = SpUtil.getString('id_name');
        String idNumber = SpUtil.getString('id_number');
        Map<String, dynamic> queryParams1 = <String, dynamic>{
          'idName': idName,
          'idNumber': idNumber,
        };
        queryParams.addAll(queryParams1);
      }

      final String result = await methodChannel.invokeMethod(
        method,
        queryParams,
      );
      res = ' do all auth result: $result%.';
    } on PlatformException {
      res = 'Failed to doIDcardOcr.';
    }
    return res;
  }
}

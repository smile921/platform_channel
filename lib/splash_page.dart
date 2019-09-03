import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_gqtg/common/config/config.dart';
import 'package:flutter_gqtg/common/local_storage.dart';
import 'package:flutter_gqtg/custom_route.dart';
import 'package:flutter_gqtg/home_page.dart';
import 'package:flutter_gqtg/net/api.dart';
import 'package:flutter_gqtg/net/code.dart';
import 'package:flutter_gqtg/net/result_data.dart';
import 'package:flutter_gqtg/net/zjex_api.dart';
import 'package:flutter_gqtg/net/zjex_otcp_api.dart';
import 'package:flutter_gqtg/util/token_time_out_util.dart';
import 'login/choose_login_page.dart';
import 'util/app_navigator.dart';
import 'util/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flukit/flukit.dart';
import 'common/common.dart';
import 'util/sp_util.dart';
import 'package:package_info/package_info.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const String HOST =
      Config.USE_GATEWAY ? Config.BASE_HOST_GATEWAY : Config.BASE_HOST;
  int _status = 0;
  String _startImg = "splash/start_page-1";
  List<String> _guideList = [
    Utils.getImgPath("app_start_1"),
    Utils.getImgPath("app_start_2"),
    Utils.getImgPath("app_start_3"),
  ];

  List<String> _startList = [
    Utils.getImgPath("splash/start_page-1"),
    Utils.getImgPath("splash/start_page-2"),
  ];
  List<Widget> _bannerList = new List();
  List<Widget> _startBannerList = new List();
  StreamSubscription _subscription;
  StreamSubscription _subscription2;

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      print('current app version is ${packageInfo.version}');
    });
    _initSplash();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription2?.cancel();
    super.dispose();
  }

  void _initAsync() async {
    _initStartBannerData();
    await SpUtil.getInstance();
    if (SpUtil.getBool(Constant.key_guide, defValue: true)) {
      SpUtil.putBool(Constant.key_guide, false);
      // _initGuide();
      _goLogin();
    } else {
      _goLogin();
    }
  }

  void _initGuide() {
    _initBannerData();
    setState(() {
      _status = 1;
    });
  }

  void _initSplash() {
    // readDeviceInfo();
    _subscription =
        Observable.just(1).delay(Duration(milliseconds: 2000)).listen((_) {
      _initAsync();
    });
    _subscription2 =
        Observable.just(1).delay(Duration(milliseconds: 900)).listen((_) {
      setState(() {
        _startImg = "splash/start_page-2";
      });
    });
  }

  keepLogined() {
    AppNavigator.pushAndRemoveUntil(context, Home(0));
  }

  chooseLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        'choose_login', (Route<dynamic> route) => false);
  }

  testIFTokenValid() async {
    String custid = SpUtil.getString('custid');
    ZjexOtcpAPI otcp = ZjexOtcpAPI();
    Map<String, dynamic> params = {
      'custid': custid,
    };
    ResultData data = await otcp.checkAuthStatusInfo(params, context);
    if (data.code == 200) {
      keepLogined();
      return;
    }
    LocalStorage.remove(Config.TOKEN_KEY);  
    chooseLogin();
  }

  _goLogin() {
    // AppNavigator.pushAndRemoveUntil(context, ChooseLogin());
    // ZjexAPI.request();
    var token = SpUtil.getString('token');
    // print('———————!——!————!———$token');
    if (token.length > 1) { 
      testIFTokenValid();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          'choose_login', (Route<dynamic> route) => false);
    }
    // Navigator.of(context).pushReplacement(CustomRoute(ChooseLogin()));
  }

  void _initBannerData() {
    for (int i = 0, length = _guideList.length; i < length; i++) {
      if (i == length - 1) {
        _bannerList.add(InkWell(
          onTap: () {
            _goLogin();
          },
          child: Image.asset(
            _guideList[i],
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ));
      } else {
        _bannerList.add(Image.asset(
          _guideList[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }
  }

  void _initStartBannerData() {
    for (int i = 0, length = _startList.length; i < length; i++) {
      if (i == length - 1) {
        _startBannerList.add(InkWell(
          onTap: () {
            _goLogin();
          },
          child: Image.asset(
            _guideList[i],
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ));
      } else {
        _startBannerList.add(Image.asset(
          _startList[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: !(_status == 0),
            child: Image.asset(
              Utils.getImgPath("splash/start_page-2", format: "jpg"),
              width: double.infinity,
              fit: defaultTargetPlatform == TargetPlatform.iOS
                  ? BoxFit.fill
                  : BoxFit.fill,
              height: double.infinity,
            ),
          ),
          Offstage(
            offstage: !(_status == 1),
            child: ObjectUtil.isEmpty(_bannerList)
                ? Container()
                : Swiper(
                    autoStart: false,
                    circular: false,
                    indicator: null,
                    children: _bannerList),
          )
        ],
      ),
    );
  }
}

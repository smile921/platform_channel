import 'package:flutter/material.dart';
import 'package:flutter_gqtg/common/config/config.dart';
import 'package:flutter_gqtg/common/zjex_main_app_bar_state.dart';
import 'package:flutter_gqtg/equity/relation_button.dart';
import 'package:flutter_gqtg/login/reg_confirm_dialog.dart';
import 'package:flutter_gqtg/more/progress_loading.dart';
import 'package:flutter_gqtg/more/sweeping_animate_component.dart';
import 'package:flutter_gqtg/native/zjex_native.dart';
import 'package:flutter_gqtg/net/result_data.dart';
import 'package:flutter_gqtg/net/zjex_api.dart';
import 'package:flutter_gqtg/net/zjex_otcp_api.dart';
import 'package:flutter_gqtg/res/colors.dart';
import 'package:flutter_gqtg/res/element_icon_all.dart';
import 'package:flutter_gqtg/util/screen_size_util.dart';
import 'package:flutter_gqtg/util/sp_util.dart';
import 'package:flutter_gqtg/util/toast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gqtg/res/equity_font_icon.dart';

class IdentifyAuthPage extends StatefulWidget {
  final Map<String, dynamic> info;
  final String todo_NATIVE;
  static const String ID_OCR = 'ID_OCR';
  static const String ID_OCR_AUTH = 'ID_OCR_AUTH';
  static const String LIVING_AUTH = 'LIVING_AUTH';
  static const String SECOND_AUTH = 'SECOND_AUTH';

  Function bizAuthSucceeCallBack;

  IdentifyAuthPage({
    @required this.info,
    @required this.todo_NATIVE,
    this.bizAuthSucceeCallBack,
  });
  @override
  _IdentifyAuthPageState createState() => _IdentifyAuthPageState();
}

class _IdentifyAuthPageState extends State<IdentifyAuthPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool _loading = false;
  String _loading_msg = '';

  snackBarMsg(String msg) {
    if (Config.DEBUG) {
      final snackBar = new SnackBar(content: new Text(msg));
      _scaffoldkey.currentState.showSnackBar(snackBar);
    } else {
      Toast.show(msg);
    }
  }

  PublishSubject<Map<String, dynamic>> _msg2Subject;

  doFaceLivingAuth(String bizType) async {
    String json = await ZjexNative.getInstance().doLivingAuth(bizType);
    print('do living auth aysnc call $json');
  }

  @override
  void dispose() {
    controller.dispose();
    ZjexNative.removeSubject(widget.info['currentBizType']);
    _msg2Subject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = false;
    });
    controller = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    animation = new Tween(begin: 10.0, end: 300.0).animate(controller);
    // ..addStatusListener((state) => print("$state"));
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
    _msg2Subject = PublishSubject<Map<String, dynamic>>();
    _msg2Subject
        // .map((item) => 'item: $item')
        .where((item) => item['code'] == 200)
        .debounce(Duration(milliseconds: 500))
        .listen((data) async {
          setState(() {
            _loading= false;
          });
      print('onData ');
      String currentBizType = data['currentBizType'];
      if (currentBizType != widget.info['currentBizType']) {
        print('not this route , nothing to do');
        return;
      }
      setState(() {
        _loading = false;
        _loading_msg = ' .';
      });
      if (data['success'] && data['method'] == 'doLivingAuth') {
        var datar = data['data'];
        String living_photo = datar['living_photo'];
        String currentBizType = datar['currentBizType'];

        String custid = SpUtil.getString('custid');
        String phone = SpUtil.getString('phone');
        if ('person_idcard_ocr' == currentBizType) {
          // 个人股东实名认证第二步人脸识别成功
          print('个人股东实名认证第二步人脸识别成功');
          if (phone == null) {
            snackBarMsg('系统异常');
            return;
          }
          Map<String, dynamic> queryParams = {
            'living_photo': living_photo,
            'custid': custid,
            'phone': phone,
          };
          queryParams.addAll(widget.info);
          widget.bizAuthSucceeCallBack(queryParams);
          return;
        } else if ('org_living_auth' == currentBizType) {
          print('法人股东实名认证');
          if (phone == null) {
            snackBarMsg('系统异常');

            return;
          }
          Map<String, dynamic> queryParams = {
            'living_photo': living_photo,
            'custid': custid,
            'phone': phone,
          };
          queryParams.addAll(widget.info);
          widget.bizAuthSucceeCallBack(queryParams, context);
          print('[ 实名认证 face living 页面暂时关掉 ]');
          return;
        }

        Map<String, dynamic> map = <String, dynamic>{
          // 'idcard_back_photo': idcard_back_photo,
          // 'idcard_front_photo': idcard_front_photo,
          'living_photo': living_photo,
          'custid': custid,
        };
        snackBarMsg('人脸识别成功。');
        // doCheckAuth();
        // doConfirmEquityBiz(map); todo
        return;
      } else if (data['success'] && 'doLivingness' == data['method']) {
        //

        var datar = data['data'];
        String living_photo = datar['living_photo'];
        String currentBizType = datar['currentBizType'];
        String custid = SpUtil.getString('custid');
        if ('org_oper_second_living' == currentBizType) {
          print('法人股东经办人活体认证成功');
          // widget.info.addAll(other)
          doSecondAuthAfterLiving(widget.info, living_photo, currentBizType);
        } else if ('confirm_share_a1' == currentBizType ||
            'confirm_share_a2' == currentBizType) {
          // 个人股东 二次认证
          doSecondAuthAfterLiving(widget.info, living_photo, currentBizType);
        }
      } else if (data['success'] && data['method'] == 'doIDcardOcr') {
        // 检查是否已经实名开户过了。
        //person_idcard_ocr 个人实名认证
        if (currentBizType == 'person_idcard_ocr') {
          print('个人股东实名认证 ocr 成功');
        } else if (currentBizType == 'org_oper_idcard_ocr') {
          print('法人股东实名认证，经办人身份证 ocr 成功');
        }
        var datar = data['data'];
        String id_name = datar['id_name'];
        String id_number = datar['id_number'];
        String idcard_back_photo = datar['idcard_back_photo'];
        String idcard_front_photo = datar['idcard_front_photo'];
        ZjexOtcpAPI api = ZjexOtcpAPI();
        String custid = SpUtil.getString('custid');
        String bindingstatus = SpUtil.getString('bindingstatus');
        Map<String, dynamic> queryParams = {
          'investorname': id_name,
          'custid': custid,
          'bindingstatus': '$bindingstatus',
          'certificateno': id_number,
          'individualorinstitution': '0',
          'certificatetype': '0',
          'idcard_back_photo': idcard_back_photo,
          'idcard_front_photo': idcard_front_photo,
        };
        widget.info.addAll(queryParams);
        if (currentBizType == 'org_oper_idcard_ocr') {
          queryParams.putIfAbsent('id_name', () => id_name);
          queryParams.putIfAbsent('id_number', () => id_number);
          widget.bizAuthSucceeCallBack(queryParams, context);
          // Navigator.of(context).pop();
          print('[ 实名认证 ocr 页面暂时关掉 ]');
          return;
        }
        ResultData rs = await api.checkAuthAccountOpen(queryParams, context);
        if (rs?.code == 200) {
          var res = rs.data;
          if (res['success']) {
            if (currentBizType == 'person_idcard_ocr') {
              print('个人股东实名认证 ocr 成功');
              // 去做人脸识别
              doBizUdAuth(IdentifyAuthPage.LIVING_AUTH);
              // widget.bizAuthSucceeCallBack(queryParams);
            }
            return;
          } else {
            var msg = res['message'];
            snackBarMsg(msg);
            return;
          }
        } else {
          snackBarMsg('网络异常');
          return;
        }
      } else {
        var message = data['message'] ?? ' ';
        if ('-101' == data['code1'] && data['method'] == 'doLivingAuth') {
          String living_photo = data['living_photo'];
          message = '$message , 现在是否转人工审核';
          showDialog(
            context: context, //BuildContext对象
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  message ?? '...',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop('ok');
                    },
                  ),
                  new FlatButton(
                    child: new Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop('cancel');
                    },
                  ),
                ],
              );
            },
          ).then((val) {
            print(val);
            if (val == 'ok') {
              print('转人工审核');
              String custid = SpUtil.getString('custid');
              String phone = SpUtil.getString('phone');
              if ('org_living_auth' == currentBizType) {
                //
                Map<String, dynamic> queryParams = {
                  'living_photo': living_photo,
                  'custid': custid,
                  'phone': phone,
                  'isWorkflow': true,
                };
                queryParams.addAll(widget.info);
                widget.bizAuthSucceeCallBack(queryParams, context);
                print('[ 实名认证 face living 页面暂时关掉 ]');
              } else if ('person_idcard_ocr' == currentBizType) {
                Map<String, dynamic> queryParams = {
                  'living_photo': living_photo,
                  'custid': custid,
                  'phone': phone,
                  'isWorkflow': true,
                };
                queryParams.addAll(widget.info);
                widget.bizAuthSucceeCallBack(queryParams);
                return;
              }

              return;
            } else {
              print('重试人脸识别');
            }
            // Navigator.of(context).push(
            //   CustomRoute(

            //   ),
            // );
          });
          return;
        }
        snackBarMsg(message);
        return;
      }
    });

    ZjexNative.addSubject(widget.info['currentBizType'], _msg2Subject);
  }

  doCheckAuth() async {
    //
    ZjexAPI api = ZjexAPI();
    // api.bizLicenseOcrAPI(formData)
  }

  /*
             * case 1  身份证扫描识别(身份证正反面及其识别结果 身份证号及姓名)
             * case 2  人脸识别，并验证身份证（人脸活体照，去开户）
             * case 3  人脸活体检测，做二次验证（入参带上实名认证时的活体照，活体照之后再，去二次验证）
             * case 4  身份证扫���识别,之后做实名认证(身份证正反面及其识别结果 身份证号及姓名)
             *  定义如下类型 ID_OCR ， LIVING_AUTH, SECOND_AUTH
             */
  doBizUdAuth(String method) async {
    String bizType = widget.info['currentBizType'];
    switch (method) {
      case IdentifyAuthPage.ID_OCR:
        setState(() {
          _loading = true;
          _loading_msg = '身份证识别中，请稍后...';
        });
        String json = await ZjexNative.getInstance().doIDcardOcr(bizType);
        print('do living auth aysnc call $json');
        break;
      case IdentifyAuthPage.ID_OCR_AUTH:
        setState(() {
          _loading = true;
          _loading_msg = '身份证识别中，请稍后...';
        });
        String json = await ZjexNative.getInstance().doIDcardOcr(bizType);
        print('do living auth aysnc call $json');
        break;
      case IdentifyAuthPage.LIVING_AUTH:
        setState(() {
          _loading = true;
          _loading_msg = '人脸识别中，请稍后...';
        });
        String json = await ZjexNative.getInstance().doLivingAuth(bizType);
        print('do living auth aysnc call $json');
        break;
      case IdentifyAuthPage.SECOND_AUTH:
        setState(() {
          _loading = true;
          _loading_msg = '人脸识别中，请稍后...';
        });
        String json = await ZjexNative.getInstance().doLivingness(bizType);
        print('do living auth aysnc call $json');
        break;
      default:
        print('undefine bisiness type nothing todo ');
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: ZjexMainAppBar(
        name: '实名认证',
      ).build(context),
      body: ProgressLoading(
        loading: _loading,
        msg: _loading_msg,
        child: SingleChildScrollView(
            child: Container(
          color: Colours.zjex_confirm_bd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // _buildInfo(context),
              SizedBox(
                // height: ScreenSizeUtil.height(75, context),
                height: 35,
              ),
              SizedBox(
                height: 24,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 2, 16, 2),
                  child: Text(
                    '为保证账户安全，需要进行身份验证',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenSizeUtil.size(30, context),
                    ),
                  ),
                ),
              ),
              SizedBox(
                // height: ScreenSizeUtil.height(105, context),
                height: 65,
              ),
              SweepingAnimateCompoent(
                animation: animation,
                // width: ScreenSizeUtil.width(680, context),
                // height: ScreenSizeUtil.height(560, context),
                width: 330,
                height: 330,
                lineColor: Colors.transparent,
              ),
              SizedBox(
                // height: ScreenSizeUtil.height(65, context),
                height: 38,
              ),
              SizedBox(
                height: 24,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 2, 16, 2),
                  child: Text(
                    '本操作需要本人亲自完成',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenSizeUtil.size(24, context),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 2, 16, 2),
                  child: Text(
                    '按照提示作出相应到动作',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenSizeUtil.size(24, context),
                    ),
                  ),
                ),
              ),
              SizedBox(
                // height: ScreenSizeUtil.height(80, context),
                height: 50,
              ),
              _buildThreeIcontip(context),
              SizedBox(
                // height: ScreenSizeUtil.height(60, context),
                height: 42,
              ),
              _buildConfirm(context),
              SizedBox(
                height: 56,
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildThreeIcontip(BuildContext context) {
    return SizedBox(
      // height: ScreenSizeUtil.height(150, context),
      height: 100,
      child: Container(
        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
        padding: EdgeInsets.fromLTRB(50, 1, 50, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //
            buildItem(context, '正对手机', EquityFontIcon.phone2),
            buildItem(context, '光线充裕', EquityFontIcon.sun),
            buildItem(context, '放慢动作', EquityFontIcon.timer_sand),
          ],
        ),
      ),
    );
  }

  buildItem(BuildContext context, String text, IconData icon) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colours.zjex_app_bar,
                width: 0.5,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: ScreenSizeUtil.width(54, context),
              backgroundColor: Colours.zjex_confirm_bd,
              foregroundColor: Colours.zjex_app_bar,
              child: Icon(
                icon,
                size: ScreenSizeUtil.size(80, context),
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: ScreenSizeUtil.size(24, context),
              color: Colors.black,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  _buildConfirm(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: ScreenSizeUtil.width(360.0, context),
          // height: ScreenSizeUtil.height(90.0, context),
          child: RelationButton(
            onPressed: () {
              setState(() {
                _loading =true;
              });
              doBizUdAuth(widget.todo_NATIVE);
            },
            text: '开始身份验证',
          ),
        )
      ],
    );
  }

  doShowConfirm() {
    showDialog(
      context: context, //BuildContext对象
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RegConfirmDialog(
          text: '您已申请成功',
        );
      },
    ).then((val) {
      print(val);
      // Navigator.popUntil(context,ModalRoute.withName('/equity'));
      Navigator.maybePop(context); //TODO 怎么跳转到首页
      // Navigator.maybePop(context);
    });
  }

  void doSecondAuthAfterLiving(Map<String, dynamic> info, String living_photo,
      String currentBizType) async {
    //
    ZjexAPI api = ZjexAPI();
    setState(() {
      _loading = true;
      _loading_msg = '二次认证中...';
    });
    ResultData res =
        await api.doFaceCompare(living_photo, info['faceFilePath'], context);

    if (res?.code == 200) {
      setState(() {
        _loading = false;
        _loading_msg = ' ...';
      });
      var data = res.data;
      if (data['successful']) {
        var rs = data['data'];
        widget.info.putIfAbsent('living_photo', () => living_photo);
        widget.bizAuthSucceeCallBack(widget.info, context);
        return;
      } else {
        snackBarMsg('认证失败 ' + data['statusMessage']);
        return;
      }
    } else {
      setState(() {
        _loading = false;
        _loading_msg = ' ...';
      });
      snackBarMsg('网络异常');
      return;
    }
  }
}

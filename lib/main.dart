import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gqtg/account/account_center_page.dart';
import 'package:flutter_gqtg/account/step_one_page.dart';
import 'package:flutter_gqtg/audit/audit_page.dart';
import 'package:flutter_gqtg/equity/eq_home.dart';
import 'package:flutter_gqtg/equity/eq_share_confirm.dart';
import 'package:flutter_gqtg/equity/eq_share_confirm_list.dart';
import 'package:flutter_gqtg/equity/eq_share_stores.dart';
import 'package:flutter_gqtg/equity/eq_share_transactions.dart';
import 'package:flutter_gqtg/equity/qr_scann_page.dart';
import 'package:flutter_gqtg/home_page.dart';
import 'package:flutter_gqtg/identify_auth_page.dart';
import 'package:flutter_gqtg/login/company_login_page.dart';
import 'package:flutter_gqtg/login/gd_login_page.dart';
import 'package:flutter_gqtg/model/company_info_ocr.dart';
import 'package:flutter_gqtg/more/demo_loading_animation.dart';
import 'package:flutter_gqtg/more/demo_page.dart';
import 'package:flutter_gqtg/more/more_page.dart';
import 'package:flutter_gqtg/res/colors.dart';
import 'package:flutter_gqtg/widgets/no_splash.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provide/provide.dart';
import 'login/choose_login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'splash_page.dart';

void main() {
  var companyInfoOcr = CompanyInfoOcr();
  var providers = Providers();

//将counter对象添加进providers
  providers.provide(Provider<CompanyInfoOcr>.value(companyInfoOcr));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ProviderNode(
      child: MyApp(),
      providers: providers,
    ));
  });

  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colours.zjex_app_bar,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          accentColor: Color.fromRGBO(244, 244, 244, 1), //f4f4f4
          scaffoldBackgroundColor: Color.fromRGBO(244, 244, 244, 1), //f4f4f4
          splashFactory: const NoSplashFactory(),
        ),
        // ThemeData(splashFactory: const NoSplashFactory()),
        child: MaterialApp(
          title: '股权',
          //debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.yellow,
            highlightColor: Color.fromRGBO(255, 255, 255, 0.5),
            primaryColor: Colours.zjex_app_bar,
            splashColor: Colors.white70,
            accentColor: Color.fromRGBO(3, 54, 255, 1.0),
            scaffoldBackgroundColor: Colors.white,
          ),
          // home: SplashPage(),
          initialRoute: "choose_login",
          // initialRoute: 'loading',
          // initialRoute: 'identify_auth', // change it temp
          routes: _buildRoutes(context),
          localizationsDelegates: [
            //此处
            GlobalMaterialLocalizations.delegate,
            PickerLocalizationsDelegate.delegate,
            GlobalCupertinoLocalizations.delegate, 
            GlobalWidgetsLocalizations.delegate,  
          ],
          supportedLocales: [
            //此处
            const Locale('zh', 'CH'),
            const Locale('en', 'US'),
          ],
        ),
      ),
    );
  }

  _buildRoutes(BuildContext context) {
    return {
      'choose_login': (context) => ChooseLogin(),
      'gd_login': (context) => GdLogin(),
      'company_login': (context) => CompanyLogin(),
      '/confirm_share': (context) => EqShareConfirmList(),
      '/confrim_share_detail': (context) => EqShareConfirm(
            info: null,
          ),
      'loading': (context) => DemoLoadingAnimation(),
      '/equity': (context) => Home(0),
      'equity': (context) => Home(0),
      '/audit': (context) => Home(1),
      'audit': (context) => Home(1),
      'qr_scann': (context) => QrCodeScanPage(
            info: {
              //
            },
          ),
      '/identify_auth': (context) => IdentifyAuthPage(
            info: {
              //
            },
          ),
      'identify_auth': (context) => IdentifyAuthPage(
            info: {
              //
            },
          ),
      '/account': (context) => Home(2),
      '/more': (context) => Home(3),
      '/store_hold': (context) => EqShareStores(),
      '/share_transactions': (context) => EqShareTransactions(),
      '/step_one': (context) => StepOnePage(
            info: {},
          ),
      'step_one': (context) => StepOnePage(
            info: {},
          ),
      'splash': (context) => SplashPage(),
      'demo': (context) => DemoPage(),
    };
  }
}

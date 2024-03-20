import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import 'package:vanilla_example/pages/main/bindings/main_bindings.dart';
import 'I10n/translations.dart';
import 'app/constants.dart';
import 'app/router/router_config.dart';
import 'app/util/global.dart';
import 'pages/main/view/main_page.dart';

void main() {
  initApp();
}

initApp() {
  Global.init();
  spInit().then((value) {
    if (value == 'ok') {
      runApp(MyApp());
    }
  });
}

Future<String> spInit() async {
  var instance = await SpUtil.getInstance();
  if (instance != null) {
    return 'ok';
  } else {
    return 'no';
  }
}

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({Key? key}) : super(key: key);

  ///app 全局context
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => createMaterialApp(),
    );
  }

  GetMaterialApp createMaterialApp() {
    return GetMaterialApp(
      title: appName,
      translations: AppTranslations(),
      supportedLocales: AppTranslations.supportedLocales,
      locale: Get.deviceLocale,
      fallbackLocale: AppTranslations.fallbackLocale,
      getPages: RoutesConfig.routePageList,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, //iOS
      ],
      defaultTransition: Transition.cupertino,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialBinding: MainBindings(),
      initialRoute: "/",
      home: MainPage(),
      builder: (context, widget) {
        return MediaQuery(
          //设置文字大小不随系统设置改变
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: FlutterEasyLoading(
            child: widget,
          ),
        );
      },
    );
  }
}

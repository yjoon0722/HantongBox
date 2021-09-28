import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hantong_cal/models/productInfoNotifier.dart';
import 'package:hantong_cal/ui/pages/courier_invoice/courier_invoice_page.dart';
import 'package:hantong_cal/ui/pages/root_page.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:hantong_cal/ui/pages/shipment_order/shipment_order_page.dart';
import 'package:hantong_cal/ui/pages/test_button_page.dart';
import 'package:hantong_cal/ui/pages/test_gradient_page.dart';
import 'package:hantong_cal/ui/pages/test_image_page.dart';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

enum PAGE_MODE { one, two, three }

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try{
    if(Device.get().isPhone) {
      // 갤럭시 폴드2 예외처리                           안드로이드면서                        편상태 세로모드                               편상태 가로모드
      if(Device.get().isAndroid == false || (Device.get().isAndroid && !( Device.screenSize == ui.Size(673.5,826.3) || Device.screenSize != ui.Size(807.6,658.7)))){
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
      }
    }
    await Firebase.initializeApp();
  }catch(e){}
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // 한통속 버튼 선택 컬러
  static const Color btnSelectedColor = Color(0xFFFF7062); // 리빙코랄
  static const Color btnBackgroundColor = Color.fromRGBO(255, 255, 255, 0.80); // 리빙코랄

  // 한통속 지정 컴퍼넌트 컬러
  static const Color componentColor = Color(0xEFFF7062); // 리빙코랄

  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(_primaryValue),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
  static const int _primaryValue = 0xFF084172;

  static const MaterialColor component = MaterialColor(
    _componentValue,
    <int, Color>{
      50: Color(_componentValue),
      100: Color(_componentValue),
      200: Color(_componentValue),
      300: Color(_componentValue),
      400: Color(_componentValue),
      500: Color(_componentValue),
      600: Color(_componentValue),
      700: Color(_componentValue),
      800: Color(_componentValue),
      900: Color(_componentValue),
    },
  );
  static const int _componentValue = 0xFFFF7062;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductInfoNotifier(),
      child: GetMaterialApp(
        title: '한통박스',
        theme: ThemeData(
          accentColor: MyApp.component,
          primarySwatch: MyApp.primary,
          textTheme: TextTheme(
              // 상단 타이틀
              headline4: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, letterSpacing: 0.25, color: Colors.black),
              // 버전
              headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: Colors.white70),
              // 텍스트
              subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Colors.black),
              // 버튼
              bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 0.25)
          )
        ),
        debugShowCheckedModeBanner: false,
        // 배경글라데이션 테스트
        //home: GradientPage(),
        // 이미지 효과 테스트
        //home: ImagePage(),
        // 버튼 테스트
        //home: ButtonPagae(),
        // 출하지시서
        // home: ShipmentOrderPage(),
        // 택배송장
        // home: CourierInvoicePage(),
        home: RootPage(),
      ),
    );
  }
}
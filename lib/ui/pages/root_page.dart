import 'dart:async';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:hantong_cal/helpers/firebase_helper.dart';
import 'package:hantong_cal/models/analytics.dart';
import 'package:hantong_cal/models/db_helper.dart';
import 'package:hantong_cal/ui/pages/ratio_calculator.dart';
import 'package:hantong_cal/ui/pages/root_0th_page.dart';
import 'package:hantong_cal/ui/pages/root_1st_page.dart';
import 'package:hantong_cal/ui/pages/root_2nd_page.dart';
import 'package:hantong_cal/ui/pages/root_3rd_page.dart';
import 'package:hantong_cal/ui/pages/sales_status.dart';
import 'package:hantong_cal/ui/pages/simple_calculator.dart';
import 'package:hantong_cal/ui/pages/simple_calculator_pad.dart';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:hantong_cal/ui/pages/simple_calculator.dart';
import 'package:hantong_cal/ui/pages/tax_calculator.dart';
import 'package:hantong_cal/ui/widgets/SSProgressIndicator.dart';
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:intl/intl.dart';

import 'package:hb_mac_interface/hb_mac_interface.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../main.dart';
import '../../transitions/fade_route.dart';
import '../../transitions/slide_route.dart';
import 'ecounterp_login_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:quick_actions/quick_actions.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with WidgetsBindingObserver,AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final formatter = new NumberFormat('#,###');

  static PAGE_MODE _root_page_mode = PAGE_MODE.one;

  static PageController _controller = new PageController(initialPage: 0, keepPage: false);
  int _selectedIndex = 0;
  static PageController _mobileController = new PageController(initialPage: 0, keepPage: false);
  int _mobileSelectedIndex = 0;

  String _sms_text_string = '';

//   패스워드 키 포커스
  FocusNode _passwordFocusNode;
  String _passwordNumber;

//   파이어베이스 데이터 가져오기 위한 변수
  int _sales_status = 0;
  bool isInit = false;

  final QuickActions quickActions = QuickActions();

  static const _platform = const MethodChannel('hantongbox.save/lastTime');

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    _passwordNumber = '';
    isInit = true;
    try{
      if(Platform.isIOS) {
        DBHelper().updateIsOpenSalesStatus0();
      }
    }catch(e){}
    super.initState();
    _setupQuickActions();
    _handleQuickActions();

    initMacInterface();

    print('RootPage ================= initState');
  }

  @override
  void dispose() {
    try{
      if(Platform.isIOS) {
        DBHelper().updateIsOpenSalesStatus0();
      }
    }catch(e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen_size = MediaQuery.of(context).size;
    if (screen_size.width > 589) {
      if (screen_size.width > screen_size.height) {
        _root_page_mode = PAGE_MODE.three;
      } else {
        _root_page_mode = PAGE_MODE.two;
      }
    } else {
      _root_page_mode = PAGE_MODE.one;
    }

    switch(_root_page_mode) {
      case PAGE_MODE.one:
        return _buildPhone(context);
      case PAGE_MODE.two:
        return _buildPad(context);
      case PAGE_MODE.three:
        return _buildLandscape(context);
    }
    return _buildPad(context);
  }

  // 폰 화면
  Widget _buildPhone(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DBHelper().getLastTime(),
        builder: (BuildContext context,AsyncSnapshot snapshot) {
          return PageView(
            controller: _mobileController,
            onPageChanged: (index){
              mobilePageChanged(index);
            },
            children: <Widget>[
              Root1stPage(page_mode: _root_page_mode, function: scrollPageViewIndex, functionSMSMessage: returnSMSMessage,),
              Root2ndPage(page_mode: _root_page_mode, function: returnDataFunction),
              SimpleCalculator(page_mode: _root_page_mode),
              RatioCalculator(page_mode: _root_page_mode),
              TaxCalculator(page_mode: _root_page_mode,),
            ],
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        // TODO: 네비게이션바 위쪽 공간만 늘리기 (아이콘위치는 그대로,safeArea와 높이가 동일하게)
//        height: 100,
        child : BottomNavigationBar(
          backgroundColor: Color(0xFF084172),
          currentIndex: _mobileSelectedIndex,
          selectedItemColor: MyApp.componentColor,
          unselectedItemColor: Colors.white,
          onTap: mobileBottomTapped,
          type: BottomNavigationBarType.fixed,
//          showSelectedLabels: false, // 글씨지우는법
//          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
//            BottomNavigationBarItem(
//                icon: GestureDetector(
//                  onTap: _salesStatusLongPress,
//                  child: Icon(Icons.assessment),
//                ),
//                title: GestureDetector(
//                  onTap: _salesStatusLongPress,
//                  child: Text('판매현황'),
//                ),
//            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (){
                  print("onTap Icon");
                  _mobileController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                },
                onLongPress: _salesStatusLongPress,
                child: Icon(Icons.home),
              ),
              title: GestureDetector(
                onTap: (){
                  print("onTap title");
                  _mobileController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                },
                onLongPress: _salesStatusLongPress,
                child: Text('한통계산기'),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.looks_one),
                title: Text('SNS')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.looks_two),
              title: Text('일반계산기')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.looks_3),
              title: Text('비율계산기')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.looks_4),
                title: Text('세금계산기')
            ),
          ],
        ),
      )
    );
  }

  // 패드 화면
  Widget _buildPad(BuildContext context) {
    // 스크롤뷰
    Size screen_size = MediaQuery.of(context).size;
    double item_width = screen_size.width / 6;
    double item_height = (item_width / 1.6);
    double height = item_height * 19 + 100;

    return Scaffold(
      body: FutureBuilder(
        future: DBHelper().getLastTime(),
        builder: (BuildContext context,AsyncSnapshot snapshot) {
          return PageView(
              controller: _controller,
              onPageChanged: (index){
                pageChanged(index);
              },
     //      IndexedStack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: screen_size.width,
                        height: max(screen_size.height, height),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Root1stPage(page_mode: _root_page_mode, function: scrollPageViewIndex,functionSMSMessage: returnSMSMessage,),
                            ),
                            Expanded(
                              child: PadSimpleCalculator(page_mode: _root_page_mode),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: screen_size.width,
                        height: max(screen_size.height, height),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Root2ndPage(page_mode: _root_page_mode, function: returnDataFunction,),
                            ),
                            Expanded(
                              child: RatioCalculator(page_mode: _root_page_mode),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
    //        index: _selectedIndex,
    //      ),
          );
        }
      ),
        bottomNavigationBar: SizedBox(
          child : BottomNavigationBar(
            backgroundColor: Color(0xFF084172),
            currentIndex: _selectedIndex,
            selectedItemColor: MyApp.componentColor,
            unselectedItemColor: Colors.white,
            onTap: bottomTapped,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: (){
                    print("onTap Icon");
                    _controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                  },
                  onLongPress: _salesStatusLongPress,
                  child: Icon(Icons.home),
                ),
                title: GestureDetector(
                  onTap: (){
                    print("onTap title");
                    _controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                  },
                  onLongPress: _salesStatusLongPress,
                  child: Text('한통계산기 / 일반계산기'),
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.looks_two),
                  title: Text('SNS / 비율계산기')
              ),
            ],
          ),
        )
    );

  }

  // 가로 화면
  Widget _buildLandscape(BuildContext context) {
    Size screen_size = MediaQuery.of(context).size;
    double item_width = (MediaQuery.of(context).size.width - (screen_size.width / 3)) / 6;
    double item_height = (item_width / 1.6);
    double height = item_height * 15 + 200;

    return Scaffold(
        body: FutureBuilder(
          future: DBHelper().getLastTime(),
          builder: (BuildContext context,AsyncSnapshot snapshot) {
            return PageView(
              controller: _controller,
              onPageChanged: (index){
                pageChanged(index);
              },
//               IndexedStack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: screen_size.width,
                          height: max(screen_size.height, height),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Root0thPage(_sms_text_string),
                              ),
                              Expanded(
                                child: Root1stPage(page_mode: _root_page_mode, function: scrollPageViewIndex,functionSMSMessage: returnSMSMessage,),
                              ),
                              Expanded(
                                child: PadSimpleCalculator(page_mode: _root_page_mode),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: screen_size.width,
                          height: max(screen_size.height, height),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Root2ndPage(page_mode: _root_page_mode, function: returnDataFunction,),
                              ),
                              Expanded(
                                child: RatioCalculator(page_mode: _root_page_mode),
                              ),
                              Expanded(
                                child: TaxCalculator(page_mode: _root_page_mode),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
//               index: _selectedIndex,
//              ),
            );
          }
        ),
        bottomNavigationBar: SizedBox(
          child : BottomNavigationBar(
            backgroundColor: Color(0xFF084172),
            currentIndex: _selectedIndex,
            selectedItemColor: MyApp.componentColor,
            unselectedItemColor: Colors.white,
            onTap: bottomTapped,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: (){
                    print("onTap Icon");
                    _controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                  },
                  onLongPress: _salesStatusLongPress,
                  child: Icon(Icons.home),
                ),
                title: GestureDetector(
                  onTap: (){
                    print("onTap title");
                    _controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                  },
                  onLongPress: _salesStatusLongPress,
                  child: Text('한통계산기 / 일반계산기'),
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.looks_two),
                  title: Text('SNS / 비율계산기')
              ),
            ],
          ),
        )
    );
  }

  // SMS 문자
  void returnSMSMessage(String msg) {
    setState(() {
      _sms_text_string = msg;
    });
  }

  // 웹뷰화면 새로 그리기
  static void returnDataFunction(String urlString) {
    print(urlString);
    //setState(() {
    //  this.urlString = urlString;
    //  this.webView.reloadURL(urlString);
    //});
  }

  // 페이지뷰 이동
  static void scrollPageViewIndex(int index) {
    print("scrollPageViewIndex: $index");
    _controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void mobilePageChanged(int index){
    setState(() {
      _mobileSelectedIndex = index;
    });
  }

  void mobileBottomTapped(int index) {
   setState(() {
     _mobileSelectedIndex = index;
     _mobileController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
   });
  }

  // Firestore 데이터 가져오기
  // Future getFirestoreData(String collection, String document) async {
  //   var docRef = Firestore.instance.collection(collection).document(document);
  //   return docRef.get().then((doc) {
  //     if (doc.exists) {
  //       return doc.data;
  //     } else {
  //       print('Error: No such document!');
  //       return null;
  //     }
  //   }).catchError((error) {
  //     print(error);
  //     return null;
  //   });
  // }

  final FocusNode _emptyNode = new FocusNode();
  final FocusNode _nodeText = new FocusNode();
  // ios에서 완료버튼 생성하기 위한 키보드 설정
  KeyboardActionsConfig _buildConfig(BuildContext context){
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: false,
        actions: [
          buildKeyboard(_nodeText)
        ]
    );
  }

  buildKeyboard(FocusNode _nodeText){
    return KeyboardActionsItem(
        focusNode: _nodeText,
        toolbarButtons: [(node) {
          return GestureDetector(
            onTap: () => _actionPasswordTextFiled_enter(context),
            child: Container(
              padding: EdgeInsets.fromLTRB(30.0, 10, 20.0, 10),
              child: Text("완료",style: TextStyle(color: Colors.blue,fontSize: 15.0,fontWeight: FontWeight.bold),),
            ),
          );
        }]
    );
  }

// 비밀번호 입력 팝업 화면
  Future<String> _asyncInputPasswordDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.1),
          body: Container(
            child: KeyboardActions(
                config: _buildConfig(context),
                child:  AlertDialog(
                  title: Text('비밀번호를 입력하세요.', style: TextStyle(color: Colors.black),),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: _buildPasswordTextComposer(context),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('취소'),
                      onPressed: () {
                        print('취소버튼');
                        Navigator.pop(context, '');
                      },
                    ),
                    FlatButton(
                      child: Text('확인'),
                      onPressed: () async {
                        _actionPasswordTextFiled_enter(context);
                      },
                    ),
                  ],
                )
            ),
          ),
        );
      },
    );
  }

  // 비밀번호 입력 텍스트 필드에 키보드 이벤트 캐치
  _buildPasswordTextComposer(BuildContext context) {
    TextField _textField = new TextField(
//      keyboardType: TextInputType.number,
      controller: TextEditingController()..text = '',
      autofocus: true,
      obscureText: true,
      focusNode: kIsWeb ? _emptyNode : Platform.isIOS ? _nodeText : null,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: new InputDecoration(
          labelText: 'password', hintText: ''
      ),
      onChanged: (value) {
        _passwordNumber = value;
      },
      onSubmitted: (value) {
        _passwordNumber = value;
        // print("kIsWeb: ${kIsWeb ? 'YES' : 'NO'}");
        // print("isMacOS: ${Theme.of(context).platform == TargetPlatform.macOS ? 'YES' : 'NO'}");
        // print("isMacOS: ${Theme.of(context).platform == TargetPlatform.macOS ? 'YES' : 'NO'}");
        // print("isMacOS: ${Theme.of(context).platform == TargetPlatform.macOS ? 'YES' : 'NO'}");
        //if (kIsWeb) {
          _actionPasswordTextFiled_enter(context);
        // }
      },
    );

    //print('_passwordFocusNode: $_passwordFocusNode');
//    FocusScope.of(context).requestFocus(_passwordFocusNode);

    return new RawKeyboardListener(
        focusNode: _passwordFocusNode,
        onKey: (RawKeyEvent value)  {
          print(value.logicalKey);
          if ((value.logicalKey == LogicalKeyboardKey.enter)|| (value.logicalKey == LogicalKeyboardKey.numpadEnter)) {
            _actionPasswordTextFiled_enter(context);
          }
          if(value.logicalKey == LogicalKeyboardKey.escape) {
            Navigator.pop(context,'');
          }
        },
        child: _textField
    );
  }

  // 팝업 확인 or Enter 키 입력
  _actionPasswordTextFiled_enter(BuildContext context) {
    if(_passwordNumber.isEmpty) {
      SSToast.show("비밀번호를 입력하세요", context);
      return;
    }
    Navigator.of(context).pop(_passwordNumber);
  }

  // 판매현황 보기위한 LongPress
  _salesStatusLongPress() async {
    if(!kIsWeb && !Platform.isMacOS) {
      // db가 비어있을경우
      if (await DBHelper().getLastTime() == null || (await DBHelper().getLastTime() != null && await DBHelper().compareTime() == false)) {
//    if (DBHelper().compareTime() == false) {
        _passwordNumber = '';
        String password_number = await _asyncInputPasswordDialog(context);
        if (password_number.isEmpty) { return; }

//      SSProgressIndicator.show(context);
        var password_json = await FirebaseHelper.getFirestoreData("Password", "S79sAnKS1wkVGIwqntos");
        //getFirestoreData('Password', 'S79sAnKS1wkVGIwqntos');
        if (password_json == null) {
          _platform.invokeListMethod('setLastTime', <String, int> {'time': 0 });
          SSToast.show("패스워드 정보를 가져오는데 실패했습니다.", context);
          SSProgressIndicator.dismiss();
          return;
        }

        String pw = password_json['pw'];
        if (password_number == pw) {
          print('비밀번호 인증 성공!');
          _platform.invokeListMethod('setLastTime', <String, int> {'time': DateTime.now().millisecondsSinceEpoch });
          if(await DBHelper().getLastTime() == null) {
            await DBHelper().createData();
          }else {
            await DBHelper().updateLastTime();
          }

          if(!Platform.isAndroid && await DBHelper().getIsOpenSalesStatus() == 1) {
            setState(() {
              Navigator.pop(context);
            });
            await DBHelper().updateIsOpenSalesStatus0();
          }
          setState(() {
            Navigator.push(context,MaterialPageRoute(builder: (context) => SalesStatus()));
          });
          await DBHelper().updateIsOpenSalesStatus1();
        } else {
          print('비밀번호가 인증 실패!');
          _platform.invokeListMethod('setLastTime', <String, int> {'time': 0 });
          SSProgressIndicator.dismiss();
          //SSToast.show("패스워드 확인 후 다시 조회해주세요.", context);

          await new Future.delayed(Duration(seconds: 1));

          SSToast.show("너 누구야 ??? - -", context, duration: 3, gravity: SSToast.CENTER);
        }
        print("longPress Icon");
      }
      else {
        print('판매현황 인증');
        _platform.invokeListMethod('setLastTime', <String, int> {'time': DateTime.now().millisecondsSinceEpoch });
        if(!Platform.isAndroid && await DBHelper().getIsOpenSalesStatus() == 1) {
          setState(() {
            Navigator.pop(context);
          });
          await DBHelper().updateIsOpenSalesStatus0();
        }
        setState(() {
          Navigator.push(context,MaterialPageRoute(builder: (context) => SalesStatus()));
        });
        await DBHelper().updateIsOpenSalesStatus1();
      }
    }
    // Web,macOS
    else {
      if (_sales_status == 0) {
        _passwordNumber = '';
        String password_number = await _asyncInputPasswordDialog(context);
        if (password_number.isEmpty) { return; }

//      SSProgressIndicator.show(context);
        var password_json = await FirebaseHelper.getFirestoreData('Password', 'S79sAnKS1wkVGIwqntos');
        if (password_json == null) {
          SSToast.show("패스워드 정보를 가져오는데 실패했습니다.", context);
          SSProgressIndicator.dismiss();
          return;
        }

        String pw = password_json['pw'];
        if (password_number == pw) {
          _sales_status = 1;
          print('비밀번호 인증 성공!');
          setState(() {
            Navigator.push(context,MaterialPageRoute(builder: (context) => SalesStatus()));
          });

        } else {
          print('비밀번호가 인증 실패!');
          SSProgressIndicator.dismiss();
          //SSToast.show("패스워드 확인 후 다시 조회해주세요.", context);

          await new Future.delayed(Duration(seconds: 1));

          SSToast.show("너 누구야 ??? - -", context, duration: 3, gravity: SSToast.CENTER);
        }
        print("longPress Icon");
      }
      else {
        setState(() {
          Navigator.push(context,MaterialPageRoute(builder: (context) => SalesStatus()));
        });
      }
    }
  }

  // QuickActionsSet
  void _setupQuickActions() {
    if (kIsWeb) { return; }

    if (Platform.isAndroid) {
      quickActions.setShortcutItems(<ShortcutItem>[
        const ShortcutItem(
          type: 'action_sales_status',
          localizedTitle: '판매 현황',
          icon: 'ic_launcher',
        ),
      ]);
    }

    if (Platform.isIOS) {
      quickActions.setShortcutItems(<ShortcutItem>[
        const ShortcutItem(
          type: 'action_sales_status',
          localizedTitle: '판매 현황',
          icon: 'AppIcon',
        ),
      ]);
    }
  }

  // QuickActionsHandling
  void _handleQuickActions() {
    if(kIsWeb) { return; }
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'action_sales_status') {
        setState(() {
          _salesStatusLongPress();
        });
      }
    });
  }

  // Mac interface
  Future<void> initMacInterface() async {
    if (kIsWeb) { return; }
    if (Platform.isMacOS == false) { return; }
    String platformVersion;
    try {
      platformVersion = await HbMacInterface.platformVersion;

      bool result = await HbMacInterface.setLastTime(<String, int> {'time': DateTime.now().millisecondsSinceEpoch });
      print("result: ${result ? "setLastTime 저장 성공" : "setLastTime 저장 실패"}");

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    print("platformVersion: ${platformVersion}");
  }

}

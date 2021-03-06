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

//   ???????????? ??? ?????????
  FocusNode _passwordFocusNode;
  String _passwordNumber;

//   ?????????????????? ????????? ???????????? ?????? ??????
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

  // ??? ??????
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
        // TODO: ?????????????????? ?????? ????????? ????????? (?????????????????? ?????????,safeArea??? ????????? ????????????)
//        height: 100,
        child : BottomNavigationBar(
          backgroundColor: Color(0xFF084172),
          currentIndex: _mobileSelectedIndex,
          selectedItemColor: MyApp.componentColor,
          unselectedItemColor: Colors.white,
          onTap: mobileBottomTapped,
          type: BottomNavigationBarType.fixed,
//          showSelectedLabels: false, // ??????????????????
//          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
//            BottomNavigationBarItem(
//                icon: GestureDetector(
//                  onTap: _salesStatusLongPress,
//                  child: Icon(Icons.assessment),
//                ),
//                title: GestureDetector(
//                  onTap: _salesStatusLongPress,
//                  child: Text('????????????'),
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
                child: Text('???????????????'),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.looks_one),
                title: Text('SNS')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.looks_two),
              title: Text('???????????????')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.looks_3),
              title: Text('???????????????')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.looks_4),
                title: Text('???????????????')
            ),
          ],
        ),
      )
    );
  }

  // ?????? ??????
  Widget _buildPad(BuildContext context) {
    // ????????????
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
                  child: Text('??????????????? / ???????????????'),
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.looks_two),
                  title: Text('SNS / ???????????????')
              ),
            ],
          ),
        )
    );

  }

  // ?????? ??????
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
                  child: Text('??????????????? / ???????????????'),
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.looks_two),
                  title: Text('SNS / ???????????????')
              ),
            ],
          ),
        )
    );
  }

  // SMS ??????
  void returnSMSMessage(String msg) {
    setState(() {
      _sms_text_string = msg;
    });
  }

  // ???????????? ?????? ?????????
  static void returnDataFunction(String urlString) {
    print(urlString);
    //setState(() {
    //  this.urlString = urlString;
    //  this.webView.reloadURL(urlString);
    //});
  }

  // ???????????? ??????
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

  // Firestore ????????? ????????????
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
  // ios?????? ???????????? ???????????? ?????? ????????? ??????
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
              child: Text("??????",style: TextStyle(color: Colors.blue,fontSize: 15.0,fontWeight: FontWeight.bold),),
            ),
          );
        }]
    );
  }

// ???????????? ?????? ?????? ??????
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
                  title: Text('??????????????? ???????????????.', style: TextStyle(color: Colors.black),),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: _buildPasswordTextComposer(context),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('??????'),
                      onPressed: () {
                        print('????????????');
                        Navigator.pop(context, '');
                      },
                    ),
                    FlatButton(
                      child: Text('??????'),
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

  // ???????????? ?????? ????????? ????????? ????????? ????????? ??????
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

  // ?????? ?????? or Enter ??? ??????
  _actionPasswordTextFiled_enter(BuildContext context) {
    if(_passwordNumber.isEmpty) {
      SSToast.show("??????????????? ???????????????", context);
      return;
    }
    Navigator.of(context).pop(_passwordNumber);
  }

  // ???????????? ???????????? LongPress
  _salesStatusLongPress() async {
    if(!kIsWeb && !Platform.isMacOS) {
      // db??? ??????????????????
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
          SSToast.show("???????????? ????????? ??????????????? ??????????????????.", context);
          SSProgressIndicator.dismiss();
          return;
        }

        String pw = password_json['pw'];
        if (password_number == pw) {
          print('???????????? ?????? ??????!');
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
          print('??????????????? ?????? ??????!');
          _platform.invokeListMethod('setLastTime', <String, int> {'time': 0 });
          SSProgressIndicator.dismiss();
          //SSToast.show("???????????? ?????? ??? ?????? ??????????????????.", context);

          await new Future.delayed(Duration(seconds: 1));

          SSToast.show("??? ????????? ??? - -", context, duration: 3, gravity: SSToast.CENTER);
        }
        print("longPress Icon");
      }
      else {
        print('???????????? ??????');
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
          SSToast.show("???????????? ????????? ??????????????? ??????????????????.", context);
          SSProgressIndicator.dismiss();
          return;
        }

        String pw = password_json['pw'];
        if (password_number == pw) {
          _sales_status = 1;
          print('???????????? ?????? ??????!');
          setState(() {
            Navigator.push(context,MaterialPageRoute(builder: (context) => SalesStatus()));
          });

        } else {
          print('??????????????? ?????? ??????!');
          SSProgressIndicator.dismiss();
          //SSToast.show("???????????? ?????? ??? ?????? ??????????????????.", context);

          await new Future.delayed(Duration(seconds: 1));

          SSToast.show("??? ????????? ??? - -", context, duration: 3, gravity: SSToast.CENTER);
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
          localizedTitle: '?????? ??????',
          icon: 'ic_launcher',
        ),
      ]);
    }

    if (Platform.isIOS) {
      quickActions.setShortcutItems(<ShortcutItem>[
        const ShortcutItem(
          type: 'action_sales_status',
          localizedTitle: '?????? ??????',
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
      print("result: ${result ? "setLastTime ?????? ??????" : "setLastTime ?????? ??????"}");

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    print("platformVersion: ${platformVersion}");
  }

}

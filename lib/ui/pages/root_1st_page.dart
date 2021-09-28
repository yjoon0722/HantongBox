import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hantong_cal/models/EcountERP_enter_order.dart';
import 'package:hantong_cal/models/Result.dart';
import 'package:hantong_cal/models/payapp.dart';
import 'package:hantong_cal/models/product.dart';
import 'package:hantong_cal/models/productInfoNotifier.dart';
import 'package:hantong_cal/ui/pages/courier_invoice/courier_invoice_page.dart';
import 'package:hantong_cal/ui/pages/sale_order/sale_order_page.dart';
import 'package:hantong_cal/ui/pages/shipment_order/shipment_order_page.dart';
import 'package:hantong_cal/ui/widgets/SNS_widget.dart';
import 'package:hantong_cal/ui/widgets/sales_status_widget.dart';
import 'package:hantong_cal/ui/widgets/tracker_delivery_widget.dart';
import 'package:hantong_cal/util/common_util.dart';
import 'package:intl/intl.dart';
import 'package:hantong_cal/models/keypad.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:hantong_cal/ui/widgets/SSProgressIndicator.dart';
import 'package:hantong_cal/main.dart';
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'dart:io' show Platform;
import 'package:hantong_cal/models/analytics.dart';
import 'package:hantong_cal/models/product.dart';

// 키보드 이벤트 리스너
class KeyboardBloc {
  KeyboardUtils _keyboardUtils = KeyboardUtils();
  StreamController<double> _streamController = StreamController<double>();
  Stream<double> get stream => _streamController.stream;
  KeyboardUtils get keyboardUtils => _keyboardUtils;

  int _idKeyboardListener;

  void start() {
    _idKeyboardListener = _keyboardUtils.add(
        listener: KeyboardListener(willHideKeyboard: () {
          _streamController.sink.add(_keyboardUtils.keyboardHeight);
        }, willShowKeyboard: (double keyboardHeight) {
          _streamController.sink.add(keyboardHeight);
        }));
  }

  void dispose() {
    _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }
    _streamController.close();
  }
}

class Root1stPage extends StatefulWidget {
  PAGE_MODE page_mode;
  Function function;
  Function functionSMSMessage;

  Root1stPage({this.page_mode, this.function, this.functionSMSMessage});

  @override
  _Root1stPageState createState() {
    return _Root1stPageState();
  }
}

class _Root1stPageState extends State<Root1stPage> with WidgetsBindingObserver,AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  final formatter = new NumberFormat('#,###');

  static const KPAD_INDEX_AutoDeliveryCount  = 2;

  static const KPAD_INDEX_Tray_10 = 9;
  static const KPAD_INDEX_Ttugbaegi_5 = 15;

  static const KPAD_INDEX_SealingMachine  = 14;

  static const KPAD_INDEX_OrangePackage_1 = 21;
  static const KPAD_INDEX_OrangePackage_2 = 22;
  static const KPAD_INDEX_OrangePackage_3 = 23;

  static const KPAD_INDEX_HantongPlate_1 = 24;
  static const KPAD_INDEX_HantongPlate_2 = 25;
  static const KPAD_INDEX_HantongPlate_3 = 26;

  static const KPAD_INDEX_SmallBusiness_1 = 27;
  static const KPAD_INDEX_SmallBusiness_2 = 28;
  static const KPAD_INDEX_SmallBusiness_3 = 29;

  static const KPAD_INDEX_Delivery_3 = 30;
  static const KPAD_INDEX_Delivery_5 = 31;
  static const KPAD_INDEX_Delivery_8 = 32;

  static const KPAD_INDEX_Sample = 33;
  static const KPAD_INDEX_Sample_Free = 34;
  static const KPAD_INDEX_DC_5p = 35;

  final bottom_KPAD_INDEX_order = 15;
  final bottom_KPAD_INDEX_order_with_message = 16;

  final String payapp_copy_url = 'http://payapp.kr/index.html';
  final String payapp_open_url = 'https://seller.payapp.kr';

  int _total_price;
  String _detail_message = "";

  int _sms_string_type;
  String _sms_message = "";

  // 할인 5%
  bool _isDiscount = false;

  // 구매 리스트
  List<Keypad> _purchaseList;

  // 버튼 리스트
  List<Keypad> _keypads;

  FocusNode _textFocusNode;
  String _phoneNumber;

  // 트럭운임비 관련
  TextEditingController _controller;
  String _start_latitudelongitude = '경기도 평택시 진위면 가곡리 126-1';
  String _goal_latitudelongitude;
  int _goal_distance;
  int _goal_price;
  String _start;
  String _goal;

  // 키보드 해제를 위한 focusNode
  final _focusNode = FocusScopeNode();

  KeyboardBloc _bloc = KeyboardBloc();

  FirebaseAnalytics analytics = FirebaseAnalytics();

  // 배송비,5%할인을 _purchaseList에 추가했는지 여부를 따지기 위한 변수
  bool is_add = false;
  // 샘플 추가 확인 변수
  bool is_sample = false;

  @override
  void initState() {
    super.initState();
    print('Root1stPage ================= initState');

    _total_price = 0;
    _detail_message = "";

    _sms_string_type = 1;
    _sms_message = "";

    _isDiscount = false;

    resetKeypads();

    _textFocusNode = FocusNode();
    _phoneNumber = '';

    _controller = new TextEditingController(text: _start_latitudelongitude);
    _goal_latitudelongitude = '';
    _goal_distance = 0;
    _goal_price = 0;
    _start = '127.0822877,37.1086106';

    is_add = false;

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // SSONG TODO: 앱에서 백그라운드 , 퍼그라운드시 타이머 동작 제어하기
    switch(state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
    print(state);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  void resetKeypads() {
    if (_purchaseList == null) { _purchaseList = new List(); }

    _purchaseList.clear();

    if (_keypads == null) { _keypads = new Keypad_list().keypads; }
  }

  @override
  Widget build(BuildContext context) {

    double statusBarHeight = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: (){
        print('click');
        _focusNode.unfocus();
      },
      child: FocusScope(
        node: _focusNode,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3, 0.7, 1.0],
                  colors: [Color(0xFF084172), Color(0xFF084C82), Color(0xFF084C82), Color(0xFF115999)])
          ),
          child:
          SafeArea(
            top: false,
            child:
            CustomScrollView(
              physics: widget.page_mode != PAGE_MODE.three ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
              slivers: <Widget>[

                // 간격
                SliverPadding(padding: EdgeInsets.only(top: statusBarHeight),),

                // 텍스트 박스
                SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color.fromRGBO(255, 255, 255, 0.90)
                        ),
                        child: Text(
                          _total_price > 0 && !_isDiscount ? formatter.format(_total_price) + "원" :
                          _total_price > 0 && _isDiscount ? formatter.format(_total_price-(_total_price * 0.05)) + "원" : "한통 계산기",
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: _total_price > 0 ? TextAlign.right : TextAlign.center,
                        ),
                      ),
                    )
                ),

                // 키 패드 (한통 계산기)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20.0, 15, 20.0, 15.0),
                  sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                          _buildKeypadItem,
                          childCount: _keypads.length
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.6 * 1.2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0 * 0.8
                      )
                  ),
                ),

                // 키패드 (한통 계산기)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                          _buildTextKeypadItem,
                          childCount: 18
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.6 * 1.2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0 * 0.8
                      )
                  ),
                ),

                // 복사할 문자열
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 55.0),
                    child: (widget.page_mode != PAGE_MODE.three) ?  Container(
                      margin: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color.fromRGBO(255, 255, 255, 0.85)
                      ),
                      child: Text(_sms_message,
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.left,
                      ),
                    ) : null,
                  ),
                ),

                // 요금 조회
                SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 60.0),
                      //const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
                      child: (widget.page_mode != PAGE_MODE.three) ? Container(
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(25.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 0.5),
                              //borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromRGBO(255, 255, 255, 0.85)
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,0,25),
                                  child: TextField(
                                    scrollPadding: EdgeInsets.symmetric(vertical:_bloc.keyboardUtils.keyboardHeight),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: '출발지',
                                    ),
                                    controller: _controller,
                                    onSubmitted: (value) async {
                                      if (value.isEmpty) { return; }
                                      SSProgressIndicator.show(context);

                                      Result geocodeResult = await request_geocode(value);
                                      if(geocodeResult.isSuccess == false) {
                                        showToast(geocodeResult.result_data, context);
                                        setState(() {
                                          _start_latitudelongitude = '';
                                          _start = '';
                                          _goal_distance = 0;
                                          _goal_price = 0;
                                        });
                                        SSProgressIndicator.dismiss();
                                        return;
                                      }
                                      String startPoint = geocodeResult.result_data;
                                      _start = startPoint;
                                      setState(() {
                                        _start_latitudelongitude = geocodeResult.result_code;
                                      });

                                      if(_goal_latitudelongitude != '') {
                                        Result directionResult = await request_direction(_start,_goal);
                                        if (directionResult.isSuccess == false) {
                                          showToast(directionResult.result_data, context);
                                          SSProgressIndicator.dismiss();
                                          setState(() {
                                            _goal_distance = 0;
                                            _goal_price = 0;
                                          });
                                          return;
                                        }
                                        int distance = int.parse(directionResult.result_data);
                                        setState(() {
                                          _goal_distance = distance;
                                        });

                                        //예상 요금
                                        predictPrice(distance);
                                      }
                                      SSProgressIndicator.dismiss();
                                    },
                                  ),
                                ),
                                TextField(
                                  scrollPadding: EdgeInsets.symmetric(vertical:_bloc.keyboardUtils.keyboardHeight),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '도착지',
                                  ),
                                  onSubmitted: (value) async {
                                    if (value.isEmpty) { return; }
                                    SSProgressIndicator.show(context);
                                    // 주소 -> 위경도
                                    Result geocodeResult = await request_geocode(value);
                                    if (geocodeResult.isSuccess == false) {
                                      showToast(geocodeResult.result_data, context);
                                      setState(() {
                                        _goal_latitudelongitude = '';
                                        _goal = '';
                                        _goal_distance = 0;
                                        _goal_price = 0;
                                      });
                                      SSProgressIndicator.dismiss();
                                      return;
                                    }
                                    String goalPoint = geocodeResult.result_data;
                                    _goal = goalPoint;
                                    setState(() {
                                      _goal_latitudelongitude = geocodeResult.result_code;
                                    });

                                    if(_start_latitudelongitude != '') {
                                      // 이동 거리
                                      Result directionResult = await request_direction(_start, _goal);
                                      if (directionResult.isSuccess == false) {
                                        showToast(
                                            directionResult.result_data, context);
                                        SSProgressIndicator.dismiss();
                                        setState(() {
                                          _goal_distance = 0;
                                          _goal_price = 0;
                                        });
                                        return;
                                      }
                                      int distance = int.parse(
                                          directionResult.result_data);
                                      setState(() {
                                        _goal_distance = distance;
                                      });

                                      //예상 요금
                                      predictPrice(distance);
                                    }
                                    SSProgressIndicator.dismiss();
                                  },
                                ),
                                SizedBox(height: 10),
                                Text('출발지: $_start_latitudelongitude'),
                                Text('도착지: $_goal_latitudelongitude'),
                                Text('이동 거리: ${_goal_distance == 0 ? '' : '약 ${formatter.format(_goal_distance/1000)}km'}'),
                                Text('예상 요금: ${_goal_price == 0 ? '' : '${formatter.format(_goal_price)}원'}'),

                              ]
                          )
                      ) : null ,
                    )
                ),

                // 송장번호 검색
                // (widget.page_mode != PAGE_MODE.three) ? TrackerDeliveryWidget() : SliverToBoxAdapter(),

                // 전화번호로 업체명 검색
                (widget.page_mode != PAGE_MODE.three) ?  SalesStatusWidget() : SliverToBoxAdapter(),

                // SNS Widget
                (widget.page_mode != PAGE_MODE.three) ?  SNSWidget() : SliverToBoxAdapter(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // 상단 - 키패드
  Widget _buildKeypadItem(BuildContext context, int index) {
    Keypad keypad = _keypads[index];
    return MaterialButton(
      onLongPress: () => _keypadLongPressed(context, keypad),
      onPressed: () => _keypadPressed(context, keypad),
      elevation: 1.0,
      highlightElevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(2),
      minWidth: 0,
      color: keypad.isSelected ? keypad.selectedColor : keypad.backgroundColor,
      textColor: keypad.textColor,
      child: Container(
        child: Text(keypad.quantity > 0 ? "${keypad.title}\n(${keypad.quantity})" : keypad.title,
          textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
      ),
    );
  }

  _keypadPressed(BuildContext context, Keypad keypad) {
    // 배송비,5%할인 _purchaseList에서 제거
    if(is_add){
      _purchaseList.removeWhere((element) => element.PROD_CD == Product.DC_5p_cd || element.PROD_CD == Product.courier_fee_3000_cd || element.PROD_CD == Product.courier_fee_5000_cd || element.PROD_CD == Product.courier_fee_8000_cd);
      is_add = false;
    }

    switch(keypad.id) {
      case 0: // C
        setState(() {
          for (int i=3; i<_keypads.length; i++) {
            _keypads[i].isSelected = false;
            _keypads[i].quantity = 0;
          }
          _purchaseList.clear();
          _total_price = 0;
          _detail_message = "";
          _sms_string_type = 1;

          _isDiscount = false;
        });

        _buildSMSMessage(context, '');

        break;

      case 1: // 배송비 제거
        _removeDeliveryInfo();
        break;

      case 2: // 배송비 자동계산
        setState(() {
          keypad.isSelected = !keypad.isSelected;
          if (keypad.isSelected) {
            _autoDeliveryInfo(true);
          }
        });
        break;

      case 3: // 일회용 식판
      case 4: // 실링비닐
      case 5: // 주황보온 용기 한상자

      case 6: // 다회용 식판
      case 7: // 종이용기
      case 8: // 주황보온 용기 4+1

      case 9:  // 한통식판
      case 10: // 한통식판뚜껑
      case 11: // 한통식판세트

      case 12: // 한통쟁반 10개
      case 13: // 한통쟁반 60개
      case 14: // 실링기계

      case 15: // 한통뚝배기 5개
      case 16: // 한통뚝배기 20개
      case 17: // 한통뚝배기 210개

      case 18: // 뚝배기내피 210개
      case 19: // 캐리어 2인용
      case 20: // 캐리어 4인용

      case 21: // 주황패키지 1,000
      case 22: // 주황패키지 2,000
      case 23: // 주황패키지 3,000

      case 24: // 한통식판 패키지 100
      case 25: // 한통식판 패키지 200
      case 26: // 한통식판 패키지 300

      case 27: // 영중소 패키지 111
      case 28: // 영중소 패키지 222
      case 29: // 영중소 패키지 333
        print("price = ${keypad.price}");
        // 샘플이 리스트에 있을시 초기화
        if(is_sample){
          _keypadPressed(context, _keypads[0]);
          is_sample = false;
        }

        int quantity = keypad.quantity + 1;
        if (quantity < 0) quantity = 0;
        setState(() {
          keypad.isSelected = quantity > 0;
          keypad.quantity = quantity;
          if (_purchaseList.contains(keypad) == false) {
            _purchaseList.add(keypad);
          }
          if (keypad.quantity == 0) {
            _purchaseList.remove(keypad);
          }

          // 한통뚝배기 5개는 배송비 3천원 무조건 추가
          if (keypad.id == KPAD_INDEX_Ttugbaegi_5) {
            _autoDeliveryHantongTtugbaegi(_keypads[KPAD_INDEX_Delivery_3]);
          } else {
            _autoDeliveryInfo(_keypads[KPAD_INDEX_AutoDeliveryCount].isSelected);
          }

        });
        break;

      case KPAD_INDEX_Delivery_3: // 배송비 3천원
      case KPAD_INDEX_Delivery_5: // 배송비 5천원
      case KPAD_INDEX_Delivery_8: // 배송비 8천원
        // 샘플이 리스트에 있을시 초기화
        if(is_sample){
          _keypadPressed(context, _keypads[0]);
          is_sample = false;
        }

        if (_keypads[KPAD_INDEX_AutoDeliveryCount].isSelected) {
          showToast("자동 계산중입니다.", context);
          break;
        }

        int quantity = keypad.quantity + 1;
        if (quantity < 0) quantity = 0;


        setState(() {
          keypad.isSelected = quantity > 0;
          keypad.quantity = quantity;

          int total_price = 0;
          String detail_message = "";

          for (Keypad key in _purchaseList) {
            total_price += key.price * key.quantity;
            if (detail_message.isEmpty) {
              detail_message = "${key.title} ${key.quantity}${key.unit}";
            } else {
              detail_message = "${detail_message} , ${key.title} ${key.quantity}${key.unit}";
            }
          }

          int delivery_total_price = 0;
          delivery_total_price += _keypads[KPAD_INDEX_Delivery_3].price * _keypads[KPAD_INDEX_Delivery_3].quantity;
          delivery_total_price += _keypads[KPAD_INDEX_Delivery_5].price * _keypads[KPAD_INDEX_Delivery_5].quantity;
          delivery_total_price += _keypads[KPAD_INDEX_Delivery_8].price * _keypads[KPAD_INDEX_Delivery_8].quantity;

          if (delivery_total_price > 0) {
            total_price += delivery_total_price;
            if (detail_message.isEmpty == false) {
              detail_message += ", 배송비 (${formatter.format(delivery_total_price)}원)";
            }
          }

          _total_price = total_price;
          _detail_message = detail_message;

          _set_sms_message();
        });
        break;

      case KPAD_INDEX_Sample:
      case KPAD_INDEX_Sample_Free:
      // 첫 클릭시만 작동
      if (keypad.quantity == 0) {
        // 초기화
        _keypadPressed(context, _keypads[0]);

        is_sample = true;

        int quantity = keypad.quantity + 1;
        if (quantity < 0) quantity = 0;

        setState(() {
          if(keypad.id == 24) {
            _sms_string_type = 100;
            _set_sms_message();
          }else {
            _sms_string_type = 101;
            _set_sms_message();
          }

          keypad.isSelected = quantity > 0;
          keypad.quantity = quantity;
          if (_purchaseList.contains(keypad) == false) {
            _purchaseList.add(keypad);
          }
          if (keypad.quantity == 0) {
            _purchaseList.remove(keypad);
          }

        });
      }
        break;
      case KPAD_INDEX_DC_5p:
        _isDiscount = false;
        _set_sms_message();

        setState(() {
          keypad.isSelected = false;
          keypad.quantity = 0;

          if (_purchaseList.contains(keypad) == false) {
            _purchaseList.add(keypad);
          }

          if (keypad.quantity == 0) {
            _purchaseList.remove(keypad);
          }
        });


        break;
      default:
        break;
    }
  }

  _keypadLongPressed(BuildContext context, Keypad keypad) {
    // 배송비,5%할인 _purchaseList에서 제거
    if(is_add){
      _purchaseList.removeWhere((element) => element.PROD_CD == Product.DC_5p_cd || element.PROD_CD == Product.courier_fee_3000_cd || element.PROD_CD == Product.courier_fee_5000_cd || element.PROD_CD == Product.courier_fee_8000_cd);
      is_add = false;
    }

    switch(keypad.id) {
      case 0: // C
        // 초기화
        setState(() {
          _keypads[KPAD_INDEX_AutoDeliveryCount].isSelected = false;

          for (int i=3; i<_keypads.length; i++) {
            _keypads[i].isSelected = false;
            _keypads[i].quantity = 0;
          }

          _purchaseList.clear();

          _total_price = 0;
          _detail_message = "";

          _sms_string_type = 1;

          _isDiscount = false;
        });

        _buildSMSMessage(context, '');

        break;

      case 3: // 일회용 식판
      case 4: // 실링비닐
      case 5: // 주황보온 용기 한상자

      case 6: // 다회용 식판
      case 7: // 종이용기
      case 8: // 주황보온 용기 4+1

      case 9:  // 한통식판
      case 10: // 한통식판뚜껑
      case 11: // 한통식판세트

      case 12: // 한통쟁반 10개
      case 13: // 한통쟁반 60개
      case 14: // 실링기계

      case 15: // 한통뚝배기 5개
      case 16: // 한통뚝배기 20개
      case 17: // 한통뚝배기 210개

      case 18: // 뚝배기내피 210개
      case 19: // 캐리어 2인용
      case 20: // 캐리어 4인용

      case 21: // 주황패키지 1,000
      case 22: // 주황패키지 2,000
      case 23: // 주황패키지 3,000

      case 24: // 한통식판 패키지 100
      case 25: // 한통식판 패키지 200
      case 26: // 한통식판 패키지 300

      case 27: // 영중소 패키지 111
      case 28: // 영중소 패키지 222
      case 29: // 영중소 패키지 333

        setState(() {
          keypad.isSelected = false;
          keypad.quantity = 0;

          if (_purchaseList.contains(keypad) == false) {
            _purchaseList.add(keypad);
          }

          if (keypad.quantity == 0) {
            _purchaseList.remove(keypad);
          }
          
          // 한통뚝배기 5개는 배송비 3천원 무조건 추가
          if (keypad.id == KPAD_INDEX_Ttugbaegi_5) {
            _autoDeliveryInfo(true);
          } else {
            _autoDeliveryInfo(_keypads[KPAD_INDEX_AutoDeliveryCount].isSelected);
          }

        });
        break;

      case KPAD_INDEX_Delivery_3: // 배송비 3천원
      case KPAD_INDEX_Delivery_5: // 배송비 5천원
      case KPAD_INDEX_Delivery_8: // 배송비 8천원
        if (_keypads[KPAD_INDEX_AutoDeliveryCount].isSelected) {
          showToast("자동 계산중입니다.", context);
          break;
        }

        setState(() {
          keypad.isSelected = false;
          keypad.quantity = 0;

          int total_price = 0;
          String detail_message = "";

          for (Keypad key in _purchaseList) {
            total_price += key.price * key.quantity;
            if (detail_message.isEmpty) {
              detail_message = "${key.title} ${key.quantity}${key.unit}";
            } else {
              detail_message = "${detail_message} , ${key.title} ${key.quantity}${key.unit}";
            }
          }

          int delivery_total_price = 0;
          delivery_total_price += _keypads[KPAD_INDEX_Delivery_3].price * _keypads[KPAD_INDEX_Delivery_3].quantity;
          delivery_total_price += _keypads[KPAD_INDEX_Delivery_5].price * _keypads[KPAD_INDEX_Delivery_5].quantity;
          delivery_total_price += _keypads[KPAD_INDEX_Delivery_8].price * _keypads[KPAD_INDEX_Delivery_8].quantity;

          if (delivery_total_price > 0) {
            total_price += delivery_total_price;
            if (detail_message.isEmpty == false) {
              detail_message += ", 배송비 (${formatter.format(delivery_total_price)}원)";
            }
          }

          _total_price = total_price;
          _detail_message = detail_message;

          _set_sms_message();
        });
        break;

      case KPAD_INDEX_Sample: // 샘플 30,000
      case KPAD_INDEX_Sample_Free: // 무료샘플
        keypad.isSelected = false;
        keypad.quantity = 0;

        setState(() {
          if (keypad.quantity == 0) {
            _purchaseList.remove(keypad);
          }
          if (_purchaseList.isEmpty) {
            _keypadPressed(context, _keypads[0]);
          }
        });
        break;
      case KPAD_INDEX_DC_5p:
        if (keypad.quantity == 0) {
          int quantity = keypad.quantity + 1;
          if (quantity < 0) quantity = 0;

          setState(() {
            keypad.isSelected = quantity > 0;
            keypad.quantity = quantity;
          });

          _isDiscount = true;
          _removeDeliveryInfo();
          _set_sms_message();
        }

        break;

      default:
        break;
    }
  }

  // 배송비 제거
  void _removeDeliveryInfo() {
    int total_price = 0;
    String detail_message = "";

    for (Keypad key in _purchaseList) {
      total_price += key.price * key.quantity;
      if (detail_message.isEmpty) {
        detail_message = "${key.title} ${key.quantity}${key.unit}";
      } else {
        detail_message = "${detail_message} , ${key.title} ${key.quantity}${key.unit}";
      }
    }

    setState(() {
      _keypads[KPAD_INDEX_AutoDeliveryCount].isSelected = false;

      _keypads[KPAD_INDEX_Delivery_3].isSelected = false;
      _keypads[KPAD_INDEX_Delivery_3].quantity = 0;

      _keypads[KPAD_INDEX_Delivery_5].isSelected = false;
      _keypads[KPAD_INDEX_Delivery_5].quantity = 0;

      _keypads[KPAD_INDEX_Delivery_8].isSelected = false;
      _keypads[KPAD_INDEX_Delivery_8].quantity = 0;

      _total_price = total_price;
      _detail_message = detail_message;

      _set_sms_message();
    });
  }

  // 배송비 자동 계산
  void _autoDeliveryInfo(bool isAuto) {
    int total_price = 0;
    String detail_message = "";

    int delivery3 = 0;
    int delivery5 = 0;
    int delivery8 = 0;

    for (Keypad key in _purchaseList) {
      total_price += key.price * key.quantity;
      if (detail_message.isEmpty) {
        detail_message = "${key.title} ${key.quantity}${key.unit}";
      } else {
        detail_message = "${detail_message} , ${key.title} ${key.quantity}${key.unit}";
      }
      // 배송비 카운트
      if (key.id == KPAD_INDEX_SealingMachine) {
        delivery8 += key.quantity;
      } else if (key.id == KPAD_INDEX_Tray_10 || key.id == KPAD_INDEX_Ttugbaegi_5) {
        delivery3 += key.quantity;
      } else if(key.id == KPAD_INDEX_Sample || key.id == KPAD_INDEX_Sample_Free){
        continue;
      } else {
        delivery5 += key.quantity;
      }
    }

    int delivery_total_price = 0;

    if (isAuto) {
      // 배송비 자동 계산
      _keypads[KPAD_INDEX_Delivery_3].isSelected = delivery3 > 0;
      _keypads[KPAD_INDEX_Delivery_3].quantity = delivery3;
      delivery_total_price += _keypads[KPAD_INDEX_Delivery_3].price * _keypads[KPAD_INDEX_Delivery_3].quantity;

      _keypads[KPAD_INDEX_Delivery_5].isSelected = delivery5 > 0;
      _keypads[KPAD_INDEX_Delivery_5].quantity = delivery5;
      delivery_total_price += _keypads[KPAD_INDEX_Delivery_5].price * _keypads[KPAD_INDEX_Delivery_5].quantity;

      _keypads[KPAD_INDEX_Delivery_8].isSelected = delivery8 > 0;
      _keypads[KPAD_INDEX_Delivery_8].quantity = delivery8;
      delivery_total_price += _keypads[KPAD_INDEX_Delivery_8].price * _keypads[KPAD_INDEX_Delivery_8].quantity;
    } else {
      // 배송비 수동 계산
      delivery_total_price += _keypads[KPAD_INDEX_Delivery_3].price * _keypads[KPAD_INDEX_Delivery_3].quantity;
      delivery_total_price += _keypads[KPAD_INDEX_Delivery_5].price * _keypads[KPAD_INDEX_Delivery_5].quantity;
      delivery_total_price += _keypads[KPAD_INDEX_Delivery_8].price * _keypads[KPAD_INDEX_Delivery_8].quantity;
    }

    if (delivery_total_price > 0) {
      total_price += delivery_total_price;
      if (detail_message.isEmpty == false) {
        detail_message += ", 배송비 (${formatter.format(delivery_total_price)}원)";
      }
    }

    _total_price = total_price;
    _detail_message = detail_message;

    _set_sms_message();
  }

  //*/ 배송비 자동 계산 - 한통뚝배기
  void _autoDeliveryHantongTtugbaegi(Keypad keypad) {
    int quantity = keypad.quantity + 1;
    if (quantity < 0) quantity = 0;

    setState(() {
      keypad.isSelected = quantity > 0;
      keypad.quantity = quantity;

      int total_price = 0;
      String detail_message = "";

      for (Keypad key in _purchaseList) {
        total_price += key.price * key.quantity;
        if (detail_message.isEmpty) {
          detail_message = "${key.title} ${key.quantity}${key.unit}";
        } else {
          detail_message = "${detail_message} , ${key.title} ${key.quantity}${key.unit}";
        }
      }

      int delivery_total_price = 0;
      delivery_total_price += _keypads[KPAD_INDEX_Delivery_3].price * _keypads[KPAD_INDEX_Delivery_3].quantity;
      delivery_total_price += _keypads[KPAD_INDEX_Delivery_5].price * _keypads[KPAD_INDEX_Delivery_5].quantity;
      delivery_total_price += _keypads[KPAD_INDEX_Delivery_8].price * _keypads[KPAD_INDEX_Delivery_8].quantity;

      if (delivery_total_price > 0) {
        total_price += delivery_total_price;
        if (detail_message.isEmpty == false) {
          detail_message += ", 배송비 (${formatter.format(delivery_total_price)}원)";
        }
      }

      _total_price = total_price;
      _detail_message = detail_message;

      _set_sms_message();
    });
  }
  // */

  // 하단 - 키패드
  Widget _buildTextKeypadItem(BuildContext context, int index) {
    String title = "";
    switch(index) {
      case 0: title = "복사"; break;
      case 1: title = "현금(법인)"; break;
      case 2: title = "카드(법인)"; break;
      case 3: title = "신규 현금\n미발행"; break;
      case 4: title = "신규 현금\n발행"; break;
      case 5: title = "신규 카드"; break;
      case 6: title = "PayApp\n바로가기"; break;
      case 7: title = "현금(개인)"; break;
      case 8: title = "카드(개인)"; break;
      case 9: title = "사용법 안내"; break;
      case 10: title = "현금결제 확인"; break;
      case 11: title = "카드결제 확인"; break;
      case 12: title = "카드결제 안내"; break;
      case 13: title = "현금결제 요청"; break;
      case 14: title = "카드결제 요청"; break;
      case 15: title = "주문서 등록"; break;
      case 16: title = "주문서 + 문자"; break;
      case 17: title = "출하 지시서"; break;
      case 18: title = "택배송장"; break;

      default:
        return null;
    }
    return _buildTextButton(context, index, title);
  }

  Widget _buildTextButton(BuildContext context, int index, String title) {
    if(index == 0) {
      return Listener(
        onPointerDown: (value) {
          if (_sms_message.isNotEmpty) {
            showToast("복사되었습니다.", context);
            Clipboard.setData(ClipboardData(text: _sms_message));
          }
        },
        child: MaterialButton(
          onPressed: () => _textKeypadPressed(context, index, false),
          onLongPress: () => _textKeypadPressed(context, index, true),
          elevation: 1.0,
          highlightElevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(8),
          minWidth: 0,
          color: MyApp.btnSelectedColor,
          textColor: Colors.white,
          child: Container(
            child: Text(title,
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
          ),
        ),
      );
    }
    else if (index == 6) {
      return MaterialButton(
        onPressed: () => _textKeypadPressed(context, index, false),
        onLongPress: () => _textKeypadPressed(context, index, true),
        elevation: 1.0,
        highlightElevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(8),
        minWidth: 0,
        color: MyApp.btnSelectedColor,
        textColor: Colors.white,
        child: Container(
          child: Text(title,
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
        ),
      );
    } else {
      return MaterialButton(
        onPressed: () => _textKeypadPressed(context, index, false),
        onLongPress: () => _textKeypadPressed(context, index, true),
        elevation: 1.0,
        highlightElevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(8),
        minWidth: 0,
        color: _sms_string_type == index ? MyApp.btnSelectedColor : MyApp.btnBackgroundColor,
        textColor: Colors.black,
        child: Container(
          child: Text(title,
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
        ),
      );
    }
  }

  // 하단 - 키패드 액션
  _textKeypadPressed(BuildContext context, int index, bool lsLongPress) async {
    String message = "";
    String product = _detail_message;

    String price = formatter.format(_total_price) + "원";
    String account = "기업은행 한병기(한통) 485-051882-01-010";
    String corporationAccount = "기업은행 ㈜한통 555-046376-04-033";

    // 배송비,5%할인 _purchaseList에서 제거
    if(is_add){
      _purchaseList.removeWhere((element) => element.PROD_CD == Product.DC_5p_cd || element.PROD_CD == Product.courier_fee_3000_cd || element.PROD_CD == Product.courier_fee_5000_cd || element.PROD_CD == Product.courier_fee_8000_cd);
      is_add = false;
    }

    switch(index) {
      case 0:
        // 복사 - 키패드에 내용 복사
        if (_sms_message.isNotEmpty) {
          showToast("복사되었습니다.", context);
          Clipboard.setData(ClipboardData(text: _sms_message));
        }
        break;
      case 1:
      case 3:
      case 4:
      case 7:
      case 9:
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
        if (lsLongPress) {
          showToast("결제링크를 지원하지 않습니다.", context);
        } else {
          _sms_string_type = index;
          _set_sms_message();

          switch(index) {
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            _textKeypadPressed(context,0,false);
              break;
            default:
              break;
          }

        }
        break;
      case 2:
      case 5:
      case 8:
        if (lsLongPress) {
          // 최종 결제 금액
          int price = _get_payapp_price();
          if (price < 1000) {
            showToast("결제금액은 1,000원 이상부터 링크생성이 가능합니다.", context);
            return;
          }

          // 상품명
          String good_name = "";
          int good_count = 0;
          for (Keypad key in _purchaseList) {
            good_count += 1;
            if (good_name.isEmpty) {
              good_name = key.title;
            }
          }

          if (good_count == 0 || good_name.isEmpty) {
            showToast("선택된 상품이 없습니다.", context);
            return;
          }

          good_count -= 1;
          if (good_count > 1) { good_name += "외 ${good_count}개"; }

          // 결제링크에 대한 로딩
          _phoneNumber = '';
          final String phone_number = await _asyncInputPhoneNumberDialog(context);
          if (phone_number.isEmpty) { return; }
          //print("phone_number: ${phone_number}");

          SSProgressIndicator.show(context);
          final PAYApp payApp = await request_payapp(good_name, price.toString(), phone_number);
          SSProgressIndicator.dismiss();

          if (payApp == null) {
            // 실패
            showErrorToast(context, "링크생성 실패!", "${payApp.errorMessage}");
            return;
          }

          if (payApp.state == 1) {
            _sms_string_type = index;
            _set_sms_message(link_url: payApp.payurl, isCopy: true);
            print(payApp.feedbackurl);
          } else {
            // 실패
            showErrorToast(context, "링크생성 실패!", "${payApp.errorMessage}");
          }

        } else {
          _sms_string_type = index;
          _set_sms_message();
        }
        break;
      case 6:
        if (lsLongPress) {
          _launchURL(payapp_open_url);
        } else {
          showToast("PayApp\n주소가 복사되었습니다.", context);
          Clipboard.setData(ClipboardData(text: payapp_copy_url));
        }
        break;

      case 15:
      case 16:
        if(!is_add) {
          if(_keypads[KPAD_INDEX_DC_5p].quantity != 0){
            _keypads[KPAD_INDEX_DC_5p].price = -(_total_price * 0.05).toInt();
            _purchaseList.add(_keypads[KPAD_INDEX_DC_5p]);
          }

          if(_keypads[KPAD_INDEX_Delivery_3].quantity != 0){
            _purchaseList.add(_keypads[KPAD_INDEX_Delivery_3]);
          }
          if(_keypads[KPAD_INDEX_Delivery_5].quantity != 0){
            _purchaseList.add(_keypads[KPAD_INDEX_Delivery_5]);
          }
          if(_keypads[KPAD_INDEX_Delivery_8].quantity != 0){
            _purchaseList.add(_keypads[KPAD_INDEX_Delivery_8]);
          }
        }

        is_add = true;

        print("index = $index");
        Navigator.push(context,MaterialPageRoute(builder: (context) =>
            SaleOrderPage(orderList: _purchaseList,smsMessage: _sms_message,keypadIndex: index)
        ));
        break;
      case 17:
        // 출하지시서
        if(kIsWeb){
          Navigator.push(context,MaterialPageRoute(builder: (context) =>
              ShipmentOrderPage()
          ));
        }else{
          SSToast.show("웹에서만 사용 가능합니다.", context, gravity: SSToast.CENTER);
        }
        break;
      case 18:
      // 택배송장
        if(kIsWeb){
          Navigator.push(context,MaterialPageRoute(builder: (context) =>
              CourierInvoicePage()
          ));
        }else{
          SSToast.show("웹에서만 사용 가능합니다.", context, gravity: SSToast.CENTER);
        }
        break;
      default:
        break;
    }

    if (message.isNotEmpty) {
      _buildSMSMessage(context, message);
    }
  }

  // 최종 결제 금액 리턴
  int _get_payapp_price() {
    int price = 0;
    if (_isDiscount) {
      int sale = (_total_price * 0.05).toInt();
      price = _total_price-sale;
    } else {
      price = _total_price;
    }
    return price;
  }

  // 최종 복사 메세지
  void _set_sms_message({String link_url = "", bool isCopy = false}) {
    String message = "";
    String product = _detail_message;

    String price = formatter.format(_total_price) + "원";
    String account = "기업은행 한병기(한통) 485-051882-01-010";
    String corporationAccount = "기업은행 ㈜한통 555-046376-04-033";
    String deliveryTime = "2시30분";

    String sale_messsage = "";
    if (_isDiscount) {
      int sale = (_total_price * 0.05).toInt();
      sale_messsage = "할인액 ${formatter.format(sale)}원\n결제 총액 ${formatter.format(_total_price-sale)}원 입니다.";
    }

    if (_keypads[KPAD_INDEX_OrangePackage_1].isSelected) {
      sale_messsage += "\n\n주황패키지 1,000 구성품\n(주황보온용기 5박스, 일회용식판 2박스, 실링비닐 1박스, 실링기계 1대)";
    }

    if (_keypads[KPAD_INDEX_OrangePackage_2].isSelected) {
      sale_messsage += "\n\n주황패키지 2,000 구성품\n(주황보온용기 10박스, 일회용식판 4박스, 실링비닐 1박스, 실링기계 1대)";
    }

    if (_keypads[KPAD_INDEX_OrangePackage_3].isSelected) {
      sale_messsage += "\n\n주황패키지 3,000 구성품\n(주황보온용기 15박스, 일회용식판 6박스, 실링비닐 2박스, 실링기계 1대)";
    }

    if (_keypads[KPAD_INDEX_HantongPlate_1].isSelected) {
      sale_messsage += "\n\n한통식판 패키지 100 구성품\n(주황보온용기 5박스, 한통식판 2박스, 한통식판뚜껑 2박스)";
    }

    if (_keypads[KPAD_INDEX_HantongPlate_2].isSelected) {
      sale_messsage += "\n\n한통식판 패키지 200 구성품\n(주황보온용기 10박스, 한통식판 4박스, 한통식판뚜껑 4박스)";
    }

    if (_keypads[KPAD_INDEX_HantongPlate_3].isSelected) {
      sale_messsage += "\n\n한통식판 패키지 300 구성품\n(주황보온용기 15박스, 한통식판 6박스, 한통식판뚜껑 6박스)";
    }

    if (_keypads[KPAD_INDEX_SmallBusiness_1].isSelected) {
      sale_messsage += "\n\n영중소 패키지 111 구성품\n(주황보온용기 1박스, 한통식판 1박스, 한통식판뚜껑 1박스, 한통쟁반(10EA) 1박스)";
    }

    if (_keypads[KPAD_INDEX_SmallBusiness_2].isSelected) {
      sale_messsage += "\n\n영중소 패키지 222 구성품\n(주황보온용기 2박스, 한통식판 2박스, 한통식판뚜껑 2박스, 한통쟁반(10EA) 2박스)";
    }

    if (_keypads[KPAD_INDEX_SmallBusiness_3].isSelected) {
      sale_messsage += "\n\n영중소 패키지 333 구성품\n(주황보온용기 3박스, 한통식판 3박스, 한통식판뚜껑 3박스, 한통쟁반(10EA) 3박스)";
    }

    String link_message = "카드결제 링크를 보내드립니다. 결제 부탁드립니다.\n";
    if (link_url.isEmpty == false) {
      link_message = """
카드결제를 진행하시려면 아래의 링크를 누르시면 됩니다.
${link_url}

ARS결제는 아래의 전화 번호를 누르시면 됩니다. 
02-6340-1833
""";
    }

    switch(_sms_string_type) {
      case 1:
// 1. 2020/10/1이후 거래처 (현금(법인))
message ="""
$product 

총액 $price
$sale_messsage

$corporationAccount

$deliveryTime 이후 확인된 결제는 평일기준 다음날 출고되며 입금이 확인되지 않으면 출고되지 않습니다.

결제 후 연락을 주시면 감사하겠습니다. 

한통도시락은 제품의 특성상 택배배송이 평일기준 3일~5일 정도 소요됩니다.
""";
        break;
      case 2:
// 2. 2020/10/1이후 거래처 (카드(법인))
message ="""
$product

총액 $price
$sale_messsage

$corporationAccount

$link_message
$deliveryTime 이후 확인된 결제는 평일기준 다음날 출고되며 결제가 확인되지 않으면 출고되지 않습니다.

결제 후 연락을 주시면 감사하겠습니다.

한통도시락은 제품의 특성상 택배배송이 평일기준 3일~5일 정도 소요됩니다.
""";
        break;
      case 3:
// 3. 신규고객 (현금, 계산서 미발행)
message ="""
$product

주문하신 제품의 총액은 $price입니다. 
$sale_messsage
$corporationAccount

당일 출고를 위해서는 2시 이전에 입금 되어야 합니다.

입금 후에 상호, 식당전화번호, 대표자명, 주소를 답변으로 보내주세요. 

한통도시락은 제품의 특성상 택배배송이 평일기준 3일~5일 정도 소요됩니다.
""";
        break;
      case 4:
// 4. 신규고객 (현금, 계산서 발행)
message ="""
$product

주문하신 제품의 총액은 $price입니다. 
$sale_messsage
$corporationAccount

당일 출고를 위해서는 2시 이전에 입금 되어야 합니다.

입금 후에 사업자등록증 사본, 식당전화번호, 계산서 발행받을 이메일주소 를 답변으로 보내주세요. 

한통도시락은 제품의 특성상 택배배송이 평일기준 3일~5일 정도 소요됩니다.
""";
        break;
      case 5:
// 5. 신규고객 (카드)
message ="""
$product

주문하신 제품의 총액은 $price입니다. 
$sale_messsage

$corporationAccount

$link_message
당일 출고를 위해서는 2시 이전에 입금 되어야 합니다.

결제 후에 상호, 식당전화번호, 대표자명, 주소를 답변으로 보내주세요. 

한통도시락은 제품의 특성상 택배배송이 평일기준 3일~5일 정도 소요됩니다.
""";
        break;
      case 7:
// 7. 기존고객 (현금(개인) 계산서 발행 & 미발행)
message ="""
$product 

총액 $price
$sale_messsage

$account

$deliveryTime 이후 확인된 결제는 평일기준 다음날 출고되며 입금이 확인되지 않으면 출고되지 않습니다.

결제 후 연락을 주시면 감사하겠습니다. 

한통도시락은 제품의 특성상 택배배송이 평일기준 3일~5일 정도 소요됩니다.
""";
        break;
      case 8:
// 8. 기존고객 (카드(개인))
        message ="""
$product

총액 $price
$sale_messsage

$account

$link_message
$deliveryTime 이후 확인된 결제는 평일기준 다음날 출고되며 결제가 확인되지 않으면 출고되지 않습니다.

결제 후 연락을 주시면 감사하겠습니다.

한통도시락은 제품의 특성상 택배배송이 평일기준 3일~5일 정도 소요됩니다.
""";
        break;
      case 9:
// 9. 사용법 안내
        message = """
한통도시락입니다.

실링기계 사용법 동영상 첨부드립니다.

실링기계 사용 시 온도는 160도로 고정설정하여 사용해주시기 바랍니다.

https://youtu.be/4xHBG7K9gog

주황보온용기 세척영상입니다.

세척영상 (45초 이후)
https://www.youtube.com/watch?v=Q7JGnX7kvAQ&feature=youtu.be 

감사합니다.
""";
        break;
      case 10:
// 10. 현금결제 확인
        message = """
입금 확인했습니다.
감사합니다.
""";
        break;
      case 11:
// 11. 카드결제 확인
        message = """
카드결제 확인했습니다.
감사합니다.
""";
        break;
      case 12:
// 12. 카드결제 안내
        message = """
안녕하세요 한통입니다.

카드결제방법 영상 송부드립니다.
영상보시고 결제하실때 참고하시기 바랍니다.

https://www.youtube.com/watch?v=E7DSkCKN1XA

감사합니다.
""";
        break;
      case 13:
// 13. 현금결제 요청
        message = """
한통도시락입니다.

입금 확인이 되지 않고 있습니다.
혹시 이미 결제하셨다면 연락 부탁 드립니다.
2시 30분까지 확인이 되지 않을 경우 금일 출고가 불가합니다.

감사합니다.
""";
        break;
      case 14:
// 14. 카드결제 요청
        message = """
한통도시락입니다.

카드결제 확인이 되지 않고 있습니다.
혹시 이미 결제하셨다면 연락 부탁 드립니다.
2시 30분까지 확인이 되지 않을 경우 금일 출고가 불가합니다.

감사합니다.
""";
        break;

      case 100:
// 100. 샘플 30,000원
        message ="""
한통도시락입니다. 저희 제품에 대한 관심에 감사드립니다   

샘플은 배송비 포함하여  1Set 30,000원 입니다. 
평일 3시 이전 입금은 당일날, 3시 이후에는 다음날 발송해드립니다.
기업은행 ㈜한통 555-046376-04-033 
입금 후에 받으실 분 성함 또는 상호, 주소를 답변으로 보내주세요.
""";
        break;
      case 101:
// 101. 무료 샘플
        message ="""
한통도시락입니다. 저희 제품에 대한 관심에 감사드립니다   

샘플 받으실 분의 성함이나 상호, 주소를 보내주시면 착불 택배로 발송해 드립니다. 
평일 3시 이전 문자는 당일날, 3시 이후에는 다음날 발송해드립니다. 
""";
        break;
      default:
        break;
    }

    if (isCopy) {
      showToast("결제 링크가 생성되었습니다.", context);
      /*/ SSONG TODO: 웹에서 복사시 오류가 발생한다. 일단 주석처리
      Clipboard.setData(ClipboardData(text: message));
      // */
    }

    if (message.isNotEmpty) {
      _buildSMSMessage(context, message);
    }
  }

  // 토스트 메세지
  void showToast(String msg, BuildContext context, {int duration = 3, int gravity}) {
    SSToast.show(msg, context, duration: duration, gravity: SSToast.CENTER);
  }

  // 팝업 메세지
  void showErrorToast(BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(title, style: TextStyle(fontSize: 20.0),),
                Text(''),
                Text(message, style: TextStyle(fontSize: 14.0),)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.pop(context);
              },
            )]
        );
      },
    );
  }

  // 전화번호 입력 팝업 화면
  Future<String> _asyncInputPhoneNumberDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('전화번호를 입력하세요.', style: TextStyle(color: Colors.black),),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: _buildPhoneTextComposer(context)
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                print('취소버튼');
                Navigator.pop(context, null);
              },
            ),
            FlatButton(
              child: Text('확인'),
              onPressed: () async {
                //print('확인버튼');
                //if(_phoneNumber.isEmpty) {
                //  showToast("전화번호를 입력하세요", context);
                //  return;
                //}
                //Navigator.of(context).pop(_phoneNumber);
                _actionPhoneTextFiled_enter(context);
              },
            ),
          ],
        );
      },
    );
  }

  // 전화번호 입력 텍스트 필드에 키보드 이벤트 캐치
  _buildPhoneTextComposer(BuildContext context) {
    print('_buildTextComposer');
    TextField _textField = new TextField(
      keyboardType: TextInputType.number,
      controller: TextEditingController()..text = '010',
      //autofocus: true,
      decoration: new InputDecoration(
          labelText: 'Phone Number', hintText: '010xxxxxxxx'
      ),
      onChanged: (value) {
        //print('onChanged: %${value}%');
        _phoneNumber = value;
      },
      onSubmitted: (value) {
        //print('onSubmitted: %${value}%');
        _phoneNumber = value;
      },
    );

    print('_textNode: $_textFocusNode');
    FocusScope.of(context).requestFocus(_textFocusNode);

    return new RawKeyboardListener(
      focusNode: _textFocusNode,
      onKey: (RawKeyEvent value)  {
        print(value.logicalKey);
        if (value.logicalKey == LogicalKeyboardKey.enter) {
          _actionPhoneTextFiled_enter(context);
        }
      },
      child: _textField
    );
  }

  // 팝업 확인 or Enter 키 입력
  _actionPhoneTextFiled_enter(BuildContext context) {
    print('확인버튼');
    if(_phoneNumber.isEmpty) {
      showToast("전화번호를 입력하세요", context);
      return;
    }
    Navigator.of(context).pop(_phoneNumber);
  }

  // 웹페이지 열기
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 복사할 문자열 갱신
  _buildSMSMessage(BuildContext context, String msg) {
    setState(() {
      _sms_message = msg;

      if (widget.functionSMSMessage == null) { return; }
      widget.functionSMSMessage(msg);
    });
  }

  // 예상요금
  // http://tel-1800-3324.com/xe/files/attach/images/638/638/6ec0d0660f85c6a93235a7dd6fa0afef.png
  int predictPrice(int distance) {
    int price = 25000;

    if (distance >= 600000) {       price = 300000; }
    else if (distance >= 550000) {  price = 270000; }
    else if (distance >= 500000) {  price = 250000; }
    else if (distance >= 450000) {  price = 220000; }
    else if (distance >= 400000) {  price = 200000; }
    else if (distance >= 350000) {  price = 190000; }
    else if (distance >= 300000) {  price = 170000; }
    else if (distance >= 250000) {  price = 150000; }
    else if (distance >= 200000) {  price = 130000; }

    else if (distance >= 170000) {  price = 120000; }
    else if (distance >= 150000) {  price = 110000; }
    else if (distance >= 130000) {  price = 100000; }
    else if (distance >= 110000) {  price =  90000; }

    else if (distance >= 90000) {  price = 80000; }
    else if (distance >= 70000) {  price = 70000; }
    else if (distance >= 50000) {  price = 60000; }
    else if (distance >= 30000) {  price = 50000; }
    else if (distance >= 20000) {  price = 40000; }
    else if (distance >= 10000) {  price = 30000; }

    setState(() {
      _goal_price = price;
    });
  }

}

// 링크생성
Future<PAYApp> request_payapp(String goodname, String price, String recvphone) async {
  var urlString = 'https://intosharp.pythonanywhere.com/payapp';
  var body = json.encode({
    "goodname":goodname,
    "price":price,
    "recvphone":recvphone,
  });

  final response = await http.post(urlString, body: body, headers: {'content-type':'application/json'});

  // SSONG TODO: response null check
  final Result result = Result.fromJson(json.decode(response.body));

  PAYApp payApp = new PAYApp();
  if (response.statusCode == 200) {
    List reslut = result.result_data.split('&');
    for(String item in reslut) {
      String key = item.split('=').first;
      String value = item.split('=').last;
      if (value.isEmpty) continue;

      var decoded = Uri.decodeFull(value).replaceAll('+', ' ');
      switch(key){
        case 'state': payApp.state = int.parse(decoded); break;
        case 'errorMessage': payApp.errorMessage = decoded; break;
        case 'mul_no': payApp.mul_no = int.parse(decoded); break;
        case 'payurl': payApp.payurl = decoded; break;
        case 'qrurl': break;
        default: break;
      }
    }
  } else {
    payApp.state = 0;
    payApp.errorMessage = "Failed to load payapp";
    throw Exception('Failed to load payapp');
  }
  return payApp;
}

// 주소 -> 위경도
Future<Result> request_geocode(String address) async {
  var urlString = 'https://intosharp.pythonanywhere.com/geocode';
  var body = json.encode({"address": address});
  try {
    final response = await http.post(urlString, body: body, headers: {'content-type':'application/json'});
    final Result result = Result.fromJson(json.decode(response.body));
    Map<String, dynamic> resultJson = jsonDecode(result.result_data);
    String status = resultJson['status'];
    if (status == 'OK') {
      List addresses = resultJson['addresses'] != null ? List.from(resultJson['addresses']) : null;
      if (addresses.isEmpty) {
        result.result_data = "addresses is null";
        result.isSuccess = false;
      } else {
        String x = addresses.first['x'];
        String y = addresses.first['y'];
        result.result_data = "$x,$y";
        result.result_code = addresses.first['roadAddress'];
        result.isSuccess = true;
      }
    } else {
      String errorMessage = resultJson['errorMessage'];
      result.result_data = errorMessage.isEmpty ? "Request Geocode Error" : errorMessage;
      result.isSuccess = false;
    }
    return result;
  } catch (e) {
    Result error = new Result(result_code: "0", result_data: e.toString(), isSuccess: false);
    return error;
  }
}

// 거리계산
Future<Result> request_direction(String start, String goal) async {
  var urlString = 'https://intosharp.pythonanywhere.com/direction';
  var body = json.encode({"start": start, "goal": goal, "option": 'traoptimal'});
  try {
    final response = await http.post(urlString, body: body, headers: {'content-type':'application/json'});
    final Result result = Result.fromJson(json.decode(response.body));
    Map<String, dynamic> resultJson = jsonDecode(result.result_data);
    List traoptimal = resultJson['route']['traoptimal'] != null ? List.from(resultJson['route']['traoptimal']) : null;
    if (traoptimal == null || traoptimal.isEmpty) {
      result.result_data = "traoptimal is null";
      result.isSuccess = false;
    } else {
      int distance = traoptimal.first['summary']['distance'];
      result.result_data = "$distance";
      result.isSuccess = true;
    }
    return result;
  } catch (e) {
    Result error = new Result(result_code: "0", result_data: e.toString(), isSuccess: false);
    return error;
  }
}
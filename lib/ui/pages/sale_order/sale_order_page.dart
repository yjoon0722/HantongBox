import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hantong_cal/models/bulks_data.dart';
import 'package:hantong_cal/models/keypad.dart';
import 'package:hantong_cal/models/product.dart';
import 'package:hantong_cal/models/productInfoNotifier.dart';
import 'package:hantong_cal/models/sales_status_data.dart';
import 'package:hantong_cal/ui/pages/sale_order/sale_order_customer_search.dart';
import 'package:hantong_cal/ui/pages/sale_order/sale_order_product_list.dart';
import 'package:hantong_cal/ui/widgets/SSHud.dart';
import 'package:hantong_cal/ui/widgets/SSProgressIndicator.dart';
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:hantong_cal/ui/widgets/ss_textfield_datepicker.dart';
import 'package:hantong_cal/ui/widgets/ss_textfield_dropdown.dart';
import 'package:hantong_cal/models/sale_order_data.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class SaleOrderPage extends StatefulWidget {
  final List<Keypad> orderList;
  final String smsMessage;
  final int keypadIndex;

  const SaleOrderPage({
    Key key,
    @required this.orderList,
    this.smsMessage,
    this.keypadIndex,
  })  : assert(orderList != null, 'orderList must not be null'),
        super(key: key);

  @override
  _SaleOrderPageState createState() => _SaleOrderPageState();
}

class _SaleOrderPageState extends State<SaleOrderPage> {

  DateTime _selectedDate;       // 일자
  String _selectedEmpCode;      // 담당자 코드
  String _selectedCustCode;     // 거래처 코드
  String _selectedCustContact;  // 거래처 연락처
  String _selectedIoTypeCode;   // 거래유형 코드
  String _selectedWhCode;       // 출하창고 코드
  String _selectedCollTermCode; // 결제조건 코드
  List<Product_Info> productInfo;

  int sendMessageButtonIndex = 16;

  FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    productInfo = getProductInfoListWithOrderList(widget.orderList);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductInfoNotifier>(context, listen: false).setProductInfoList(productInfo);
    });

    _selectedDate = DateTime.now();
    _selectedIoTypeCode = IO_TYPE_MAP[1].values.first;
    _selectedWhCode = WH_CD_MAP[3].values.first;
    _loadSelectedEmpCode();

    print("widget.smsMessage = ${widget.smsMessage}");

    // SSONG TEST 데이터
    // _selectedEmpCode = "00013";
    // _selectedCustCode = "HT0001";
    // _selectedIoTypeCode = "11";
    // _selectedWhCode = "00010";
    // _selectedCollTermCode = "현금";

  }

  _loadSelectedEmpCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedEmpCode = (prefs.getString("selectedEmpCode") ?? EMP_CD_MAP.first.values.first);
  }


  @override
  Widget build(BuildContext context) {
    final productInfoNotifier = context.watch<ProductInfoNotifier>();
    productInfoNotifier.setProductInfoListNoListeners(productInfo);

    return Scaffold(
      appBar: AppBar(
        title: const Text('주문서 입력'),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3, 0.7, 1.0],
                  colors: [Color(0xFF084172), Color(0xFF084C82), Color(0xFF084C82), Color(0xFF115999)])
          ),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [

              SliverPadding(padding: EdgeInsets.only(top: 40),),

              // 일자
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    child: SSTextFieldDatePicker(
                      labelText: "일자",
                      prefixIcon: Icon(Icons.date_range, color: Colors.white,),
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      lastDate: DateTime.now().add(Duration(days: 366)),
                      firstDate: DateTime.now().add(Duration(days: -366)),
                      initialDate: _selectedDate,
                      onDateChanged: (selectedDate) {
                        print(selectedDate);
                        if (selectedDate != null) {
                          setState(() {
                            _selectedDate = selectedDate;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),

              // 담당자
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    child: SSTextFieldDropDown(
                      labelText: "담당자",
                      items: EMP_CD_MAP,
                      prefixIcon: Icon(Icons.account_box, color: Colors.white,),
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      onChanged: (value) async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        _selectedEmpCode = getCodeWithMap(value);
                        var _selectedEmpCodeValue = getValueWithMap(value);
                        prefs.setString("selectedEmpCode", _selectedEmpCode);
                        prefs.setString("selectedEmpCodeValue", _selectedEmpCodeValue);
                      },
                    ),
                  ),
                ),
              ),

              // 거래처
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0,20.0,20.0,0.0),
                  child: Container(
                    child: SaleOrderCustomerSearch(
                      onChanged: (value) async {
                        setState(() {
                          _selectedCustCode = value.account_code;
                          _selectedCustContact = (value.account_contact_information1).replaceAll("-", "");
                        });
                        List<SalesStatusData> salesStatusData = await request_mysql(_selectedCustCode);
                        print(salesStatusData);

                        if(salesStatusData.isNotEmpty){
                          for(int i=0; i < productInfoNotifier.productInfoList.length; i++){
                            if(Product.sealing_vinyl_cd_list.contains(productInfoNotifier.productInfoList[i].PROD_CD)){
                              productInfoNotifier.productInfoList[i].PROD_DES = salesStatusData[0].goods;
                              switch(productInfoNotifier.productInfoList[i].PROD_DES){
                                case Product.sealing_vinyl_A_name:
                                  productInfoNotifier.productInfoList[i].PROD_CD = Product.sealing_vinyl_A_cd;
                                  break;
                                case Product.sealing_vinyl_B_name:
                                  productInfoNotifier.productInfoList[i].PROD_CD = Product.sealing_vinyl_B_cd;
                                  break;
                                case Product.sealing_vinyl_C_name:
                                  productInfoNotifier.productInfoList[i].PROD_CD = Product.sealing_vinyl_C_cd;
                                  break;
                                case Product.sealing_vinyl_D_name:
                                  productInfoNotifier.productInfoList[i].PROD_CD = Product.sealing_vinyl_D_cd;
                                  break;
                                default:
                                  break;
                              }
                              productInfoNotifier.changeProductInfo(i, productInfoNotifier.productInfoList[i]);
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),

              widget.keypadIndex == sendMessageButtonIndex ?
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0,0,20.0,20.0),
                  child: Container(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: _selectedCustCode == null ? "" : "연락처 : $_selectedCustContact",
                          style: TextStyle(fontSize: 12.0,color: Colors.white),
                        ),
                        TextSpan(
                          text: _selectedCustCode == null ? "" : "   변경하기",
                          style: TextStyle(fontSize: 12.0,color: Colors.red),
                          recognizer: TapGestureRecognizer()
                            ..onTapDown = (value) async {
                              String passwordNumber = await _asyncInputPasswordDialog(context);
                              if (passwordNumber.isEmpty) { return; }

                            }
                        )
                      ])
                    ),
                  ),
                )
              ) : SliverToBoxAdapter(),

              // 거래유형
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    child: SSTextFieldDropDown(
                      labelText: "거래유형",
                      items: IO_TYPE_MAP,
                      prefixIcon: Icon(Icons.article_outlined, color: Colors.white,),
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      onChanged: (value) {
                        _selectedIoTypeCode = getCodeWithMap(value);
                      },
                    ),
                  ),
                ),
              ),

              // 출하창고
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    child: SSTextFieldDropDown(
                      labelText: "출하창고",
                      items: WH_CD_MAP,
                      prefixIcon: Icon(Icons.water_damage, color: Colors.white,),
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      onChanged: (value) {
                        _selectedWhCode = getCodeWithMap(value);
                      },
                    ),
                  ),
                ),
              ),

              // 결제조건
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    child: SSTextFieldDropDown(
                      labelText: "결제조건",
                      items: COLL_TERM_MAP,
                      prefixIcon: Icon(Icons.attach_money, color: Colors.white,),
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      onChanged: (value) {
                        _selectedCollTermCode = getValueWithMap(value);
                      },
                    ),
                  ),
                ),
              ),

              // 품목 리스트
              SliverToBoxAdapter(
                child: SaleOrderProductList(selectedDate: _selectedDate)
              ),

              // 등록 버튼
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  child: Container(
                    child: Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.save),
                        label: widget.keypadIndex == sendMessageButtonIndex ? Text('주문서 등록 & 문자 전송') : Text('주문서 등록'),
                        style: ElevatedButton.styleFrom(
                          //onPrimary: Colors.white,
                          //onSurface: Color(0xFF084172),
                          primary: Color(0xFF084172),
                          side: BorderSide(color: Color(0xFF084172), width: 1),
                          elevation: 62,
                          minimumSize: Size(300, 62),
                          shadowColor: Colors.black87,
                        ),
                        onPressed: () {
                          if(_selectedEmpCode == null || _selectedEmpCode == getCodeWithMap(EMP_CD_MAP.first) ||
                              _selectedIoTypeCode == null || _selectedIoTypeCode == getCodeWithMap(IO_TYPE_MAP.first) ||
                              _selectedWhCode == null || _selectedWhCode == getCodeWithMap(WH_CD_MAP.first) ||
                              _selectedCollTermCode == null || _selectedCollTermCode == getCodeWithMap(COLL_TERM_MAP.first) ||
                              _selectedCustCode == null) {
                            SSToast.show("필수 입력값을 선택하세요.", context, gravity: SSToast.CENTER);
                            return;
                          }
                          if(productInfoNotifier.productInfoList.length == 0) {
                            SSToast.show("등록할 상품이 없습니다.", context, gravity: SSToast.CENTER);
                            return;
                          }
                          if(_selectedCustContact == "" || _selectedCustContact.length < 10) {
                            SSToast.show("문자 보낼 연락처를 확인해 주세요.", context, gravity: SSToast.CENTER);
                            return;
                          }

                          showDialog(context: context, builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: Center(
                                child: Text('주문서 등록',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                                ),
                              ),
                              content: Text('입력하신 주문서를 등록 하시겠습니까?'),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      child: Text('취소'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text('확인'),
                                      onPressed: () {
                                        Navigator.pop(context);

                                        List saleOrderList = [];
                                        for (Product_Info productInfo in productInfoNotifier.productInfoList) {
                                          try {
                                            BulksData data = new BulksData(
                                                CUST: _selectedCustCode,
                                                EMP_CD: _selectedEmpCode,
                                                WH_CD: _selectedWhCode,
                                                COLL_TERM: _selectedCollTermCode,
                                                TIME_DATE: DateFormat("yyyy-MM-dd").format(_selectedDate),
                                                PROD_CD: productInfo.PROD_CD,
                                                QTY: productInfo.QTY.toString(),
                                                PRICE: productInfo.PRICE.toString(),
                                                SUPPLY_AMT: productInfo.SUPPLY_AMT.toString(),
                                                VAT_AMT: productInfo.VAT_AMT.toString(),
                                                ITEM_TIME_DATE: DateFormat("yyyy-MM-dd").format(_selectedDate),
                                                P_REMARKS2: productInfo.P_REMARKS2_1 == null && (productInfo.P_REMARKS2_2 == null || productInfo.P_REMARKS2_2.toString() == "0") ? ""
                                                    : productInfo.P_REMARKS2_1 == null && int.tryParse(productInfo.P_REMARKS2_2) is int ? "${numberWithComma(productInfo.P_REMARKS2_2)}원"
                                                    : productInfo.P_REMARKS2_1 == null ? "${productInfo.P_REMARKS2_2}"
                                                    : productInfo.P_REMARKS2_2 == null || productInfo.P_REMARKS2_2.toString() == "0" || productInfo.P_REMARKS2_2 == "" ? "${productInfo.P_REMARKS2_1}"
                                                    : int.tryParse(productInfo.P_REMARKS2_2) is int ? "${productInfo.P_REMARKS2_1} / ${numberWithComma(productInfo.P_REMARKS2_2)}원"
                                                    : "${productInfo.P_REMARKS2_1} / ${productInfo.P_REMARKS2_2}"
                                            );
                                            saleOrderList.add({"BulkDatas" : data.toMap()});
                                          } catch (ex) {
                                            print("ERROR: $ex");
                                            break;
                                          }
                                        }

                                        if (saleOrderList.isNotEmpty) {
                                          requestEcountERPEnterOrder(saleOrderList);
                                        }

                                        if(widget.keypadIndex == sendMessageButtonIndex) {
                                          requestAllinda([{"phoneNumber" : _selectedCustContact.replaceAll("-", "")}],widget.smsMessage);
                                        }

                                        //test_api();

                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),

              SliverPadding(padding: EdgeInsets.only(top: 40),),
            ],
          ),
        ),
      ),
    );
  }

  String getCodeWithMap(Map<String, String> map) {
    String result = "";
    if (map == null) return result;
    try {
      result = map.keys.first.toString();
    } catch (ex) {
      print("Error: $ex");
    }
    return result;
  }

  String getValueWithMap(Map<String, String> map) {
    String result = "";
    if (map == null) return result;
    try {
      result = map.values.first.toString();
    } catch (ex) {
      print("Error: $ex");
    }
    return result;
  }

  // EcountERP API - 주문서 입력
  Future<void> requestEcountERPEnterOrder(List saleOrderList) async{
    SSProgressIndicator.show(context);

    // var urlString = "http://127.0.0.1:5000/ecounterp_enter_order";
    var urlString = "https://intosharp.pythonanywhere.com/ecounterp_enter_order";
    var body = json.encode({"SaleOrderList" : saleOrderList});

    try {
      final response = await http.post(urlString, body: body, headers: {'content-type':'application/json','Accept' : 'application/json'});
      if(response.statusCode == 412) {
        SSToast.show("ECOUNT ERP 오류입니다. 20초 후 다시 시도해 주세요.", context, gravity: SSToast.CENTER,duration: 3);
      }else if(response.statusCode == 500){
        SSToast.show("ECOUNT ERP API 서비스 오류입니다.", context, gravity: SSToast.CENTER,duration: 3);
      }else{
        Map<String, dynamic> resultJson = json.decode(response.body);
        Map<String, dynamic> resultJsonResultDataData = json.decode(resultJson['result_data'])['Data'];
        if(resultJsonResultDataData['SuccessCnt'] == saleOrderList.length) {
          SSToast.show("주문서 입력 완료", context, gravity: SSToast.CENTER,duration: 3);
          Navigator.pop(context);
        }else {
          SSToast.show("주문서 입력 오류 ECOUNT ERP를 확인해 주세요.", context, gravity: SSToast.CENTER,duration: 3);
        }
      }

      SSProgressIndicator.dismiss();
    } catch(e) {
      print('Error: $e');
      SSProgressIndicator.dismiss();
      SSToast.show("주문서 입력 중 오류가 발생했습니다.", context, gravity: SSToast.CENTER,duration: 3);
    }
    return;
  }

  Future<void> requestAllinda(List<Map> phoneNumMap,String smsMessage) async{
    SSHud.show("Sending...", context);
    var urlString = "https://intosharp.pythonanywhere.com/send_sms";
    var body = json.encode({
      "recipients" : phoneNumMap,
      "contents" : smsMessage
    });

// /*/
    try {
      final response = await http.post(urlString, body: body, headers: {'Content-Type':'application/json'});
      SSHud.dismiss();
      Map<String, dynamic> resultJson = json.decode(response.body);
      if (resultJson['code'] == 200) {
        SSToast.show("문자 전송을 성공 했습니다.", context, duration: SSToast.LENGTH_SHORT, gravity: SSToast.CENTER);
      } else {
        SSToast.show("문자 전송을 실패 했습니다.", context, duration: SSToast.LENGTH_SHORT, gravity: SSToast.CENTER);
      }
    } catch(e) {
      SSHud.dismiss();
      print('Error: $e');
      SSToast.show("문자 전송을 실패 했습니다.", context, duration: SSToast.LENGTH_SHORT, gravity: SSToast.CENTER);
    }
// */
  }

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

// 전화번호 입력 팝업 화면
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
                  title: Text('변경할 연락처를 입력하세요.', style: TextStyle(color: Colors.black),),
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
      controller: TextEditingController()..text = _selectedCustContact,
      autofocus: true,
      obscureText: false,
      focusNode: kIsWeb ? _emptyNode : Platform.isIOS ? _nodeText : null,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      // decoration: new InputDecoration(
      //     labelText: 'password', hintText: ''
      // ),
      onChanged: (value) {
        setState(() {
          _selectedCustContact = value;
        });
      },

      onSubmitted: (value) {
        setState(() {
          _selectedCustContact = value;
        });
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
    if(_selectedCustContact.isEmpty) {
      SSToast.show("연락처를 입력하세요", context);
      return;
    }
    Navigator.of(context).pop(_selectedCustContact);
  }
}

Future<List<SalesStatusData>> request_mysql(String searchWord) async{
  var urlString = "https://intosharp.pythonanywhere.com/current_sealing_vinyl";
  var body = json.encode({"name" : searchWord});
  try{
    final response = await http.post(urlString, body: body,headers: {'content-type':'application/json'});
    Map<String, dynamic> resultJson = json.decode(response.body);
    final SalesStatusResult result = SalesStatusResult.fromMap(resultJson);
    return result.result_array;
  } catch(e) {
    print('Error: $e');
    SalesStatusResult error = SalesStatusResult(isSuccess: false);
    return [];
  }
}

// 숫자 사이에 ,찍기
String numberWithComma(String param){
  num number = int.parse(param);
  return new NumberFormat('#,###').format(number);
}
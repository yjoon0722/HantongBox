import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hantong_cal/ui/pages/root_page.dart';
import 'package:intl/intl.dart';
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:hantong_cal/ui/widgets/SSProgressIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

class SalesStatusSave extends StatefulWidget {

  @override
  _SalesStatusSave createState() {
    return _SalesStatusSave();
  }

}

class _SalesStatusSave extends State<SalesStatusSave> with WidgetsBindingObserver,AutomaticKeepAliveClientMixin {
//  AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  final formatter = new NumberFormat('#,###');

  // 패스워드 키 포커스
  FocusNode _passwordFocusNode;
  String _passwordNumber;

  // 파이어베이스 데이터 가져오기 위한 변수
  Map<String, dynamic> _sales_status;
  String _today_date;
  int _today_day;
  int _today_sum;
  String _yesterday_date;
  int _yesterday_sum;
  String _this_month_date;
  int _this_month_sum;
  String _last_month_date;
  int _last_month_sum;
  DateTime _request_dateTime;
  DateTime _refresh_dateTime;

  Timer _timer;

  bool _isLoadingEcountInquiry = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _passwordFocusNode = FocusNode();
    _passwordNumber = '';

    _sales_status = null;

    _today_date = '';
    _today_day = 0;
    _today_sum = 0;
    _yesterday_date = '';
    _yesterday_sum = 0;
    _this_month_date = '';
    _this_month_sum = 0;
    _last_month_date = '';
    _last_month_sum = 0;
    _request_dateTime = null;
    _refresh_dateTime = null;
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return
      Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.3, 0.7, 1.0],
                    colors: [Color(0xFF084172), Color(0xFF084C82), Color(0xFF084C82), Color(0xFF115999)])
            ),
            child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(padding: EdgeInsets.only(top: statusBarHeight),),
                  SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 55.0),
                        child: GestureDetector(
                          onTap: () {
                            //리플레쉬 버튼 이벤트
                            cancelTimer();
                            // 판매현황 데이터 로딩
                            getFirestoreDataSalesStatus(true);
                            // 타이머 시작
                            Timer(Duration(seconds: 60 * 10), startTimer);
                          },
                          child:
                          Container(
                            color: Colors.black12,
                            child:
                            _sales_status == null ?

                            // 패스워드 버튼
                            RaisedButton(
                              onPressed: () async {
                                // 패스워드 대한 로딩
                                _passwordNumber = '';
                                String password_number = await _asyncInputPasswordDialog(context);
                                if (password_number.isEmpty) { return; }

                                SSProgressIndicator.show(context);
                                var password_json = await getFirestoreData('Password', 'S79sAnKS1wkVGIwqntos');
                                if (password_json == null) {
                                  SSToast.show("패스워드 정보를 가져오는데 실패했습니다.", context);
                                  SSProgressIndicator.dismiss();
                                  return;
                                }

                                String pw = password_json['pw'];
                                if (password_number == pw) {
                                  print('비밀번호 인증 성공!');

                                  // 판매현황 데이터 로딩
                                  getFirestoreDataSalesStatus(false);

                                  // 타이머 시작
                                  Timer(Duration(seconds: 60 * 10), startTimer);

                                } else {
                                  print('비밀번호가 인증 실패!');
                                  SSProgressIndicator.dismiss();
                                  //SSToast.show("패스워드 확인 후 다시 조회해주세요.", context);

                                  await new Future.delayed(Duration(seconds: 1));

                                  SSToast.show("너 누구야 ??? - -", context, duration: 3, gravity: SSToast.CENTER);
                                }
                              },
                              child: const Text('Get ECountERP Data', style: TextStyle(fontSize: 12.0),),
                            )

                                :

                            // ECountERP 판매현황 상황판
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text('현황판', style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 20.0),),
                                      Flexible(child:_isLoadingEcountInquiry ?
                                      Container(
                                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: SizedBox.fromSize(
                                            size: Size(18, 18),
                                            child: CircularProgressIndicator(strokeWidth: 3.0,)
                                        ),
                                      )
                                          :
                                      Container(child:
                                      Text( _refresh_dateTime == null ? '' :
                                      _sfRefreshDateTime(_refresh_dateTime),
                                        style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 10.0), overflow: TextOverflow.ellipsis,),
                                      )
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // 날짜
                                        Text(_sfTodayDate(_today_date), style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0),),
                                        // 금액
                                        Flexible(child:
                                        Container(child:
                                        Text('${formatter.format(_today_sum)}',
                                          style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0), overflow: TextOverflow.ellipsis,),
                                        ))
                                      ],
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // 날짜
                                        Text(_sfYesterdayDate(_yesterday_date), style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0),),
                                        // 금액
                                        Flexible(child:
                                        Container(child:
                                        Text('${formatter.format(_yesterday_sum)}',
                                          style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0), overflow: TextOverflow.ellipsis,),
                                        ))
                                      ],
                                    )
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      // 날짜
                                      Text(_sfThisMonthDate(_this_month_date), style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0),),
                                      // 금액
                                      Flexible(child:
                                      Container(child:
                                      Text('${formatter.format(_this_month_sum)}',
                                        style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0), overflow: TextOverflow.ellipsis,),
                                      ))
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // 날짜
                                        Text(_sfLastMonthDate(_last_month_date), style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0),),
                                        // 금액
                                        Flexible(child:
                                        Container(child:
                                        Text('${formatter.format(_last_month_sum)}',
                                          style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0), overflow: TextOverflow.ellipsis,),
                                        ))
                                      ],
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // 날짜
                                        Text(_sfThisMonthAverage(DateTime.now(), _this_month_sum), style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0),),
                                        // 금액
                                        Flexible(child:
                                        Container(child:
                                        Text('${ DateTime.now().day > 0 ? formatter.format(_this_month_sum/DateTime.now().day) : 0}',
                                          style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0), overflow: TextOverflow.ellipsis,),
                                        ))
                                      ],
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(12, 4, 12, 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text('Data', style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0),),
                                        Flexible(child:
                                        Container(child:
                                        Text(_request_dateTime == null ? '' : _sfRequstDateTime(_request_dateTime),
                                          style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 10.0), overflow: TextOverflow.ellipsis,),
                                        ))
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                ]
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              doStuff();
            });
          },
          child: Icon(Icons.home),
        ),
      );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  // 판매현황 YYYY-MM-DD HH:mm:ss
  String _sfRefreshDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')} ${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}';
    // :${dateTime.second.toString().padLeft(2,'0')}
  }

  // 서버에 데이터가 저장된 시간  YYYY-MM-DD HH-mm
  String _sfRequstDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')} ${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}';
  }

  // 금일판매현황
  String _sfTodayDate(String date) {
    String dateString = '금일';
    if (date == null) return dateString;
    if (date.isEmpty) return dateString;
    return '$dateString(${date.split('/').first}.${date.split('/').last})';
    //return '${date.split('/').first}.${date.split('/').last}';
  }

  // 전일판매현황
  String _sfYesterdayDate(String date) {
    String dateString = '전일';
    if (date == null) return dateString;
    if (date.isEmpty) return dateString;
    return '$dateString(${date.split('/').first}.${date.split('/').last})';
  }

  // 당월판매현황
  String _sfThisMonthDate(String date) {
    String dateString = '당월';
    if (date == null) return dateString;
    if (date.isEmpty) return dateString;
    return '$dateString(${date.split('/').first.substring(2)}/${date.split('/').last})';
    //return '${date.split('/').first.substring(2)}/${date.split('/').last}';
  }

  // 지난달판매현황
  String _sfLastMonthDate(String date) {
    String dateString = '전월';
    if (date == null) return dateString;
    if (date.isEmpty) return dateString;
    return '$dateString(${date.split('/').first.substring(2)}/${date.split('/').last})';
    //return '${date.split('/').first.substring(2)}/${date.split('/').last}';
  }

  // 금월 일 평균 매출
  String _sfThisMonthAverage(DateTime dateTime, int monthSum) {
    String dateString = '평균';
    if (dateTime == null) return dateString;
    if (monthSum == 0) return dateString;
    String year = dateTime.year.toString();
    String month = dateTime.month.toString();
    return '$dateString(${year.substring(2)}/${month.padLeft(2,'0')})';
    //return '${year.substring(2)}/${month.padLeft(2,'0')}';
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  // ECountERP 자동 데이터 로딩 타이머
  startTimer() async {
    cancelTimer();
    const period = const Duration(seconds: 60 * 10);
    _timer = Timer.periodic(period, (timer) {
      getFirestoreDataSalesStatus(true);
    });
  }
  cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  // Firestore 데이터 가져오기
  Future getFirestoreData(String collection, String document) async {
    var docRef = Firestore.instance.collection(collection).document(document);
    return docRef.get().then((doc) {
      if (doc.exists) {
        return doc.data;
      } else {
        print('Error: No such document!');
        return null;
      }
    }).catchError((error) {
      print(error);
      return null;
    });
  }

  // Firestore - 판매현황 데이터 로딩
  Future getFirestoreDataSalesStatus(bool isTimer) async {
    if (isTimer) {
      setState(() { _isLoadingEcountInquiry = true; });
    }

    var sales_status = await getFirestoreData('SalesStatus', 'RjWGIkHgqvec7xgvsnXh');
    print(sales_status);

    if (sales_status == null) {
      if (isTimer) {
        setState(() { _isLoadingEcountInquiry = false; });
      } else {
        SSToast.show("판매현황 정보를 가져오는데 실패했습니다.", context);
        SSProgressIndicator.dismiss();
      }
      return;
    }

    if (isTimer == false) SSProgressIndicator.dismiss();

    setState(() {
      _sales_status = sales_status;

      var todayDate = _sales_status['today_date'];
      if (todayDate != null) {
        _today_date = todayDate;
        _today_day = int.parse(_today_date.split('/').last);
      }
      int todaySum = _sales_status['today_sum'];
      //if (todaySum > 0) _today_sum = todaySum;
      _today_sum = todaySum;

      var yesterdayDate = _sales_status['yesterday_date'];
      if (yesterdayDate != null) _yesterday_date = yesterdayDate;
      int yesterdaySum = _sales_status['yesterday_sum'];
      _yesterday_sum = yesterdaySum;

      var this_month_date = _sales_status['this_month_date'];
      if (this_month_date != null) _this_month_date = this_month_date;
      int this_month_sum = _sales_status['this_month_sum'];
      //if (this_month_sum > 0) _this_month_sum = this_month_sum;
      _this_month_sum = this_month_sum;

      var last_month_date = _sales_status['last_month_date'];
      if (last_month_date != null) _last_month_date = last_month_date;
      int last_month_sum = _sales_status['last_month_sum'];
      //if (last_month_sum > 0) _last_month_sum = last_month_sum;
      _last_month_sum = last_month_sum;

      var timestamp = _sales_status['timestamp'];
      if (timestamp != null)  _request_dateTime = DateTime.parse(timestamp.toDate().toString());

      _refresh_dateTime = DateTime.now();

      _isLoadingEcountInquiry = false;
    });
  }

  // 비밀번호 입력 팝업 화면
  Future<String> _asyncInputPasswordDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('비밀번호를 입력하세요.', style: TextStyle(color: Colors.black),),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: _buildPasswordTextComposer(context)
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
      decoration: new InputDecoration(
          labelText: 'password', hintText: ''
      ),
      onChanged: (value) {
        _passwordNumber = value;
      },
      onSubmitted: (value) {
        _passwordNumber = value;
        _actionPasswordTextFiled_enter(context);
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

  void doStuff() {
    _sales_status = null;
  }
}
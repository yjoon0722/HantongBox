import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hantong_cal/helpers/firebase_helper.dart';
import 'package:hantong_cal/models/db_helper.dart';
import 'package:hantong_cal/ui/pages/root_page.dart';
import 'package:intl/intl.dart';
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:hantong_cal/ui/widgets/SSProgressIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:hantong_cal/main.dart';

class SalesStatus extends StatefulWidget {

  @override
  _SalesStatus createState() {
    return _SalesStatus();
  }

}

class _SalesStatus extends State<SalesStatus> with WidgetsBindingObserver,AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  final formatter = new NumberFormat('#,###');

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

    // 판매현황 데이터 로딩
    getFirestoreDataSalesStatus(false);

    // 타이머 시작
    Timer(Duration(seconds: 60 * 10), startTimer);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if(!kIsWeb && !Platform.isMacOS){
      DBHelper().updateIsOpenSalesStatus0();
    }
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
                                      // Flexible(child:_isLoadingEcountInquiry ?
                                      // Container(
                                      //   padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      //   child: SizedBox.fromSize(
                                      //       size: Size(18, 18),
                                      //       child: CircularProgressIndicator(strokeWidth: 3.0,)
                                      //   ),
                                      // )
                                      //     :
                                      // Container(child:
                                      // Text( _refresh_dateTime == null ? '' :
                                      // _sfRefreshDateTime(_refresh_dateTime),
                                      //   style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 10.0), overflow: TextOverflow.ellipsis,),
                                      // )
                                      // )
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
                                          )
                                        )
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
                                          )
                                        )
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
                                        )
                                      )
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
                                          )
                                        )
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
                                          )
                                        )
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
                                        Text('갱신', style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0),),
                                        Flexible(child:
                                          Container(child:
                                            Text( _refresh_dateTime == null ? '' :
                                             _sfRefreshDateTime(_refresh_dateTime),
                                              style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 10.0), overflow: TextOverflow.ellipsis,),
                                        )
                                        )
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
                                        Text('서버', style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 12.0),),
                                        Flexible(child:
                                          Container(child:
                                            Text(_request_dateTime == null ? '' : _sfRequstDateTime(_request_dateTime),
                                                style: TextStyle(decoration: TextDecoration.none, color: Colors.white, fontSize: 10.0), overflow: TextOverflow.ellipsis,),
                                         )
                                        )
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
          onPressed: () async {
            setState(() {
              Navigator.pop(context);
            });
            if(!kIsWeb && !Platform.isMacOS){
              await DBHelper().updateIsOpenSalesStatus0();
            }
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
    return '$dateString(${date.split('/').last})';
    // return '$dateString(${date.split('/').first}.${date.split('/').last})';
    //return '${date.split('/').first}.${date.split('/').last}';
  }

  // 전일판매현황
  String _sfYesterdayDate(String date) {
    String dateString = '전일';
    if (date == null) return dateString;
    if (date.isEmpty) return dateString;
    return dateString;
    // return '$dateString(${date.split('/').first}.${date.split('/').last})';
  }

  // 당월판매현황
  String _sfThisMonthDate(String date) {
    String dateString = '당월';
    if (date == null) return dateString;
    if (date.isEmpty) return dateString;
    return '$dateString(${date.split('/').first})';
    // return '$dateString(${date.split('/').first.substring(2)}/${date.split('/').last})';
    //return '${date.split('/').first.substring(2)}/${date.split('/').last}';
  }

  // 지난달판매현황
  String _sfLastMonthDate(String date) {
    String dateString = '전월';
    if (date == null) return dateString;
    if (date.isEmpty) return dateString;
    return dateString;
    // return '$dateString(${date.split('/').first.substring(2)}/${date.split('/').last})';
    //return '${date.split('/').first.substring(2)}/${date.split('/').last}';
  }

  // 금월 일 평균 매출
  String _sfThisMonthAverage(DateTime dateTime, int monthSum) {
    String dateString = '평균';
    if (dateTime == null) return dateString;
    if (monthSum == 0) return dateString;
    String year = dateTime.year.toString();
    String month = dateTime.month.toString();
    return dateString;
    // return '$dateString(${year.substring(2)}/${month.padLeft(2,'0')})';
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
    // var docRef = Firestore.instance.collection(collection).document(document);
    // return docRef.get().then((doc) {
    //   if (doc.exists) {
    //     return doc.data;
    //   } else {
    //     print('Error: No such document!');
    //     return null;
    //   }
    // }).catchError((error) {
    //   print(error);
    //   return null;
    // });
    var docRef = FirebaseFirestore.instance.collection(collection).doc(document);
    return docRef.get().then((DocumentSnapshot documentSnapshot)  {
      print("documentSnapshot.data(): ${documentSnapshot.data()}");
      return documentSnapshot.data();
    });
  }

  // Firestore - 판매현황 데이터 로딩
  Future getFirestoreDataSalesStatus(bool isTimer) async {
    if (isTimer) {
      setState(() { _isLoadingEcountInquiry = true; });
    }
    print('판매현황 데이터로딩');
    var sales_status = await getFirestoreData('SalesStatus', 'GIfe230j8lFmLatxU2F0');
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

      // var todayDate = _sales_status['today_date'];
      var todayDate = DateFormat.Md().format(DateTime.now());
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

      // var this_month_date = _sales_status['this_month_date'];
      var this_month_date = DateFormat.yMd().format(DateTime.now());
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
}
import 'dart:convert';
import 'dart:ui';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hantong_cal/models/analytics.dart';
import 'package:hantong_cal/models/keypad.dart';
import 'package:hantong_cal/ui/widgets/SNS_widget.dart';
import 'package:hantong_cal/ui/widgets/SSProgressIndicator.dart';
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:hantong_cal/ui/widgets/sales_status_widget.dart';
import 'package:hantong_cal/util/common_util.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:hantong_cal/models/Result.dart';
import 'dart:core';
import 'dart:io' show Platform;
import 'package:hantong_cal/ui/widgets/tracker_delivery_widget.dart';
import 'package:hantong_cal/ui/pages/root_2nd_page.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class Root0thPage extends StatefulWidget {
  String _textMessage;

  Root0thPage(this._textMessage);

  void reloadTextMessage(String textMessage) {
    _textMessage = textMessage;
  }

  @override
  _Root0thPageState createState() {
    return _Root0thPageState();
  }
}

class _Root0thPageState extends State<Root0thPage> with WidgetsBindingObserver,AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  final formatter = new NumberFormat('#,###');
  TextEditingController _controller;

  String _start_latitudelongitude = '경기도 평택시 진위면 가곡리 126-1';
  String _goal_latitudelongitude;
  int _goal_distance;
  int _goal_price;
  String _start;
  String _goal;

  FirebaseAnalytics analytics = FirebaseAnalytics();

  final double keypad_crossAxisSpacing = 10.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = new TextEditingController(text: _start_latitudelongitude);
    _goal_latitudelongitude = '';
    _goal_distance = 0;
    _goal_price = 0;
    _start = '127.0822877,37.1086106';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
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
          // 간격
          SliverPadding(padding: EdgeInsets.only(top: statusBarHeight),),

          // 복사할 문자열
          SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 60.0),
                //const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
                child: Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color.fromRGBO(255, 255, 255, 0.85)
                  ),
                  child: Text(widget._textMessage,
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.left,
                  ),
                ),
              )
          ),

          // 출발지/도착지 입력
          SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 60.0),
                //const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
                child: Container(
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
                                CommonUtil.showToast(context, geocodeResult.result_data);
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
                                  CommonUtil.showToast(context, directionResult.result_data);
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
                              CommonUtil.showToast(context, geocodeResult.result_data);
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

                            // 이동 거리
                            if(_start_latitudelongitude != '') {
                              Result directionResult = await request_direction(_start,_goal);
                              if (directionResult.isSuccess == false) {
                                CommonUtil.showToast(context, directionResult.result_data);
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
                        SizedBox(height: 10),
                        Text('출발지: $_start_latitudelongitude'),
                        Text('도착지: $_goal_latitudelongitude'),
                        Text('이동 거리: ${_goal_distance == 0 ? '' : '약 ${formatter.format(_goal_distance/1000)}km'}'),
                        Text('예상 요금: ${_goal_price == 0 ? '' : '${formatter.format(_goal_price)}원'}'),

                      ]
                  )
                ),
              )
          ),

          // 송장번호 검색
          TrackerDeliveryWidget(),

          // 전화번호로 업체명 검색
          SalesStatusWidget(),

          SNSWidget(),
        ],
      ),
    );
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

Future updateFunctionUsed() async{
  var docRef = Firestore.instance.collection('SalesStatus').document('0gcWuQYkxzPrOHeREd2i');
  var function_used_json = await getFirestoreData('SalesStatus', '0gcWuQYkxzPrOHeREd2i');
  int function_used = function_used_json['function_used'] + 1;
  await docRef.updateData({'function_used' : function_used});
}


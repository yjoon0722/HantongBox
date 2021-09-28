import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hantong_cal/models/analytics.dart';
import 'package:hantong_cal/models/sales_status_data.dart';
import 'package:hantong_cal/ui/widgets/SSProgressIndicator.dart';
import 'package:http/http.dart' as http;

class SalesStatusWidget extends StatefulWidget {
  @override
  _SalesStatusWidgetState createState() => _SalesStatusWidgetState();
}

class _SalesStatusWidgetState extends State<SalesStatusWidget> {

  TextEditingController _vynil_controller;
  Map<String, List<SalesStatusData>> _salesStatusData;

  @override
  void initState() {
    super.initState();
    _vynil_controller = new TextEditingController();
    _salesStatusData = null;
  }

  @override
  void dispose() {
    _vynil_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 28.0, 16.0, 28.0),
        child: Container(
          margin: const EdgeInsets.all(0.0),
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
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
                    labelText: '업체명 또는 전화번호',
                  ),
                  controller: _vynil_controller,
                  onSubmitted: (value) async{

                    // SSONG TEST
                    //value = "사람찬(휴먼푸드)";
                    //value = "푸드";
                    //

                    if(value.isEmpty) { return; }

                    SSProgressIndicator.show(context);

                    analytics_test('sales_status_count');

                    _salesStatusData = null;

                    SalesStatusResult mysqlResult = await request_mysql(value);

                    if(mysqlResult.result_count == 0) {
                      setState(() {
                        _salesStatusData = null;
                      });
                      SSProgressIndicator.dismiss();
                      return;
                    }
                    setState(() {
                      _salesStatusData = groupBy(mysqlResult.result_array, (obj) => obj.account_name);
                    });
                    SSProgressIndicator.dismiss();
                  },
                ),
              ),
              _salesStatusData == null ? Container() : _buildSalesStatus(context),
            ],
          ),
        ),
      ),
    );
  }

  // 거래처 판매현황
  _buildSalesStatus(BuildContext context) {
    if (_salesStatusData == null) { return Container(); }
    print(_salesStatusData.toString());

    List<Widget> rows = [];

    _salesStatusData.forEach((String key, List<SalesStatusData> value) {
      // 이름
      rows.add(Text(key.toString().trim(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),textAlign: TextAlign.left,));
      print('value: $value');
      if (value.length > 0) {
        // 핸드폰 번호
        String phone = null;
        if (value.first.account_contact_information1 != null) {
          phone = value.first.account_contact_information1.toString();
        }
        if (value.first.account_contact_information2 != null && value.first.account_contact_information2.length > 0) {
          phone += (phone == null) ? value.first.account_contact_information2 : ", ${value.first.account_contact_information2}";
        }
        if (phone != null) {
          rows.add(Text(phone, style: TextStyle(fontSize: 14),textAlign: TextAlign.left,));
        }
        // 판매 정보
        for (SalesStatusData data in value) {
          if (data.goods != null && data.sales_date != null) {
            rows.add(Text('   ${data.goods} : ${data.sales_date}',
              style: TextStyle(fontSize: 14), textAlign: TextAlign.left,));
          }
        }
        rows.add(SizedBox(height: 12,));
      } else {
        rows.add(Text('   판매내역이 없습니다', style: TextStyle(fontSize: 14),textAlign: TextAlign.left,));
      }
    });
    return Container (
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows
      ),
    );
  }
}

Future<SalesStatusResult> request_mysql(String searchWord) async{
  var urlString = "https://intosharp.pythonanywhere.com/sales_status";
  var body = json.encode({"name" : searchWord});
  try{
    final response = await http.post(urlString, body: body,headers: {'content-type':'application/json'});
    Map<String, dynamic> resultJson = json.decode(response.body);
    final SalesStatusResult result = SalesStatusResult.fromMap(resultJson);
    return result;
  } catch(e) {
    print('Error: $e');
    SalesStatusResult error = SalesStatusResult(isSuccess: false);
    return error;
  }
}
import 'package:flutter/material.dart';
import 'package:hantong_cal/models/analytics.dart';
import 'package:hantong_cal/models/tracker_delivery_data.dart';
import 'package:hantong_cal/ui/widgets/SSProgressIndicator.dart';
import 'package:hantong_cal/util/common_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

List<String> _carriernames = ['한진택배','CJ 대한통운','로젠택배','경동택배'];

class TrackerDeliveryWidget extends StatefulWidget {
  @override
  _TrackerDeliveryWidgetState createState() => _TrackerDeliveryWidgetState();
}

class _TrackerDeliveryWidgetState extends State<TrackerDeliveryWidget> {

  String _dropdownValue;
  TrackerDeliveryData _trackerDeliveryData;

  @override
  void initState() {
    super.initState();

    _dropdownValue = _carriernames.first;
    _trackerDeliveryData = null;
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
                //borderRadius: BorderRadius.circular(10.0),
                color: Color.fromRGBO(255, 255, 255, 0.85)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,25),
                    child: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.black45)
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _dropdownValue,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _dropdownValue = newValue;
                                  });
                                },
                                items: _carriernames.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value));
                                }).toList(),
                              ),
                            )
                        ),
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '송장번호',
                            ),
                            onSubmitted: (value) async {
                              if (value.isEmpty) { return; }
                              SSProgressIndicator.show(context);

                              TrackerDeliveryData trackerDeliveryData = await request_deliveryTracks(_dropdownValue, value);
                              setState(() {
                                _trackerDeliveryData = trackerDeliveryData;
                              });
                              SSProgressIndicator.dismiss();
                            },
                          ),
                        ),
                      ],
                    )
                ),
                _trackerDeliveryData == null ? Container() : _buildResultTrackerDelivery(context),
              ],
            ),
          ),
        )
    );
  }

  _buildResultTrackerDelivery(BuildContext context) {
    if (_trackerDeliveryData == null) { return Container(); }
    if (_trackerDeliveryData.message != null) { return Text(_trackerDeliveryData.message); }

    List<Widget> rows = [];
    rows.add(Text('보내시는 분: ${_trackerDeliveryData.from.name}'));
    rows.add(Text('받으시는 분: ${_trackerDeliveryData.to.name}'));
    rows.add(SizedBox(height: 12,));
    for (var progresse in _trackerDeliveryData.progresses) {
      DateTime dateTime = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(progresse.time);
      String dateString = DateFormat("MM-dd HH:mm").format(dateTime).toString();
      rows.add(
        Text('${progresse.status.text} ${dateString}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
      );
      rows.add(Text('${progresse.description}'));
      rows.add(SizedBox(height: 12,));
    }

    rows.add(
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Center(
              child: new InkWell(
                  child: new Text('Open Detail',),
                  onTap: () => CommonUtil.launchURL(_trackerDeliveryData.link)
              )
          ),
        )
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}

// 택배조회 API
Future<TrackerDeliveryData> request_deliveryTracks(String dropdownValue, String trackId) async {
  String carrierId = null;

  /*/ SSONG TEST
  dropdownValue = 'CJ 대한통운';
  trackId = '@ 6367361 546-81 @';
  // */

  trackId = trackId.replaceAll('_', '').replaceAll('-', '').replaceAll(' ', '');
  String link = '';
  if(dropdownValue == '한진택배') {
    carrierId = 'kr.hanjin'; // 418978253352
    link = 'http://www.hanjinexpress.hanjin.net/customer/hddcw18_ms.tracking?w_num=$trackId';
  } else if(dropdownValue == 'CJ 대한통운') {
    carrierId = 'kr.cjlogistics'; // 636736154681
    link = 'http://nplus.doortodoor.co.kr/web/detail.jsp?slipno=$trackId';
  } else if(dropdownValue == '로젠택배') {
    carrierId = 'kr.logen'; // 98878246751
    link = 'https://www.ilogen.com/m/personal/trace/$trackId';
  } else if(dropdownValue == '경동택배') {
    carrierId = 'kr.kdexp'; // 313309 53 00507
    link = 'https://kdexp.com/basicNewDelivery.kd?barcode=$trackId';
  }

  if (carrierId == null) {
    return TrackerDeliveryData(message: '지원하지 않는 택배사입니다.');
  }

  var urlString = 'https://apis.tracker.delivery/carriers/$carrierId/tracks/$trackId';
  try {
    final response = await http.get(urlString);
    Map<String, dynamic> resultJson = json.decode(response.body);
    if (resultJson['message'] != null) {
      return TrackerDeliveryData(message: resultJson['message']);
    }
    TrackerDeliveryData trackerDeliveryData = TrackerDeliveryData.fromMap(resultJson);
    trackerDeliveryData.link = link;
    return trackerDeliveryData;
  } catch (e) {
    print('Error: request_deliveryTracks \n $e');
    return null;
  }
}

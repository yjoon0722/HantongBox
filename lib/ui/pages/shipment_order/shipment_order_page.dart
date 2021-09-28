import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hantong_cal/models/product.dart';
import 'package:hantong_cal/models/shipment_order_data.dart';
import 'package:hantong_cal/ui/widgets/SSHud.dart';
import 'package:hantong_cal/ui/widgets/SSProgressIndicator.dart';
import 'package:universal_html/html.dart' as HTML;
// import 'dart:html' as HTML;
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:hantong_cal/util/common_util.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class ShipmentOrderPage extends StatefulWidget {
  const ShipmentOrderPage({Key key}) : super(key: key);

  @override
  _ShipmentOrderPageState createState() => _ShipmentOrderPageState();
}

class _ShipmentOrderPageState extends State<ShipmentOrderPage> with WidgetsBindingObserver {

  List<ShipmentOrderData> _items = [];
  var todayDate;
  String cellColor = "#FFFF00";
  String juntech = "준테크";
  String goryeoHanjin = "고려(한진)";
  String goryeoGunyoung = "고려(건영)";

  @override
  void initState() {
    super.initState();
    todayDate = DateFormat('yyyyMMdd').format(DateTime.now());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('출하지시서'),
        bottom: PreferredSize(
          child: Container(
              alignment: Alignment.center,
              color: Color(0xFF084172),
              constraints: BoxConstraints.expand(height: 60),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        label: Text(juntech, style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.save, color: Colors.white,),
                        onPressed: () {
                          checkItems(_items);
                          createShipmentOrderJuntech(_items);
                        },
                      ),
                      TextButton.icon(
                        label: Text(goryeoHanjin, style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.save, color: Colors.white,),
                        onPressed: () {
                          checkItems(_items);
                          createShipmentOrderGoryeoHanjin(_items);
                        },
                      ),
                      TextButton.icon(
                        label: Text(goryeoGunyoung, style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.save, color: Colors.white,),
                        onPressed: () {
                          checkItems(_items);
                          createShipmentOrderGoryeoGunyoung(_items);
                        },
                      ),
                      TextButton.icon(
                        label: Text("전체", style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.save, color: Colors.white,),
                        onPressed: () {
                          checkItems(_items);
                          createShipmentOrderJuntech(_items);
                          createShipmentOrderGoryeoHanjin(_items);
                          createShipmentOrderGoryeoGunyoung(_items);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        label: Text(juntech, style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.outgoing_mail, color: Colors.white,),
                        onPressed: () {
                          SSToast.show("제작중입니다.",
                              context, duration: 5, gravity: SSToast.CENTER);
                          return;
                          checkItems(_items);
                          sendShipmentOrderData(_items,juntech);
                        },
                      ),
                      TextButton.icon(
                        label: Text(goryeoHanjin, style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.outgoing_mail, color: Colors.white,),
                        onPressed: () {
                          SSToast.show("제작중입니다.",
                              context, duration: 5, gravity: SSToast.CENTER);
                          return;
                          checkItems(_items);
                          sendShipmentOrderData(_items,goryeoHanjin);
                        },
                      ),
                      TextButton.icon(
                        label: Text(goryeoGunyoung, style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.outgoing_mail, color: Colors.white,),
                        onPressed: () {
                          SSToast.show("제작중입니다.",
                              context, duration: 5, gravity: SSToast.CENTER);
                          return;
                          checkItems(_items);
                          sendShipmentOrderData(_items,goryeoGunyoung);
                        },
                      ),
                      TextButton.icon(
                        label: Text("전체", style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.outgoing_mail, color: Colors.white,),
                        onPressed: () {
                          SSToast.show("제작중입니다.",
                              context, duration: 5, gravity: SSToast.CENTER);
                          return;
                          checkItems(_items);
                          sendShipmentOrderData(_items,"전체");
                        },
                      ),
                    ],
                  ),
                ],
              )
          ),
          preferredSize: Size(60, 60),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            tooltip: "엑셀 파일 업로드",
            onPressed: () {

              // 파일 로딩
              HTML.InputElement uploadInput = HTML.FileUploadInputElement();
              uploadInput.multiple = false;
              uploadInput.draggable = true;
              uploadInput.click();
              uploadInput.onChange.listen((event) {
                final files = uploadInput.files;
                final file = files[0];
                final reader = new HTML.FileReader();
                reader.onAbort.listen((abort) {
                  print("### Error: startWebFilePicker - onAbort");
                });
                reader.onError.listen((error) {
                  print("### Error: startWebFilePicker - onError: $error");
                });
                reader.onLoadEnd.listen((event) async {
                  // 파일 체크
                  var fileName = file.name;
                  if (checkFileName(fileName) == false) {
                    SSToast.show("파일 포맷이 다릅니다. 확인 후 다시 시도해주세요.\n$fileName",
                        context, duration: 5, gravity: SSToast.CENTER);
                    return;
                  }

                  startDataUpload(fileName, reader.result.toString());

                });
                reader.readAsDataUrl(file);
              });
            },
          ),
        ],
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: buildDataTable(context),
          ),
        ),
      ),
    );
  }

  Widget buildDataTable(BuildContext context) {
    var colums = ['주문번호','품목명','주문상품수량','수취인이름','수취인전화','수취인핸드폰','우편번호','주소','메모'];
    if (CommonUtil.isFull(context)) {
      colums = ['주문번호','품목명','주문상품수량','수취인이름','수취인전화','수취인핸드폰','우편번호','주소','메모'];
    } else if (CommonUtil.isHalf(context)) {
      colums = ['품목명','주문상품수량','수취인이름','수취인핸드폰','주소','메모'];
    } else {
      colums = ['품목명','수취인이름','메모'];
    }

    return DataTable(
      horizontalMargin: 0, // default : 24.0
      columnSpacing: 0, // default : 56.0
      showCheckboxColumn: true,
      columns: getColumns(colums),
      rows: getRows(_items),
      onSelectAll: (bool isSelected) {
        for (ShipmentOrderData data in _items) {
          data.isCheck = isSelected;
        }
        setState(() {});
      },
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        label: Expanded(
          child: Text(column,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        numeric: false,
      );
    }).toList();
  }

  List<DataRow> getRows(List<ShipmentOrderData> rows) {
    if (CommonUtil.isFull(context)) {
      return rows.mapIndexed((int index, ShipmentOrderData data) {
        return DataRow(
          selected: data.isCheck,
          onSelectChanged: (val) {
            setState(() {
              data.isCheck = !data.isCheck;
            });
          },
          cells: <DataCell>[
            DataCell(getCell(data.doc_no, Colors.white)),
            DataCell(getCell(data.prod_des, Colors.white)),
            DataCell(getCell(data.doc_qty, Colors.white)),
            DataCell(getCell(data.cust_name, Colors.white)),
            DataCell(getCell(data.cust_telephone, Colors.white)),
            DataCell(getCell(data.cust_cellphone, Colors.white)),
            DataCell(getCell(data.cust_zip, Colors.white)),
            DataCell(getTextAlignCell(data.cust_address, Colors.white, textAlign: TextAlign.left)),
            DataCell(getCell(data.p_remarks2, Colors.white))
          ],
        );
      }).toList();
    } else if (CommonUtil.isHalf(context)) {
      return rows.mapIndexed((int index, ShipmentOrderData data) {
        return DataRow(
          selected: data.isCheck,
          onSelectChanged: (val) {
            setState(() {
              data.isCheck = !data.isCheck;
            });
          },
          cells: <DataCell>[
            DataCell(getCell(data.prod_des, Colors.white)),
            DataCell(getCell(data.doc_qty, Colors.white)),
            DataCell(getCell(data.cust_name, Colors.white)),
            DataCell(getCell(data.cust_cellphone, Colors.white)),
            DataCell(getTextAlignCell(data.cust_address, Colors.white, textAlign: TextAlign.left)),
            DataCell(getCell(data.p_remarks2, Colors.white))
          ],
        );
      }).toList();
    } else {
      return rows.mapIndexed((int index, ShipmentOrderData data) {
        return DataRow(
          selected: data.isCheck,
          onSelectChanged: (val) {
            setState(() {
              data.isCheck = !data.isCheck;
            });
          },
          cells: <DataCell>[
            DataCell(getCell(data.prod_des, Colors.white)),
            // DataCell(getCell(data.doc_qty, Colors.white)),
            DataCell(getCell(data.cust_name, Colors.white)),
            DataCell(getCell(data.p_remarks2, Colors.white))
          ],
        );
      }).toList();
    }
  }

  Widget getCell(String text, Color color, {TextAlign textAlign = TextAlign.center}) {
    return Center(
      child: Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: 12.0,),
      ),
    );
  }

  Widget getTextAlignCell(String text, Color color, {TextAlign textAlign = TextAlign.center}) {
    return Text(text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: 12.0,),
    );
  }

  // 파일 체크
  bool checkFileName(String fileName) {
    bool result = false;
    try {
      if (p.extension(fileName) == ".xlsx") {
        result = true;
      }
    } catch (ex) {
    }
    return result;
  }

  // 파일 업로드
  void startDataUpload(String fileName, String result) {
    SSHud.show("Loading...", context);
    Future.delayed(Duration(seconds: 1)).then((value) {
      startDataParsing(fileName, result);
      SSHud.dismiss();
    });
  }

  // 엑셀 파일 로딩
  Future<bool> startDataParsing(String fileName, String data) async {
    // 1. 파일 로딩
    List<int> selectedFile = Base64Decoder().convert(data.split(',').last);
    if (selectedFile == null || selectedFile.isEmpty) {
      print("### Error: startWebFilePicker - selectedFile is null or empty");
      return false;
    }

    // 2. 파일 파싱
    List<ShipmentOrderData> items = await getLoadingExcelFile(selectedFile, fileName);
    if (items == null || items.isEmpty) {
      print("### Error: startWebFilePicker - items is null or empty");
      return false;
    }

    setState(() {
      _items = items;
    });

    return true;
  }

  // 로딩된 데이터 파싱
  Future<List<ShipmentOrderData>> getLoadingExcelFile(List<int> selectedFile, String fileName) async {
    List<ShipmentOrderData> shipmentOrderDataList = [];
    if (fileName.isEmpty) {
      print("### Error: loadingExcelFile - fileName is null");
      return shipmentOrderDataList;
    }

    if (selectedFile == null || selectedFile.isEmpty) {
      print("### Error: loadingExcelFile - selectedFile is null or empty");
      return shipmentOrderDataList;
    }

    var excel = Excel.decodeBytes(selectedFile);
    Pattern pattern = r'^[0-9]{4}/[0-9]{2}/[0-9]{2} -[0-9]{0,100}$';
    RegExp regex = RegExp(pattern);
    for (var sheetName in excel.tables.keys) {
      for (var row in excel.tables[sheetName].rows) {
        try {
          String docNo = getToString(row, 0);
          if (regex.hasMatch(docNo) == false) continue;
          ShipmentOrderData data = ShipmentOrderData();
          data.doc_no = docNo;
          data.prod_des = getToString(row, 1);
          data.doc_qty = getToString(row, 2);
          data.doc_name = getToString(row, 3);
          data.doc_telephone = getToString(row, 4);
          data.doc_cellphone = getToString(row, 5);
          data.cust_name = getToString(row, 6);
          data.cust_telephone = getToString(row, 7);
          data.cust_cellphone = getToString(row, 8);
          data.cust_zip = getToString(row, 9);
          data.cust_address = getToString(row, 10);
          data.track_id = getToString(row, 11);
          data.track_memo = getToString(row, 12);
          data.p_remarks2 = getToString(row, 13);
          data.isCheck = true;
          shipmentOrderDataList.add(data);
        } catch (ex) {
          print("### Error: " + ex);
          break;
        }
      }
    }
    return shipmentOrderDataList;
  }

  String getToString(List<Data> dataList, int colIndex) {
    String result = "";
    try {
      Data data = dataList[colIndex];
      result = data.value.toString();
      print(result);
    } catch (ex) {
    }
    return result;
  }

  Excel createShipmentOrderBase() {
    var excel = new Excel.createExcel();
    excel.rename('Sheet1','송장');
    Sheet sheetObject = excel['송장'];
    List formList = ['주문번호','상품명(옵션포함)','주문상품수량','주문자이름','주문자전화','주문자핸드폰','수취인이름','수취인전화','수취인핸드폰','신)수취인우편번호','수취인주소','송장번호','배송메시지'];
    sheetObject.updateCell(CellIndex.indexByString('A1'), formList[0]);
    sheetObject.updateCell(CellIndex.indexByString('B1'), formList[1]);
    sheetObject.updateCell(CellIndex.indexByString('C1'), formList[2]);
    sheetObject.updateCell(CellIndex.indexByString('D1'), formList[3]);
    sheetObject.updateCell(CellIndex.indexByString('E1'), formList[4]);
    sheetObject.updateCell(CellIndex.indexByString('F1'), formList[5]);
    sheetObject.updateCell(CellIndex.indexByString('G1'), formList[6]);
    sheetObject.updateCell(CellIndex.indexByString('H1'), formList[7]);
    sheetObject.updateCell(CellIndex.indexByString('I1'), formList[8]);
    sheetObject.updateCell(CellIndex.indexByString('J1'), formList[9]);
    sheetObject.updateCell(CellIndex.indexByString('K1'), formList[10]);
    sheetObject.updateCell(CellIndex.indexByString('L1'), formList[11]);
    sheetObject.updateCell(CellIndex.indexByString('M1'), formList[12]);

    return excel;
  }

  void createShipmentOrderJuntech(List<ShipmentOrderData> _items) {
    var excel = createShipmentOrderBase();
    Sheet sheetObject = excel['송장'];

    var count = 2;
    for (ShipmentOrderData item in _items){
      String trackMemo = setTrackMemo(item);

      if(item.isCheck && item.p_remarks2.contains(juntech)) {
        setSheetObject(sheetObject,count,item,trackMemo);
        count++;
      }
    }

    if(kIsWeb && _items.isNotEmpty){
      excel.save(fileName: "$todayDate준테크발주서.xlsx");
    }
  }

  void createShipmentOrderGoryeoHanjin(List<ShipmentOrderData> _items) {
    var excel = createShipmentOrderBase();
    Sheet sheetObject = excel['송장'];


    var count = 2;
    for (ShipmentOrderData item in _items){
      String trackMemo = setTrackMemo(item);
      if(item.isCheck && item.p_remarks2.contains('고려')) {
        if(int.parse(item.doc_qty) == 1){
          setSheetObject(sheetObject, count, item, trackMemo);
          count++;
        }else{
          for(int i = int.parse(item.doc_qty); i >= 1; i-- ){
            setSheetObjectQtyOne(sheetObject, count, item, trackMemo);
            count++;
          }
        }
      }
    }

    if(kIsWeb && _items.isNotEmpty){
      excel.save(fileName: "$todayDate고려포장발주서.xlsx");
    }
  }

  void createShipmentOrderGoryeoGunyoung(List<ShipmentOrderData> _items) {
    var excel = createShipmentOrderBase();
    Sheet sheetObject = excel['송장'];

    var count = 2;
    for (ShipmentOrderData item in _items){
      String trackMemo = setTrackMemo(item);
      if(item.isCheck && item.p_remarks2.contains('건영')) {
        if(int.parse(item.doc_qty) == 1){
          setSheetObject(sheetObject, count, item, trackMemo);
          count++;
        }else{
          for(int i = int.parse(item.doc_qty); i >= 1; i-- ){
            setSheetObjectQtyOne(sheetObject, count, item, trackMemo);
            count++;
          }
        }
      }
    }

    if(kIsWeb && _items.isNotEmpty){
      excel.save(fileName: "$todayDate고려포장발주서(건영택배).xlsx");
    }
  }

  void checkItems(List<ShipmentOrderData> _items) {
    if(_items.isEmpty){
      SSToast.show("먼저 파일을 업로드 해주세요.", context, duration: 5, gravity: SSToast.CENTER);
      return;
    }
  }

  String setTrackMemo(ShipmentOrderData item) {
    String trackMemo = "";
    String p_remarks2 = item.p_remarks2.replaceAll(" ", "");

    if(p_remarks2.contains("직접수령")){
      trackMemo = "직접수령";
    }else if(p_remarks2.contains("용달신용")){
      trackMemo = "용달신용";
    }else if(p_remarks2.contains("용달착불")){
      trackMemo = "용달착불";
    }else if(p_remarks2.contains("정기화물착불")){
      trackMemo = "정기화물착불";
    }else if(p_remarks2.contains("정기화물선불")){
      trackMemo = "정기화물선불";
    }

    return trackMemo;
  }

  void setSheetObject(Sheet sheetObject,int count,ShipmentOrderData item,String trackMemo){

    if(trackMemo != "") {
      sheetObject.updateCell(CellIndex.indexByString('A$count'), '${item.doc_no}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('B$count'), '${item.prod_des}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('C$count'), int.tryParse(item.doc_qty),cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('D$count'), '${item.doc_name}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('E$count'), '${item.doc_telephone}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('F$count'), '${item.doc_cellphone}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('G$count'), '${item.cust_name}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('H$count'), '${item.cust_telephone}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('I$count'), '${item.cust_cellphone}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('J$count'), '${item.cust_zip}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('K$count'), '${item.cust_address}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('L$count'), '${item.track_id}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('M$count'), trackMemo,cellStyle: CellStyle(backgroundColorHex: cellColor));
    }else {
      sheetObject.updateCell(CellIndex.indexByString('A$count'), '${item.doc_no}');
      sheetObject.updateCell(CellIndex.indexByString('B$count'), '${item.prod_des}');
      sheetObject.updateCell(CellIndex.indexByString('C$count'), int.tryParse(item.doc_qty));
      sheetObject.updateCell(CellIndex.indexByString('D$count'), '${item.doc_name}');
      sheetObject.updateCell(CellIndex.indexByString('E$count'), '${item.doc_telephone}');
      sheetObject.updateCell(CellIndex.indexByString('F$count'), '${item.doc_cellphone}');
      sheetObject.updateCell(CellIndex.indexByString('G$count'), '${item.cust_name}');
      sheetObject.updateCell(CellIndex.indexByString('H$count'), '${item.cust_telephone}');
      sheetObject.updateCell(CellIndex.indexByString('I$count'), '${item.cust_cellphone}');
      sheetObject.updateCell(CellIndex.indexByString('J$count'), '${item.cust_zip}');
      sheetObject.updateCell(CellIndex.indexByString('K$count'), '${item.cust_address}');
      sheetObject.updateCell(CellIndex.indexByString('L$count'), '${item.track_id}');
      sheetObject.updateCell(CellIndex.indexByString('M$count'), trackMemo);
    }
  }

  void setSheetObjectQtyOne(Sheet sheetObject,int count,ShipmentOrderData item,String trackMemo){

    if(trackMemo != "") {
      sheetObject.updateCell(CellIndex.indexByString('A$count'), '${item.doc_no}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('B$count'), '${item.prod_des}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('C$count'), 1,cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('D$count'), '${item.doc_name}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('E$count'), '${item.doc_telephone}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('F$count'), '${item.doc_cellphone}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('G$count'), '${item.cust_name}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('H$count'), '${item.cust_telephone}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('I$count'), '${item.cust_cellphone}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('J$count'), '${item.cust_zip}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('K$count'), '${item.cust_address}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('L$count'), '${item.track_id}',cellStyle: CellStyle(backgroundColorHex: cellColor));
      sheetObject.updateCell(CellIndex.indexByString('M$count'), trackMemo,cellStyle: CellStyle(backgroundColorHex: cellColor));
    }else {
      sheetObject.updateCell(CellIndex.indexByString('A$count'), '${item.doc_no}');
      sheetObject.updateCell(CellIndex.indexByString('B$count'), '${item.prod_des}');
      sheetObject.updateCell(CellIndex.indexByString('C$count'), 1);
      sheetObject.updateCell(CellIndex.indexByString('D$count'), '${item.doc_name}');
      sheetObject.updateCell(CellIndex.indexByString('E$count'), '${item.doc_telephone}');
      sheetObject.updateCell(CellIndex.indexByString('F$count'), '${item.doc_cellphone}');
      sheetObject.updateCell(CellIndex.indexByString('G$count'), '${item.cust_name}');
      sheetObject.updateCell(CellIndex.indexByString('H$count'), '${item.cust_telephone}');
      sheetObject.updateCell(CellIndex.indexByString('I$count'), '${item.cust_cellphone}');
      sheetObject.updateCell(CellIndex.indexByString('J$count'), '${item.cust_zip}');
      sheetObject.updateCell(CellIndex.indexByString('K$count'), '${item.cust_address}');
      sheetObject.updateCell(CellIndex.indexByString('L$count'), '${item.track_id}');
      sheetObject.updateCell(CellIndex.indexByString('M$count'), trackMemo);
    }
  }

  Future<void> sendShipmentOrderData(List<ShipmentOrderData> _items,String warehouse) async{
    SSProgressIndicator.show(context);

    List itemList = [];
    for (var item in _items) {
      try{
        itemList.add({"itemData" : item.toMap()});
      }catch(e){
        print("exception : $e");
      }
    }

    // var urlString = "http://127.0.0.1:5000/send_shipment_order_data";
    var urlString = "https://intosharp.pythonanywhere.com/send_shipment_order_data";
    var body = json.encode({"item" : itemList,"warehouse" : warehouse});
    try {
      final response = await http.post(urlString, body: body, headers: {'content-type':'application/json','Accept' : 'application/json'});
      if(response.body == "SUCCESS") {
        SSToast.show("메일 발송 완료", context, gravity: SSToast.CENTER,duration: 3);
      }else {
        SSToast.show("메일 발송에 실패했습니다. 서버를 확인해주세요", context, gravity: SSToast.CENTER,duration: 3);
      }
      print(response.body);
      SSProgressIndicator.dismiss();
    }catch(e){
      SSToast.show("한통박스 에러. 개발자에게 문의해주세요.", context, gravity: SSToast.CENTER,duration: 3);
      print('Error: $e');
      SSProgressIndicator.dismiss();
    }
  }

}
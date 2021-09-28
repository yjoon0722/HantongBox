import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hantong_cal/models/courier_invoice/courier_invoice_data.dart';
import 'package:hantong_cal/models/product.dart';
import 'package:hantong_cal/ui/widgets/SSHud.dart';
import 'package:universal_html/html.dart' as HTML;
// import 'dart:html' as HTML;
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:hantong_cal/util/common_util.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class CourierInvoicePage extends StatefulWidget {
  const CourierInvoicePage({Key key}) : super(key: key);

  @override
  _CourierInvoicePageState createState() => _CourierInvoicePageState();
}

class _CourierInvoicePageState extends State<CourierInvoicePage> with WidgetsBindingObserver {

  var todayDate;
  int isJuntech = 0;
  int isGoryeoHanjin = 0;
  int isGoryeoGunyoung = 0;
  bool isJuntechShipmentOrder = false;

  String goryeoHanjin = '고려포장(한진)';
  String goryeoGunyoung = '고려포장(건영)';
  String juntechCJ = '준테크(CJ)';

  String hanjinURL = "http://www.hanjinexpress.hanjin.net/customer/hddcw18_ms.tracking?w_num=";
  String gunyoungURL = "https://www.kunyoung.com/goods/goods_02.php?mulno=";
  String CJURL = "http://nplus.doortodoor.co.kr/web/detail.jsp?slipno=";

  List<CourierInvoiceData> _goryeoHanjinItems = [];
  List<CourierInvoiceData> _goryeoGunyoungItems = [];
  List<CourierInvoiceData> _juntechItems = [];
  List<CourierInvoiceData> _juntechShipmentOrderItems = [];

  @override
  void initState() {
    super.initState();
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
        title: const Text('택배송장 제작'),
        bottom: PreferredSize(
          child: Container(),
          preferredSize: Size(50,0),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            tooltip: "엑셀 파일 업로드",
            onPressed: () {
              excelUpload(true);
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
          child: PreferredSize(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  // color: Color(0xFF084172),
                  constraints: BoxConstraints.expand(height: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        label: Text("준테크 발주서", style: TextStyle(color: Colors.white),),
                        icon: !isJuntechShipmentOrder ? Icon(Icons.check_box_outline_blank, color: Colors.white,) : Icon(Icons.check_box_outlined, color: Colors.white,),
                      ),
                      TextButton.icon(
                        label: Text("준테크 ($isJuntech)", style: TextStyle(color: Colors.white),),
                        icon: isJuntech < 1 ? Icon(Icons.check_box_outline_blank, color: Colors.white,) : isJuntech > 1 ? Icon(Icons.check_box, color: Colors.white,) : Icon(Icons.check_box_outlined, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  // color: Color(0xFF084172),
                  constraints: BoxConstraints.expand(height: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        label: Text("고려(한진) ($isGoryeoHanjin)", style: TextStyle(color: Colors.white),),
                        icon: isGoryeoHanjin < 1 ? Icon(Icons.check_box_outline_blank, color: Colors.white,) : isGoryeoHanjin > 1 ? Icon(Icons.check_box, color: Colors.white,) : Icon(Icons.check_box_outlined, color: Colors.white,),
                      ),
                      TextButton.icon(
                        label: Text("고려(건영) ($isGoryeoGunyoung)", style: TextStyle(color: Colors.white),),
                        icon: isGoryeoGunyoung < 1 ? Icon(Icons.check_box_outline_blank, color: Colors.white,) : isGoryeoGunyoung > 1 ? Icon(Icons.check_box, color: Colors.white,) : Icon(Icons.check_box_outlined, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  // color: Color(0xFF084172),
                  constraints: BoxConstraints.expand(height: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        label: Text("다운로드", style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.save, color: Colors.white,),
                        onPressed: () {
                          // if(checkItems()){
                          downloadCourierInvoice();
                          // }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            preferredSize: Size(50, 100),
          ),
        ),
      ),
    );
  }

  // 파일 체크
  bool checkFileName(String fileName) {
    bool result = false;
    try {
      if (p.extension(fileName) == ".xlsx") {
        result = true;
      }
      if(fileName.contains("건영") || fileName.contains("건영") ||
          fileName.contains("고려포장") || fileName.contains("고려포장") ||
          fileName.contains("한통 송장번호") || fileName.contains("한통 송장번호")) {
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
    if(fileName.contains("고려포장") || fileName.contains("고려포장")){
      if(fileName.contains("건영") || fileName.contains("건영")){
        List<CourierInvoiceData> goryeoGunyoungItems = await getLoadingExcelFile(selectedFile, fileName);

        if (goryeoGunyoungItems == null || goryeoGunyoungItems.isEmpty) {
          print("### Error: startWebFilePicker - items is null or empty");
          return false;
        }
        _goryeoGunyoungItems += goryeoGunyoungItems;
        setState(() {
          isGoryeoGunyoung++;
        });
      }else{
        List<CourierInvoiceData> goryeoHanjinItems = await getLoadingExcelFile(selectedFile, fileName);
        if (goryeoHanjinItems == null || goryeoHanjinItems.isEmpty) {
          print("### Error: startWebFilePicker - items is null or empty");
          return false;
        }
        _goryeoHanjinItems += goryeoHanjinItems;
        setState(() {
          isGoryeoHanjin++;
        });
      }
    }else if(fileName.contains("한통 송장번호") || fileName.contains("한통 송장번호")){
      List<CourierInvoiceData> juntechItems = await getLoadingExcelFile(selectedFile, fileName);

      if (juntechItems == null || juntechItems.isEmpty) {
        print("### Error: startWebFilePicker - items is null or empty");
        return false;
      }
      _juntechItems += juntechItems;
      setState(() {
        isJuntech++;
      });
    } else if(fileName.contains("준테크발주서") || fileName.contains("준테크발주서")){
      List<CourierInvoiceData> juntechShipmentOrderItems = await getLoadingExcelFile(selectedFile, fileName);
      juntechShipmentOrderItems.sort((a,b) => a.cust_name.compareTo(b.cust_name));

      for(var i in juntechShipmentOrderItems) {
        print(i.cust_name + i.cust_cellphone);
      }

      if (juntechShipmentOrderItems == null || juntechShipmentOrderItems.isEmpty) {
        print("### Error: startWebFilePicker - items is null or empty");
        return false;
      }
      _juntechShipmentOrderItems = juntechShipmentOrderItems;
      setState(() {
        isJuntechShipmentOrder = true;
      });
    } else {
      SSToast.show("물류사가 파일명에 포함되지 않았습니다. 확인 후 다시 시도해주세요.\n$fileName",
          context, duration: 5, gravity: SSToast.CENTER);
      return false;
    }

    return true;
  }

  // 로딩된 데이터 파싱
  Future<List<CourierInvoiceData>> getLoadingExcelFile(List<int> selectedFile, String fileName) async {
    List<CourierInvoiceData> CourierInvoiceDataList = [];
    if (fileName.isEmpty) {
      print("### Error: loadingExcelFile - fileName is null");
      return CourierInvoiceDataList;
    }

    if (selectedFile == null || selectedFile.isEmpty) {
      print("### Error: loadingExcelFile - selectedFile is null or empty");
      return CourierInvoiceDataList;
    }

    String carrierURLBase = "";
    if(fileName.contains("건영") || fileName.contains("건영")) {
      carrierURLBase = gunyoungURL;
    }else if(fileName.contains("고려포장") || fileName.contains("고려포장")){
      carrierURLBase = hanjinURL;
    }else if(fileName.contains("한통 송장번호") || fileName.contains("한통 송장번호")) {
      carrierURLBase = CJURL;
    }

    var excel = Excel.decodeBytes(selectedFile);
    Pattern pattern = r'^[0-9]{4}/[0-9]{2}/[0-9]{2} -[0-9]{0,100}$';
    Pattern pattern2 = r'^[0-9]{4}-[0-9]{4}-[0-9]{4}$';
    RegExp regex = RegExp(pattern);
    RegExp regex2 = RegExp(pattern2);
    var sheetName = excel.tables.keys.first;

    Sheet sheetObject = excel[sheetName];

    print("L1 = ${sheetObject.cell(CellIndex.indexByString("L1")).value}");
    // print("L1 = ${sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 11,rowIndex: 1)).value}");
    print("L2 = ${sheetObject.cell(CellIndex.indexByString("L2")).value}");
    print("L3 = ${sheetObject.cell(CellIndex.indexByString("L3")).value}");
    print("L4 = ${sheetObject.cell(CellIndex.indexByString("L4")).value}");
    print("L5 = ${sheetObject.cell(CellIndex.indexByString("L5")).value}");
    // print("cell.value = ${cell.value}");
    // excel.save(fileName: "$fileName-다운로드.xlsx");

    for (var row in excel.tables[sheetName].rows) {
      if(fileName.contains("한통 송장번호") || fileName.contains("한통 송장번호")){
        try {
          String trackId = getToString(row, 1);
          if (regex2.hasMatch(trackId) == false) continue;
          CourierInvoiceData data = CourierInvoiceData();
          data.cust_name = getToString(row, 4);
          data.prod_des = getToString(row, 5);
          data.track_id = trackId.replaceAll('-', '');
          data.carrierURL = carrierURLBase + data.track_id;
          data.cust_cellphone = "";
          data.isCheck = true;

          CourierInvoiceDataList.add(data);
        } catch(ex){
          print("### Error: " + ex);
          break;
        }

      }else{
        try {
          String docNo = getToString(row, 0);
          String trackMemo = getToString(row, 12);
          // if ((row[2].value) is int == false) continue;
          if (regex.hasMatch(docNo) == false) continue;
          if (trackMemo.contains("용달") || trackMemo.contains("직접수령")) continue;
          CourierInvoiceData data = CourierInvoiceData();
          // print("row = $row");
          // data.doc_no = docNo;
          data.prod_des = getToString(row, 1);
          data.cust_name = getToString(row, 6);
          data.cust_cellphone = getToString(row, 8);
          data.track_id = getToString(row, 11);
          data.carrierURL = carrierURLBase + data.track_id;
          data.isCheck = true;

          // 중복업체 연락처 제거
          if(fileName.contains("준테크발주서") || fileName.contains("준테크발주서")){
            List<CourierInvoiceData> courierInvoiceDataList2 = [];
            courierInvoiceDataList2.add(data);
            CourierInvoiceDataList.addAll(
                courierInvoiceDataList2..removeWhere((a) {
                  bool flag = false;
                  CourierInvoiceDataList.forEach((b) {
                    if(b.cust_name.contains(a.cust_name)){
                      flag = true;
                    }
                  });
                  return flag;
                })
            );

          }else{
            CourierInvoiceDataList.add(data);
          }

        } catch (ex) {
          print("### Error: " + ex);
          break;
        }
      }
    }

    return CourierInvoiceDataList;
  }

  void excelUpload(bool isMultiple) {
    // 파일 로딩
    HTML.InputElement uploadInput = HTML.FileUploadInputElement();
    uploadInput.multiple = isMultiple;
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      for(var file in files) {
        if(!checkFileName(file.name)){
          SSToast.show("올바르지 않은 파일명이 있습니다. 확인 후 다시 시도해주세요.\n${file.name}",
              context, duration: 5, gravity: SSToast.CENTER);
          return;
        }
      }

      for(var file in files){
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
      }
    });
  }


  String getToString(List<Data> dataList, int colIndex) {
    String result = "";
    try {
      Data data = dataList[colIndex];
      result = data.value.toString();
      // print("result = $result");
    } catch (ex) {
    }
    return result;
  }

  bool checkItems() {
    bool _checkItems = true;
    if(isJuntech == 0 && isGoryeoHanjin == 0 && isGoryeoGunyoung == 0) {
      SSToast.show("먼저 파일을 업로드 해주세요.", context, duration: 5, gravity: SSToast.CENTER);
      _checkItems = false;
    }

    if(isJuntech != 0 && !isJuntechShipmentOrder){
      SSToast.show("준테크 발주서를 업로드 해주세요.", context, duration: 5, gravity: SSToast.CENTER);
      _checkItems = false;
    }

    return _checkItems;
  }

  bool checkItemsNull(List<CourierInvoiceData> _items) {
    if (_items == null || _items.isEmpty) {
      print("### Error: startWebFilePicker - items is null or empty");
      return false;
    }
    return true;
  }


  Excel createCourierInvoiceBase() {
    var excel = new Excel.createExcel();
    excel.rename('Sheet1',goryeoHanjin);
    Sheet sheetObject1 = excel[goryeoHanjin];
    List formList = ['', '판매처명', '창고', '모바일', '품목명', '정규식송장', '일반송장', '문구1', '문구2', '문구3', '기본URL', '주소복사대상', '배송조회URL', '한진택배'];
    sheetObject1.updateCell(CellIndex.indexByString('A1'), formList[0]);
    sheetObject1.updateCell(CellIndex.indexByString('B1'), formList[1]);
    sheetObject1.updateCell(CellIndex.indexByString('C1'), formList[2]);
    sheetObject1.updateCell(CellIndex.indexByString('D1'), formList[3]);
    sheetObject1.updateCell(CellIndex.indexByString('E1'), formList[4]);
    sheetObject1.updateCell(CellIndex.indexByString('F1'), formList[5]);
    sheetObject1.updateCell(CellIndex.indexByString('G1'), formList[6]);
    sheetObject1.updateCell(CellIndex.indexByString('H1'), formList[7]);
    sheetObject1.updateCell(CellIndex.indexByString('I1'), formList[8]);
    sheetObject1.updateCell(CellIndex.indexByString('J1'), formList[9]);
    sheetObject1.updateCell(CellIndex.indexByString('K1'), formList[10]);
    sheetObject1.updateCell(CellIndex.indexByString('L1'), formList[11]);
    sheetObject1.updateCell(CellIndex.indexByString('M1'), formList[12]);
    sheetObject1.updateCell(CellIndex.indexByString('N1'), formList[13]);

    // excel.copy('고려포장(한진)', "고려포장(CJ)");
    excel.copy(goryeoHanjin, goryeoGunyoung);
    excel.copy(goryeoHanjin, juntechCJ);

    // Sheet sheetObject2 = excel['고려포장(CJ)'];
    Sheet sheetObject3 = excel[goryeoGunyoung];
    Sheet sheetObject4 = excel[juntechCJ];

    // sheetObject2.updateCell(CellIndex.indexByString('N1'), 'CJ택배');
    sheetObject3.updateCell(CellIndex.indexByString('N1'), '건영택배');
    sheetObject4.updateCell(CellIndex.indexByString('N1'), 'CJ택배');

    return excel;
  }


  Excel createCourierInvoice(Excel excel, List<CourierInvoiceData> _items,String courier) {
    Sheet sheetObject;
    String warehouse;

    if(courier == goryeoHanjin){
      sheetObject = excel[goryeoHanjin];
      warehouse = "고려포장";
    }else if(courier == goryeoGunyoung){
      sheetObject = excel[goryeoGunyoung];
      warehouse = "고려포장";
    }else if(courier == juntechCJ){
      sheetObject = excel[juntechCJ];
      warehouse = "준테크";
    }

    var count = 2;
    var count2 = -1;
    for(int i = 0; i<_items.length; i++) {
      sheetObject.updateCell(CellIndex.indexByString('A$count'), count-1);
      sheetObject.updateCell(CellIndex.indexByString('B$count'), _items[i].cust_name);
      if(courier == juntechCJ){
        try{
          if(i>0 && _items[i].cust_name == _items[i-1].cust_name){
            sheetObject.updateCell(CellIndex.indexByString('D$count'), _juntechShipmentOrderItems[count2].cust_cellphone);
          }else{
            count2++;
            sheetObject.updateCell(CellIndex.indexByString('D$count'), _juntechShipmentOrderItems[count2].cust_cellphone);
          }
        }catch(ex){
          SSToast.show(".", context, duration: 5, gravity: SSToast.CENTER);
        }

      }else{
        sheetObject.updateCell(CellIndex.indexByString('D$count'), _items[i].cust_cellphone);
      }
      sheetObject.updateCell(CellIndex.indexByString('C$count'), warehouse);
      sheetObject.updateCell(CellIndex.indexByString('E$count'), _items[i].prod_des);
      sheetObject.updateCell(CellIndex.indexByString('G$count'), _items[i].track_id);
      sheetObject.updateCell(CellIndex.indexByString('M$count'), _items[i].carrierURL);
      sheetObject.updateCell(CellIndex.indexByString('N$count'), _items[i].track_id);
      count++;
    }

    // for(CourierInvoiceData item in _items){
    //   sheetObject.updateCell(CellIndex.indexByString('A$count'), count-1);
    //   sheetObject.updateCell(CellIndex.indexByString('B$count'), item.cust_name);
    //   if(courier == juntechCJ){
    //     try{
    //       sheetObject.updateCell(CellIndex.indexByString('D$count'), _juntechShipmentOrderItems[count-2].cust_cellphone);
    //     }catch(ex){
    //       SSToast.show(".", context, duration: 5, gravity: SSToast.CENTER);
    //     }
    //
    //   }else{
    //     sheetObject.updateCell(CellIndex.indexByString('D$count'), item.cust_cellphone);
    //   }
    //   sheetObject.updateCell(CellIndex.indexByString('C$count'), warehouse);
    //   sheetObject.updateCell(CellIndex.indexByString('E$count'), item.prod_des);
    //   sheetObject.updateCell(CellIndex.indexByString('G$count'), item.track_id);
    //   sheetObject.updateCell(CellIndex.indexByString('M$count'), item.carrierURL);
    //   sheetObject.updateCell(CellIndex.indexByString('N$count'), item.track_id);
    //   count++;
    // }

    return excel;
  }

  void downloadCourierInvoice() {
    todayDate = DateFormat('yyyyMMdd').format(DateTime.now().subtract(Duration(days:1)));
    Excel excel = createCourierInvoiceBase();
    excel = createCourierInvoice(excel, _goryeoGunyoungItems, goryeoGunyoung);
    excel = createCourierInvoice(excel, _goryeoHanjinItems, goryeoHanjin);
    excel = createCourierInvoice(excel, _juntechItems, juntechCJ);
    if(kIsWeb){
      if(DateTime.now().weekday == DateTime.monday){
        todayDate = DateFormat('yyyyMMdd').format(DateTime.now().subtract(Duration(days:3)));
      }
      excel.save(fileName: "${todayDate}_택배송장.xlsx");
    }
  }
}

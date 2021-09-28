import 'package:collection/src/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hantong_cal/models/product.dart';
import 'package:hantong_cal/models/productInfoNotifier.dart';
import 'package:hantong_cal/models/sale_order_data.dart';
import 'package:hantong_cal/ui/widgets/ss_dropdown.dart';
import 'package:hantong_cal/ui/widgets/ss_text_dialog.dart';
import 'package:hantong_cal/util/common_util.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SaleOrderProductList extends StatefulWidget {

  final DateTime selectedDate;

  const SaleOrderProductList({
    Key key,
    @required this.selectedDate,
  })  : super(key: key);

  @override
  _SaleOrderProductListState createState() => _SaleOrderProductListState();
}

class _SaleOrderProductListState extends State<SaleOrderProductList> with WidgetsBindingObserver {

  DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat('yyyy-MM-dd');

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.white24,
        ),
        child: buildDataTable(context),
      ),
    );
  }

  Widget buildDataTable(BuildContext context) {
    var colums = ['품목코드', '품목명', '수량', '단가', '공급가액', '부가세', '품목별납기일자', '창고', '메모'];
    if (CommonUtil.isFull(context)) {
      colums = ['품목코드', '품목명', '수량', '단가', '공급가액', '부가세', '품목별납기일자', '창고', '메모'];
    } else if (CommonUtil.isHalf(context)) {
      colums = ['품목명', '수량', '단가', '공급가액', '창고', '메모'];
    } else {
      colums = ['품목명', '수량', '창고', '메모'];
    }

    final productInfoNotifier = context.watch<ProductInfoNotifier>();
    return DataTable(
      horizontalMargin: 0, // default : 24.0
      columnSpacing: 0, // default : 56.0
      showCheckboxColumn: false,
      columns: getColumns(colums),
      rows: getRows(context, productInfoNotifier.productInfoList),
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

  List<DataRow> getRows(BuildContext context, List<Product_Info> rows) {
    final productInfoNotifier = context.watch<ProductInfoNotifier>();
    int total_QTY = 0;
    num total_SUPPLY_AMT = 0;
    num total_VAT_AMT = 0;
    for(Product_Info product_info in productInfoNotifier.productInfoList){
      total_QTY += product_info.QTY;
      total_SUPPLY_AMT += product_info.SUPPLY_AMT.toInt();
      total_VAT_AMT += product_info.VAT_AMT.toInt();
    }
    int total_PricePlusVAT = total_SUPPLY_AMT + total_VAT_AMT;

    if (CommonUtil.isFull(context)) {
      List dataRow = rows.mapIndexed((int index, Product_Info info) {
        return DataRow(
          cells: <DataCell>[
            DataCell(getCell(info.PROD_CD, Colors.white)),
            getProDesDataCell(index, info, productInfoNotifier),
            getQtyDataCell(index, info, productInfoNotifier),
            getPriceDataCell(index, info, productInfoNotifier),
            DataCell(getCell(numberWithComma(info.SUPPLY_AMT), Colors.white)),
            DataCell(getCell(numberWithComma(info.VAT_AMT), Colors.white)),
            DataCell(getCell(_dateFormat.format(widget.selectedDate), Colors.white)),
            getPRemarks2_1DataCell(index, info, productInfoNotifier),
            getPRemarks2_2DataCell(index, info, productInfoNotifier),
          ],
        );
      }).toList();
      dataRow.add(
          DataRow(
              cells: <DataCell>[
                DataCell(getCellBold("Total",Colors.white)),
                DataCell(getCellBold("",Colors.white)),
                DataCell(getCellBold("$total_QTY",Colors.white)),
                DataCell(getCellBold("",Colors.white)),
                DataCell(getCellBold("${numberWithComma(total_SUPPLY_AMT)}",Colors.white)),
                DataCell(getCellBold("${numberWithComma(total_VAT_AMT)}",Colors.white)),
                DataCell(getCellBold("${numberWithComma(total_PricePlusVAT)}",Colors.white)),
                DataCell(getCellBold("",Colors.white)),
                DataCell(getCellBold("",Colors.white)),
              ]
          )
      );

      return dataRow;
    } else if (CommonUtil.isHalf(context)) {
      List dataRow = rows.mapIndexed((int index, Product_Info info) {
        return DataRow(
          cells: <DataCell>[
            getProDesDataCell(index, info, productInfoNotifier),
            getQtyDataCell(index, info, productInfoNotifier),
            getPriceDataCell(index, info, productInfoNotifier),
            DataCell(getCell(numberWithComma(info.SUPPLY_AMT), Colors.white)),
            getPRemarks2_1DataCell(index, info, productInfoNotifier),
            getPRemarks2_2DataCell(index, info, productInfoNotifier),
          ],
        );
      }).toList();
      dataRow.add(
          DataRow(
              cells: <DataCell>[
                DataCell(getCellBold("Total",Colors.white)),
                DataCell(getCellBold("$total_QTY",Colors.white)),
                DataCell(getCellBold("",Colors.white)),
                DataCell(getCellBold("${numberWithComma(total_SUPPLY_AMT)}",Colors.white)),
                DataCell(getCellBold("${numberWithComma(total_VAT_AMT)}",Colors.white)),
                DataCell(getCellBold("${numberWithComma(total_PricePlusVAT)}",Colors.white)),
              ]
          )
      );

      return dataRow;
    } else {
      List dataRow = rows.mapIndexed((int index, Product_Info info) {
        return DataRow(
          cells: <DataCell>[
            getProDesDataCell(index, info, productInfoNotifier),
            getQtyDataCell(index, info, productInfoNotifier),
            getPRemarks2_1DataCell(index, info, productInfoNotifier),
            getPRemarks2_2DataCell(index, info, productInfoNotifier),
          ],
        );
      }).toList();
      dataRow.add(
          DataRow(
              cells: <DataCell>[
                DataCell(getCellBold("Total",Colors.white)),
                DataCell(getCellBold("$total_QTY",Colors.white)),
                DataCell(getCellBold("${numberWithComma(total_PricePlusVAT)}",Colors.white)),
                DataCell(getCellBold("",Colors.white)),
              ]
          )
      );

      return dataRow;
    }
  }

  // 품목명
  DataCell getProDesDataCell(int index, Product_Info info, ProductInfoNotifier productInfoNotifier) {
    return DataCell(
      GestureDetector(
        onLongPress: (){
          if(Product.plate_cd_list.contains(info.PROD_CD)){
            Product_Info info2 = new Product_Info();
            info2.PROD_CD = info.PROD_CD;
            info2.PROD_DES = info.PROD_DES;
            info2.QTY = 1;
            info2.PricePlusVAT = info.PricePlusVAT;
            info2.PRICE = calc_price(info2.PricePlusVAT);
            info2.SUPPLY_AMT = calc_supply_amt(info2.PricePlusVAT, info2.QTY);
            info2.VAT_AMT = calc_vat_amt(info2.PricePlusVAT, info2.QTY, info2.SUPPLY_AMT);
            info2.P_REMARKS2_1 = Product.cj;
            // info2.P_REMARKS2_2 = calc_P_REMARKS2_2(calc_cj_courier_fee(info2.PROD_CD), info2.QTY);

            productInfoNotifier.insertProductInfo(index+1, info2);
          }
          if(info.PROD_CD == Product.paperBox_cd) {
            info.PROD_CD = Product.paperBox2_cd;
            info.PROD_DES = Product.paperBox2_name;

            productInfoNotifier.changeProductInfo(index, info);
            productInfoNotifier.changeDC5P();
          }
          else if (info.PROD_CD == Product.paperBox2_cd) {
            info.PROD_CD = Product.paperBox_cd;
            info.PROD_DES = Product.paperBox_name;

            productInfoNotifier.changeProductInfo(index, info);
            productInfoNotifier.changeDC5P();
          }
        },
        child: Center(
          child: SSDropDown(
            labelColor: Colors.lightGreenAccent,
            currentSelectedValue: info.PROD_DES,
            items: PROD_CD_MAP,
            onChanged: (value) {
              // 품목명 수정
              try {
                var value_list = value.values.toList();
                info.PROD_CD = value.keys.first;
                info.PROD_DES = value.values.first;
                // info.QTY = 1;
                info.PricePlusVAT = num.parse(value_list[1]);
                info.PRICE = calc_price(info.PricePlusVAT);
                info.SUPPLY_AMT = calc_supply_amt(info.PricePlusVAT, info.QTY);
                info.VAT_AMT = calc_vat_amt(info.PricePlusVAT, info.QTY, info.SUPPLY_AMT);
                info.P_REMARKS2_1 = calc_courier(info.PROD_CD);
                if(Product.headOffice_list.contains(info.PROD_CD)){
                  info.P_REMARKS2_2 = calc_P_REMARKS2_2(calc_courier_fee(info.PROD_CD), info.QTY);
                }

                productInfoNotifier.changeProductInfo(index, info);
                productInfoNotifier.changeDC5P();

              } catch (ex) {
                print(ex);
              }

            },
          ),
        ),
      )
    );
  }

  // 수량
  DataCell getQtyDataCell(int index, Product_Info info, ProductInfoNotifier productInfoNotifier) {
    return DataCell(
      getCell(info.QTY.toString(), Colors.lightGreenAccent),
      onTap: () async {
        // 수량 수정
        final value = await showTextDialog(
          context,
          title: '수량을 입력하세요.',
          value: info.QTY.toString(),
        );
        int qty = int.parse(value);
        if (qty > 0) {
          info.QTY = qty;
          info.SUPPLY_AMT = calc_supply_amt(info.PricePlusVAT, info.QTY);
          info.VAT_AMT = calc_vat_amt(info.PricePlusVAT, info.QTY, info.SUPPLY_AMT);
          // info.P_REMARKS2_2 = info.P_REMARKS2_1 == Product.cj ? calc_P_REMARKS2_2(calc_cj_courier_fee(info.PROD_CD), info.QTY) : calc_P_REMARKS2_2(calc_courier_fee(info.PROD_CD), info.QTY);

          productInfoNotifier.changeProductInfo(index, info);
          productInfoNotifier.changeDC5P();
        }
      },
    );
  }

  // 단가
  DataCell getPriceDataCell(int index, Product_Info info, ProductInfoNotifier productInfoNotifier) {
    return DataCell(
      getCell(numberWithComma(info.PRICE), Colors.lightGreenAccent),
      onTap: () async {
        // 단가 수정
        final value = await showTextDialog(context, title: '단가를 입력하세요.', value: info.PRICE.toString(),);
        num price = num.parse(value);
        if (price > 0) {
          info.PRICE = price;
          info.SUPPLY_AMT = num.parse((info.PRICE * info.QTY).toStringAsFixed(0));
          info.VAT_AMT = num.parse((info.SUPPLY_AMT / 10).toStringAsFixed(0));
          info.PricePlusVAT = (info.SUPPLY_AMT + info.VAT_AMT) / info.QTY;
          productInfoNotifier.changeProductInfo(index, info);
          productInfoNotifier.changeDC5P();
        }
      },
    );
  }

  // 창고
  DataCell getPRemarks2_1DataCell(int index, Product_Info info, ProductInfoNotifier productInfoNotifier) {
    return DataCell(info.P_REMARKS2_1 == null ? Text('') :
      Center(
        child: SSDropDown(
          labelColor: Colors.lightGreenAccent,
          currentSelectedValue: info.P_REMARKS2_1,
          items: Product.cj_list.contains(info.PROD_CD) ? WARE_HOUSE_MAP_CJ
              : Product.headOffice_list.contains(info.PROD_CD) ? WARE_HOUSE_MAP_HEADOFFICE
              : Product.gunyoung_list.contains(info.PROD_CD) ? WARE_HOUSE_MAP_GUNYOUNG
              : WARE_HOUSE_MAP,
          onChanged: (value) {

            // 창고 수정
            try {
              info.P_REMARKS2_1 = value.values.first.toString();
              // info.P_REMARKS2_2 = info.P_REMARKS2_1 == Product.cj ? calc_P_REMARKS2_2(calc_cj_courier_fee(info.PROD_CD), info.QTY)
              //     : info.P_REMARKS2_1 == Product.headOffice ? "택배착불"
              //     : info.P_REMARKS2_1.isEmpty ? ""
              //     : info.P_REMARKS2_1 == Product.gunyoung && !Product.gunyoung_list.contains(info.PROD_CD) ? "" // 일반품목을 건영으로 보낼시에는 직접입력하게 변경
              //     : calc_P_REMARKS2_2(calc_courier_fee(info.PROD_CD), info.QTY);

              productInfoNotifier.changeProductInfo(index, info);
            } catch (ex) {
              print(ex);
            }

          },
        ),
      ),
    );
  }

  // 배송
  DataCell getPRemarks2_2DataCell(int index, Product_Info info, ProductInfoNotifier productInfoNotifier) {
    return DataCell(info.P_REMARKS2_2 == null ? Text('') :
      getCell(info.P_REMARKS2_2, Colors.lightGreenAccent),
        onTap: () async {
          // 배송비 수정
          final value = await showTextDialog(
            context,
            title: '메모를 입력하세요.',
            value: info.P_REMARKS2_2,
          );
          info.P_REMARKS2_2 = value;
          productInfoNotifier.changeProductInfo(index, info);
        },
    );
  }

  Widget getCell(String text, Color color) {
    return Center(
      child: Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: 12.0,),
      ),
    );
  }

  Widget getCellBold(String text, Color color) {
    return Center(
      child: Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: 12.0,fontWeight: FontWeight.bold),
      ),
    );
  }

}

// 숫자 사이에 ,찍기
String numberWithComma(num param){
  return new NumberFormat('#,###.##########').format(param);
}
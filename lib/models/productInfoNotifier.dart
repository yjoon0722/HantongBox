import 'package:flutter/foundation.dart';
import 'package:hantong_cal/models/product.dart';

class ProductInfoNotifier extends ChangeNotifier {
  List<Product_Info> _productInfoList = [];
  List<Product_Info> get productInfoList => _productInfoList;

  // DateTime _selectedDate;
  // DateTime get selectedDate => _selectedDate;

  void addProductInfo(Product_Info info) {
    _productInfoList.add(info);
    notifyListeners();
  }

  void setProductInfoList(List<Product_Info> list) {
    _productInfoList = list;
    notifyListeners();
  }

  void setProductInfoListNoListeners(List<Product_Info> list) {
    _productInfoList = list;
  }

  void changeProductInfo(int index, Product_Info info) {
    _productInfoList.replaceRange(index, index+1, [info]);
    notifyListeners();
  }

  void insertProductInfo(int index, Product_Info info) {
    _productInfoList.insert(index, info);
    notifyListeners();
  }

  void changeDC5P() {
    num totalPrice = 0;
    for(Product_Info productInfo in _productInfoList) {
      if(productInfo.PROD_CD != Product.DC_5p_cd) {
        totalPrice += productInfo.PricePlusVAT * productInfo.QTY;
      }
    }

    for(int i = 0; i < _productInfoList.length; i++) {
      Product_Info productInfo = _productInfoList[i];
      if(productInfo.PROD_CD == Product.DC_5p_cd) {
        num pricePlusVat = -(totalPrice * 0.05).toInt();
        num price = calc_supply_amt(pricePlusVat, 1);
        num supplyAMT = calc_supply_amt(pricePlusVat, productInfo.QTY);
        num vatAMT = calc_vat_amt(pricePlusVat, productInfo.QTY, supplyAMT);

        productInfo.PricePlusVAT = pricePlusVat;
        productInfo.PRICE = price;
        productInfo.SUPPLY_AMT = supplyAMT;
        productInfo.VAT_AMT = vatAMT;
        changeProductInfo(i, productInfo);
      }
    }
  }

  // void setSelectedDate(DateTime dateTime) {
  //   _selectedDate = dateTime;
  //   notifyListeners();
  // }

}
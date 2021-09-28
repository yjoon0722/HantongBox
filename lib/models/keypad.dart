import 'package:flutter/material.dart';
import 'package:hantong_cal/main.dart';
import 'package:hantong_cal/models/product.dart';

class Keypad {
  final int id;
  final String title;     // 제목
  final String subTitle;  // 부제목
  final String detail;    // 상세설명
  final String imagePath;     // 이미지
  final String unit;      // 수량 단위 표시 (개, 박스, ...)

  final Color backgroundColor;
  final Color selectedColor;
  final Color textColor;

  bool isSelected; // 선택 여부
  int quantity; // 수량
  num price;    // 가격
  final String PROD_CD; // 품목 코드
  int count_Components; // 구성품의 수

  Keypad({
    this.id, this.title, this.subTitle = "", this.detail = "", this.imagePath = "", this.unit = "박스",
    this.backgroundColor = MyApp.btnBackgroundColor,
    //this.selectedColor = Colors.orange,
    this.selectedColor = MyApp.btnSelectedColor,
    this.textColor = Colors.black,
    this.isSelected = false,
    this.quantity = 0, this.price = 0, this.PROD_CD = "", this.count_Components});

}

class Keypad_list {
  final List<Keypad> keypads = [
    Keypad(id: 0, title: "C"),
    Keypad(id: 1, title: "택배비 제거"),
    Keypad(id: 2, title: "택배비\n자동계산", isSelected: false),

    Keypad(id: 3, title: "일회용식판", price: Product.disposable_plate, PROD_CD: Product.disposable_plate_cd),
    Keypad(id: 4, title: "실링비닐", price: Product.sealing_vinyl, PROD_CD: Product.sealing_vinyl_D_cd),
    Keypad(id: 5, title: "주황보온용기", price: Product.orangeBox, PROD_CD: Product.orangeBox_cd),

    Keypad(id: 6, title: "다회용식판", price: Product.multi_use_plate, PROD_CD: Product.multi_use_plate_cd),
    Keypad(id: 7, title: "종이용기", price: Product.paperBox, PROD_CD: Product.paperBox_cd),
    Keypad(id: 8, title: "주황보온용기\n4+1", price: Product.orangeBox4plus1, unit: "세트", count_Components : 1),

    Keypad(id: 9, title: "한통식판본체", price: Product.hantong_plate, PROD_CD: Product.hantong_plate_cd),
    Keypad(id: 10, title: "한통식판뚜껑", price: Product.hantong_plate_lid, PROD_CD: Product.hantong_plate_lid_cd),
    Keypad(id: 11, title: "한통식판세트", price: Product.hantongPlateSet, unit: "세트", count_Components : Product.hantongPlateSet_cd_list.length),

    Keypad(id: 12, title: "한통쟁반 10개", price: Product.hantong_tray_10EA, PROD_CD: Product.hantong_tray_10EA_cd),
    Keypad(id: 13, title: "한통쟁반 60개", price: Product.hantong_tray_60EA, PROD_CD: Product.hantong_tray_60EA_cd),
    Keypad(id: 14, title: "실링기계", price: Product.sealing_machine, unit: "대",PROD_CD: Product.sealing_machine_cd),

    Keypad(id: 15, title: "한통뚝배기 5개", price: Product.hantong_ttukbaegi_5EA, PROD_CD: Product.hantong_ttukbaegi_5EA_cd),
    Keypad(id: 16, title: "한통뚝배기 20개", price: Product.hantong_ttukbaegi_20EA, PROD_CD: Product.hantong_ttukbaegi_20EA_cd),
    Keypad(id: 17, title: "한통뚝배기 210개", price: Product.hantong_ttukbaegi,count_Components : Product.hantong_ttukbaegi_list.length),

    Keypad(id: 18, title: "뚝배기내피 210개", price: Product.hantong_ttukbaegi_inner, count_Components : Product.hantong_ttukbaegi_inner_list.length),
    Keypad(id: 19, title: "캐리어 2인용", price: Product.hantong_ttukbaegi_carrier_2, PROD_CD: Product.hantong_ttukbaegi_carrier_2_cd),
    Keypad(id: 20, title: "캐리어 4인용", price: Product.hantong_ttukbaegi_carrier_4, PROD_CD: Product.hantong_ttukbaegi_carrier_4_cd),

    Keypad(id: 21, title: "주황패키지 1,000", price: (Product.orangePackage1000).toInt(), unit: "세트", count_Components: Product.orangePackage_cd_list.length),
    Keypad(id: 22, title: "주황패키지 2,000", price: (Product.orangePackage2000).toInt(), unit: "세트", count_Components: Product.orangePackage_cd_list.length),
    Keypad(id: 23, title: "주황패키지 3,000", price: (Product.orangePackage3000).toInt(), unit: "세트", count_Components: Product.orangePackage_cd_list.length),

    Keypad(id: 24, title: "한통식판 패키지 100", price: (Product.hantongPlatePackage100).toInt(), unit: "세트", count_Components: Product.hantongPlatePackage_cd_list.length),
    Keypad(id: 25, title: "한통식판 패키지 200", price: (Product.hantongPlatePackage200).toInt(), unit: "세트", count_Components: Product.hantongPlatePackage_cd_list.length),
    Keypad(id: 26, title: "한통식판 패키지 300", price: (Product.hantongPlatePackage300).toInt(), unit: "세트", count_Components: Product.hantongPlatePackage_cd_list.length),

    Keypad(id: 27, title: "영중소 패키지 111", price: (Product.smallBusinessPackage111).toInt(), unit: "세트", count_Components: Product.smallBusinessPackage_cd_list.length),
    Keypad(id: 28, title: "영중소 패키지 222", price: (Product.smallBusinessPackage222).toInt(), unit: "세트", count_Components: Product.smallBusinessPackage_cd_list.length),
    Keypad(id: 29, title: "영중소 패키지 333", price: (Product.smallBusinessPackage333).toInt(), unit: "세트", count_Components: Product.smallBusinessPackage_cd_list.length),

    Keypad(id: 30, title: "택배비 3천원", price: Product.courier_fee_3000, PROD_CD: Product.courier_fee_3000_cd),
    Keypad(id: 31, title: "택배비 5천원", price: Product.courier_fee_5000, PROD_CD: Product.courier_fee_5000_cd),
    Keypad(id: 32, title: "택배비 8천원", price: Product.courier_fee_8000, PROD_CD: Product.courier_fee_8000_cd),

    Keypad(id: 33, title: "샘플\n30,000원", price: Product.sample, PROD_CD: Product.sample_cd),
    Keypad(id: 34, title: "무료 샘플", price: Product.sample, PROD_CD: Product.sample_cd),
    Keypad(id: 35, title: "할인 5%", PROD_CD: Product.DC_5p_cd)
  ];
}
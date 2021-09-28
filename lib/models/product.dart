import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// TODO: 안쓰는 코드 지우기
class Product {

  // 부가세 포함 가격(단품)
  static const sealing_vinyl = 144000;
  static const sealing_vinyl_A = 144000;
  static const sealing_vinyl_B = 144000;
  static const sealing_vinyl_C = 144000;
  static const sealing_vinyl_D = 144000;
  static const orangeBox = 198000;
  static const hantong_tray_10EA = 40000;
  static const hantong_tray_60EA = 198000;
  static const hantong_ttukbaegi_5EA = 9600;
  static const hantong_ttukbaegi_20EA = 38400;
  static const hantong_ttukbaegi_outer_24EA = 35000;
  static const hantong_ttukbaegi_carrier_2 = 15000;
  static const hantong_ttukbaegi_carrier_4 = 20000;
  static const paperBox = 60000;
  static const multi_use_plate = 250000;
  static const disposable_plate = 150000;
  static const hantong_ttukbaegi_inner_vessel = 42000;
  static const hantong_ttukbaegi_inner_lid = 42000;
  static const sample = 30000;
  static const sealing_machine = 1300000;
  static const courier_fee_3000 = 3000;
  static const courier_fee_5000 = 5000;
  static const courier_fee_8000 = 8000;
  static const courier_fee_quick = 45000;
  // 2021/09/27 추가 물품
  static const paperBox2 = 60000;
  static const hantong_plate = 60000;
  static const hantong_plate_lid = 60000;

  // 들어가는 갯수, 할인율 정리
  // 한통뚝배기 210EA
  static const hantong_ttukbaegi_outer_qty = 9;
  static const hantong_ttukbaegi_inner_vessel_qty = 1;
  static const hantong_ttukbaegi_inner_lid_qty = 1;

  // 주황보온용기 4+1
  static const orangeBox4plus1 = orangeBox * 4;
  static const orangeBox4plus1_qty = 5;

  // 주황패키지 1000
  static const orangePackage1000_orangeBox_DC = 0.8;
  static const orangePackage1000_orangeBox_qty = 5;
  static const orangePackage1000_disposable_plate_qty = 2;
  static const orangePackage1000_sealing_vinyl_qty = 1;
  static const orangePackage1000_sealing_machine_qty = 1;
  // 주황패키지 2000
  static const orangePackage2000_orangeBox_qty = 10;
  static const orangePackage2000_disposable_plate_qty = 4;
  static const orangePackage2000_sealing_vinyl_qty = 1;
  static const orangePackage2000_sealing_machine_qty = 1;
  // 주황패키지 3000
  static const orangePackage3000_orangeBox_DC = 0.75;
  static const orangePackage3000_orangeBox_qty = 15;
  static const orangePackage3000_disposable_plate_qty = 6;
  static const orangePackage3000_sealing_vinyl_qty = 2;
  static const orangePackage3000_sealing_machine_qty = 1;
  // 한통식판 패키지 100
  static const hantongPlatePackage100_orangeBox_DC = 0.8;
  static const hantongPlatePackage100_orangeBox_qty = 5;
  static const hantongPlatePackage100_hantong_plate_qty = 2;
  static const hantongPlatePackage100_hantong_plate_lid_qty = 2;
  // 한통식판 패키지 200
  static const hantongPlatePackage200_orangeBox_qty = 10;
  static const hantongPlatePackage200_hantong_plate_qty = 4;
  static const hantongPlatePackage200_hantong_plate_lid_qty = 4;
  // 한통식판 패키지 300
  static const hantongPlatePackage300_orangeBox_DC = 0.75;
  static const hantongPlatePackage300_orangeBox_qty = 15;
  static const hantongPlatePackage300_hantong_plate_qty = 6;
  static const hantongPlatePackage300_hantong_plate_lid_qty = 6;
  // 영중소 패키지 111
  static const smallBusinessPackage111_orangeBox_qty = 1;
  static const smallBusinessPackage111_hantong_plate_qty = 1;
  static const smallBusinessPackage111_hantong_plate_lid_qty = 1;
  static const smallBusinessPackage111_hantong_tray_qty = 1;
  // 영중소 패키지 222
  static const smallBusinessPackage222_orangeBox_qty = 2;
  static const smallBusinessPackage222_hantong_plate_qty = 2;
  static const smallBusinessPackage222_hantong_plate_lid_qty = 2;
  static const smallBusinessPackage222_hantong_tray_qty = 2;
  // 영중소 패키지 333
  static const smallBusinessPackage333_orangeBox_qty = 3;
  static const smallBusinessPackage333_hantong_plate_qty = 3;
  static const smallBusinessPackage333_hantong_plate_lid_qty = 3;
  static const smallBusinessPackage333_hantong_tray_qty = 3;
  // 한통식판세트
  static const hantongPlateSet_hantong_plate_qty = 1;
  static const hantongPlateSet_hantong_plate_lid_qty = 1;

  // 물품 코드
  static const sealing_vinyl_A_cd = "EPL001";
  static const sealing_vinyl_B_cd = "EPL004";
  static const sealing_vinyl_C_cd = "EPL006";
  static const sealing_vinyl_D_cd = "EPL007";
  static const orangeBox_cd = "EPP01";
  static const hantong_tray_10EA_cd = "EPP04";
  static const hantong_tray_60EA_cd = "EPP03";
  static const hantong_ttukbaegi_5EA_cd = "EPS003";
  static const hantong_ttukbaegi_20EA_cd = "EPS004";
  static const hantong_ttukbaegi_outer_24EA_cd = "EPS006";
  static const hantong_ttukbaegi_carrier_2_cd = "HDPE04";
  static const hantong_ttukbaegi_carrier_4_cd = "HDPE02";
  static const paperBox_cd = "PBOX03";
  static const paperBox2_cd = "PBOX04";
  static const multi_use_plate_cd = "PP01";
  static const disposable_plate_cd = "PP04";
  static const hantong_plate_cd = "PP03";
  static const hantong_plate_lid_cd = "PP02";
  static const hantong_ttukbaegi_inner_vessel_cd = "PP05";
  static const hantong_ttukbaegi_inner_lid_cd = "PP06";
  static const sealing_machine_cd = "SEAL03";
  static const sample_cd = "SAMP06";
  static const courier_fee_3000_cd = "parcel4";
  static const courier_fee_5000_cd = "parcel1";
  static const courier_fee_8000_cd = "parcel2";
  static const courier_fee_quick_cd = "parcel3";
  static const DC_5p_cd = "DC006";

  static const sealing_vinyl_cd_list = [
    sealing_vinyl_A_cd,
    sealing_vinyl_B_cd,
    sealing_vinyl_C_cd,
    sealing_vinyl_D_cd
  ];

  static const plate_cd_list = [
    multi_use_plate_cd,
    disposable_plate_cd,
    hantong_plate_cd,
    hantong_plate_lid_cd
  ];
  
  static const product_list = [
    sealing_vinyl_A_cd,
    sealing_vinyl_B_cd,
    sealing_vinyl_C_cd,
    sealing_vinyl_D_cd,
    orangeBox_cd,
    hantong_tray_10EA_cd,
    hantong_tray_60EA_cd,
    hantong_ttukbaegi_5EA_cd,
    hantong_ttukbaegi_20EA_cd,
    hantong_ttukbaegi_outer_24EA_cd,
    hantong_ttukbaegi_carrier_2_cd,
    hantong_ttukbaegi_carrier_4_cd,
    paperBox_cd,
    multi_use_plate_cd,
    disposable_plate_cd,
    sample_cd,
    sealing_machine_cd,
    courier_fee_3000_cd,
    courier_fee_5000_cd,
    courier_fee_8000_cd,
    courier_fee_quick_cd,
    paperBox2_cd,
    hantong_ttukbaegi_inner_vessel_cd,
    hantong_ttukbaegi_inner_lid_cd
  ];

  // 물품 이름
  static const sealing_vinyl_A_name = "실링비닐A";
  static const sealing_vinyl_B_name = "실링비닐B";
  static const sealing_vinyl_C_name = "실링비닐C";
  static const sealing_vinyl_D_name = "실링비닐D";
  static const orangeBox_name = "주황보온용기";
  static const hantong_tray_10EA_name = "한통쟁반(10EA)";
  static const hantong_tray_60EA_name = "한통쟁반(60EA)";
  static const hantong_ttukbaegi_5EA_name = "한통뚝배기 5EA세트";
  static const hantong_ttukbaegi_20EA_name = "한통뚝배기 20EA세트";
  static const hantong_ttukbaegi_outer_24EA_name = "한통뚝배기 24EA 외부케이스";
  static const hantong_ttukbaegi_carrier_2_name = "한통뚝배기캐리어2인용";
  static const hantong_ttukbaegi_carrier_4_name = "한통뚝배기캐리어4인용";
  static const paperBox_name = "종이용기";
  static const multi_use_plate_name = "다회용식판(검정색)";
  static const disposable_plate_name = "일회용식판(흰색)신형";
  static const hantong_ttukbaegi_inner_vessel_name = "한통뚝배기 내피용기";
  static const hantong_ttukbaegi_inner_lid_name = "한통뚝배기 내피뚜껑";
  static const sample_name = "(샘플)2종식판+주황보온용기세트";
  static const sealing_machine_name = "실링기계(TY-PCB)";
  static const courier_fee_3000_name = "택배비3,000";
  static const courier_fee_5000_name = "택배비5,000";
  static const courier_fee_8000_name = "택배비8,000";
  static const courier_fee_quick_name = "퀵배송45,000";
  static const DC_5p_name = "5%할인";
  // 2021/09/27 추가 물품
  static const paperBox2_name = "종이용기(신형)";
  static const hantong_plate_name = "한통식판본체";
  static const hantong_plate_lid_name = "한통식판뚜껑";

  // 물품 배송비 TODO: 창고별 물품배송비 정리
  // CJ
  static const cj = "준테크";
  static const cj_fee_1 = 4500;
  static const cj_fee_1_list = [
    Product.multi_use_plate_cd,
    Product.disposable_plate_cd,
  ];

  // 한진
  static const hanjin = "고려";
  static const hanjin_fee_1 = 2530;
  static const hanjin_fee_2 = 3520;
  static const hanjin_fee_3 = 4070;

  static const hanjin_fee_1_list = [
    Product.sealing_vinyl_A_cd,
    Product.sealing_vinyl_B_cd,
    Product.sealing_vinyl_C_cd,
    Product.sealing_vinyl_D_cd,
    Product.hantong_tray_10EA_cd,
    Product.hantong_ttukbaegi_carrier_2_cd,
    Product.hantong_ttukbaegi_carrier_4_cd,
  ];

  static const hanjin_fee_2_list = [
    Product.hantong_ttukbaegi_5EA_cd,
    Product.multi_use_plate_cd,
    Product.hantong_ttukbaegi_inner_lid_cd,
  ];

  static const hanjin_fee_3_list = [
    Product.orangeBox_cd,
    Product.disposable_plate_cd,
    Product.paperBox_cd,
    Product.hantong_ttukbaegi_20EA_cd,
    Product.hantong_ttukbaegi_outer_24EA_cd,
    Product.hantong_ttukbaegi_inner_vessel_cd,
    Product.hantong_tray_60EA_cd,
  ];

  // 건영
  static const gunyoung = "건영";
  static const gunyoung_fee_1 = 7000;
  static const gunyoung_fee_1_list = [
    Product.sealing_machine_cd
  ];

  // 본사
  static const headOffice = "본사";
  static const headOffice_fee_1 = "택배출고";
  static const headOffice_fee_2 = "택배착불";
  static const headOffice_fee_1_list = [
    Product.sample_cd
  ];



  // 한통뚝배기 210EA 각 품목 가격 (부가세포함)
  static const hantong_ttukbaegi_list = [
    Product.hantong_ttukbaegi_outer_24EA,
    Product.hantong_ttukbaegi_inner_vessel,
    Product.hantong_ttukbaegi_inner_lid
  ];

  // 뚝배기내피 210EA 각 품목 가격 (부가세포함)
  static const hantong_ttukbaegi_inner_list = [
    Product.hantong_ttukbaegi_inner_vessel,
    Product.hantong_ttukbaegi_inner_lid
  ];

  // 주황패키지 1000 각 품목 가격 (부가세포함)
  static const orangePackage1000_list = [
    Product.orangeBox * orangePackage1000_orangeBox_DC,
    Product.disposable_plate,
    Product.sealing_vinyl_D,
    Product.sealing_machine
  ];

  // 주황패키지 2000 각 품목 가격 (부가세포함)
  static const orangePackage2000_list = [
    150000, // 주황패키지 2000은 단가할인율이 정해져 있지않고 150,000원에 맞춘듯
    Product.disposable_plate,
    Product.sealing_vinyl_D,
    Product.sealing_machine
  ];

  // 주황패키지 3000 각 품목 가격 (부가세포함)
  static const orangePackage3000_list = [
    Product.orangeBox * orangePackage3000_orangeBox_DC,
    Product.disposable_plate,
    Product.sealing_vinyl_D,
    Product.sealing_machine
  ];

  // 한통식판 패키지 100 각 품목 가격 (부가세포함)
  static const hantongPlatePackage100_list = [
    Product.orangeBox * hantongPlatePackage100_orangeBox_DC,
    Product.hantong_plate, // 한통식판본체
    50000  // 한통식판 뚜껑
  ];

  // 한통식판 패키지 200 각 품목 가격 (부가세포함)
  static const hantongPlatePackage200_list = [
    150000,
    Product.hantong_plate, // 한통식판본체
    50000  // 한통식판 뚜껑
  ];

  // 한통식판 패키지 300 각 품목 가격 (부가세포함)
  static const hantongPlatePackage300_list = [
    Product.orangeBox * hantongPlatePackage300_orangeBox_DC,
    Product.hantong_plate, // 한통식판본체
    50000  // 한통식판 뚜껑
  ];

  // 영중소 패키지 111 각 품목 가격 (부가세포함)
  static const smallBusinessPackage111_list = [
    Product.orangeBox,
    Product.hantong_plate,
    Product.hantong_plate_lid,
    Product.hantong_tray_10EA
  ];
  // 영중소 패키지 222 각 품목 가격 (부가세포함)
  static const smallBusinessPackage222_list = [
    Product.orangeBox,
    Product.hantong_plate,
    50000, // 한통식판뚜껑
    Product.hantong_tray_10EA
  ];
  // 영중소 패키지 333 각 품목 가격 (부가세포함)
  static const smallBusinessPackage333_list = [
    Product.orangeBox,
    Product.hantong_plate,
    50000, // 한통식판뚜껑
    33000 // 한통쟁반
  ];
  static const hantongPlateSet_list = [
    Product.hantong_plate,
    50000
  ];

  // 부가세 포함 가격(세트)
  // 뚝배기내피 210EA
  static const hantong_ttukbaegi_inner =
      hantong_ttukbaegi_inner_vessel +
      hantong_ttukbaegi_inner_lid;
  // 한통뚝배기 210EA
  static const hantong_ttukbaegi =
      hantong_ttukbaegi_outer_24EA * hantong_ttukbaegi_outer_qty +
      hantong_ttukbaegi_inner;
  // 주황패키지 1000 가격
  static const orangePackage1000 =
      (orangeBox * orangePackage1000_orangeBox_qty * orangePackage1000_orangeBox_DC) +
      (disposable_plate * orangePackage1000_disposable_plate_qty) +
      sealing_vinyl_D +
      sealing_machine;
  // 주황패키지 2000 가격
  static const orangePackage2000 =
      (150000 * orangePackage2000_orangeBox_qty) + // 패키지2000은 보온용기의 할인율이 정해져있지 않고 그냥 15만원에 맞춘느낌..
      (disposable_plate * orangePackage2000_disposable_plate_qty) +
      sealing_vinyl_D + sealing_machine;
  // 주황패키지 3000 가격
  static const orangePackage3000 =
      (orangeBox * orangePackage3000_orangeBox_qty * orangePackage3000_orangeBox_DC) +
      (disposable_plate * orangePackage3000_disposable_plate_qty) +
      (sealing_vinyl_D * orangePackage3000_sealing_vinyl_qty) +
      sealing_machine;
  // 한통식판 패키지 100 가격
  static const hantongPlatePackage100 =
      (orangeBox * hantongPlatePackage100_orangeBox_qty * hantongPlatePackage100_orangeBox_DC) +
      (hantong_plate * hantongPlatePackage100_hantong_plate_qty) +
      (50000 * hantongPlatePackage100_hantong_plate_lid_qty);
  // 한통식판 패키지 200 가격
  static const hantongPlatePackage200 =
      (150000 * hantongPlatePackage200_orangeBox_qty) +
      (hantong_plate * hantongPlatePackage200_hantong_plate_qty) +
      (50000 * hantongPlatePackage200_hantong_plate_lid_qty);
  // 한통식판 패키지 300 가격
  static const hantongPlatePackage300 =
      (orangeBox * hantongPlatePackage300_orangeBox_qty * hantongPlatePackage300_orangeBox_DC) +
      (hantong_plate * hantongPlatePackage300_hantong_plate_qty) +
      (50000 * hantongPlatePackage300_hantong_plate_lid_qty);
  // 영중소 패키지 111 가격
  static const smallBusinessPackage111 =
      (orangeBox * smallBusinessPackage111_orangeBox_qty) +
      (hantong_plate * smallBusinessPackage111_hantong_plate_qty) +
      (hantong_plate_lid * smallBusinessPackage111_hantong_plate_lid_qty) +
      (hantong_tray_10EA * smallBusinessPackage111_hantong_tray_qty);
  // 영중소 패키지 222 가격
  static const smallBusinessPackage222 =
      (orangeBox * smallBusinessPackage222_orangeBox_qty) +
      (hantong_plate * smallBusinessPackage222_hantong_plate_qty) +
      (50000 * smallBusinessPackage222_hantong_plate_lid_qty) +
      (hantong_tray_10EA * smallBusinessPackage222_hantong_tray_qty);
  // 영중소 패키지 333 가격
  static const smallBusinessPackage333 =
      (orangeBox * smallBusinessPackage333_orangeBox_qty) +
      (hantong_plate * smallBusinessPackage333_hantong_plate_qty) +
      (50000 * smallBusinessPackage333_hantong_plate_lid_qty) +
      (33000 * smallBusinessPackage333_hantong_tray_qty);
  // 한통식판 세트 가격
  static const hantongPlateSet =
    hantong_plate + 50000;

  // 한통뚝배기 210EA 코드 리스트
  static const hantong_ttukbaegi_cd_list = [
    Product.hantong_ttukbaegi_outer_24EA_cd,
    Product.hantong_ttukbaegi_inner_vessel_cd,
    Product.hantong_ttukbaegi_inner_lid_cd
  ];

  // 뚝배기내피 210EA 코드 리스트
  static const hantong_ttukbaegi_inner_cd_list = [
    Product.hantong_ttukbaegi_inner_vessel_cd,
    Product.hantong_ttukbaegi_inner_lid_cd
  ];

  // 주황패키지 코드 리스트
  static const orangePackage_cd_list = [
    Product.orangeBox_cd,
    Product.disposable_plate_cd,
    Product.sealing_vinyl_D_cd,
    Product.sealing_machine_cd
  ];

  // 한통식판 패키지 코드 리스트
  static const hantongPlatePackage_cd_list = [
    Product.orangeBox_cd,
    Product.hantong_plate_cd,
    Product.hantong_plate_lid_cd
  ];
  // 영중소 패키지 코드 리스트
  static const smallBusinessPackage_cd_list = [
    Product.orangeBox_cd,
    Product.hantong_plate_cd,
    Product.hantong_plate_lid_cd,
    Product.hantong_tray_10EA_cd
  ];
  // 한통식판세트 코드 리스트
  static const hantongPlateSet_cd_list = [
    Product.hantong_plate_cd,
    Product.hantong_plate_lid_cd
  ];

  // 한통뚝배기 210EA 갯수 리스트
  static const hantong_ttukbaegi_qty_list =[
    Product.hantong_ttukbaegi_outer_qty,
    Product.hantong_ttukbaegi_inner_vessel_qty,
    Product.hantong_ttukbaegi_inner_lid_qty,
  ];

  // 뚝배기내피 210EA 갯수 리스트
  static const hantong_ttukbaegi_inner_qty_list =[
    Product.hantong_ttukbaegi_inner_vessel_qty,
    Product.hantong_ttukbaegi_inner_lid_qty,
  ];

  // 주황패키지 1000 갯수 리스트
  static const orangePackage1000_qty_list = [
    Product.orangePackage1000_orangeBox_qty,
    Product.orangePackage1000_disposable_plate_qty,
    Product.orangePackage1000_sealing_vinyl_qty,
    Product.orangePackage1000_sealing_machine_qty
  ];

  // 주황패키지 2000 갯수 리스트
  static const orangePackage2000_qty_list = [
    Product.orangePackage2000_orangeBox_qty,
    Product.orangePackage2000_disposable_plate_qty,
    Product.orangePackage2000_sealing_vinyl_qty,
    Product.orangePackage2000_sealing_machine_qty
  ];

  // 주황패키지 3000 갯수 리스트
  static const orangePackage3000_qty_list = [
    Product.orangePackage3000_orangeBox_qty,
    Product.orangePackage3000_disposable_plate_qty,
    Product.orangePackage3000_sealing_vinyl_qty,
    Product.orangePackage3000_sealing_machine_qty
  ];

  // 한통식판 패키지 100 갯수 리스트
  static const hantongPlatePackage100_qty_list = [
    Product.hantongPlatePackage100_orangeBox_qty,
    Product.hantongPlatePackage100_hantong_plate_qty,
    Product.hantongPlatePackage100_hantong_plate_lid_qty,
  ];

  // 한통식판 패키지 200 갯수 리스트
  static const hantongPlatePackage200_qty_list = [
    Product.hantongPlatePackage200_orangeBox_qty,
    Product.hantongPlatePackage200_hantong_plate_qty,
    Product.hantongPlatePackage200_hantong_plate_lid_qty,
  ];
  // 한통식판 패키지 300 갯수 리스트
  static const hantongPlatePackage300_qty_list = [
    Product.hantongPlatePackage300_orangeBox_qty,
    Product.hantongPlatePackage300_hantong_plate_qty,
    Product.hantongPlatePackage300_hantong_plate_lid_qty,
  ];
  // 영중소 패키지 111 갯수 리스트
  static const smallBusinessPackage111_qty_list = [
    Product.smallBusinessPackage111_orangeBox_qty,
    Product.smallBusinessPackage111_hantong_plate_qty,
    Product.smallBusinessPackage111_hantong_plate_lid_qty,
    Product.smallBusinessPackage111_hantong_tray_qty
  ];
  // 영중소 패키지 222 갯수 리스트
  static const smallBusinessPackage222_qty_list = [
    Product.smallBusinessPackage222_orangeBox_qty,
    Product.smallBusinessPackage222_hantong_plate_qty,
    Product.smallBusinessPackage222_hantong_plate_lid_qty,
    Product.smallBusinessPackage222_hantong_tray_qty
  ];
  // 영중소 패키지 333 갯수 리스트
  static const smallBusinessPackage333_qty_list = [
    Product.smallBusinessPackage333_orangeBox_qty,
    Product.smallBusinessPackage333_hantong_plate_qty,
    Product.smallBusinessPackage333_hantong_plate_lid_qty,
    Product.smallBusinessPackage333_hantong_tray_qty
  ];
  // 한통식판세트 갯수 리스트
  static const hantongPlateSet_qty_list = [
    hantongPlateSet_hantong_plate_qty,
    hantongPlateSet_hantong_plate_lid_qty
  ];

  static const cj_list = [
    Product.multi_use_plate_cd,
    Product.disposable_plate_cd,
    Product.hantong_plate_cd,
    Product.hantong_plate_lid_cd
  ];

  static const hanjin_list = [
    Product.sealing_vinyl_A_cd,
    Product.sealing_vinyl_B_cd,
    Product.sealing_vinyl_C_cd,
    Product.sealing_vinyl_D_cd,
    Product.orangeBox_cd,
    Product.hantong_tray_10EA_cd,
    Product.hantong_tray_60EA_cd,
    Product.hantong_ttukbaegi_5EA_cd,
    Product.hantong_ttukbaegi_20EA_cd,
    Product.hantong_ttukbaegi_outer_24EA_cd,
    Product.hantong_ttukbaegi_carrier_2_cd,
    Product.hantong_ttukbaegi_carrier_4_cd,
    Product.paperBox_cd,
    Product.multi_use_plate_cd,
    Product.disposable_plate_cd,
    Product.hantong_ttukbaegi_inner_vessel_cd,
    Product.hantong_ttukbaegi_inner_lid_cd,
    Product.paperBox2_cd,
    Product.hantong_plate_cd,
    Product.hantong_plate_lid_cd
  ];

  static const gunyoung_list = [
    Product.sealing_machine_cd
  ];

  static const headOffice_list = [
    Product.sample_cd
  ];
}

// 물품 1개의 가격 (세금제외)
num calc_price(num pricePlusVat){
  num price = num.parse((pricePlusVat / 1.1).toStringAsFixed(10));
  return price;
}

// 주문한 갯수 만큼의 가격 (세금제외)
num calc_supply_amt(num pricePlusVat, num QTY) {
  num supply_amt = num.parse((pricePlusVat * QTY / 1.1).toStringAsFixed(0));
  return supply_amt;
}

// 주문한 갯수 만큼의 세금
num calc_vat_amt(num pricePlusVat, num QTY, num SUPPLY_AMT) {
  num var_amt = pricePlusVat * QTY - SUPPLY_AMT;
  return var_amt;
}

// 품목별 창고
String calc_courier (PROD_CD) {
  String calc_courier;

  if (Product.gunyoung_list.contains(PROD_CD)) {
    calc_courier = Product.gunyoung;
  } else if (Product.headOffice_list.contains(PROD_CD)) {
    calc_courier = Product.headOffice;
  } else if (Product.hanjin_list.contains(PROD_CD)) {
    calc_courier = Product.hanjin;
  }else if (Product.cj_list.contains(PROD_CD)){
    calc_courier = Product.cj;
  }

  return calc_courier;
}

// 품목별 배송비 계산
String calc_courier_fee (PROD_CD) {
  String courier_fee;

  if(Product.hanjin_fee_1_list.contains(PROD_CD)) {
    courier_fee = Product.hanjin_fee_1.toString();
  }else if(Product.hanjin_fee_2_list.contains(PROD_CD)){
    courier_fee = Product.hanjin_fee_2.toString();
  }else if(Product.hanjin_fee_3_list.contains(PROD_CD)){
    courier_fee = Product.hanjin_fee_3.toString();
  }else if(Product.gunyoung_fee_1_list.contains(PROD_CD)) {
    courier_fee = Product.gunyoung_fee_1.toString();
  }else if(Product.headOffice_list.contains(PROD_CD) && Product.headOffice_fee_1_list.contains(PROD_CD)){
    courier_fee = Product.headOffice_fee_1;
  }

  return courier_fee;
}

String calc_cj_courier_fee (PROD_CD) {
  String cj_courier_fee;

  if(Product.cj_fee_1_list.contains(PROD_CD)) {
    cj_courier_fee = Product.cj_fee_1.toString();
  }

  return cj_courier_fee;
}

// 최종 배송비 계산
String calc_P_REMARKS2_2 (P_REMARKS2_2, QTY) {
  String courier_fee;
  try{
    courier_fee = (num.parse(P_REMARKS2_2) * QTY).toString();
  }catch(e) {
    courier_fee = P_REMARKS2_2;
  }

  return courier_fee;
}


class Product_Info {
  String PROD_CD;           // 품목코드
  String PROD_DES;          // 품목명
  num QTY;                  // 수량
  num PricePlusVAT;         //
  num PRICE;                // 단가
  num SUPPLY_AMT;           // 공급가액
  num VAT_AMT;              // 부가세
  String P_REMARKS2_1;      // 창고
  String P_REMARKS2_2;      // 배송비

  Product_Info({
    this.PROD_CD,
    this.PROD_DES,
    this.QTY,
    this.PricePlusVAT,
    this.PRICE,
    this.SUPPLY_AMT,
    this.VAT_AMT,
    this.P_REMARKS2_1,
    this.P_REMARKS2_2
  });
}

class Product_Info_list {
  // 물품 정보 리스트
  final List<Product_Info> product_info = [
    // 실링비닐 A
    Product_Info(
        PROD_CD: Product.sealing_vinyl_A_cd,
        PROD_DES: Product.sealing_vinyl_A_name,
        PricePlusVAT: Product.sealing_vinyl_A,
        PRICE: calc_price(Product.sealing_vinyl_A),
        P_REMARKS2_1: calc_courier(Product.sealing_vinyl_A_cd),
        P_REMARKS2_2: calc_courier_fee(Product.sealing_vinyl_A_cd)
    ),
    // 실링비닐 B
    Product_Info(
        PROD_CD: Product.sealing_vinyl_B_cd,
        PROD_DES: Product.sealing_vinyl_B_name,
        PricePlusVAT: Product.sealing_vinyl_B,
        PRICE: calc_price(Product.sealing_vinyl_B),
        P_REMARKS2_1: calc_courier(Product.sealing_vinyl_B_cd),
        P_REMARKS2_2: calc_courier_fee(Product.sealing_vinyl_B_cd)
    ),
    // 실링비닐 C
    Product_Info(
        PROD_CD: Product.sealing_vinyl_C_cd,
        PROD_DES: Product.sealing_vinyl_C_name,
        PricePlusVAT: Product.sealing_vinyl_C,
        PRICE: calc_price(Product.sealing_vinyl_C),
        P_REMARKS2_1: calc_courier(Product.sealing_vinyl_C_cd),
        P_REMARKS2_2: calc_courier_fee(Product.sealing_vinyl_C_cd)
    ),
    // 실링비닐 D
    Product_Info(
        PROD_CD: Product.sealing_vinyl_D_cd,
        PROD_DES: Product.sealing_vinyl_D_name,
        PricePlusVAT: Product.sealing_vinyl_D,
        PRICE: calc_price(Product.sealing_vinyl_D),
        P_REMARKS2_1: calc_courier(Product.sealing_vinyl_D_cd),
        P_REMARKS2_2: calc_courier_fee(Product.sealing_vinyl_D_cd)
    ),
    // 주황보온용기
    Product_Info(
        PROD_CD: Product.orangeBox_cd,
        PROD_DES: Product.orangeBox_name,
        PricePlusVAT: Product.orangeBox,
        PRICE: calc_price(Product.orangeBox),
        P_REMARKS2_1: calc_courier(Product.orangeBox_cd),
        P_REMARKS2_2: calc_courier_fee(Product.orangeBox_cd)
    ),
    // 한통쟁반(10EA)
    Product_Info(
        PROD_CD: Product.hantong_tray_10EA_cd,
        PROD_DES: Product.hantong_tray_10EA_name,
        PricePlusVAT: Product.hantong_tray_10EA,
        PRICE: calc_price(Product.hantong_tray_10EA),
        P_REMARKS2_1: calc_courier(Product.hantong_tray_10EA_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_tray_10EA_cd)
    ),
    // 한통쟁반(60EA)
    Product_Info(
        PROD_CD: Product.hantong_tray_60EA_cd,
        PROD_DES: Product.hantong_tray_60EA_name,
        PricePlusVAT: Product.hantong_tray_60EA,
        PRICE: calc_price(Product.hantong_tray_60EA),
        P_REMARKS2_1: calc_courier(Product.hantong_tray_60EA_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_tray_60EA_cd)
    ),
    // 한통뚝배기 5EA세트
    Product_Info(
        PROD_CD: Product.hantong_ttukbaegi_5EA_cd,
        PROD_DES: Product.hantong_ttukbaegi_5EA_name,
        PricePlusVAT: Product.hantong_ttukbaegi_5EA,
        PRICE: calc_price(Product.hantong_ttukbaegi_5EA),
        P_REMARKS2_1: calc_courier(Product.hantong_ttukbaegi_5EA_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_ttukbaegi_5EA_cd)
    ),
    // 한통뚝배기 20EA세트
    Product_Info(
        PROD_CD: Product.hantong_ttukbaegi_20EA_cd,
        PROD_DES: Product.hantong_ttukbaegi_20EA_name,
        PricePlusVAT: Product.hantong_ttukbaegi_20EA,
        PRICE: calc_price(Product.hantong_ttukbaegi_20EA),
        P_REMARKS2_1: calc_courier(Product.hantong_ttukbaegi_20EA_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_ttukbaegi_20EA_cd)
    ),
    // 한통뚝배기 24EA 외부케이스
    Product_Info(
        PROD_CD: Product.hantong_ttukbaegi_outer_24EA_cd,
        PROD_DES: Product.hantong_ttukbaegi_outer_24EA_name,
        PricePlusVAT: Product.hantong_ttukbaegi_outer_24EA,
        PRICE: calc_price(Product.hantong_ttukbaegi_outer_24EA),
        P_REMARKS2_1: calc_courier(Product.hantong_ttukbaegi_outer_24EA_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_ttukbaegi_outer_24EA_cd)
    ),
    // 한통뚝배기캐리어2인용
    Product_Info(
        PROD_CD: Product.hantong_ttukbaegi_carrier_2_cd,
        PROD_DES: Product.hantong_ttukbaegi_carrier_2_name,
        PricePlusVAT: Product.hantong_ttukbaegi_carrier_2,
        PRICE: calc_price(Product.hantong_ttukbaegi_carrier_2),
        P_REMARKS2_1: calc_courier(Product.hantong_ttukbaegi_carrier_2_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_ttukbaegi_carrier_2_cd)
    ),
    // 한통뚝배기캐리어4인용
    Product_Info(
        PROD_CD: Product.hantong_ttukbaegi_carrier_4_cd,
        PROD_DES: Product.hantong_ttukbaegi_carrier_4_name,
        PricePlusVAT: Product.hantong_ttukbaegi_carrier_4,
        PRICE: calc_price(Product.hantong_ttukbaegi_carrier_4),
        P_REMARKS2_1: calc_courier(Product.hantong_ttukbaegi_carrier_4_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_ttukbaegi_carrier_4_cd)
    ),
    // 종이용기
    Product_Info(
        PROD_CD: Product.paperBox_cd,
        PROD_DES: Product.paperBox_name,
        PricePlusVAT: Product.paperBox,
        PRICE: calc_price(Product.paperBox),
        P_REMARKS2_1: calc_courier(Product.paperBox_cd),
        P_REMARKS2_2: calc_courier_fee(Product.paperBox_cd)
    ),
    // 다회용식판(검정색)
    Product_Info(
        PROD_CD: Product.multi_use_plate_cd,
        PROD_DES: Product.multi_use_plate_name,
        PricePlusVAT: Product.multi_use_plate,
        PRICE: calc_price(Product.multi_use_plate),
        P_REMARKS2_1: calc_courier(Product.multi_use_plate_cd),
        P_REMARKS2_2: calc_courier_fee(Product.multi_use_plate_cd)
    ),
    // 일회용식판(흰색)신형
    Product_Info(
        PROD_CD: Product.disposable_plate_cd,
        PROD_DES: Product.disposable_plate_name,
        PricePlusVAT: Product.disposable_plate,
        PRICE: calc_price(Product.disposable_plate),
        P_REMARKS2_1: calc_courier(Product.disposable_plate_cd),
        P_REMARKS2_2: calc_courier_fee(Product.disposable_plate_cd)
    ),
    // 한통뚝배기 내피용기
    Product_Info(
        PROD_CD: Product.hantong_ttukbaegi_inner_vessel_cd,
        PROD_DES: Product.hantong_ttukbaegi_inner_vessel_name,
        PricePlusVAT: Product.hantong_ttukbaegi_inner_vessel,
        PRICE: calc_price(Product.hantong_ttukbaegi_inner_vessel),
        P_REMARKS2_1: calc_courier(Product.hantong_ttukbaegi_inner_vessel_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_ttukbaegi_inner_vessel_cd)
    ),
    // 한통뚝배기 내피뚜껑
    Product_Info(
        PROD_CD: Product.hantong_ttukbaegi_inner_lid_cd,
        PROD_DES: Product.hantong_ttukbaegi_inner_lid_name,
        PricePlusVAT: Product.hantong_ttukbaegi_inner_lid,
        PRICE: calc_price(Product.hantong_ttukbaegi_inner_lid),
        P_REMARKS2_1: calc_courier(Product.hantong_ttukbaegi_inner_lid_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_ttukbaegi_inner_lid_cd)
    ),
    // (샘플)2종식판+주황보온용기세트
    Product_Info(
        PROD_CD: Product.sample_cd,
        PROD_DES: Product.sample_name,
        PricePlusVAT: Product.sample,
        PRICE: calc_price(Product.sample),
        P_REMARKS2_1: calc_courier(Product.sample_cd),
        P_REMARKS2_2: calc_courier_fee(Product.sample_cd)
    ),
    // 실링기계(TY-PCB)
    Product_Info(
        PROD_CD: Product.sealing_machine_cd,
        PROD_DES: Product.sealing_machine_name,
        PricePlusVAT: Product.sealing_machine,
        PRICE: calc_price(Product.sealing_machine),
        P_REMARKS2_1: calc_courier(Product.sealing_machine_cd),
        P_REMARKS2_2: calc_courier_fee(Product.sealing_machine_cd)
    ),
    // 택배비3,000
    Product_Info(
        PROD_CD: Product.courier_fee_3000_cd,
        PROD_DES: Product.courier_fee_3000_name,
        PricePlusVAT: Product.courier_fee_3000,
        PRICE: calc_price(Product.courier_fee_3000),
        P_REMARKS2_1: calc_courier(Product.courier_fee_3000_cd),
        P_REMARKS2_2: calc_courier_fee(Product.courier_fee_3000_cd)
    ),
    // 택배비5,000
    Product_Info(
        PROD_CD: Product.courier_fee_5000_cd,
        PROD_DES: Product.courier_fee_5000_name,
        PricePlusVAT: Product.courier_fee_5000,
        PRICE: calc_price(Product.courier_fee_5000),
        P_REMARKS2_1: calc_courier(Product.courier_fee_5000_cd),
        P_REMARKS2_2: calc_courier_fee(Product.courier_fee_5000_cd)
    ),
    // 택배비8,000
    Product_Info(
        PROD_CD: Product.courier_fee_8000_cd,
        PROD_DES: Product.courier_fee_8000_name,
        PricePlusVAT: Product.courier_fee_8000,
        PRICE: calc_price(Product.courier_fee_8000),
        P_REMARKS2_1: calc_courier(Product.courier_fee_8000_cd),
        P_REMARKS2_2: calc_courier_fee(Product.courier_fee_8000_cd)
    ),
    // 퀵배송45,000
    Product_Info(
        PROD_CD: Product.courier_fee_quick_cd,
        PROD_DES: Product.courier_fee_quick_name,
        PricePlusVAT: Product.courier_fee_quick,
        PRICE: calc_price(Product.courier_fee_quick),
        P_REMARKS2_1: calc_courier(Product.courier_fee_quick_cd),
        P_REMARKS2_2: calc_courier_fee(Product.courier_fee_quick_cd)
    ),
    // 5% 할인
    Product_Info(
        PROD_CD: Product.DC_5p_cd,
        PROD_DES: Product.DC_5p_name
    ),
    // 종이용기(신형)
    Product_Info(
        PROD_CD: Product.paperBox2_cd,
        PROD_DES: Product.paperBox2_name,
        PricePlusVAT: Product.paperBox2,
        PRICE: calc_price(Product.paperBox2),
        P_REMARKS2_1: calc_courier(Product.paperBox2_cd),
        P_REMARKS2_2: calc_courier_fee(Product.paperBox2_cd)
    ),
    // 한통식판본체
    Product_Info(
        PROD_CD: Product.hantong_plate_cd,
        PROD_DES: Product.hantong_plate_name,
        PricePlusVAT: Product.hantong_plate,
        PRICE: calc_price(Product.hantong_plate),
        P_REMARKS2_1: calc_courier(Product.hantong_plate_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_plate_cd)
    ),
    // 한통식판뚜껑
    Product_Info(
        PROD_CD: Product.hantong_plate_lid_cd,
        PROD_DES: Product.hantong_plate_lid_name,
        PricePlusVAT: Product.hantong_plate_lid,
        PRICE: calc_price(Product.hantong_plate_lid),
        P_REMARKS2_1: calc_courier(Product.hantong_plate_lid_cd),
        P_REMARKS2_2: calc_courier_fee(Product.hantong_plate_lid_cd)
    )

  ];
}


// 숫자 사이에 ,찍기
String numberWithComma(num param){
  return new NumberFormat('#,###').format(param);
}
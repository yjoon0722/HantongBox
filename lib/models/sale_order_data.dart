
/*
 * 담당자코드(ERP 담당자코드)
 * 필수항목설정 되어 있으면 반드시 입력해야 함.(재고1 > 영업관리 > 주문서입력 > 옵션 > 입력화면설정 > 상단탭에서 설정 가능)
*/
import 'package:hantong_cal/models/keypad.dart';
import 'package:hantong_cal/models/product.dart';

final List<Map<String, String>> EMP_CD_MAP = [
  {"00000":"담당자를 선택하세요."},
  {"00013":"김대성"},
  {"00021":"안정윤"},
  {"00018":"염예진"},
  {"00022":"이강주"},
  {"00011":"채수봉"}
];

/*
 * 구분(거래유형)
 * 부가세유형코드 입력
 * Self-Customizing > 환경설정 > 기능설정 > 공통탭 > 재고-부가세 설정 > 거래유형별 설정에 유형코드 참조
 * 미 입력시 기본값 입력됨
 * 재고1> 영업관리 > (주문서, 견적서, 판매)입력 > 옵션 > 입력화면설정 > 상단탭에서 반드시 항목설정이 되어있어야 함.
*/
final List<Map<String, String>> IO_TYPE_MAP = [
  {"00000" : "거래유형을 선택하세요."},
  {"11":"부가세율 적용"},
  {"12":"부가세율 미적용"},
];

/*
 * 출하창고
 * 출하창고코드(ERP 창고코드)
*/
final List<Map<String, String>> WH_CD_MAP = [
  {"00000":"창고를 선택하세요."},
  {"00004":"(주)준테크피에스와이"},
  {"00008":"(주)지피에스코리아"},
  {"00009":"본사물류센터(고려포장)"},
  {"00002":"실링기계(오성산업)"},
  {"00003":"실링기계(태영엔텍)"},
  {"00010":"일산본사"},
];

/*
 * 결제조건
 * 필수항목설정 되어 있으면 반드시 입력해야 함.(재고1 > 영업관리 > 주문서입력 > 옵션 > 입력화면설정 > 상단탭에서 설정 가능)
*/
final List<Map<String, String>> COLL_TERM_MAP = [
  {"00000":"결제조건을 선택하세요."},
  {"0":"없음"},
  {"1":"현금"},
  {"2":"법인카드"},
  {"3":"스토어"},
  {"4":"소매"}
];

/*
 * 품목코드
 * 품목코드(ERP품목코드)
*/
final List<Map<String, String>> PROD_CD_MAP = [
  // {"DC001": "PP보온용기할인"},
  // {"DC002": "일회용식판할인"},
  // {"DC003": "다회용식판할인"},
  // {"DC004": "실링비닐할인"},
  // {"DC005": "종이용기할인"},
  {"DC006": "5%할인","PRICE" : ""},
  // {"DC007": "할인"},
  // {"DC008": "현금/카드분할결제"},
  {"EPL001": "실링비닐A","PRICE" : "144000"},
  {"EPL004": "실링비닐B","PRICE" : "144000"},
  {"EPL006": "실링비닐C","PRICE" : "144000"},
  {"EPL007": "실링비닐D","PRICE" : "144000"},
  {"EPP01": "주황보온용기","PRICE" : "198000"},
  // {"EPP02": "노랑보온용기"},
  {"EPP03": "한통쟁반(60EA)","PRICE" : "198000"},
  {"EPP04": "한통쟁반(10EA)","PRICE" : "40000"},
  // {"EPS002": "한통뚝배기 외부케이스"},
  {"EPS003": "한통뚝배기 5EA세트","PRICE" : "9600"},
  {"EPS004": "한통뚝배기 20EA세트","PRICE" : "38400"},
  {"EPS006": "한통뚝배기 24EA 외부케이스","PRICE" : "35000"},
  // {"EPS01": "회색보온용기"},
  {"HDPE02": "한통뚝배기캐리어4인용","PRICE" : "20000"},
  {"HDPE04": "한통뚝배기캐리어2인용","PRICE" : "15000"},
  {"parcel1": "택배비5,000","PRICE" : "5000"},
  {"parcel2": "택배비8,000","PRICE" : "8000"},
  {"parcel3": "퀵배송45,000","PRICE" : "45000"},
  {"parcel4": "택배비3,000","PRICE" : "3000"},
  // {"parcelbox_01": "보온용기택배박스(카톤)"},
  // {"parcelbox_02": "한통뚝배기택배박스(소포장)"},
  // {"parcelbox_03": "한통뚝배기택배박스(대포장)"},
  // {"parcelbox_04": "한통쟁반택배박스(소포장)"},
  // {"PBOX01": "종이용기(팩스타-단종)"},
  {"PBOX03": "종이용기","PRICE" : "60000"},
  {"PBOX04": "종이용기(신형)","PRICE" : "60000"},
  {"PP01": "다회용식판(검정색)","PRICE" : "250000"},
  {"PP02": "한통식판뚜껑", "PRICE" : "60000"},
  {"PP03": "한통식판본체", "PRICE" : "60000"},
  {"PP04": "일회용식판(흰색)신형","PRICE" : "150000"},
  {"PP05": "한통뚝배기 내피용기","PRICE" : "42000"},
  {"PP06": "한통뚝배기 내피뚜껑","PRICE" : "42000"},
  // {"PP07": "한통뚝배기(내피)_폴리백"},
  // {"REPAIR": "실링기계수리"},
  // {"SAMP01": "샘플"},
  // {"SAMP02": "실링비닐샘플 [245*200]"},
  {"SAMP03": "실링비닐샘플(TY80)"},
  // {"SAMP04": "실링비닐샘플(AP60)"},
  // {"SAMP05": "(샘플)2종식판+종이용기세트"},
  {"SAMP06": "(샘플)2종식판+주황보온용기세트","PRICE" : "30000"},
  // {"SEAL01": "M4-도시락(실링기계)"},
  // {"SEAL02": "실링기계(TY-350)"},
  {"SEAL03": "실링기계(TY-PCB)","PRICE" : "1300000"},
];


/*
 * 창고
*/
final List<Map<String, String>> WARE_HOUSE_MAP = [
  {"00000": ""},
  {"00002": "고려"},
  {"00003": "건영"},
  {"00004": "본사"},
];

final List<Map<String, String>> WARE_HOUSE_MAP_CJ = [
  {"00000": ""},
  {"00001": "준테크"},
  {"00002": "고려"},
  {"00003": "건영"},
  {"00004": "본사"},
];

final List<Map<String, String>> WARE_HOUSE_MAP_HEADOFFICE = [
  {"00000": ""},
  {"00004": "본사"},
];

final List<Map<String, String>> WARE_HOUSE_MAP_GUNYOUNG = [
  {"00000": ""},
  {"00003": "건영"},
  {"00004": "본사"},
];

const KPAD_INDEX_OrangeBox4Plus1 = 8;
const KPAD_INDEX_HantongPlateSet = 11;
const KPAD_INDEX_Ttugbaegi_210 = 17;
const KPAD_INDEX_Ttugbaegi_inner_210  = 18;
const KPAD_INDEX_OrangePackage_1 = 21;
const KPAD_INDEX_OrangePackage_2 = 22;
const KPAD_INDEX_OrangePackage_3 = 23;

const KPAD_INDEX_HantongPlate_1 = 24;
const KPAD_INDEX_HantongPlate_2 = 25;
const KPAD_INDEX_HantongPlate_3 = 26;

const KPAD_INDEX_SmallBusiness_1 = 27;
const KPAD_INDEX_SmallBusiness_2 = 28;
const KPAD_INDEX_SmallBusiness_3 = 29;

const KPAD_INDEX_Sample_Free = 34;
const KPAD_INDEX_DC_5p = 35;

// ProductInfoList
List<Product_Info> getProductInfoListWithOrderList(List<Keypad> order) {
  List<Product_Info> prodInfoList = [];

  if (order == null) { return prodInfoList; }

  try {
    List<Product_Info> prodInfo = new Product_Info_list().product_info;

    for (var i = 0; i < order.length; i++) {
      var ID = order[i].id;
      num pricePlusVat = order[i].price;
      int QTY = order[i].quantity;
      String PROD_CD = order[i].PROD_CD;
      int count_Components = order[i].count_Components;
      // -----------------------------------------
      num SET_QTY;
      num PRICE;
      num SUPPLY_AMT;
      num VAT_AMT;
      String P_REMARKS2_2;

      switch (ID) {
        case KPAD_INDEX_OrangeBox4Plus1:  // 주황보온용기 4+1
        case KPAD_INDEX_HantongPlateSet:
        case KPAD_INDEX_Ttugbaegi_210: // 한통뚝배기 210EA
        case KPAD_INDEX_Ttugbaegi_inner_210: // 뚝배기내피 210EA
        case KPAD_INDEX_OrangePackage_1: // 주황패키지 1000
        case KPAD_INDEX_OrangePackage_2: // 주황패키지 2000
        case KPAD_INDEX_OrangePackage_3: // 주황패키지 3000
        case KPAD_INDEX_HantongPlate_1: // 한통식판 패키지 100
        case KPAD_INDEX_HantongPlate_2: // 한통식판 패키지 200
        case KPAD_INDEX_HantongPlate_3: // 한통식판 패키지 300
        case KPAD_INDEX_SmallBusiness_1: // 영중소 패키지 111
        case KPAD_INDEX_SmallBusiness_2: // 영중소 패키지 222
        case KPAD_INDEX_SmallBusiness_3: // 영중소 패키지 333
          for (var j = 0; j < count_Components; j++) {
            PROD_CD =
            ID == KPAD_INDEX_OrangeBox4Plus1 ? Product.orangeBox_cd :
            ID == KPAD_INDEX_Ttugbaegi_210 ? Product.hantong_ttukbaegi_cd_list[j] :
            ID == KPAD_INDEX_Ttugbaegi_inner_210 ? Product.hantong_ttukbaegi_inner_cd_list[j] :
            ID == KPAD_INDEX_OrangePackage_1 || ID == KPAD_INDEX_OrangePackage_2 || ID == KPAD_INDEX_OrangePackage_3 ? Product.orangePackage_cd_list[j] :
            ID == KPAD_INDEX_HantongPlateSet ? Product.hantongPlateSet_cd_list[j] :
            ID == KPAD_INDEX_HantongPlate_1 || ID == KPAD_INDEX_HantongPlate_2 || ID == KPAD_INDEX_HantongPlate_3 ? Product.hantongPlatePackage_cd_list[j] :
            ID == KPAD_INDEX_SmallBusiness_1 || ID == KPAD_INDEX_SmallBusiness_2 || ID == KPAD_INDEX_SmallBusiness_3 ? Product.smallBusinessPackage_cd_list[j] : null;

            SET_QTY =
            ID == KPAD_INDEX_OrangeBox4Plus1 ? Product.orangeBox4plus1_qty * QTY :
            ID == KPAD_INDEX_Ttugbaegi_210 ? Product.hantong_ttukbaegi_qty_list[j] * QTY :
            ID == KPAD_INDEX_Ttugbaegi_inner_210 ? Product.hantong_ttukbaegi_inner_qty_list[j] * QTY :
            ID == KPAD_INDEX_OrangePackage_1 ? Product.orangePackage1000_qty_list[j] * QTY :
            ID == KPAD_INDEX_OrangePackage_2 ? Product.orangePackage2000_qty_list[j] * QTY :
            ID == KPAD_INDEX_OrangePackage_3 ? Product.orangePackage3000_qty_list[j] * QTY :
            ID == KPAD_INDEX_HantongPlateSet ? Product.hantongPlateSet_qty_list[j] * QTY :
            ID == KPAD_INDEX_HantongPlate_1 ? Product.hantongPlatePackage100_qty_list[j] * QTY :
            ID == KPAD_INDEX_HantongPlate_2 ? Product.hantongPlatePackage200_qty_list[j] * QTY :
            ID == KPAD_INDEX_HantongPlate_3 ? Product.hantongPlatePackage300_qty_list[j] * QTY :
            ID == KPAD_INDEX_SmallBusiness_1 ? Product.smallBusinessPackage111_qty_list[j] * QTY :
            ID == KPAD_INDEX_SmallBusiness_2 ? Product.smallBusinessPackage222_qty_list[j] * QTY :
            ID == KPAD_INDEX_SmallBusiness_3 ? Product.smallBusinessPackage333_qty_list[j] * QTY : null;

            for (var k = 0; k < prodInfo.length; k++) {
              if (PROD_CD == prodInfo[k].PROD_CD) {
                pricePlusVat =
                ID == KPAD_INDEX_OrangeBox4Plus1 ? Product.orangeBox4plus1 / Product.orangeBox4plus1_qty :
                ID == KPAD_INDEX_Ttugbaegi_210 ? Product.hantong_ttukbaegi_list[j] :
                ID == KPAD_INDEX_Ttugbaegi_inner_210 ? Product.hantong_ttukbaegi_inner_list[j] :
                ID == KPAD_INDEX_OrangePackage_1 ? Product.orangePackage1000_list[j] :
                ID == KPAD_INDEX_OrangePackage_2 ? Product.orangePackage2000_list[j] :
                ID == KPAD_INDEX_OrangePackage_3 ? Product.orangePackage3000_list[j] :
                ID == KPAD_INDEX_HantongPlateSet ? Product.hantongPlateSet_list[j]:
                ID == KPAD_INDEX_HantongPlate_1 ? Product.hantongPlatePackage100_list[j]:
                ID == KPAD_INDEX_HantongPlate_2 ? Product.hantongPlatePackage200_list[j]:
                ID == KPAD_INDEX_HantongPlate_3 ? Product.hantongPlatePackage300_list[j]:
                ID == KPAD_INDEX_SmallBusiness_1 ? Product.smallBusinessPackage111_list[j]:
                ID == KPAD_INDEX_SmallBusiness_2 ? Product.smallBusinessPackage222_list[j]:
                ID == KPAD_INDEX_SmallBusiness_3 ? Product.smallBusinessPackage333_list[j]: null;

                PRICE = calc_price(pricePlusVat);
                SUPPLY_AMT = calc_supply_amt(pricePlusVat, SET_QTY);
                VAT_AMT = calc_vat_amt(pricePlusVat, SET_QTY, SUPPLY_AMT);
                P_REMARKS2_2 = calc_P_REMARKS2_2(prodInfo[k].P_REMARKS2_2, SET_QTY);

                prodInfoList.add(
                    Product_Info(
                        PROD_CD : prodInfo[k].PROD_CD,                    // 품목코드
                        PROD_DES : prodInfo[k].PROD_DES,                  // 품목명
                        QTY : SET_QTY,                                    // 수량
                        PricePlusVAT : pricePlusVat,                      // VAT 포함금액
                        PRICE : PRICE,                                    // 단가
                        SUPPLY_AMT : SUPPLY_AMT,                          // 공급가액
                        VAT_AMT : VAT_AMT,                                // 부가세
                        P_REMARKS2_1 : prodInfo[k].P_REMARKS2_1,          // 배송비 (창고)
                        // P_REMARKS2_2 : P_REMARKS2_2                       // 배송비 (금액)
                        P_REMARKS2_2 : ""                       // 배송비 (금액)
                    )
                );
              }
            }
          }
          break;

        case KPAD_INDEX_Sample_Free: // 무료샘플
          for (var k = 0; k < prodInfo.length; k++) {
            if(PROD_CD == prodInfo[k].PROD_CD) {
              prodInfoList.add(
                  Product_Info(
                      PROD_CD : prodInfo[k].PROD_CD,                // 품목코드
                      PROD_DES : prodInfo[k].PROD_DES,              // 품목명
                      QTY : QTY,                                    // 수량
                      PricePlusVAT : 0,                             // VAT 포함금액
                      PRICE : 0,                                    // 단가
                      SUPPLY_AMT : 0,                               // 공급가액
                      VAT_AMT : 0,                                  // 부가세
                      P_REMARKS2_1 : prodInfo[k].P_REMARKS2_1,      // 배송비 (창고)
                      P_REMARKS2_2 : Product.headOffice_fee_2       // 배송비 (금액)
                  )
              );
            }
          }
          break;

        case KPAD_INDEX_DC_5p: // 할인 5%
          for (var k = 0; k < prodInfo.length; k++) {
            if(PROD_CD == prodInfo[k].PROD_CD) {
              PRICE = calc_supply_amt(pricePlusVat, 1);
              SUPPLY_AMT = calc_supply_amt(pricePlusVat, QTY);
              VAT_AMT = calc_vat_amt(pricePlusVat, QTY, SUPPLY_AMT);

              prodInfoList.add(
                  Product_Info(
                    PROD_CD : prodInfo[k].PROD_CD,               // 품목코드
                    PROD_DES : prodInfo[k].PROD_DES,             // 품목명
                    QTY : QTY,                                   // 수량
                    PricePlusVAT: pricePlusVat,                  // VAT 포함금액
                    PRICE: PRICE,                                // 단가
                    SUPPLY_AMT: SUPPLY_AMT,                      // 공급가액
                    VAT_AMT: VAT_AMT                             // 부가세
                  )
              );
            }
          }
          break;

        default:
          for (var k = 0; k < prodInfo.length; k++) {
            if (PROD_CD == prodInfo[k].PROD_CD) {
              pricePlusVat = prodInfo[k].PricePlusVAT;
              PRICE = calc_price(pricePlusVat);
              SUPPLY_AMT = calc_supply_amt(pricePlusVat, QTY);
              VAT_AMT = calc_vat_amt(pricePlusVat, QTY, SUPPLY_AMT);
              P_REMARKS2_2 = calc_P_REMARKS2_2(prodInfo[k].P_REMARKS2_2, QTY);

              prodInfoList.add(
                  Product_Info(
                      PROD_CD : prodInfo[k].PROD_CD,                // 품목코드
                      PROD_DES : prodInfo[k].PROD_DES,              // 품목명
                      QTY : QTY,                                    // 수량
                      PricePlusVAT : pricePlusVat,                  // VAT 포함금액
                      PRICE : PRICE,                                // 단가
                      SUPPLY_AMT : SUPPLY_AMT,                      // 공급가액
                      VAT_AMT : VAT_AMT,                            // 부가세
                      P_REMARKS2_1 : prodInfo[k].P_REMARKS2_1,      // 배송비 (창고)
                      // P_REMARKS2_2 : P_REMARKS2_2                   // 배송비 (금액)
                      P_REMARKS2_2 : ""                   // 배송비 (금액)
                  )
              );
            }
          }
          break;
      }
    }

    print("order_count = ${order.length}");
    for(int i = 0 ; i < prodInfoList.length; i++){
      print("""
        PROD_CD : ${prodInfoList[i].PROD_CD}
        PROD_DES : ${prodInfoList[i].PROD_DES}
        QTY : ${prodInfoList[i].QTY}
        PricePlusVAT : ${prodInfoList[i].PricePlusVAT}
        PRICE : ${prodInfoList[i].PRICE}
        SUPPLY_AMT : ${prodInfoList[i].SUPPLY_AMT}
        VAT_AMT : ${prodInfoList[i].VAT_AMT}
        P_REMARKS2_1 : ${prodInfoList[i].P_REMARKS2_1}
        P_REMARKS2_2 : ${prodInfoList[i].P_REMARKS2_2}
      """);
    }
  } catch (ex) {
    print("Error: $ex");
  }

  return prodInfoList;
}


import 'package:flutter/foundation.dart';

class BulksData {
  String CUST;
  String EMP_CD;
  String WH_CD;
  String COLL_TERM;
  String TIME_DATE;
  String PROD_CD;
  String QTY;
  String PRICE;
  String SUPPLY_AMT;
  String VAT_AMT;
  String ITEM_TIME_DATE;
  String P_REMARKS2;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  BulksData({
    @required this.CUST,
    @required this.EMP_CD,
    @required this.WH_CD,
    @required this.COLL_TERM,
    @required this.TIME_DATE,
    @required this.PROD_CD,
    @required this.QTY,
    @required this.PRICE,
    @required this.SUPPLY_AMT,
    @required this.VAT_AMT,
    @required this.ITEM_TIME_DATE,
    @required this.P_REMARKS2,
  });

  BulksData copyWith({
    String CUST,
    String EMP_CD,
    String WH_CD,
    String COLL_TERM,
    String TIME_DATE,
    String PROD_CD,
    String QTY,
    String PRICE,
    String SUPPLY_AMT,
    String VAT_AMT,
    String ITEM_TIME_DATE,
    String P_REMARKS2,
  }) {
    return new BulksData(
      CUST: CUST ?? this.CUST,
      EMP_CD: EMP_CD ?? this.EMP_CD,
      WH_CD: WH_CD ?? this.WH_CD,
      COLL_TERM: COLL_TERM ?? this.COLL_TERM,
      TIME_DATE: TIME_DATE ?? this.TIME_DATE,
      PROD_CD: PROD_CD ?? this.PROD_CD,
      QTY: QTY ?? this.QTY,
      PRICE: PRICE ?? this.PRICE,
      SUPPLY_AMT: SUPPLY_AMT ?? this.SUPPLY_AMT,
      VAT_AMT: VAT_AMT ?? this.VAT_AMT,
      ITEM_TIME_DATE: ITEM_TIME_DATE ?? this.ITEM_TIME_DATE,
      P_REMARKS2: P_REMARKS2 ?? this.P_REMARKS2,
    );
  }

  @override
  String toString() {
    return 'BulksData{CUST: $CUST, EMP_CD: $EMP_CD, WH_CD: $WH_CD, COLL_TERM: $COLL_TERM, TIME_DATE: $TIME_DATE, PROD_CD: $PROD_CD, QTY: $QTY, PRICE: $PRICE, SUPPLY_AMT: $SUPPLY_AMT, VAT_AMT: $VAT_AMT, ITEM_TIME_DATE: $ITEM_TIME_DATE, P_REMARKS2: $P_REMARKS2}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BulksData &&
          runtimeType == other.runtimeType &&
          CUST == other.CUST &&
          EMP_CD == other.EMP_CD &&
          WH_CD == other.WH_CD &&
          COLL_TERM == other.COLL_TERM &&
          TIME_DATE == other.TIME_DATE &&
          PROD_CD == other.PROD_CD &&
          QTY == other.QTY &&
          PRICE == other.PRICE &&
          SUPPLY_AMT == other.SUPPLY_AMT &&
          VAT_AMT == other.VAT_AMT &&
          ITEM_TIME_DATE == other.ITEM_TIME_DATE &&
          P_REMARKS2 == other.P_REMARKS2);

  @override
  int get hashCode =>
      CUST.hashCode ^
      EMP_CD.hashCode ^
      WH_CD.hashCode ^
      COLL_TERM.hashCode ^
      TIME_DATE.hashCode ^
      PROD_CD.hashCode ^
      QTY.hashCode ^
      PRICE.hashCode ^
      SUPPLY_AMT.hashCode ^
      VAT_AMT.hashCode ^
      ITEM_TIME_DATE.hashCode ^
      P_REMARKS2.hashCode;

  factory BulksData.fromMap(Map<String, dynamic> map) {
    return new BulksData(
      CUST: map['CUST'] as String,
      EMP_CD: map['EMP_CD'] as String,
      WH_CD: map['WH_CD'] as String,
      COLL_TERM: map['COLL_TERM'] as String,
      TIME_DATE: map['TIME_DATE'] as String,
      PROD_CD: map['PROD_CD'] as String,
      QTY: map['QTY'] as String,
      PRICE: map['PRICE'] as String,
      SUPPLY_AMT: map['SUPPLY_AMT'] as String,
      VAT_AMT: map['VAT_AMT'] as String,
      ITEM_TIME_DATE: map['ITEM_TIME_DATE'] as String,
      P_REMARKS2: map['P_REMARKS2'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'CUST': this.CUST,
      'EMP_CD': this.EMP_CD,
      'WH_CD': this.WH_CD,
      'COLL_TERM': this.COLL_TERM,
      'TIME_DATE': this.TIME_DATE,
      'PROD_CD': this.PROD_CD,
      'QTY': this.QTY,
      'PRICE': this.PRICE,
      'SUPPLY_AMT': this.SUPPLY_AMT,
      'VAT_AMT': this.VAT_AMT,
      'ITEM_TIME_DATE': this.ITEM_TIME_DATE,
      'P_REMARKS2': this.P_REMARKS2,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
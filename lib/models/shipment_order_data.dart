import 'package:flutter/foundation.dart';

class ShipmentOrderData {
  String doc_no;		      // 주문번호
  String prod_des;		    // 품목명
  String doc_qty;		      // 주문상품수량
  String doc_name;		    // 주문자이름
  String doc_telephone;		// 주문자전화
  String doc_cellphone;		// 주문자핸드폰
  String cust_name;		    // 수취인이름
  String cust_telephone;	// 수취인전화
  String cust_cellphone;	// 수취인핸드폰
  String cust_zip;		    // 주소2 우편번호
  String cust_address;		// 주소2
  String track_id;		    // 송장번호
  String track_memo;		  // 배송메시지
  String p_remarks2;      // 배송비
  bool isCheck;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  ShipmentOrderData({
    this.doc_no,
    this.prod_des,
    this.doc_qty,
    this.doc_name,
    this.doc_telephone,
    this.doc_cellphone,
    this.cust_name,
    this.cust_telephone,
    this.cust_cellphone,
    this.cust_zip,
    this.cust_address,
    this.track_id,
    this.track_memo,
    this.p_remarks2,
    this.isCheck
  });

  ShipmentOrderData copyWith({
    String doc_no,
    String prod_des,
    String doc_qty,
    String doc_name,
    String doc_telephone,
    String doc_cellphone,
    String cust_name,
    String cust_telephone,
    String cust_cellphone,
    String cust_zip,
    String cust_address,
    String track_id,
    String track_memo,
    String p_remarks2,
    bool isCheck
  }) {
    return new ShipmentOrderData(
      doc_no: doc_no ?? this.doc_no,
      prod_des: prod_des ?? this.prod_des,
      doc_qty: doc_qty ?? this.doc_qty,
      doc_name: doc_name ?? this.doc_name,
      doc_telephone: doc_telephone ?? this.doc_telephone,
      doc_cellphone: doc_cellphone ?? this.doc_cellphone,
      cust_name: cust_name ?? this.cust_name,
      cust_telephone: cust_telephone ?? this.cust_telephone,
      cust_cellphone: cust_cellphone ?? this.cust_cellphone,
      cust_zip: cust_zip ?? this.cust_zip,
      cust_address: cust_address ?? this.cust_address,
      track_id: track_id ?? this.track_id,
      track_memo: track_memo ?? this.track_memo,
      p_remarks2: p_remarks2 ?? this.p_remarks2,
      isCheck: isCheck ?? this.isCheck,
    );
  }

  @override
  String toString() {
    return 'ShipmentOrderData{doc_no: $doc_no, prod_des: $prod_des, doc_qty: $doc_qty, doc_name: $doc_name, doc_telephone: $doc_telephone, doc_cellphone: $doc_cellphone, cust_name: $cust_name, cust_telephone: $cust_telephone, cust_cellphone: $cust_cellphone, cust_zip: $cust_zip, cust_address: $cust_address, track_id: $track_id, track_memo: $track_memo, p_remarks2: $p_remarks2, isCheck: $isCheck}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ShipmentOrderData &&
              runtimeType == other.runtimeType &&
              doc_no == other.doc_no &&
              prod_des == other.prod_des &&
              doc_qty == other.doc_qty &&
              doc_name == other.doc_name &&
              doc_telephone == other.doc_telephone &&
              doc_cellphone == other.doc_cellphone &&
              cust_name == other.cust_name &&
              cust_telephone == other.cust_telephone &&
              cust_cellphone == other.cust_cellphone &&
              cust_zip == other.cust_zip &&
              cust_address == other.cust_address &&
              track_id == other.track_id &&
              track_memo == other.track_memo &&
              p_remarks2 == other.p_remarks2 &&
              isCheck == other.isCheck);

  @override
  int get hashCode =>
      doc_no.hashCode ^
      prod_des.hashCode ^
      doc_qty.hashCode ^
      doc_name.hashCode ^
      doc_telephone.hashCode ^
      doc_cellphone.hashCode ^
      cust_name.hashCode ^
      cust_telephone.hashCode ^
      cust_cellphone.hashCode ^
      cust_zip.hashCode ^
      cust_address.hashCode ^
      track_id.hashCode ^
      track_memo.hashCode ^
      p_remarks2.hashCode ^
      isCheck.hashCode;

  factory ShipmentOrderData.fromMap(Map<String, dynamic> map) {
    return new ShipmentOrderData(
      doc_no: map['doc_no'] as String,
      prod_des: map['prod_des'] as String,
      doc_qty: map['doc_qty'] as String,
      doc_name: map['doc_name'] as String,
      doc_telephone: map['doc_telephone'] as String,
      doc_cellphone: map['doc_cellphone'] as String,
      cust_name: map['cust_name'] as String,
      cust_telephone: map['cust_telephone'] as String,
      cust_cellphone: map['cust_cellphone'] as String,
      cust_zip: map['cust_zip'] as String,
      cust_address: map['cust_address'] as String,
      track_id: map['track_id'] as String,
      track_memo: map['track_memo'] as String,
      p_remarks2: map['p_remarks2'] as String,
      isCheck: map['isCheck'],
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'doc_no': this.doc_no,
      'prod_des': this.prod_des,
      'doc_qty': this.doc_qty,
      'doc_name': this.doc_name,
      'doc_telephone': this.doc_telephone,
      'doc_cellphone': this.doc_cellphone,
      'cust_name': this.cust_name,
      'cust_telephone': this.cust_telephone,
      'cust_cellphone': this.cust_cellphone,
      'cust_zip': this.cust_zip,
      'cust_address': this.cust_address,
      'track_id': this.track_id,
      'track_memo': this.track_memo,
      'p_remarks2': this.p_remarks2,
      'isCheck': this.isCheck
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
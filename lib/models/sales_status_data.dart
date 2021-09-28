
import 'dart:convert';
import 'package:flutter/foundation.dart';

class SalesStatusData {
  String account_name;
  String goods;
  String sales_date;
  String account_contact_information1;
  String account_contact_information2;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  SalesStatusData({
    @required this.account_name,
    @required this.goods,
    @required this.sales_date,
    @required this.account_contact_information1,
    @required this.account_contact_information2,
  });

  SalesStatusData copyWith({
    String account_name,
    String goods,
    String sales_date,
    String account_contact_information1,
    String account_contact_information2,
  }) {
    return new SalesStatusData(
      account_name: account_name ?? this.account_name,
      goods: goods ?? this.goods,
      sales_date: sales_date ?? this.sales_date,
      account_contact_information1:
          account_contact_information1 ?? this.account_contact_information1,
      account_contact_information2:
          account_contact_information2 ?? this.account_contact_information2,
    );
  }

  @override
  String toString() {
    return 'SalesStatusData{account_name: $account_name, goods: $goods, sales_date: $sales_date, account_contact_information1: $account_contact_information1, account_contact_information2: $account_contact_information2}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesStatusData &&
          runtimeType == other.runtimeType &&
          account_name == other.account_name &&
          goods == other.goods &&
          sales_date == other.sales_date &&
          account_contact_information1 == other.account_contact_information1 &&
          account_contact_information2 == other.account_contact_information2);

  @override
  int get hashCode =>
      account_name.hashCode ^
      goods.hashCode ^
      sales_date.hashCode ^
      account_contact_information1.hashCode ^
      account_contact_information2.hashCode;

  factory SalesStatusData.fromMap(Map<String, dynamic> map) {
    return new SalesStatusData(
      account_name: map['account_name'] as String,
      goods: map['goods'] as String,
      sales_date: map['sales_date'] as String,
      account_contact_information1:
          map['account_contact_information1'] as String,
      account_contact_information2:
          map['account_contact_information2'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'account_name': this.account_name,
      'goods': this.goods,
      'sales_date': this.sales_date,
      'account_contact_information1': this.account_contact_information1,
      'account_contact_information2': this.account_contact_information2,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class SalesStatusResult {
  String result_code;
  List<SalesStatusData> result_array;
  int result_count;
  bool isSuccess;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  SalesStatusResult({
    @required this.result_code,
    @required this.result_array,
    @required this.result_count,
    @required this.isSuccess,
  });

  SalesStatusResult copyWith({
    String result_code,
    List<SalesStatusData> result_array,
    int result_count,
    bool isSuccess,
  }) {
    return new SalesStatusResult(
      result_code: result_code ?? this.result_code,
      result_array: result_array ?? this.result_array,
      result_count: result_count ?? this.result_count,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  String toString() {
    return 'SalesStatusResult{result_code: $result_code, result_array: $result_array, result_count: $result_count, isSuccess: $isSuccess}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesStatusResult &&
          runtimeType == other.runtimeType &&
          result_code == other.result_code &&
          result_array == other.result_array &&
          result_count == other.result_count &&
          isSuccess == other.isSuccess);

  @override
  int get hashCode =>
      result_code.hashCode ^
      result_array.hashCode ^
      result_count.hashCode ^
      isSuccess.hashCode;

  factory SalesStatusResult.fromMap(Map<String, dynamic> map) {
    return new SalesStatusResult(
      result_code: map['result_code'] as String,
      result_array: List.from(json.decode(map['result_array'])).map((element) => SalesStatusData.fromMap(element)).toList(),
      result_count: map['result_count'] as int,
      isSuccess: map['isSuccess'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'result_code': this.result_code,
      'result_array': this.result_array,
      'result_count': this.result_count,
      'isSuccess': this.isSuccess,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

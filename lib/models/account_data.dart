
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AccountData {
  String account_code;
  String account_name;
  String owner;
  String manager;
  String first_sale;
  String region;
  String account_contact_information2;
  String machine_and_vinyl;
  String account_contact_information1;
  String basic_payment_type;
  String remarks;
  String remarks_2;
  String address1_zip_code;
  String address1;
  String address2;


//<editor-fold desc="Data Methods" defaultstate="collapsed">

  AccountData({
    @required this.account_code,
    @required this.account_name,
    @required this.owner,
    @required this.manager,
    @required this.first_sale,
    @required this.region,
    @required this.account_contact_information2,
    @required this.machine_and_vinyl,
    @required this.account_contact_information1,
    @required this.basic_payment_type,
    @required this.remarks,
    @required this.remarks_2,
    @required this.address1_zip_code,
    @required this.address1,
    @required this.address2
  });

  AccountData copyWith({
    String account_code,
    String account_name,
    String owner,
    String manager,
    String first_sale,
    String region,
    String account_contact_information2,
    String machine_and_vinyl,
    String account_contact_information1,
    String basic_payment_type,
    String remarks,
    String remarks_2,
    String address1_zip_code,
    String address1,
    String address2
  }) {
    return new AccountData(
      account_code: account_code ?? this.account_code,
      account_name: account_name ?? this.account_name,
      owner: owner ?? this.owner,
      manager: manager ?? this.manager,
      first_sale: first_sale ?? this.first_sale,
      region: region ?? this.region,
      account_contact_information2 : account_contact_information2 ?? this.account_contact_information2,
      machine_and_vinyl : machine_and_vinyl ?? this.machine_and_vinyl,
      account_contact_information1 : account_contact_information1 ?? this.account_contact_information1,
      basic_payment_type: basic_payment_type ?? this.basic_payment_type,
      remarks : remarks ?? this.remarks,
      remarks_2 : remarks_2 ?? this.remarks_2,
      address1_zip_code : address1_zip_code ?? this.address1_zip_code,
      address1 : address1 ?? this.address1,
      address2 : address2 ?? this.address2
    );
  }

  @override
  String toString() {
    return 'SalesStatusData{account_code: $account_code, account_name: $account_name, owner: $owner, manager: $manager, first_sale: $first_sale, region: $region, account_contact_information2: $account_contact_information2, machine_and_vinyl: $machine_and_vinyl,account_contact_information1: $account_contact_information1,basic_payment_type: $basic_payment_type,remarks: $remarks,remarks_2: $remarks_2, address1_zip_code: $address1_zip_code,address1 : $address1, address2: $address2}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AccountData &&
              runtimeType == other.runtimeType &&
              account_code == other.account_code &&
              account_name == other.account_name &&
              owner == other.owner &&
              manager == other.manager &&
              first_sale == other.first_sale &&
              region == other.region &&
              account_contact_information2 == other.account_contact_information2 &&
              machine_and_vinyl == other.machine_and_vinyl &&
              account_contact_information1 == other.account_contact_information1 &&
              basic_payment_type == other.basic_payment_type &&
              remarks == other.remarks &&
              remarks_2 == other.remarks_2 &&
              address1_zip_code == other.address1_zip_code &&
              address1 == other.address1 &&
              address2 == other.address2);

  @override
  int get hashCode =>
      account_code.hashCode ^
      account_name.hashCode ^
      owner.hashCode ^
      manager.hashCode ^
      first_sale.hashCode ^
      region.hashCode ^
      account_contact_information2.hashCode ^
      machine_and_vinyl.hashCode ^
      account_contact_information1.hashCode ^
      basic_payment_type.hashCode ^
      remarks.hashCode ^
      remarks_2.hashCode ^
      address1_zip_code.hashCode ^
      address1.hashCode ^
      address2.hashCode;

  factory AccountData.fromMap(Map<String, dynamic> map) {
    return new AccountData(
      account_code: map['account_code'] as String,
      account_name: map['account_name'] as String,
      owner: map['owner'] as String,
      manager: map['manager'] as String,
      first_sale: map['first_sale'] as String,
      region: map['region'] as String,
      account_contact_information2: map['account_contact_information2'] as String,
      machine_and_vinyl: map['machine_and_vinyl'] as String,
      account_contact_information1: map['account_contact_information1'] as String,
      basic_payment_type: map['basic_payment_type'] as String,
      remarks: map['remarks'] as String,
      remarks_2: map['remarks_2'] as String,
      address1_zip_code: map['address1_zip_code'] as String,
      address1: map['address1'] as String,
      address2: map['address2'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'account_code': this.account_code,
      'account_name': this.account_name,
      'owner': this.owner,
      'manager': this.manager,
      'first_sale': this.first_sale,
      'region': this.region,
      'account_contact_information2': this.account_contact_information2,
      'machine_and_vinyl': this.machine_and_vinyl,
      'account_contact_information1': this.account_contact_information1,
      'basic_payment_type': this.basic_payment_type,
      'remarks': this.remarks,
      'remarks_2': this.remarks_2,
      'address1_zip_code': this.address1_zip_code,
      'address1': this.address1,
      'address2': this.address2,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class AccountResult {
  String result_code;
  List<AccountData> result_array;
  int result_count;
  bool isSuccess;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  AccountResult({
    @required this.result_code,
    @required this.result_array,
    @required this.result_count,
    @required this.isSuccess,
  });

  AccountResult copyWith({
    String result_code,
    List<AccountData> result_array,
    int result_count,
    bool isSuccess,
  }) {
    return new AccountResult(
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
          (other is AccountResult &&
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

  factory AccountResult.fromMap(Map<String, dynamic> map) {
    return new AccountResult(
      result_code: map['result_code'] as String,
      result_array: List.from(json.decode(map['result_array'])).map((element) => AccountData.fromMap(element)).toList(),
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

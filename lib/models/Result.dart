import 'dart:convert';

class Result {
  String result_code;
  String result_data;
  int result_count;
  bool isSuccess;

  List<dynamic> result_array;

  Result({this.result_code, this.result_data, this.result_count, this.isSuccess, this.result_array});

  factory Result.fromJson(Map<String, dynamic> json) {

    List<dynamic> array = null;
    var result_array = json['result_array'];

    if (result_array != null) {
      array = List.from(result_array);
    }

    return Result(
      result_code: json['result_code'],
      result_count: json['result_count'],
      result_data: json['result_data'],
      result_array: array,
    );
  }
}
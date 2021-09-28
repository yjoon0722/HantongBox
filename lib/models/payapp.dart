
class PAYApp {
  int state;
  String errorMessage;
  int mul_no;
  String payurl;
  String feedbackurl;

  PAYApp({this.state, this.errorMessage, this.mul_no, this.payurl, this.feedbackurl});

  factory PAYApp.fromJson(Map<String, dynamic> json) {
    return PAYApp(
      state: json['state'],
      errorMessage: json['errorMessage'],
      mul_no: json['mul_no'],
      payurl: json['payurl'],
      feedbackurl: json['feedbackurl']
    );
  }
}
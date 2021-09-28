class EcountERP_enter_order{
  int state;
  String errorMessage;
  int mul_no;
  String payurl;

  EcountERP_enter_order({this.state, this.errorMessage, this.mul_no, this.payurl});

  factory EcountERP_enter_order.fromJson(Map<String, dynamic> json) {
    return EcountERP_enter_order(
      state: json['state'],
      errorMessage: json['errorMessage'],
      mul_no: json['mul_no'],
      payurl: json['payurl'],
    );
  }
}
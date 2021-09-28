import 'package:flutter/material.dart';
import 'package:hantong_cal/models/keypad.dart';

class ModalBottomSheet extends StatefulWidget {

  final Keypad keypad;
  final String total_price;

  const ModalBottomSheet({Key key, this.keypad, this.total_price}) : super(key: key);

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {

  String _paymentType;

  @override
  void initState() {
    super.initState();

    _paymentType = "카드";

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Text(widget.keypad.title, style: Theme.of(context).textTheme.title.copyWith(),),
          ),
          SizedBox(height: 10.0),
          Text("결제 방법 선택"),
          SizedBox(height: 20.0),
          _buildPaymentChoice(context),
          SizedBox(height: 20.0),
          RaisedButton(
              child: Text("보내기", style: TextStyle(color: Colors.white),),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.indigo,
              onPressed: (){
                Navigator.pop(context);

                //sendSMS(message: widget.total_price, recipients: null);

                // 클립보드
                //Clipboard.setData(ClipboardData(text: quote));


              }
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  // 결제 타입 선택
  Widget _buildPaymentChoice(BuildContext context) {

    if (widget.keypad.id == 1) {

      return SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 16.0,
          spacing: 16.0,
          children: <Widget>[
            SizedBox(width: 0.0),
            _buildActionChip(context, "현금"),
            _buildActionChip(context, "카드"),
            SizedBox(width: 0.0),
          ],
        ),
      );

    } else {

      return SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 16.0,
          spacing: 16.0,
          children: <Widget>[
            SizedBox(width: 0.0),
            _buildActionChip(context, "계산서 발행"),
            _buildActionChip(context, "계산서 미발행"),
            _buildActionChip(context, "카드"),
            SizedBox(width: 0.0),
          ],
        ),
      );
    }
  }

  Widget _buildActionChip(BuildContext context, String string) {
    return ActionChip (
      label: Text(string),
      labelStyle: TextStyle(color: Colors.white),
      backgroundColor: _paymentType == string ? Colors.indigo : Colors.grey.shade600,
      onPressed: () => _selectPaymentType(string),
    );
  }

  _selectPaymentType(String s) {
    setState(() {
      _paymentType = s;
    });
  }

}

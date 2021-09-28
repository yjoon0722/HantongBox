import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hantong_cal/helpers/app_config.dart';
import 'package:hantong_cal/main.dart';
import 'package:hantong_cal/models/analytics.dart';
import 'package:hantong_cal/models/calculator.dart';
import 'package:flutter/services.dart';

class PadSimpleCalculator extends StatefulWidget {
  final PAGE_MODE page_mode;

  const PadSimpleCalculator({Key key, this.page_mode}) : super(key: key);

  @override
  _PadSimpleCalculatorState createState() => _PadSimpleCalculatorState();
}

class _PadSimpleCalculatorState extends State<PadSimpleCalculator> with AutomaticKeepAliveClientMixin{

  // 화면전환시 데이터값 유지
  @override
  bool get wantKeepAlive => true;

  String equation = "";
  String number = "";
  String result = "";
  int operation = 0;
  int maxLength = 15;
  double equationFontSize = 33.0;
  double numFontSize = 48.0;
  List<String> _buttonList = new List();

  final FocusNode _focusNode = new FocusNode();
  String _buttonText;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event){
    if(event.isKeyPressed(event.logicalKey) == true) {
      return;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad0 || event.logicalKey == LogicalKeyboardKey.digit0){
      _buttonText = Buttons.zero;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad1 || event.logicalKey == LogicalKeyboardKey.digit1) {
      _buttonText = Buttons.one;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad2 || event.logicalKey == LogicalKeyboardKey.digit2) {
      _buttonText = Buttons.two;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad3 || event.logicalKey == LogicalKeyboardKey.digit3) {
      _buttonText = Buttons.three;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad4 || event.logicalKey == LogicalKeyboardKey.digit4) {
      _buttonText = Buttons.four;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad5 || event.logicalKey == LogicalKeyboardKey.digit5) {
      _buttonText = Buttons.five;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad6 || event.logicalKey == LogicalKeyboardKey.digit6) {
      _buttonText = Buttons.six;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad7 || event.logicalKey == LogicalKeyboardKey.digit7) {
      _buttonText = Buttons.seven;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad8 || event.logicalKey == LogicalKeyboardKey.digit8) {
      _buttonText = Buttons.eight;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpad9 || event.logicalKey == LogicalKeyboardKey.digit9) {
      _buttonText = Buttons.nine;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpadDecimal || event.logicalKey == LogicalKeyboardKey.period) {
      _buttonText = Buttons.point;
    }
    else if(event.logicalKey ==LogicalKeyboardKey.numpadAdd) {
      _buttonText = Buttons.ADD;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpadSubtract) {
      _buttonText = Buttons.SUBTRACT;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpadDivide) {
      _buttonText = Buttons.DEVIDE;
    }
    else if(event.logicalKey == LogicalKeyboardKey.numpadMultiply) {
      _buttonText = Buttons.MULTIFLY;
    }
    else if(event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter || event.logicalKey == LogicalKeyboardKey.numpadEqual) {
      _buttonText = Buttons.equal;
    }
    else if(event.logicalKey == LogicalKeyboardKey.escape) {
      _buttonText = Buttons.clear;
    }
    else if(event.logicalKey == LogicalKeyboardKey.backspace) {
    // || event.logicalKey == LogicalKeyboardKey.numpadBackspace
      _buttonText = Buttons.delete;
    }
    else {
      _buttonText = '';
    }

    if(Buttons.keyboard.contains(_buttonText)) {
      setState(() {
        buildResult(_buttonText);
      });
    }
  }

  // build
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('click');
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3, 0.7, 1.0],
                  colors: [Color(0xFF084172), Color(0xFF084C82), Color(0xFF084C82), Color(0xFF115999)])
          ),
          child: SafeArea(
              child: RawKeyboardListener(
                focusNode: _focusNode,
                onKey: _handleKeyEvent,
                autofocus: true,
                child: Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                          physics: BouncingScrollPhysics(),
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                                    padding: const EdgeInsets.all(20.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey, width: 0.5),
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Color.fromRGBO(255, 255, 255, 0.90)
                                    ),
                                    child: Text("일반 계산기 ",
                                      style: Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    color: Colors.black,
                                    height: MediaQuery.of(context).size.height * 0.1,
                                    child: ListView(
                                      reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        Text(equation,style: TextStyle(fontSize: equationFontSize,color: Colors.white),)
                                      ],
                                    ),
                                  )
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    color: Colors.black,
                                    height: MediaQuery.of(context).size.height * 0.1,
                                    child: AutoSizeText(number,style: TextStyle(fontSize: numFontSize,color: Colors.white),),
                                  )
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: widget.page_mode == PAGE_MODE.two ? MediaQuery.of(context).size.width / 2 : widget.page_mode == PAGE_MODE.three ? MediaQuery.of(context).size.width / 3 : null ,
                                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                    child: Table(
                                      children: [
                                        TableRow(
                                            children: [
                                              buildButton(Buttons.clear, 1, MyApp.btnSelectedColor),
                                              buildButton(Buttons.delete, 1, Colors.blue),
                                              buildButton(Buttons.percentage, 1, Colors.blue),
                                              buildButton(Buttons.DEVIDE, 1, Colors.blue)
                                            ]
                                        ),

                                        TableRow(
                                            children: [
                                              buildButton(Buttons.seven, 1, Colors.black54),
                                              buildButton(Buttons.eight, 1, Colors.black54),
                                              buildButton(Buttons.nine, 1, Colors.black54),
                                              buildButton(Buttons.MULTIFLY, 1, Colors.blue)
                                            ]
                                        ),

                                        TableRow(
                                            children: [
                                              buildButton(Buttons.four, 1, Colors.black54),
                                              buildButton(Buttons.five, 1, Colors.black54),
                                              buildButton(Buttons.six, 1, Colors.black54),
                                              buildButton(Buttons.SUBTRACT, 1, Colors.blue)
                                            ]
                                        ),

                                        TableRow(
                                            children: [
                                              buildButton(Buttons.one, 1, Colors.black54),
                                              buildButton(Buttons.two, 1, Colors.black54),
                                              buildButton(Buttons.three, 1, Colors.black54),
                                              buildButton(Buttons.ADD, 1, Colors.blue)
                                            ]
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: widget.page_mode == PAGE_MODE.two ? MediaQuery.of(context).size.width / 2 : widget.page_mode == PAGE_MODE.three ? MediaQuery.of(context).size.width / 3 : null ,
                                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                    child: Table(
                                      children: [
                                        TableRow(
                                          children: [
                                            buildButton(Buttons.zero, 1, Colors.black54),
                                            Table(
                                              children: [
                                                TableRow(
                                                  children: [
                                                    buildButton(Buttons.point, 1, Colors.black54),
                                                    buildButton(Buttons.equal, 1, MyApp.btnSelectedColor)
                                                  ]
                                                )
                                              ],
                                            )
                                          ]
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 16.0, 16, 0.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(App.version,style: TextStyle(color: Colors.black.withOpacity(0.4))),
                                ),
                              ),
                            )
                          ]
                      ),
                    )
                  ],
                ),
              )
          )
      ),
    );
  }

  // 버튼모양
  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid
            )
        ),
        padding: EdgeInsets.all(16.0),
        onPressed: () => buttonPressed(buttonText),
        child: AutoSizeText(
          buttonText,
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Colors.white
          ),
        ),
      ),
    );
  }

  // 버튼동작
  buttonPressed(String buttonText) {
    setState(() {
      buildResult(buttonText);
    });
  }

  // 입력값 체크
  void buildResult(String buttonText) {
    int lastIndex = _buttonList.isEmpty ? 0 : _buttonList.length - 1;
    bool isMaxLength = _buttonList.isEmpty ? true :_buttonList[lastIndex].length <= maxLength;
    var lastValue = _buttonList.isEmpty ? null : _buttonList[lastIndex];
    var newValue;

    // 연산자(+ - * /) 클릭
    if (Buttons.OPERATER.contains(buttonText)) {

      // = 눌러서 계산후 연산자 클릭할 경우
      if(number != "" && _buttonList.isEmpty){
        _buttonList.add(number.replaceAll(',', ''));
        _buttonList.add(buttonText);
        equation = number + buttonText;
        number = "";
        return;
      }

      if(_buttonList.isEmpty) { return; }

      // _buttonList의 마지막배열이 연산자일 경우
      if(isOperator(lastValue)){
        _buttonList[lastIndex] = buttonText;
        equation = delLastChar(equation) + buttonText;
        return;
      }

      // 마지막배열이 .으로 끝날경우 .제거
      if(lastChar(lastValue) == Buttons.point) { _buttonList[lastIndex] = delLastChar(lastValue); }

      equation += numberWithComma(double.parse(_buttonList[lastIndex])) + buttonText;
      _buttonList.add(buttonText);

      // 입력된 값 미리 연산후 출력
      if(_buttonList.length >= 3) {
        buildSum(buttonText,lastValue,lastIndex);
      }else{
        number = "";
      }
      return;
    }
    if(buttonText == Buttons.clear) {
      equation = "";
      number = "";
      _buttonList.clear();
      result = "";
    }
    else if(buttonText == Buttons.delete) {
      if(_buttonList.isEmpty || isOperator(lastValue)) { return; }

      if(lastValue.length == 1) {
        _buttonList.removeLast();
        number = "";
        return;
      }

      _buttonList[lastIndex] = delLastChar(lastValue);

      if(lastValue.contains(Buttons.point)){
        number = delLastChar(number);
        return;
      }
      number = numberWithComma(double.parse(_buttonList[lastIndex]));
    }
    else if (buttonText == Buttons.equal) {
      if(_buttonList.isEmpty) { return; }
      buildSum(buttonText,lastValue,lastIndex);
      _buttonList.clear();
    }
    else if (buttonText == Buttons.percentage) {
      if(isOperator(lastValue) || _buttonList.isEmpty){ return; }
      _buttonList[lastIndex] = (num.parse(lastValue)/100).toString();
      number = numberWithComma(double.parse(_buttonList[lastIndex]));
    }
    else if (buttonText == Buttons.point) {
      if(!isMaxLength) { return; }
      if(lastValue.contains(Buttons.point)) { return; }

      // 입력값 없이 . 을 눌렀을경우
      if(_buttonList.isEmpty || isOperator(lastValue)){
        _buttonList.add("0.");
        number = "0.";
        return;
      }
      newValue = lastValue+buttonText;
      _buttonList[lastIndex] = newValue;
      number = numberWithComma(double.parse(_buttonList[lastIndex])) + buttonText;
    }
    // 숫자 클릭
    else {
      // 단위제한
      if (!isMaxLength) { return; }

      // = 클릭 후 숫자 클릭시 equation 초기화
      if(_buttonList.isEmpty) { equation = ""; }

      // 마지막 배열이 연산자거나 비어있을 경우
      if (_buttonList.isEmpty || isOperator(_buttonList[lastIndex])) {
        // 0 or 000 클릭
        if(buttonText == Buttons.zero) {
          _buttonList.add("0");
          number = "0";
          return;
        }
        _buttonList.add(buttonText);
        number = buttonText;
        return;
      }

      // 마지막 배열의 값이 0일 경우
      if (_buttonList[lastIndex] == Buttons.zero) {
        _buttonList[lastIndex] = buttonText;
        number = buttonText;
        return;
      }
      // 소수 출력 제어문
      if(lastValue.contains(Buttons.point)){
        if(lastChar(lastValue) == Buttons.point){
          number = numberWithComma(double.parse(_buttonList[lastIndex])) + Buttons.point + buttonText;
          newValue = lastValue+buttonText;
          _buttonList[lastIndex] = newValue;
        }else{
          newValue = lastValue + buttonText;
          _buttonList[lastIndex] = newValue;
          number += buttonText;
          return;
        }
        return;
      }
      newValue = lastValue+buttonText;
      _buttonList[lastIndex] = newValue;
      number = numberWithComma(double.parse(_buttonList[lastIndex]));
    }
  }

  // 입력값 계산
  void buildSum(String buttonText, String lastValue, int lastIndex) {
    num sum = 0;
    String operator;

    // 마지막배열이 .으로 끝날경우 .제거
    if(lastChar(lastValue) == Buttons.point) { _buttonList[lastIndex] = delLastChar(lastValue); number = delLastChar(number); }

    // 방정식 맨 뒤의 연산자 제거
    if(buttonText == Buttons.equal){
      if(isOperator(lastValue)){
        equation = delLastChar(equation);
        return;
      }
      equation += number;
    }

    // 계산
    for(int i=0; i<_buttonList.length; i++) {
      var value = _buttonList[i];

      if (isOperator(value) == false) {
        if (operator == null) {
          sum = num.parse(value);
        } else {
          if (operator == Buttons.MULTIFLY) {
            sum = sum * num.parse(value);
          } else if (operator == Buttons.DEVIDE) {
            sum = sum / num.parse(value);
            if(sum == sum.toInt()){
              sum = sum.toInt();
            }
          } else if (operator == Buttons.SUBTRACT) {
            sum = sum - num.parse(value);
          } else if (operator == Buttons.ADD) {
            sum = sum + num.parse(value);
          }
          operator = null;
        }
      } else {
        operator = value;
      }
      number = numberWithComma(sum).toString();
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hantong_cal/main.dart';
import 'package:hantong_cal/models/analytics.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class RatioCalculator extends StatefulWidget {
  PAGE_MODE page_mode;
  RatioCalculator({Key key, this.page_mode}) : super(key: key);

  @override
  _RatioCalculatorState createState() {
    return _RatioCalculatorState();
  }
}
class _RatioCalculatorState extends State<RatioCalculator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  TextEditingController _controller3 = new TextEditingController();
  TextEditingController _controller4 = new TextEditingController();
  TextEditingController _controller5 = new TextEditingController();
  TextEditingController _controller6 = new TextEditingController();
  TextEditingController _controller7 = new TextEditingController();
  final _focusNode = FocusScopeNode();
  final FocusNode _emptyNode1 = new FocusNode();
  final FocusNode _emptyNode2 = new FocusNode();
  final FocusNode _emptyNode3 = new FocusNode();
  final FocusNode _emptyNode4 = new FocusNode();
  final FocusNode _emptyNode5 = new FocusNode();
  final FocusNode _emptyNode6 = new FocusNode();
  final FocusNode _emptyNode7 = new FocusNode();
  final FocusNode _nodeText1 = new FocusNode();
  final FocusNode _nodeText2 = new FocusNode();
  final FocusNode _nodeText3 = new FocusNode();
  final FocusNode _nodeText4 = new FocusNode();
  final FocusNode _nodeText5 = new FocusNode();
  final FocusNode _nodeText6 = new FocusNode();
  final FocusNode _nodeText7 = new FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context){
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: false,
        actions: [
          buildKeyboard(_nodeText1),
          buildKeyboard(_nodeText2),
          buildKeyboard(_nodeText3),
          buildKeyboard(_nodeText4),
          buildKeyboard(_nodeText5),
          buildKeyboard(_nodeText6),
          buildKeyboard(_nodeText7),
        ]
    );
  }

  buildKeyboard(FocusNode _nodeText){
    return KeyboardActionsItem(
        focusNode: _nodeText,
        toolbarButtons: [(node) {
          return GestureDetector(
            onTap: () => node.unfocus(),
            child: Container(
              padding: EdgeInsets.fromLTRB(30.0, 10, 20.0, 10),
              child: Text("완료",style: TextStyle(color: Colors.blue,fontSize: 15.0,fontWeight: FontWeight.bold),),
            ),
          );
        }]
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          print('click');
          _focusNode.unfocus();
        },
        child: FocusScope(
          node: _focusNode,
          child: Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.3, 0.7, 1.0],
                          colors: [Color(0xFF084172), Color(0xFF084C82), Color(0xFF084C82), Color(0xFF115999)])
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: KeyboardActions(
                            config: _buildConfig(context),
                            child: CustomScrollView(
                              physics: widget.page_mode == PAGE_MODE.one ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                              slivers: <Widget>[
//                            SliverPadding(padding: EdgeInsets.only(top: statusBarHeight),),
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
                                        child: Text("비율 계산기 ",
                                          style: Theme.of(context).textTheme.headline4,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: TextField(
                                            controller: _controller1,
                                            focusNode: kIsWeb ? _emptyNode1 : Platform.isIOS ? _nodeText1 : null,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            decoration: InputDecoration(
                                                fillColor: Color.fromRGBO(255, 255, 255, 0.90), filled: true,
                                                border: OutlineInputBorder(),
                                                hintText: '비율1'
                                            ),
                                            textAlign: TextAlign.center,
                                            inputFormatters: <TextInputFormatter>[
                                              WhitelistingTextInputFormatter.digitsOnly
                                            ],
                                          ),
                                        ),
                                        Text('         :         ',style: TextStyle(color: Colors.white),),
                                        Flexible(
                                          child: TextField(
                                            controller: _controller2,
                                            focusNode: kIsWeb ? _emptyNode2 : Platform.isIOS ? _nodeText2 : null,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            decoration: InputDecoration(
                                                fillColor: Color.fromRGBO(255, 255, 255, 0.90), filled: true,
                                                border: OutlineInputBorder(),
                                                hintText: '비율2'
                                            ),
                                            textAlign: TextAlign.center,
                                            inputFormatters: <TextInputFormatter>[
                                              WhitelistingTextInputFormatter.digitsOnly
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Text("||",style: TextStyle(fontSize:20,color: Colors.white), textAlign: TextAlign.center,),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextField(
                                                controller: _controller3,
                                                focusNode: kIsWeb ? _emptyNode3 : Platform.isIOS ? _nodeText3 : null,
                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromRGBO(255, 255, 255, 0.90), filled: true,
                                                    border: OutlineInputBorder(),
                                                    hintText: '비율3'
                                                ),
                                                textAlign: TextAlign.center,
                                                inputFormatters: <TextInputFormatter>[
                                                  WhitelistingTextInputFormatter.digitsOnly
                                                ],
                                              ),
                                            ),
                                            Text('         :         ',style: TextStyle(color: Colors.white),),
                                            Flexible(
                                              child: TextField(
                                                controller: _controller4,
                                                focusNode: kIsWeb ? _emptyNode4 : Platform.isIOS ? _nodeText4 : null,
                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromRGBO(255, 255, 255, 0.90), filled: true,
                                                    border: OutlineInputBorder(),
                                                    hintText: '비율4'
                                                ),
                                                textAlign: TextAlign.center,
                                                inputFormatters: <TextInputFormatter>[
                                                  WhitelistingTextInputFormatter.digitsOnly
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                    )
                                ),

                                // 비율계산 버튼
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: FlatButton(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5,
                                                    style: BorderStyle.solid
                                                )
                                            ),
                                            onPressed: () => ratioPressed(),
                                            child: Text('비율계산'),
                                          ),
                                        ),
                                        Text('                   '),
                                        Expanded(
                                          child: FlatButton(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5,
                                                    style: BorderStyle.solid
                                                )
                                            ),
                                            onPressed: () => ratioResetPressed(),
                                            child: Text('리셋'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                      child: (widget.page_mode == PAGE_MODE.two) ? Container(
                                        margin: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                                        padding: const EdgeInsets.all(20.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey, width: 0.5),
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Color.fromRGBO(255, 255, 255, 0.90)
                                        ),
                                        child: Text("세금 계산기 ",
                                          style: Theme.of(context).textTheme.headline4,
                                          textAlign: TextAlign.center,
                                        ),
                                      ) : null,
                                    )
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                                    child: (widget.page_mode == PAGE_MODE.two) ? TextField(
                                      controller: _controller5,
                                      focusNode: kIsWeb ? _emptyNode5 : Platform.isIOS ? _nodeText5 : null,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromRGBO(255, 255, 255, 0.90), filled: true,
                                          border: OutlineInputBorder(),
                                          hintText: '세금 포함 금액'
                                      ),
                                      textAlign: TextAlign.center,
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter.digitsOnly
                                      ],
                                    ) : null,
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: (widget.page_mode == PAGE_MODE.two) ? Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Text('⇩',style: TextStyle(fontSize:20,color: Colors.white),textAlign: TextAlign.center),
                                  ) : null,
                                ),
                                SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                                      child: (widget.page_mode == PAGE_MODE.two) ? Row(
                                        children: <Widget>[
                                          Flexible(
                                            child: TextField(
                                              controller: _controller6,
                                              focusNode: kIsWeb ? _emptyNode6 : Platform.isIOS ? _nodeText6 : null,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              decoration: InputDecoration(
                                                  fillColor: Color.fromRGBO(255, 255, 255, 0.90), filled: true,
                                                  border: OutlineInputBorder(),
                                                  hintText: '세전 금액'
                                              ),
                                              textAlign: TextAlign.center,
                                              inputFormatters: <TextInputFormatter>[
                                                WhitelistingTextInputFormatter.digitsOnly
                                              ],
                                            ),
                                          ),
                                          Text('                   '),
                                          Flexible(
                                            child: TextField(
                                              controller: _controller7,
                                              focusNode: kIsWeb ? _emptyNode7 : Platform.isIOS ? _nodeText7 : null,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              decoration: InputDecoration(
                                                  fillColor: Color.fromRGBO(255, 255, 255, 0.90), filled: true,
                                                  border: OutlineInputBorder(),
                                                  hintText: '세금'
                                              ),
                                              textAlign: TextAlign.center,
                                              inputFormatters: <TextInputFormatter>[
                                                WhitelistingTextInputFormatter.digitsOnly
                                              ],
                                            ),
                                          )
                                        ],
                                      ) : null,
                                    )
                                ),

                                //세금계산 버튼
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                                    child: (widget.page_mode == PAGE_MODE.two) ? Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: FlatButton(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5,
                                                    style: BorderStyle.solid
                                                )
                                            ),
                                            onPressed: () => taxPressed(),
                                            child: Text('세금계산'),
                                          ),
                                        ),
                                        Text('                   '),
                                        Expanded(
                                          child: FlatButton(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5,
                                                    style: BorderStyle.solid
                                                )
                                            ),
                                            onPressed: () => taxResetPressed(),
                                            child: Text('리셋'),
                                          ),
                                        ),
                                      ],
                                    ) : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              )
          ),
        )
    );
  }

  // 비율계산버튼 클릭
  ratioPressed(){
    setState(() {
      buildRatioResult();
    });
  }

  // 비율계산 결과출력
  void buildRatioResult(){
    num controller1text = isEmpty(_controller1.text) ? 0 : num.parse(delComma(_controller1.text));
    num controller2text = isEmpty(_controller2.text) ? 0 : num.parse(delComma(_controller2.text));
    num controller3text = isEmpty(_controller3.text) ? 0 : num.parse(delComma(_controller3.text));
    num controller4text = isEmpty(_controller4.text) ? 0 : num.parse(delComma(_controller4.text));
    num result;

    if(isEmpty(_controller1.text) && !isEmpty(_controller2.text) && !isEmpty(_controller3.text) && !isEmpty(_controller4.text)){
      result = (controller2text * controller3text) / controller4text;
      if(result == result.toInt()) { result = result.toInt(); }
      _controller1.text = numberWithComma(result).toString();
      print(_controller1.text);
    }
    else if(isEmpty(_controller2.text) && !isEmpty(_controller1.text) && !isEmpty(_controller3.text) && !isEmpty(_controller4.text)){
      result = (controller1text * controller4text) / controller3text;
      if(result == result.toInt()) { result = result.toInt(); }
      _controller2.text = numberWithComma(result).toString();
      print(_controller2.text);
    }
    else if(isEmpty(_controller3.text) && !isEmpty(_controller1.text) && !isEmpty(_controller2.text) && !isEmpty(_controller4.text)){
      result = (controller1text * controller4text) / controller2text;
      if(result == result.toInt()) { result = result.toInt(); }
      _controller3.text = numberWithComma(result).toString();
      print(_controller3.text);
    }
    else if(isEmpty(_controller4.text) && !isEmpty(_controller1.text) && !isEmpty(_controller2.text) && !isEmpty(_controller3.text)){
      result = (controller2text * controller3text) / controller1text;
      if(result == result.toInt()) { result = result.toInt(); }
      _controller4.text = numberWithComma(result).toString();
      print(_controller4.text);
    }
    else{
      print(controller1text);
      print(controller2text);
      print(controller3text);
      print(controller4text);
      print('3개의 칸에 숫자를 입력해주세요');
    }

  }

  // 세금계산 버튼동작
  taxPressed(){
    setState(() {
      buildTaxResult();
    });
  }

  // 세금 입력값 확인
  void buildTaxResult(){
    num controller5text = isEmpty(_controller5.text) ? 0 : num.parse(delComma(_controller5.text));
    num controller6text = isEmpty(_controller6.text) ? 0 : num.parse(delComma(_controller6.text));
    num controller7text = isEmpty(_controller7.text) ? 0 : num.parse(delComma(_controller7.text));

    if(!isEmpty(_controller5.text) && isEmpty(_controller6.text) && isEmpty(_controller7.text)){
      _controller6.text = numberWithComma(((controller5text/1.1).round())).toString();
      _controller7.text = numberWithComma(((controller5text-(controller5text/1.1)).round())).toString();
    }
    else if(!isEmpty(_controller6.text) && isEmpty(_controller5.text) && isEmpty(_controller7.text)) {
      _controller5.text = numberWithComma(((controller6text*1.1).round())).toString();
      _controller7.text = numberWithComma(((controller6text*0.1).round())).toString();
    }
    else if(!isEmpty(_controller7.text) && isEmpty(_controller5.text) && isEmpty(_controller6.text)){
      _controller5.text = numberWithComma(((controller7text*11).round())).toString();
      _controller6.text = numberWithComma(((controller7text*10).round())).toString();
    }
    else{
      print('1개의 칸에만 숫자를 입력하세요.');
    }
  }

  ratioResetPressed(){
    setState(() {
      _controller1.clear();
      _controller2.clear();
      _controller3.clear();
      _controller4.clear();
    });
  }

  taxResetPressed(){
    setState(() {
      _controller5.clear();
      _controller6.clear();
      _controller7.clear();
    });
  }

  bool isEmpty(_controller) {
    bool isEmpty = false;
    if(_controller == '') { isEmpty = true; }
    return isEmpty;
  }

  String numberWithComma(num param){
    return new NumberFormat('#,###.#####').format(param);
  }

  String delComma(String param) {
    return param.replaceAll(',','');
  }

}

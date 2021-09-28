import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hantong_cal/main.dart';
import 'package:hantong_cal/models/analytics.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class TaxCalculator extends StatefulWidget {
  PAGE_MODE page_mode;
  TaxCalculator({Key key, this.page_mode}) : super(key: key);

  @override
  _TaxCalculatorState createState() => _TaxCalculatorState();
}

class _TaxCalculatorState extends State<TaxCalculator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController _controller5 = new TextEditingController();
  TextEditingController _controller6 = new TextEditingController();
  TextEditingController _controller7 = new TextEditingController();
  final _focusNode = FocusScopeNode();
  final FocusNode _emptyNode5 = new FocusNode();
  final FocusNode _emptyNode6 = new FocusNode();
  final FocusNode _emptyNode7 = new FocusNode();
  final FocusNode _nodeText5 = new FocusNode();
  final FocusNode _nodeText6 = new FocusNode();
  final FocusNode _nodeText7 = new FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context){
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: false,
        actions: [
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
                                        child: Text("세금 계산기 ",
                                          style: Theme.of(context).textTheme.headline4,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                ),
                              SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                                    child: TextField(
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
                                    ),
                                  ),
                                ),
                              SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Text('⇩',style: TextStyle(fontSize:20,color: Colors.white),textAlign: TextAlign.center),
                                  ),
                                ),
                              SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                                      child: Row(
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
                                      ),
                                    )
                                ),

                                //세금계산 버튼
                              SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
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
                                    ),
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
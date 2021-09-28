import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hantong_cal/main.dart';

class SSProgressIndicator {
  static void show(BuildContext context,
      { Color backgroundColor = MyApp.componentColor,
        double backgroundRadius = 20,
        Border border}) {
    SSProgressIndicatorView.dismiss();
    SSProgressIndicatorView.createView(context, backgroundColor, backgroundRadius, border);
  }

  static void dismiss() { SSProgressIndicatorView.dismiss(); }
}

class SSProgressIndicatorView {
  static final SSProgressIndicatorView _singleton = new SSProgressIndicatorView._internal();

  factory SSProgressIndicatorView() {
    return _singleton;
  }

  SSProgressIndicatorView._internal();

  static OverlayState overlayState;
  static OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void createView(BuildContext context,
      Color background, double backgroundRadius, Border border) async {
    overlayState = Overlay.of(context);
    Paint paint = Paint();
    paint.strokeCap = StrokeCap.square;
    paint.color = background;

    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) => SSProgressIndicatorWidget(
          widget: Container(
              width: MediaQuery.of(context).size.width,
              child: new GestureDetector(
                //onTap: () {
                //  dismiss();
                //},
                child: Container(
                    color: background,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      //decoration: BoxDecoration(
                      //  color: background,
                      //  borderRadius: BorderRadius.circular(backgroundRadius),
                      //  border: border,
                      //),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(80) ,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            child: CircularProgressIndicator(strokeWidth: 6,
                              backgroundColor: Colors.white,
                            ),
                            height: 100.0,
                            width: 100.0,
                          ),
                          SizedBox(height: 40,),
                          Text('Watting...', style: TextStyle(fontSize: 20, color: Colors.white),),
                        ]
                      )
                    )
                ),
              )
          ),
      ),
    );
    _isVisible = true;
    overlayState.insert(_overlayEntry);
  }

  static dismiss() async {
    if (!_isVisible) { return; }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class SSProgressIndicatorWidget extends StatelessWidget {
  SSProgressIndicatorWidget({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: null,
        bottom: null,
        child: Material(
          color: Colors.transparent,
          child: widget,
        ));
  }
}

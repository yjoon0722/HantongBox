import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SSHud {
  static final int LENGTH_SHORT = 1;
  static final int LENGTH_LONG = 2;
  static final int BOTTOM = 0;
  static final int CENTER = 1;
  static final int TOP = 2;

  static void show(String msg, BuildContext context,
      {int duration = 1,
        int gravity = 1,
        Color backgroundColor = const Color(0xAA000000),
        Color textColor = Colors.white,
        double backgroundRadius = 20,
        Border border}) {
    SSHudView.dismiss();
    SSHudView.createView(
        msg, context, duration, gravity, backgroundColor, textColor, backgroundRadius, border);
  }

  static void dismiss() {
    SSHudView.dismiss();
  }
}

class SSHudView {
  static final SSHudView _singleton = new SSHudView._internal();

  factory SSHudView() {
    return _singleton;
  }

  SSHudView._internal();

  static OverlayState overlayState;
  static OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void createView(String msg, BuildContext context, int duration, int gravity,
      Color background, Color textColor, double backgroundRadius, Border border) async {
    overlayState = Overlay.of(context);

    Paint paint = Paint();
    paint.strokeCap = StrokeCap.square;
    paint.color = background;

    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) => SSHudWidget(
          widget: Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                  color: Color(0x00FFFFFF),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(backgroundRadius),
                      border: border,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    //padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        Image.asset('assets/img/cupertino_activity_indicator_square_large.gif', width: 60,),
                        SizedBox(height: 20),
                        Text(msg, softWrap: true, style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                      ],
                        //child: Image.asset('assets/images/cupertino_activity_indicator_square_large.gif', width: 60,)),
                    ),
                    //Text(msg, softWrap: true, style: TextStyle(fontSize: 15, color: textColor)),
                  ))
          ),
          gravity: gravity),
    );
    _isVisible = true;
    overlayState.insert(_overlayEntry);
    //await new Future.delayed(Duration(seconds: duration == null ? SSHud.LENGTH_SHORT : duration));
    //dismiss();
  }

  static dismiss() async {
    if (!_isVisible) { return; }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class SSHudWidget extends StatelessWidget {
  SSHudWidget({
    Key key,
    @required this.widget,
    @required this.gravity,
  }) : super(key: key);

  final Widget widget;
  final int gravity;

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: gravity == 2 ? 50 : null,
      bottom: gravity == 0 ? 50 : null,
      child: Material(
        color: Colors.transparent,
        child: widget,
      ),
    );
  }
}

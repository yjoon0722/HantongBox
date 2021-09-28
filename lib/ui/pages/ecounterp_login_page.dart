
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final kECountERP_Login_URL = "https://login.ecounterp.com/";
final kECountERP_Inquiry_URL = "https://loginab.ecounterp.com/ECERP/ECP/ECP050M";

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
    name: 'Print',
    onMessageReceived: (JavascriptMessage message) {
      print('JavascriptChannel: ${message.message}\n');
    },
  ),
].toSet();

class ECountERP_LoginPage extends StatefulWidget {

  final Function function;

  ECountERP_LoginPage({this.function});

  @override
  _ECountERP_LoginPageState createState() => _ECountERP_LoginPageState();
}

class _ECountERP_LoginPageState extends State<ECountERP_LoginPage> {

  final flutterWebViewPluginLogin = FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onProgressChanged;

  @override
  void initState() {
    super.initState();

    flutterWebViewPluginLogin.close();

    _onDestroy = flutterWebViewPluginLogin.onDestroy.listen((_) {
      print('ECountERP_LoginPage =================_onDestroy');
    });

    _onUrlChanged = flutterWebViewPluginLogin.onUrlChanged.listen((String url) {
      print('ECountERP_LoginPage =================_onUrlChanged : $url');
    });

    _onStateChanged = flutterWebViewPluginLogin.onStateChanged.listen((WebViewStateChanged state) {
      print('ECountERP_LoginPage =================_onStateChanged : ${state.type}\nurl:${state.url}\n');

      switch(state.type) {
        case WebViewState.startLoad:
          break;

        case WebViewState.finishLoad:
          if (state.url.contains(kECountERP_Inquiry_URL)) {

            flutterWebViewPluginLogin.close();

            if (widget.function != null) {
              widget.function(state.url);
            }

            Navigator.of(context).pop();


          }
          break;
      }

    });

    _onHttpError = flutterWebViewPluginLogin.onHttpError.listen((WebViewHttpError error) {
      print('ECountERP_LoginPage =================_onHttpError : ${error.code}\nurl:${error.url}\n');
    });

    _onProgressChanged = flutterWebViewPluginLogin.onProgressChanged.listen((double progress) {
      print('ECountERP_LoginPage =================_onProgressChanged : $progress');
    });
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();

    flutterWebViewPluginLogin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: kECountERP_Login_URL,
      javascriptChannels: jsChannels,
      mediaPlaybackRequiresUserGesture: false,
      appBar: AppBar(title: const Text('ECOUNT ERP'),),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
    );
  }
}

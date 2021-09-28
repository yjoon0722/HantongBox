import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';

class Root3stPage extends StatefulWidget {

  String urlStgring;
  //WebViewController _webController;

  Root3stPage(this.urlStgring);

  void reloadURL(String urlString) {
    //_webController.loadUrl(urlString);
  }

  @override
  _Root3stPageState createState() => _Root3stPageState();

}

class _Root3stPageState extends State<Root3stPage> {

  //final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {

//    print("================================ build" + widget.urlStgring);
//
//    return WebView(
//      initialUrl: widget.urlStgring,
//      javascriptMode: JavascriptMode.unrestricted,
//      onWebViewCreated: (WebViewController webViewController) {
//        print("================================ onWebViewCreated");
//        _controller.complete(webViewController);
//        widget._webController = webViewController;
//      },
//      // TODO(iskakaushik): Remove this when collection literals makes it to stable.
//      // ignore: prefer_collection_literals
//      javascriptChannels: <JavascriptChannel>[
//        _toasterJavascriptChannel(context),
//      ].toSet(),
//      onPageFinished: (String url) {
//        print('Page finished loading: $url');
//      },
//    );

      return Text("");
  }

//  setState(() {
//    print("================================ setState");
//    _webController.loadUrl(widget.urlStgring);
//  });

  void printSample (){
    print("Sample text");
  }



//  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//    return JavascriptChannel(
//        name: 'Toaster',
//        onMessageReceived: (JavascriptMessage message) {
//          Scaffold.of(context).showSnackBar(
//            SnackBar(content: Text(message.message)),
//          );
//        });
//  }
}

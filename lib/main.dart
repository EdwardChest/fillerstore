import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:async';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const FillerStore());
}

class FillerStore extends StatefulWidget {
  const FillerStore({Key? key}) : super(key: key);

  @override
  State<FillerStore> createState() => _FillerStoreState();
}

class _FillerStoreState extends State<FillerStore> {
  late WebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          bool canBack = await _webViewController.canGoBack();
          if(canBack) {
            _webViewController.goBack();
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(top: 35.0, bottom: 15.0),
            child: WebView(
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
              onPageFinished: (context) {

                _webViewController.runJavascript("""
              var video = document.getElementById('home-slider-video');
              video.loop = true;
              """);
                FlutterNativeSplash.remove();
              },
              gestureNavigationEnabled: true,
              backgroundColor: Colors.white,
              allowsInlineMediaPlayback: true,
              javascriptMode: JavascriptMode.unrestricted,      
              initialUrl: 'https://fillerstore.ru',
              debuggingEnabled: false,
             ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

const MaterialColor AppColor = const MaterialColor(
  0xFF00BAD4,
  const <int, Color>{
    50: const Color(0xFF00BAD4),
    100: const Color(0xFF00BAD4),
    200: const Color(0xFF00BAD4),
    300: const Color(0xFF00BAD4),
    400: const Color(0xFF00BAD4),
    500: const Color(0xFF00BAD4),
    600: const Color(0xFF00BAD4),
    700: const Color(0xFF00BAD4),
    800: const Color(0xFF00BAD4),
    900: const Color(0xFF00BAD4),
  },
);

const String startUrl = 'https://www.owahu.de';

class MyApp extends StatelessWidget {
  String lastPage = '';

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    lastPage = startUrl;

    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.startLoad) {
        if (!viewState.url.contains('owahu.de')) {
          // Not working correctly....
          flutterWebviewPlugin.stopLoading();
          flutterWebviewPlugin.reloadUrl(lastPage);
          _launchURL(viewState.url);
        } else if (viewState.url.contains('mailto:')) {
          flutterWebviewPlugin.stopLoading();
          flutterWebviewPlugin.reloadUrl(lastPage);
          _launchURL(viewState.url);
        } else {
          lastPage = viewState.url;
        }
      } else if (viewState.type == WebViewState.finishLoad) {
        flutterWebviewPlugin.resize(Rect.fromLTRB(
          MediaQuery.of(context).padding.left,

          /// for safe area
          MediaQuery.of(context).padding.top,

          /// for safe area
          MediaQuery.of(context).size.width + 3,

          /// add one to make it fullscreen
          MediaQuery.of(context).size.height,
        ));
      }
    });

    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: AppColor,
      ),
      home: new WebviewScaffold(
        url: startUrl,
        withJavascript: true,
        ignoreSSLErrors: true,
        withZoom: true,
        withLocalStorage: true,
        scrollBar: false,
        hidden: true,
        localUrlScope: '',
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(10.0), // here the desired height
            child: AppBar()),
      ),
    );
  }
}
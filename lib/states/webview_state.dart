import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:teragate/config/env.dart';
import 'package:teragate/states/widgets/navbar.dart';
import 'package:teragate/states/widgets/text.dart';

import '../config/font-weights.dart';

class WebViews extends StatefulWidget {
  final String userid;
  const WebViews(this.userid, Key? key) : super(key: key);

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebViews> {
  String? userPassward = "";
  late Map<String, String> param;

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  String currentUrl = "";
  double progress = 0;
  final urlController = TextEditingController();
  late Uri groupwareUri;

  @override
  void initState() {
    super.initState();
    groupwareUri = Uri.parse("${Env.SERVER_GROUPWARE_URL}/${widget.userid}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _createContainerByBackground(
      _initScaffoldByAppbar(SafeArea(
          child: Column(children: <Widget>[
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                  key: webViewKey,
                  initialUrlRequest:
                      URLRequest(url: groupwareUri), //실행 시 첫 접속 url
                  initialOptions: options,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {},
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  onLoadStop: (controller, url) async {}),
              progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container(),
            ],
          ),
        ),
      ]))),
    );
  }

  Scaffold _initScaffoldByAppbar(Widget widget) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: NavBar(
            title: CustomText(
              text: "환경설정",
              size: 20.0,
              weight: TeragateFontWeight.semiBold,
            ),
            isLeading: true,
            // isActions: true,
          ),
        ),
        backgroundColor: Colors.transparent,
        body: widget);
  }

  Container _createContainerByBackground(Widget widget) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.fill)),
        child: widget);
  }
}

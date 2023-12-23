import 'dart:async';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MaterialApp(
    home: InterstitialExample(),
  ));
}

/// A simple app that loads an interstitial ad.
class InterstitialExample extends StatefulWidget {
  const InterstitialExample({super.key});

  @override
  InterstitialExampleState createState() => InterstitialExampleState();
}

class InterstitialExampleState extends State<InterstitialExample> {
  static InterstitialAd? _interstitialAd;
  final _gameLength = 5;
  late var _counter = _gameLength;
  BannerAd? _bannerAd;
  String staticURL =
      'https://dub9yt9jaous2llnwnuokw.on.drv.tw/NURO%20AI%20RELEASE%202023%20%2F%20DECEMBER%20%2F%2018/NueoAihome%20.html';
  static final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-7933393775749899/8503871041'
      : 'ca-app-pub-7933393775749899/8503871041';
  static final String _adUnitIdBanner = Platform.isAndroid
      ? 'ca-app-pub-7933393775749899/2130034386'
      : 'ca-app-pub-7933393775749899/2130034386';
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          String staticURL =
              'https://dub9yt9jaous2llnwnuokw.on.drv.tw/NUROAIRELEASE2023DECEMBER22/NueoAiorg.html';

          if (url != staticURL) {
            _interstitialAd?.show();
            _loadAd();
          }
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(
              'https://dub9yt9jaous2llnwnuokw.on.drv.tw/NUROAIRELEASE2023DECEMBER22/NueoAiorg.html')) {
            return NavigationDecision.navigate;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        'https://dub9yt9jaous2llnwnuokw.on.drv.tw/NUROAIRELEASE2023DECEMBER22/NueoAiorg.html'));
  @override
  void initState() {
    super.initState();
    _loadAd();
    _loadAdBanner();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: MaterialApp(
        title: 'Interstitial Example',
        home: Scaffold(
          appBar: AppBar(
            title: Center(child: const Text('NURO AI')),
            backgroundColor: Color.fromARGB(255, 26, 36, 61),
          ),
          body: WebViewWidget(controller: controller),
        ),
      ),
    );
  }

  static void _loadAd() {
    InterstitialAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {},
                onAdImpression: (ad) {},
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
                onAdClicked: (ad) {});

            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadAdBanner() async {
    BannerAd(
      adUnitId: _adUnitIdBanner,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }
}

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:vegflavours/konstants.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewController controller;
  num position = 1;
  final key = UniqueKey();
  var internet = false;
  bool loadBottomNavBar = false;

  int _currentIndex = 1;


  doneLoading(String A) {
    loadBottomNavBar = true;
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        String url = await controller.currentUrl();
        if (url == "https://driptripsworld.com/") {
          return true;
        } else {
          controller.goBack();
          return false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFF0D0D0E),
          body: IndexedStack(index: position, children: [
            _connectionStatus != 'Failed to get connectivity.'
                ? WebView(
                    initialUrl: 'https://driptripsworld.com/music/',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController wc) {
                      controller = wc;
                    },
                    key: key,
                    onPageFinished: doneLoading,
                    onPageStarted: startLoading,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitPulse(
                          color: Colors.green,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No internet connection \n Please check your internet settings',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
            Container(
              height: MediaQuery.of(context).size.height,
              color: Color(0xFF0D0D0E),
              child: Center(
                  child: SpinKitPulse(
                color: Colors.green,
              )),
            ),
          ]),
          bottomNavigationBar: loadBottomNavBar?BottomNavigationBar(
            backgroundColor: Color(0xFF0D0D0E),
            currentIndex: _currentIndex,
            onTap: (value) {
              // Respond to item press.
              if(value == 0){
                controller.loadUrl('https://driptripsworld.com/');
              }
              else if(value == 2){
                controller.loadUrl('https://driptripsworld.com/shop/');
              }
              else{
                controller.loadUrl('https://driptripsworld.com/music/');
              }
              setState(() => _currentIndex = value);
            },
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.60),
            items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.music_note),label: 'Radio'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_rounded),label: 'Shop'),
          ],

          ):Container(
            height: 0,
          ),
        ),
      ),
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print(result.toString());
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        // case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
}

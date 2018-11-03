// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MaterialApp(home: WebViewExample()));
  //runApp(MaterialApp(home: MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
            primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: new SingleChildScrollView(
                child: Column(
                    children: [
                      Container(
                          height: 400.0,
                          color: Colors.orange,
                      ),
                      Container(
                          height: 400.0,
                          color: Colors.blue,
                          child: const WebView(
                              //initialUrl: 'https://youtube.com',
                              initialUrl: 'https://flutter.io',
                              javaScriptMode: JavaScriptMode.unrestricted,
                          ),
                      ),
                      Container(
                          height: 400.0,
                          color: Colors.orange,
                      ),
                    ],
                ),
            ),
        ),
        );
  }
}

class WebViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[const SampleMenu()],
      ),
      body: const WebView(
        //initialUrl: 'https://youtube.com',
        initialUrl: 'https://flutter.io',
        javaScriptMode: JavaScriptMode.unrestricted,
      ),
    );
  }
}

class SampleMenu extends StatelessWidget {
  const SampleMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      // onSelected: (String value) {
      //   Scaffold.of(context)
      //       .showSnackBar(SnackBar(content: Text('You selected: $value')));
      // },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            const PopupMenuItem<String>(
              value: 'Item 1',
              child: Text('Item 1'),
            ),
            const PopupMenuItem<String>(
              value: 'Item 2',
              child: Text('Item 2'),
            ),
          ],
    );
  }
}

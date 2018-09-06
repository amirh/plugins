// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: new WebViewExample()));

class WebViewExample extends StatefulWidget {
  @override
  State createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> with SingleTickerProviderStateMixin {
  TabController tabController;

  final List<String> tabs = <String>[
    'https://flutter.io',
    'https://news.google.com',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        bottom: new TabBar(
          controller: tabController,
          tabs: tabs.map((String url) => new Tab(text: url)).toList(),
        ),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[const SampleMenu()],
      ),
      body: new TabBarView(
        controller: tabController,
        children: tabs.map((String url) =>  new WebViewTab(url: url)).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: tabs.length, vsync: this);
  }
}

class WebViewTab extends StatefulWidget {
  const WebViewTab({Key key, this.url}) : super(key: key);

  final String url;

  @override
  State createState() => new WebViewTabState();
}

class WebViewTabState extends State<WebViewTab> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new WebView(
      initialUrl: widget.url,
      javaScriptMode: JavaScriptMode.unrestricted,
      gestureRecognizers: <OneSequenceGestureRecognizer>[ new VerticalDragGestureRecognizer() ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SampleMenu extends StatelessWidget {
  const SampleMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text('You selected: $value')));
      },
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

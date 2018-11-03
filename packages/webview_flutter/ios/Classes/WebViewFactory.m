//
//  WebViewFactory.m
//  Pods-Runner
//
//  Created by Amir Hardon on 10/12/18.
//

#import <WebKit/WebKit.h>
#import "WebViewFactory.h"


@implementation WebViewFactory

- (instancetype) init {
  return [super init];
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (UIView*)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
  WKWebView* view = [[WKWebView alloc] initWithFrame:frame];
  NSURL *url = [NSURL URLWithString:@"https://flutter.io"];
  //NSURL *url = [NSURL URLWithString:@"https://youtube.com"];
  NSURLRequest *req = [NSURLRequest requestWithURL:url];
  [view loadRequest:req];
  return view;
}

@end

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

- (UIView*)createWithFrame:(CGRect)frame {
  NSLog(@"Created!!!");
  return [[WKWebView alloc] initWithFrame:frame];
}

@end

package io.flutter.plugins.webviewflutter;

import android.annotation.TargetApi;
import android.content.Context;
import android.media.Image;
import android.os.Build;
import android.os.SystemClock;
import android.util.Log;
import android.view.Choreographer;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.TextView;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class WebViewFactory implements PlatformViewFactory {
    final BinaryMessenger messenger;

    public WebViewFactory(BinaryMessenger messenger) {
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id) {
        MethodChannel methodChannel = new MethodChannel(messenger, "webview_flutter/" + id);
        return new SimplePlatformView(context, methodChannel);
    }

    private static class SimplePlatformView implements PlatformView, MethodChannel.MethodCallHandler {
        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
        SimplePlatformView(Context context, MethodChannel methodChannel) {
//            ImageView imageView = new ImageView(context);
//            imageView.setImageDrawable(context.getDrawable(android.R.drawable.ic_dialog_email));
//            imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
//            this.webView = imageView;
            this.webView = new WebView(context);

            webView.setWebViewClient(new WebViewClient());
            webView.getSettings().setJavaScriptEnabled(true);

            methodChannel.setMethodCallHandler(this);
        }

        //private View webView;
        private WebView webView;

        @Override
        public View getView() {
            return webView;
        }

        @Override
        public void dispose() {
            webView = null;
        }

        @TargetApi(Build.VERSION_CODES.M)
        public void postOnNextFrame(final Runnable runnable) {
            webView.post(new Runnable() {
                @Override
                public void run() {
                    Choreographer.getInstance().postFrameCallback(new Choreographer.FrameCallback() {
                        @Override
                        public void doFrame(long frameTimeNanos) {
                            runnable.run();
                        }
                    });
                }
            });
            //runnable.run();
        }

        @Override
        public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
            switch(methodCall.method) {
                case "loadUrl":
                    String url = (String) methodCall.arguments;
                     webView.loadUrl(url);
                    return;
            }
            result.notImplemented();
        }
    }
}

package io.flutter.plugins.webviewflutter;

import android.annotation.TargetApi;
import android.content.Context;
import android.media.Image;
import android.os.Build;
import android.os.SystemClock;
import android.util.Log;
import android.view.Choreographer;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.TextView;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.security.Key;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class WebViewFactory implements PlatformViewFactory {
    final BinaryMessenger messenger;
    final View fluterView;

    public WebViewFactory(BinaryMessenger messenger, View fluterView) {
        this.messenger = messenger;
        this.fluterView = fluterView;
    }

    @Override
    public PlatformView create(Context context, int id) {
        MethodChannel methodChannel = new MethodChannel(messenger, "webview_flutter/" + id);
        return new SimplePlatformView(context, methodChannel, fluterView);
    }

    private static class SimplePlatformView implements PlatformView, MethodChannel.MethodCallHandler {
        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
        SimplePlatformView(Context context, MethodChannel methodChannel, View flutterView) {
//            ImageView imageView = new ImageView(context);
//            imageView.setImageDrawable(context.getDrawable(android.R.drawable.ic_dialog_email));
//            imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
//            this.webView = imageView;
            this.keyboardView = new KeyboardView(context, flutterView);
            this.webView = new MyWebView(context,flutterView);

            webView.setWebViewClient(new WebViewClient());
            webView.getSettings().setJavaScriptEnabled(true);

            methodChannel.setMethodCallHandler(this);
        }

        //private View webView;
        private WebView webView;
        private KeyboardView keyboardView;

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

class MyWebView extends WebView {

    final InputMethodManager mImm;
    boolean replaceRootView = false;
    final View flutterView;

    @TargetApi(Build.VERSION_CODES.CUPCAKE)
    public MyWebView(Context context, View flutterView) {
        super(context);
        mImm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        this.flutterView = flutterView;
    }

    @TargetApi(Build.VERSION_CODES.FROYO)
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getActionMasked() == MotionEvent.ACTION_DOWN) {
            stealFocus();
        }
        return super.onTouchEvent(event);
    }

    @TargetApi(Build.VERSION_CODES.CUPCAKE)
    private void stealFocus() {
        try {
            Method m = InputMethodManager.class.getMethod("focusIn", View.class);
            //replaceRootView = true;
            m.invoke(mImm, this);
            //replaceRootView = false;
        } catch (NoSuchMethodException e1) {
            Log.d("AMIR", "no such method");
        } catch (IllegalAccessException e1) {
            e1.printStackTrace();
        } catch (InvocationTargetException e1) {
            e1.printStackTrace();
        }
    }

    @Override
    public View getRootView() {
        // if(!replaceRootView)
        //     return super.getRootView();
        return flutterView.getRootView();
    }

}

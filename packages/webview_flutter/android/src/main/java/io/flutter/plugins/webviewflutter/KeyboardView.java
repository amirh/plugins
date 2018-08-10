package io.flutter.plugins.webviewflutter;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Build;
import android.util.Log;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.BaseInputConnection;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputMethodManager;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class KeyboardView extends View implements GestureDetector.OnGestureListener {

    InputMethodManager imm;
    View rootView;

    @TargetApi(Build.VERSION_CODES.CUPCAKE)
    public KeyboardView(Context context, View root) {
        super(context);
        rootView = root;
        gestureDetector = new GestureDetector(context, this);
        imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        // setFocusable(true);
        setFocusableInTouchMode(true);
    }
    GestureDetector gestureDetector;

    @Override
    public View getRootView() {
        if (replaceRootView)
            return rootView.getRootView();
        return super.getRootView();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        Paint p = new Paint();
        p.setColor(0xffffff00);
        p.setStyle(Paint.Style.STROKE);
        canvas.drawCircle(canvas.getWidth() / 2.0f, canvas.getHeight() / 2.0f, 80.0f, p);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return gestureDetector.onTouchEvent(event);
    }

    @Override
    public boolean onDown(MotionEvent e) {
        return true;
    }

    @Override
    public void onShowPress(MotionEvent e) {

    }

    boolean replaceRootView = false;
    @TargetApi(Build.VERSION_CODES.CUPCAKE)
    @Override
    public boolean onSingleTapUp(MotionEvent e) {
        try {
            Method m = InputMethodManager.class.getMethod("focusIn", View.class);
            replaceRootView = true;
            m.invoke(imm, this);
            replaceRootView = false;
        } catch (NoSuchMethodException e1) {
            Log.d("AMIR", "no such method");
        } catch (IllegalAccessException e1) {
            e1.printStackTrace();
        } catch (InvocationTargetException e1) {
            e1.printStackTrace();
        }
        isFocusable();
        Log.d("AMIR", "TAP");
        if (requestFocus()) {
            Log.d("AMIR", "showing keyboard");
            imm.showSoftInput(this, InputMethodManager.SHOW_IMPLICIT);
        } else {
            Log.d("AMIR", "no focus");
        }
        return true;
    }

    @Override
    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
        return false;
    }

    @Override
    public void onLongPress(MotionEvent e) {

    }

    @Override
    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
        return false;
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        Log.d("AMIR", "view onKeyDown: " + event);
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
        return new BaseInputConnection(this, false) {
            @TargetApi(Build.VERSION_CODES.ECLAIR)
            @Override
            public boolean sendKeyEvent(KeyEvent event) {
                Log.d("AMIR", "view sendKeyEvent: " + event);
                Log.d("AMIR", "view sendKeyEvent, isCancelled " + event.isCanceled());
                return super.sendKeyEvent(event);
            }
        };
    }
}

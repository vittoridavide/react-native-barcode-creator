package com.reactnativebarcodecreator;

import android.util.Base64;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewProps;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.google.zxing.BarcodeFormat;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

public class BarcodeCreatorViewManager extends BarcodeCreatorViewManagerSpec<BarcodeView> {
    public static final String REACT_CLASS = "BarcodeCreatorView";

    ReactApplicationContext mCallerContext;

  public BarcodeCreatorViewManager(ReactApplicationContext reactContext) {
    mCallerContext = reactContext;
  }

  @Override
  public String getName() {
    return REACT_CLASS;
  }

  @NonNull
  @Override
  protected BarcodeView createViewInstance(@NonNull ThemedReactContext reactContext) {
    BarcodeView qrCodeView = new BarcodeView(reactContext);
    return qrCodeView;
  }

  @ReactProp(name = "format")
  public void setFormat(BarcodeView view, @Nullable String format) {
    view.setFormat(BarcodeFormat.valueOf(format));
  }

  @ReactProp(name = "foregroundColor")
  public void setForeground(BarcodeView view, @Nullable String color) {
    view.setForegroundColor(color);
  }

  @ReactProp(name = "background")
  public void setBackground(BarcodeView view, @Nullable String color) {
    view.setBackgroundColor(color);
  }

  @ReactProp(name = "value")
  public void setValue(BarcodeView view, @Nullable String content) {
    view.setContent(content);
  }


  @ReactProp(name = "encodedValue")
  public void setBase64(BarcodeView view, @Nullable ReadableMap encodedValue) {
    if (encodedValue != null ){
      String encoded = encodedValue.getString("base64");
      String encodedFormat = encodedValue.getString("messageEncoded");
      try {
        byte[] bytes = Base64.decode(encoded, Base64.URL_SAFE);
        view.setContent(new String(bytes, encodedFormat));
      } catch (UnsupportedEncodingException e) {
        Utils.showException(mCallerContext, e);
        e.printStackTrace();
      }
    }
  }

  @ReactProp(name = ViewProps.WIDTH, defaultInt = 100)
  public void setWidth(BarcodeView view, @Nullable int width) {
    view.setWidth(width);
  }

  @ReactProp(name = ViewProps.HEIGHT, defaultInt = 100)
  public void setHeight(BarcodeView view, @Nullable int height) {
    view.setHeight(height);
  }

  @Override
  public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
    Map<String, Object> export = new HashMap<>();
    export.put("onBarcodeError", MapBuilder.of("registrationName", "onBarcodeError"));
    return export;
  }

  // Implement abstract methods from BarcodeCreatorViewManagerSpec for Fabric compatibility
  @Override
  public void setFormat(BarcodeView view, @Nullable String format) {
    if (format != null) {
      view.setFormat(BarcodeFormat.valueOf(format));
    }
  }

  @Override
  public void setValue(BarcodeView view, @Nullable String value) {
    if (value != null) {
      view.setContent(value);
    }
  }

  @Override
  public void setBackground(BarcodeView view, @Nullable String color) {
    if (color != null) {
      view.setBackgroundColor(color);
    }
  }

  @Override
  public void setForegroundColor(BarcodeView view, @Nullable String color) {
    if (color != null) {
      view.setForegroundColor(color);
    }
  }

  @Override
  public void setWidth(BarcodeView view, int width) {
    view.setWidth(width);
  }

  @Override
  public void setHeight(BarcodeView view, int height) {
    view.setHeight(height);
  }

}

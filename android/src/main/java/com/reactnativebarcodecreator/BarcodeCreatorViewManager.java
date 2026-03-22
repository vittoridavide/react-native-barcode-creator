package com.reactnativebarcodecreator;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.util.Log;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewManagerDelegate;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.viewmanagers.BarcodeCreatorViewManagerDelegate;
import com.facebook.react.viewmanagers.BarcodeCreatorViewManagerInterface;
import com.google.zxing.BarcodeFormat;

public class BarcodeCreatorViewManager extends SimpleViewManager<BarcodeView>
  implements BarcodeCreatorViewManagerInterface<BarcodeView> {
  public static final String REACT_CLASS = "BarcodeCreatorView";

  private final ViewManagerDelegate<BarcodeView> delegate;

  public BarcodeCreatorViewManager(ReactApplicationContext reactContext) {
    delegate = new BarcodeCreatorViewManagerDelegate<>(this);
  }

  @Override
  public String getName() {
    return REACT_CLASS;
  }

  @Nullable
  @Override
  protected ViewManagerDelegate<BarcodeView> getDelegate() {
    return delegate;
  }

  @NonNull
  @Override
  protected BarcodeView createViewInstance(@NonNull ThemedReactContext reactContext) {
    return new BarcodeView(reactContext);
  }

  @Override
  @ReactProp(name = "format")
  public void setFormat(BarcodeView view, @Nullable String format) {
    if (format == null || format.isEmpty()) {
      return;
    }
    try {
      view.setFormat(BarcodeFormat.valueOf(format));
    } catch (IllegalArgumentException e) {
      Log.w("BarcodeCreator", "Unknown barcode format: " + format, e);
    }
  }

  @Override
  @ReactProp(name = "foregroundColor")
  public void setForegroundColor(BarcodeView view, @Nullable String color) {
    if (color == null) {
      return;
    }
    view.setForegroundColor(color);
  }

  @Override
  @ReactProp(name = "background")
  public void setBackground(BarcodeView view, @Nullable String color) {
    if (color == null) {
      return;
    }
    view.setBackgroundColor(color);
  }

  @Override
  @ReactProp(name = "value")
  public void setValue(BarcodeView view, @Nullable String content) {
    view.setContent(content == null ? "" : content);
  }

  @Override
  @ReactProp(name = "encodedValueBase64")
  public void setEncodedValueBase64(BarcodeView view, @Nullable String encodedValueBase64) {
    view.setEncodedValueBase64(encodedValueBase64);
  }

  @Override
  @ReactProp(name = "messageEncoded")
  public void setMessageEncoded(BarcodeView view, @Nullable String messageEncoded) {
    view.setMessageEncoded(messageEncoded);
  }
}

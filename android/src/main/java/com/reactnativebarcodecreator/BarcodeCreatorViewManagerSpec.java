package com.reactnativebarcodecreator;

import android.view.View;

import androidx.annotation.Nullable;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ViewManagerDelegate;

/**
 * Fabric ViewManagerSpec for BarcodeCreatorView
 * This serves as a base class that will work with both legacy and Fabric architectures
 */
public abstract class BarcodeCreatorViewManagerSpec<T extends View> extends SimpleViewManager<T> {

  // For New Architecture compatibility - will be set by generated code when available
  private ViewManagerDelegate<T> mDelegate;

  public BarcodeCreatorViewManagerSpec() {
    // mDelegate will be null in legacy architecture, which is fine
    mDelegate = createDelegate();
  }

  protected ViewManagerDelegate<T> createDelegate() {
    // This will be overridden by codegen in New Architecture
    // For legacy, return null which is handled by SimpleViewManager
    return null;
  }

  @Nullable
  @Override
  protected ViewManagerDelegate<T> getDelegate() {
    return mDelegate;
  }

  // Interface methods that will be implemented by the concrete ViewManager
  public abstract void setFormat(T view, @Nullable String value);
  public abstract void setValue(T view, @Nullable String value);
  public abstract void setBackground(T view, @Nullable String value);
  public abstract void setForegroundColor(T view, @Nullable String value);
  public abstract void setWidth(T view, int value);
  public abstract void setHeight(T view, int value);
}

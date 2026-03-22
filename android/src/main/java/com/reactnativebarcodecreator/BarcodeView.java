package com.reactnativebarcodecreator;

import java.util.HashMap;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Color;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.ExceptionsManagerModule;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;

import static com.reactnativebarcodecreator.Utils.showException;

public class BarcodeView extends androidx.appcompat.widget.AppCompatImageView {
  int width = 100;
  int height = 100;
  String content = "";
  int foregroundColor = 0x000000;
  int background = 0xffffff;
  BarcodeFormat format = BarcodeFormat.QR_CODE;
  ReactContext context;
  public static int dpToPx(int dp) {
    return (int) (dp * Resources.getSystem().getDisplayMetrics().density);
  }
  public void setWidth(int width) {
    this.width = dpToPx(width);
    updateQRCodeView();
  }

  public void setHeight(int height) {
    this.height = dpToPx(height);
    updateQRCodeView();
  }

  public void setFormat(BarcodeFormat format) {
    this.format = format;
    updateQRCodeView();
  }

  public void setContent(String content) {
    this.content = content;
    updateQRCodeView();
  }


  private int handleColor(String color) throws Exception {
    if(!color.startsWith("#") || (color.length() != 4 && color.length() != 7 && color.length() != 9)) {
      throw new Exception("Color not supported");
    }
    if (color.length() == 4){
      String sub = color.substring(1, 4);
      color += sub;
      color += "FF";
    }else if (color.length() == 7){
      color += "FF";
    }
    long iColor = Long.parseLong(color.replaceFirst("#", ""), 16);
    int r = (int) ((iColor >> 24) & 0xFF);
    int g = (int) ((iColor >> 16) & 0xFF);
    int b = (int) ((iColor >> 8) & 0xFF);
    int a = (int) ((iColor) & 0xFF);
    return Color.argb(a,r, g, b);
  }

  public void setForegroundColor(String c) {
    if (c.isEmpty()) return;
    try {
      this.foregroundColor = handleColor(c);
      updateQRCodeView();
    }catch (Exception e) {
      showException(context, e);
      e.printStackTrace();
    }
  }

  public void setBackgroundColor(String c) {
    if (c.isEmpty()) return;
    try {
      this.background = handleColor(c);
      updateQRCodeView();
    }catch (Exception e) {
      showException(context, e);
      e.printStackTrace();
    }
  }

  public void updateQRCodeView() {
    if (content.isEmpty()) return;

    MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
    try {
      HashMap<EncodeHintType, Integer> hintMap = new HashMap<>();
      hintMap.put(EncodeHintType.MARGIN, 0);
      BitMatrix bitMatrix = multiFormatWriter.encode(content, format, width, height);
      BarcodeEncoder barcodeEncoder = new BarcodeEncoder();
      Bitmap bitmap = barcodeEncoder.createBitmap(bitMatrix, background, foregroundColor);
      setImageBitmap(bitmap);
    } catch (Exception e) {
      showException(context, e);
      e.printStackTrace();
    }
  }



  public BarcodeView(ReactContext context) {
    super(context);
    this.context = context;
  }
}

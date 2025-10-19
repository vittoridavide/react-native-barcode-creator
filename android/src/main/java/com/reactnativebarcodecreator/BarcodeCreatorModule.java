package com.reactnativebarcodecreator;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.module.annotations.ReactModule;
import com.google.zxing.BarcodeFormat;

import java.util.HashMap;
import java.util.Map;

@ReactModule(name = BarcodeCreatorModule.NAME)
public class BarcodeCreatorModule extends ReactContextBaseJavaModule {
  
  public static final String NAME = "BarcodeCreatorModule";
  
  public BarcodeCreatorModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }
  @Nullable
  @Override
  public Map<String, Object> getConstants() {
    Map<String, Object> constants = new HashMap<String, Object>() {{
      put("AZTEC", BarcodeFormat.AZTEC.name());
      put("CODE128", BarcodeFormat.CODE_128.name());
      put("PDF417", BarcodeFormat.PDF_417.name());
      put("QR", BarcodeFormat.QR_CODE.name());
      put("EAN13", BarcodeFormat.EAN_13.name());
      put("UPCA", BarcodeFormat.UPC_A.name());
    }};
    return constants;
  }

  @NonNull
  @Override
  public String getName() {
    return NAME;
  }
}

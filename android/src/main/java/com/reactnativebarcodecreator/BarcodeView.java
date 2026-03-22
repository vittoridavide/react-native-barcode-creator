package com.reactnativebarcodecreator;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.util.Base64;
import android.util.Log;
import com.facebook.react.bridge.ReactContext;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;

public class BarcodeView extends androidx.appcompat.widget.AppCompatImageView {
  private static final String TAG = "BarcodeCreator";
  private static final int DEFAULT_SIZE_DP = 100;

  private String content = "";
  private String encodedValueBase64 = null;
  private String messageEncoded = null;
  private int foregroundColor = 0x000000;
  private int background = 0xffffff;
  private BarcodeFormat format = BarcodeFormat.QR_CODE;
  private final ReactContext context;

  public BarcodeView(ReactContext context) {
    super(context);
    this.context = context;
    setScaleType(ScaleType.FIT_XY);
  }

  /**
   * Validates that the given content is acceptable for the current barcode format.
   * Returns true if valid, false otherwise (and logs a warning).
   */
  private boolean isValidContentForFormat(String content, BarcodeFormat format) {
    if (content == null || content.isEmpty()) {
      return false;
    }

    switch (format) {
      case UPC_A:
        // UPC-A requires exactly 11 digits (check digit auto-calculated) or 12 digits
        if (!content.matches("^\\d{11,12}$")) {
          Log.w(TAG, "UPC_A requires 11 or 12 numeric digits, got: \"" + content + "\"");
          return false;
        }
        return true;

      case UPC_E:
        if (!content.matches("^\\d{7,8}$")) {
          Log.w(TAG, "UPC_E requires 7 or 8 numeric digits, got: \"" + content + "\"");
          return false;
        }
        return true;

      case EAN_13:
        if (!content.matches("^\\d{12,13}$")) {
          Log.w(TAG, "EAN_13 requires 12 or 13 numeric digits, got: \"" + content + "\"");
          return false;
        }
        return true;

      case EAN_8:
        if (!content.matches("^\\d{7,8}$")) {
          Log.w(TAG, "EAN_8 requires 7 or 8 numeric digits, got: \"" + content + "\"");
          return false;
        }
        return true;

      case ITF:
        if (!content.matches("^\\d+$") || content.length() % 2 != 0) {
          Log.w(TAG, "ITF requires an even number of numeric digits, got: \"" + content + "\"");
          return false;
        }
        return true;

      default:
        // QR_CODE, CODE_128, AZTEC, PDF_417, etc. accept arbitrary content
        return true;
    }
  }

  private void applyEncodedValueIfPossible() {
    if (encodedValueBase64 == null || encodedValueBase64.isEmpty() || messageEncoded == null || messageEncoded.isEmpty()) {
      return;
    }

    try {
      byte[] bytes = Base64.decode(encodedValueBase64, Base64.URL_SAFE);
      setContent(new String(bytes, messageEncoded));
    } catch (UnsupportedEncodingException e) {
      Log.w(TAG, "Unsupported encoding: " + messageEncoded, e);
    }
  }

  public static int dpToPx(int dp) {
    return (int) (dp * Resources.getSystem().getDisplayMetrics().density);
  }

  public void setFormat(BarcodeFormat format) {
    this.format = format;
    updateQRCodeView();
  }

  public void setContent(String content) {
    this.content = content;
    updateQRCodeView();
  }

  public void setEncodedValueBase64(String encodedValueBase64) {
    this.encodedValueBase64 = encodedValueBase64;
    applyEncodedValueIfPossible();
  }

  public void setMessageEncoded(String messageEncoded) {
    this.messageEncoded = messageEncoded;
    applyEncodedValueIfPossible();
  }

  private int handleColor(String color) throws Exception {
    if (!color.startsWith("#") || (color.length() != 4 && color.length() != 7 && color.length() != 9)) {
      throw new Exception("Color not supported");
    }

    if (color.length() == 4) {
      String sub = color.substring(1, 4);
      color += sub;
      color += "FF";
    } else if (color.length() == 7) {
      color += "FF";
    }

    long iColor = Long.parseLong(color.replaceFirst("#", ""), 16);
    int r = (int) ((iColor >> 24) & 0xFF);
    int g = (int) ((iColor >> 16) & 0xFF);
    int b = (int) ((iColor >> 8) & 0xFF);
    int a = (int) (iColor & 0xFF);
    return Color.argb(a, r, g, b);
  }

  public void setForegroundColor(String color) {
    if (color.isEmpty()) {
      return;
    }

    try {
      foregroundColor = handleColor(color);
      updateQRCodeView();
    } catch (Exception e) {
      Log.w(TAG, "Invalid foreground color: " + color, e);
    }
  }

  public void setBackgroundColor(String color) {
    if (color.isEmpty()) {
      return;
    }

    try {
      background = handleColor(color);
      updateQRCodeView();
    } catch (Exception e) {
      Log.w(TAG, "Invalid background color: " + color, e);
    }
  }

  /**
   * Clears the currently displayed bitmap without removing or replacing the view.
   * This is Fabric-safe: it only mutates the existing ImageView's content.
   */
  private void clearBitmap() {
    setImageBitmap(null);
  }

  public void updateQRCodeView() {
    if (content == null || content.isEmpty()) {
      clearBitmap();
      return;
    }

    // Pre-validate content for the current format before attempting to encode.
    // This prevents ZXing from throwing, which under Fabric would leave the
    // native view update path in a broken state.
    if (!isValidContentForFormat(content, format)) {
      clearBitmap();
      return;
    }

    int targetWidth = getWidth() > 0 ? getWidth() : dpToPx(DEFAULT_SIZE_DP);
    int targetHeight = getHeight() > 0 ? getHeight() : dpToPx(DEFAULT_SIZE_DP);

    try {
      MultiFormatWriter multiFormatWriter = new MultiFormatWriter();
      HashMap<EncodeHintType, Integer> hintMap = new HashMap<>();
      hintMap.put(EncodeHintType.MARGIN, 0);
      BitMatrix bitMatrix = multiFormatWriter.encode(content, format, targetWidth, targetHeight, hintMap);
      BarcodeEncoder barcodeEncoder = new BarcodeEncoder();
      Bitmap bitmap = barcodeEncoder.createBitmap(bitMatrix, background, foregroundColor);
      setImageBitmap(bitmap);
    } catch (Exception e) {
      // Defensive catch: if encoding still fails despite validation, clear the
      // bitmap safely. NEVER propagate or report as fatal — doing so under Fabric
      // tears down the native view and causes "Unable to find view for viewState".
      Log.w(TAG, "Failed to encode barcode (format=" + format + ", content=\"" + content + "\")", e);
      clearBitmap();
    }
  }

  @Override
  protected void onSizeChanged(int w, int h, int oldw, int oldh) {
    super.onSizeChanged(w, h, oldw, oldh);
    if (w != oldw || h != oldh) {
      updateQRCodeView();
    }
  }
}

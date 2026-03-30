import CoreImage
import Foundation
import UIKit

@objc(BarcodeCreatorViewManager)
class BarcodeCreatorViewManager: RCTViewManager {
  override func view() -> BarcodeCreatorView {
    BarcodeCreatorView()
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    true
  }
}

@objc(BarcodeCreatorView)
@objcMembers
public class BarcodeCreatorView: UIView {
  private let imageView = UIImageView()
  private var resolvedForegroundColor: UIColor = .black
  private var resolvedBackgroundColor: UIColor = .white

  public var format: NSString = "QR_CODE" {
    didSet {
      generateCode()
    }
  }

  public var value: NSString = "" {
    didSet {
      generateCode()
    }
  }

  public var valueByteArray: [UInt8]? {
    didSet {
      if let valueByteArray {
        value = (String(bytes: valueByteArray, encoding: .isoLatin1) ?? "") as NSString
      }
    }
  }

  public var encodedValueBase64: NSString? {
    didSet {
      applyEncodedValueIfPossible()
    }
  }

  public var messageEncoded: NSString? {
    didSet {
      applyEncodedValueIfPossible()
    }
  }

  public var foregroundColor: NSString = "#000000" {
    didSet {
      resolvedForegroundColor = Self.color(from: foregroundColor as String) ?? .black
      generateCode()
    }
  }

  public var background: NSString = "#FFFFFF" {
    didSet {
      resolvedBackgroundColor = Self.color(from: background as String) ?? .white
      generateCode()
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    CIEANBarcodeGenerator.register()
    imageView.contentMode = .scaleToFill
    addSubview(imageView)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = bounds
  }

  private func applyEncodedValueIfPossible() {
    guard let base64 = encodedValueBase64 as String?,
          !base64.isEmpty,
          let messageEncoded = messageEncoded as String?,
          !messageEncoded.isEmpty
    else {
      return
    }

    let normalizedBase64 = base64
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")

    guard let data = Data(base64Encoded: normalizedBase64, options: .ignoreUnknownCharacters),
          let decodedValue = String(data: data, encoding: encoding(for: messageEncoded))
    else {
      return
    }

    value = decodedValue as NSString
  }

  private func encoding(for format: String) -> String.Encoding {
    switch format.uppercased() {
    case "ISO-8859-1":
      return .isoLatin1
    case "UTF-8":
      return .utf8
    case "UTF-16":
      return .utf16
    default:
      return .utf16
    }
  }

  private func nativeFormat(for format: String) -> String {
    switch format.uppercased() {
    case "AZTEC":
      return "CIAztecCodeGenerator"
    case "CODE_128":
      return "CICode128BarcodeGenerator"
    case "PDF_417":
      return "CIPDF417BarcodeGenerator"
    case "EAN_13", "UPC_A":
      return "CIEANBarcodeGenerator"
    case "QR_CODE":
      fallthrough
    default:
      return "CIQRCodeGenerator"
    }
  }

  func generateCode() {
    let currentValue = value as String
    guard !currentValue.isEmpty,
          let filter = CIFilter(name: nativeFormat(for: format as String)),
          let data = currentValue.data(using: .isoLatin1, allowLossyConversion: false)
    else {
      return
    }

    filter.setValue(data, forKey: "inputMessage")
    if filter.inputKeys.contains("inputQuietSpace") {
      filter.setValue(0, forKey: "inputQuietSpace")
    }

    guard let ciImage = filter.outputImage else {
      return
    }

    let transformed = ciImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
    let invertFilter = CIFilter(name: "CIColorInvert")
    invertFilter?.setValue(transformed, forKey: kCIInputImageKey)

    let alphaFilter = CIFilter(name: "CIMaskToAlpha")
    alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)

    let context = CIContext(options: nil)
    guard let outputImage = alphaFilter?.outputImage,
          let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
    else {
      return
    }

    imageView.tintColor = resolvedForegroundColor
    imageView.backgroundColor = resolvedBackgroundColor
    imageView.image = UIImage(cgImage: cgImage, scale: 2.0, orientation: .up)
      .withRenderingMode(.alwaysTemplate)
  }

  private static func color(from rawValue: String) -> UIColor? {
    let value = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)

    if value.hasPrefix("#") {
      return hexColor(from: value)
    }

    let lowercased = value.lowercased()
    if lowercased.hasPrefix("rgba(") {
      return rgbaColor(from: value)
    }

    if lowercased.hasPrefix("rgb(") {
      return rgbColor(from: value)
    }

    return nil
  }

  private static func hexColor(from value: String) -> UIColor? {
    let hex = value.replacingOccurrences(of: "#", with: "")
    let normalizedHex: String
    switch hex.count {
    case 3:
      normalizedHex = hex.map { "\($0)\($0)" }.joined() + "FF"
    case 6:
      normalizedHex = hex + "FF"
    case 8:
      normalizedHex = hex
    default:
      return nil
    }

    var color: UInt64 = 0
    guard Scanner(string: normalizedHex).scanHexInt64(&color) else {
      return nil
    }

    let red = CGFloat((color >> 24) & 0xFF) / 255.0
    let green = CGFloat((color >> 16) & 0xFF) / 255.0
    let blue = CGFloat((color >> 8) & 0xFF) / 255.0
    let alpha = CGFloat(color & 0xFF) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

  private static func rgbColor(from value: String) -> UIColor? {
    guard let components = parseColorComponents(from: value, expectedCount: 3) else {
      return nil
    }

    return UIColor(
      red: components[0] / 255.0,
      green: components[1] / 255.0,
      blue: components[2] / 255.0,
      alpha: 1.0
    )
  }

  private static func rgbaColor(from value: String) -> UIColor? {
    guard let components = parseColorComponents(from: value, expectedCount: 4) else {
      return nil
    }

    return UIColor(
      red: components[0] / 255.0,
      green: components[1] / 255.0,
      blue: components[2] / 255.0,
      alpha: components[3]
    )
  }

  private static func parseColorComponents(from value: String, expectedCount: Int) -> [CGFloat]? {
    guard let start = value.firstIndex(of: "("),
          let end = value.lastIndex(of: ")"),
          start < end
    else {
      return nil
    }

    let values = value[value.index(after: start)..<end]
      .split(separator: ",")
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

    guard values.count == expectedCount else {
      return nil
    }

    var components: [CGFloat] = []
    for (index, component) in values.enumerated() {
      guard let number = Double(component) else {
        return nil
      }

      if index < 3 {
        guard (0...255).contains(number) else {
          return nil
        }
      } else {
        guard (0...1).contains(number) else {
          return nil
        }
      }

      components.append(CGFloat(number))
    }

    return components
  }
}

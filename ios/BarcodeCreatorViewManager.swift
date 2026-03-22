@objc(BarcodeCreatorViewManager)
class BarcodeCreatorViewManager: RCTViewManager {

  override func view() -> (BarcodeCreatorView) {
    return BarcodeCreatorView()
  }
   @objc
      override func constantsToExport() -> [AnyHashable : Any]! {
          return [
                  "AZTEC": "CIAztecCodeGenerator",
                  "CODE128": "CICode128BarcodeGenerator",
                  "PDF417": "CIPDF417BarcodeGenerator",
                  "QR": "CIQRCodeGenerator",
                  "EAN13": "CIEANBarcodeGenerator",
                  "UPCA": "CIEANBarcodeGenerator"
          ]
      }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

class BarcodeCreatorView : UIView {

  lazy var imageView = UIImageView()
      @objc var format = "CIQRCodeGenerator" {
          didSet {
              generateCode()
          }
      }

      @objc var value = "" {
          didSet {
              generateCode()
          }
      }

      @objc var valueByteArray: [UInt8]? {
          didSet {
              if let valueByteArray = valueByteArray {
                  self.value = String(bytes: valueByteArray, encoding: .isoLatin1) ?? ""
                  generateCode()
              }
          }
      }

      func encoded(format: String) -> String.Encoding {
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

      @objc var encodedValue: [String: Any]? {
          didSet {
              if let base64 = encodedValue?["base64"] as? String,
                 let encodingFormat = encodedValue?["messageEncoded"] as? String{
                  let b64 = base64
                      .replacingOccurrences(of: "-", with: "+")
                      .replacingOccurrences(of: "_", with: "/")
                  if let data = Data(base64Encoded: b64, options: .ignoreUnknownCharacters).map ({String(data: $0, encoding: encoded(format: encodingFormat))}) as? String {
                      self.value = data
                      generateCode()
                  }

              }
          }
      }


      @objc var foregroundColor: UIColor = .black {
          didSet {
              generateCode()
          }
      }

      @objc var background: UIColor = .white {
          didSet {
              generateCode()
          }
      }

      override init(frame: CGRect) {
          super.init(frame: frame)
          CIEANBarcodeGenerator.register()
          addSubview(imageView)

      }

      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

      override func layoutSubviews() {
          super.layoutSubviews()
          imageView.frame = bounds
      }

      func generateCode() {
          guard !value.isEmpty, let filter = CIFilter(name: format),
                let data = value.data(using: .isoLatin1, allowLossyConversion: false) else {
              return
          }

          filter.setValue(data, forKey: "inputMessage")
          if filter.inputKeys.contains("inputQuietSpace") {
               filter.setValue(0, forKey: "inputQuietSpace")
          }

          guard let ciImage = filter.outputImage else {
              return
          }

          let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
          let invertFilter = CIFilter(name: "CIColorInvert")
          invertFilter?.setValue(transformed, forKey: kCIInputImageKey)

          let alphaFilter = CIFilter(name: "CIMaskToAlpha")
          alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)

          let context = CIContext(options: nil)

          if let outputImage = alphaFilter?.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent)   {
              imageView.tintColor = foregroundColor
              imageView.backgroundColor = background
              imageView.image = UIImage(cgImage: cgImage, scale: 2.0, orientation: .up)
              .withRenderingMode(.alwaysTemplate)
          }
      }

      @objc var color: String = "" {
          didSet {
              self.backgroundColor = hexStringToUIColor(hexColor: color)
          }
      }

      func hexStringToUIColor(hexColor: String) -> UIColor {
          let stringScanner = Scanner(string: hexColor)

          if(hexColor.hasPrefix("#")) {
              stringScanner.scanLocation = 1
          }
          var color: UInt32 = 0
          stringScanner.scanHexInt32(&color)

          let r = CGFloat(Int(color >> 16) & 0x000000FF)
          let g = CGFloat(Int(color >> 8) & 0x000000FF)
          let b = CGFloat(Int(color) & 0x000000FF)

          return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
      }
}

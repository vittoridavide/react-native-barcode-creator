import UIKit
import CoreImage

// Shared implementation for both Legacy UIView and Fabric ComponentView
class BarcodeCreatorViewImpl {
    
    // MARK: - Properties
    var format = "CIQRCodeGenerator" {
        didSet {
            generateCode()
        }
    }
    
    var value = "" {
        didSet {
            generateCode()
        }
    }
    
    var valueByteArray: [UInt8]? {
        didSet {
            if let valueByteArray = valueByteArray {
                self.value = String(bytes: valueByteArray, encoding: .isoLatin1) ?? ""
                generateCode()
            }
        }
    }
    
    var encodedValue: [String: Any]? {
        didSet {
            if let base64 = encodedValue?["base64"] as? String,
               let encodingFormat = encodedValue?["messageEncoded"] as? String {
                let b64 = base64
                    .replacingOccurrences(of: "-", with: "+")
                    .replacingOccurrences(of: "_", with: "/")
                if let data = Data(base64Encoded: b64, options: .ignoreUnknownCharacters),
                   let decodedString = String(data: data, encoding: encoded(format: encodingFormat)) {
                    self.value = decodedString
                    generateCode()
                }
            }
        }
    }
    
    var foregroundColor: UIColor = .black {
        didSet {
            generateCode()
        }
    }
    
    var background: UIColor = .white {
        didSet {
            generateCode()
        }
    }
    
    // MARK: - UI Components
    let imageView = UIImageView()
    
    // MARK: - Memory Management
    private static var sharedContext: CIContext = {
        let options: [CIContextOption: Any] = [
            .useSoftwareRenderer: false,
            .cacheIntermediates: false
        ]
        return CIContext(options: options)
    }()
    
    // MARK: - Event Handling
    var onBarcodeError: ((String) -> Void)?
    
    // MARK: - Initialization
    init() {
        CIEANBarcodeGenerator.register()
        setupImageView()
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
    }
    
    func setupConstraints(in containerView: UIView) {
        containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    // MARK: - Utility Methods
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
    
    func hexStringToUIColor(hexColor: String) -> UIColor {
        let stringScanner = Scanner(string: hexColor)
        
        if hexColor.hasPrefix("#") {
            stringScanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        stringScanner.scanHexInt32(&color)
        
        let r = CGFloat(Int(color >> 16) & 0x000000FF)
        let g = CGFloat(Int(color >> 8) & 0x000000FF)
        let b = CGFloat(Int(color) & 0x000000FF)
        
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    // MARK: - Barcode Generation
    func generateCode() {
        guard !value.isEmpty else {
            imageView.image = nil
            return
        }
        
        do {
            let image = try generateBarcodeImage()
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        } catch {
            let errorMessage = "Failed to generate barcode: \(error.localizedDescription)"
            onBarcodeError?(errorMessage)
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = nil
            }
        }
    }
    
    private func generateBarcodeImage() throws -> UIImage? {
        guard let filter = CIFilter(name: format),
              let data = value.data(using: .isoLatin1, allowLossyConversion: false) else {
            throw BarcodeError.invalidInput
        }
        
        filter.setValue(data, forKey: "inputMessage")
        
        guard let ciImage = filter.outputImage else {
            throw BarcodeError.filterFailed
        }
        
        // Apply transformations
        let transformed = ciImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        
        // Apply color filters
        guard let invertFilter = CIFilter(name: "CIColorInvert") else {
            throw BarcodeError.filterFailed
        }
        invertFilter.setValue(transformed, forKey: kCIInputImageKey)
        
        guard let alphaFilter = CIFilter(name: "CIMaskToAlpha") else {
            throw BarcodeError.filterFailed
        }
        alphaFilter.setValue(invertFilter.outputImage, forKey: kCIInputImageKey)
        
        guard let outputImage = alphaFilter.outputImage,
              let cgImage = Self.sharedContext.createCGImage(outputImage, from: outputImage.extent) else {
            throw BarcodeError.renderFailed
        }
        
        let uiImage = UIImage(cgImage: cgImage, scale: 2.0, orientation: .up)
            .withRenderingMode(.alwaysTemplate)
        
        return uiImage
    }
    
    func updateColors() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.tintColor = self.foregroundColor
            self.imageView.backgroundColor = self.background
        }
    }
}

// MARK: - Error Types
enum BarcodeError: Error, LocalizedError {
    case invalidInput
    case filterFailed
    case renderFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid barcode input data"
        case .filterFailed:
            return "Core Image filter processing failed"
        case .renderFailed:
            return "Failed to render barcode image"
        }
    }
}
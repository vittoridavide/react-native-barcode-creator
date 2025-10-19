@objc(BarcodeCreatorViewManager)
class BarcodeCreatorViewManager: RCTViewManager {

  override func view() -> (BarcodeCreatorView) {
    let view = BarcodeCreatorView()
    return view
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
      
  // MARK: - Event Support
  override func customDirectEventTypes() -> [String]! {
    return ["onBarcodeError"]
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  // MARK: - Fabric Architecture Detection
  @objc static func fabricEnabled() -> Bool {
      #if RCT_NEW_ARCH_ENABLED
      return true
      #else
      return false
      #endif
  }
}

class BarcodeCreatorView : UIView {
    
    // MARK: - Properties  
    private let impl = BarcodeCreatorViewImpl()
    
    // Legacy property accessors using shared implementation
    @objc var format: String {
        get { impl.format }
        set { impl.format = newValue }
    }
    
    @objc var value: String {
        get { impl.value }
        set { impl.value = newValue }
    }
    
    @objc var valueByteArray: [UInt8]? {
        get { impl.valueByteArray }
        set { impl.valueByteArray = newValue }
    }
    
    @objc var encodedValue: [String: Any]? {
        get { impl.encodedValue }
        set { impl.encodedValue = newValue }
    }
    
    @objc var foregroundColor: UIColor {
        get { impl.foregroundColor }
        set { 
            impl.foregroundColor = newValue
            impl.updateColors()
        }
    }
    
    @objc var background: UIColor {
        get { impl.background }
        set { 
            impl.background = newValue
            impl.updateColors()
        }
    }
    
    @objc var color: String = "" {
        didSet {
            self.backgroundColor = impl.hexStringToUIColor(hexColor: color)
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        impl.setupConstraints(in: self)
        
        // Setup error event handling for legacy architecture
        impl.onBarcodeError = { [weak self] errorMessage in
            self?.emitBarcodeErrorEvent(error: errorMessage)
        }
        
        // Apply initial colors
        impl.updateColors()
    }
    
    // Event callback property
    @objc var onBarcodeError: RCTDirectEventBlock?
    
    // MARK: - Legacy Event Emission
    private func emitBarcodeErrorEvent(error: String) {
        guard let onBarcodeError = onBarcodeError else { return }
        
        let event: [String: Any] = [
            "error": error
        ]
        
        onBarcodeError(event)
    }
}

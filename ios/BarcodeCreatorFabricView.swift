#if RCT_NEW_ARCH_ENABLED

import UIKit

@objc(BarcodeCreatorFabricView)
class BarcodeCreatorFabricView: UIView {
    
    // MARK: - Properties
    private let impl = BarcodeCreatorViewImpl()
    
    // MARK: - Event Emitters
    private var eventEmitter: RCTBubblingEventEmitter?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        impl.setupConstraints(in: self)
        
        // Setup error event handling
        impl.onBarcodeError = { [weak self] errorMessage in
            self?.emitBarcodeError(error: errorMessage)
        }
        
        // Apply initial colors
        impl.updateColors()
    }
    
    // MARK: - RCTComponentViewProtocol-like Methods
    func updateProps(_ props: [String: Any]) {
        var needsColorUpdate = false
        
        if let format = props["format"] as? String {
            impl.format = format
        }
        
        if let value = props["value"] as? String {
            impl.value = value
        }
        
        if let encodedValue = props["encodedValue"] as? [String: Any] {
            impl.encodedValue = encodedValue
        }
        
        if let foregroundColorValue = props["foregroundColor"] {
            if let color = convertToUIColor(foregroundColorValue) {
                impl.foregroundColor = color
                needsColorUpdate = true
            }
        }
        
        if let backgroundValue = props["background"] {
            if let color = convertToUIColor(backgroundValue) {
                impl.background = color
                needsColorUpdate = true
            }
        }
        
        if needsColorUpdate {
            impl.updateColors()
        }
    }
    
    func updateEventEmitter(_ eventEmitter: AnyObject?) {
        // In a real Fabric implementation, this would be the generated EventEmitter
        // For now, we'll use a generic approach
        self.eventEmitter = eventEmitter as? RCTBubblingEventEmitter
    }
    
    // MARK: - Event Emission
    private func emitBarcodeError(error: String) {
        let event = [
            "error": error
        ]
        
        // Emit through event emitter if available
        eventEmitter?.onBarcodeError(event)
    }
    
    // MARK: - Color Conversion
    private func convertToUIColor(_ value: Any) -> UIColor? {
        if let colorString = value as? String {
            return impl.hexStringToUIColor(hexColor: colorString)
        } else if let colorNumber = value as? NSNumber {
            // Handle color as integer (React Native color format)
            let colorValue = colorNumber.uint32Value
            let alpha = CGFloat((colorValue >> 24) & 0xFF) / 255.0
            let red = CGFloat((colorValue >> 16) & 0xFF) / 255.0
            let green = CGFloat((colorValue >> 8) & 0xFF) / 255.0
            let blue = CGFloat(colorValue & 0xFF) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        return nil
    }
}

// MARK: - Event Emitter Protocol
@objc protocol RCTBubblingEventEmitter {
    func onBarcodeError(_ event: [String: Any])
}

#endif
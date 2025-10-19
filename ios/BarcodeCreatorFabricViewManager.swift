#if RCT_NEW_ARCH_ENABLED

import UIKit

@objc(BarcodeCreatorFabricViewManager)
class BarcodeCreatorFabricViewManager: NSObject {
    
    @objc static func createView() -> BarcodeCreatorFabricView {
        return BarcodeCreatorFabricView()
    }
    
    @objc static func constantsToExport() -> [String: Any] {
        return [
            "AZTEC": "CIAztecCodeGenerator",
            "CODE128": "CICode128BarcodeGenerator", 
            "PDF417": "CIPDF417BarcodeGenerator",
            "QR": "CIQRCodeGenerator",
            "EAN13": "CIEANBarcodeGenerator",
            "UPCA": "CIEANBarcodeGenerator"
        ]
    }
    
    // MARK: - Property Updates
    @objc static func updateProps(_ view: BarcodeCreatorFabricView, props: [String: Any]) {
        view.updateProps(props)
    }
    
    @objc static func updateEventEmitter(_ view: BarcodeCreatorFabricView, eventEmitter: AnyObject?) {
        view.updateEventEmitter(eventEmitter)
    }
}

#endif
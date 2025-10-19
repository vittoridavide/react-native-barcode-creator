#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(BarcodeCreatorViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(format, NSString)
RCT_EXPORT_VIEW_PROPERTY(value, NSString)
RCT_EXPORT_VIEW_PROPERTY(foregroundColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(background, UIColor)
RCT_EXPORT_VIEW_PROPERTY(valueByteArray, NSArray)
RCT_EXPORT_VIEW_PROPERTY(encodedValue, NSDictionary)

// Event support
RCT_EXPORT_VIEW_PROPERTY(onBarcodeError, RCTDirectEventBlock)

@end

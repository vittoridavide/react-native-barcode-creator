#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(BarcodeCreatorViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(format, NSString)
RCT_EXPORT_VIEW_PROPERTY(value, NSString)
RCT_EXPORT_VIEW_PROPERTY(foregroundColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(background, NSString)
RCT_EXPORT_VIEW_PROPERTY(valueByteArray, NSArray)
RCT_EXPORT_VIEW_PROPERTY(encodedValueBase64, NSString)
RCT_EXPORT_VIEW_PROPERTY(messageEncoded, NSString)

@end

#ifdef RCT_NEW_ARCH_ENABLED

#import <React/RCTViewComponentView.h>
#import <react/renderer/components/RNBarcodeCreatorSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNBarcodeCreatorSpec/Props.h>
#import <react/renderer/components/RNBarcodeCreatorSpec/RCTComponentViewHelpers.h>

#if __has_include(<react_native_barcode_creator/react_native_barcode_creator-Swift.h>)
#import <react_native_barcode_creator/react_native_barcode_creator-Swift.h>
#elif __has_include("react_native_barcode_creator-Swift.h")
#import "react_native_barcode_creator-Swift.h"
#elif __has_include(<react_native_barcode_creator/BarcodeCreator-Swift.h>)
#import <react_native_barcode_creator/BarcodeCreator-Swift.h>
#elif __has_include("BarcodeCreator-Swift.h")
#import "BarcodeCreator-Swift.h"
#endif

using namespace facebook::react;

@interface BarcodeCreatorViewComponentView : RCTViewComponentView <RCTBarcodeCreatorViewViewProtocol>
@end

@implementation BarcodeCreatorViewComponentView {
  BarcodeCreatorView *_barcodeView;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<BarcodeCreatorViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    static const auto defaultProps = std::make_shared<const BarcodeCreatorViewProps>();
    _props = defaultProps;
    _barcodeView = [BarcodeCreatorView new];
    self.contentView = _barcodeView;
  }

  return self;
}

static NSString *NSStringFromStdString(const std::string &value)
{
  return [NSString stringWithUTF8String:value.c_str()];
}

- (void)updateProps:(const Props::Shared &)props oldProps:(const Props::Shared &)oldProps
{
  const auto &newViewProps = *std::static_pointer_cast<const BarcodeCreatorViewProps>(props);

  _barcodeView.format = NSStringFromStdString(newViewProps.format);
  _barcodeView.value = NSStringFromStdString(newViewProps.value);
  _barcodeView.encodedValueBase64 = NSStringFromStdString(newViewProps.encodedValueBase64);
  _barcodeView.messageEncoded = NSStringFromStdString(newViewProps.messageEncoded);
  _barcodeView.foregroundColor = NSStringFromStdString(newViewProps.foregroundColor);
  _barcodeView.background = NSStringFromStdString(newViewProps.background);

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> BarcodeCreatorViewCls(void)
{
  return BarcodeCreatorViewComponentView.class;
}

@end

#endif

import {requireNativeComponent, UIManager} from 'react-native';
import type {NativeProps} from './NativeBarcodeCreatorView';

const ComponentName = 'BarcodeCreatorView';

// Legacy wrapper using the same prop types to preserve API surface
const LegacyBarcodeCreatorView = UIManager.getViewManagerConfig(ComponentName) != null
  ? requireNativeComponent<NativeProps>(ComponentName)
  : (() => {
      throw new Error(
        "react-native-barcode-creator: Legacy native view is not linked. Did you run 'pod install' and rebuild?"
      );
    }) as any;

export default LegacyBarcodeCreatorView;

import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
  NativeModules,
} from 'react-native';

// Import Fabric components (will be ignored in legacy mode)
import BarcodeCreatorViewNativeComponent from './NativeBarcodeCreatorView';
import NativeBarcodeCreator from './NativeBarcodeCreatorModule';

const LINKING_ERROR =
  `The package 'react-native-barcode-creator' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n';

export type BarcodeCreatorProps = {
  format: string;
  value?: string;
  encodedValue?: {
    base64: string;
    messageEncoded: string;
  };
  background?: string;
  foregroundColor?: string;
  style?: ViewStyle;
  width?: number;
  height?: number;
  onBarcodeError?: (event: { nativeEvent: { error: string } }) => void;
};

const ComponentName = 'BarcodeCreatorView';

// Check if we're running with New Architecture (Fabric)
const isFabricEnabled = (global as any).nativeFabricUIManager != null;

export const BarcodeCreatorView = isFabricEnabled
  ? BarcodeCreatorViewNativeComponent
  : UIManager.getViewManagerConfig(ComponentName) != null
  ? requireNativeComponent<BarcodeCreatorProps>(ComponentName)
  : () => {
      throw new Error(LINKING_ERROR);
    };

// Constants export with Fabric/Legacy support
const getConstants = () => {
  if (isFabricEnabled) {
    try {
      return NativeBarcodeCreator.getConstants();
    } catch (error) {
      console.warn('Fabric constants not available, falling back to legacy');
    }
  }

  // Legacy fallback
  if (NativeModules.BarcodeCreatorModule) {
    return NativeModules.BarcodeCreatorModule.getConstants();
  }

  // Final fallback with hardcoded values
  return {
    AZTEC: 'AZTEC',
    CODE128: 'CODE_128',
    PDF417: 'PDF_417',
    QR: 'QR_CODE',
    EAN13: 'EAN_13',
    UPCA: 'UPC_A',
  };
};

const constants = getConstants();

export const BarcodeFormat = {
  AZTEC: constants.AZTEC,
  CODE128: constants.CODE128,
  PDF417: constants.PDF417,
  QR: constants.QR,
  EAN13: constants.EAN13,
  UPCA: constants.UPCA,
};

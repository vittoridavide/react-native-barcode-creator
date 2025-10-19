import {
  UIManager,
  Platform,
  type ViewStyle,
  NativeModules,
} from 'react-native';

// Import Fabric components (will be ignored in legacy mode)
import NativeBarcodeCreatorView from './NativeBarcodeCreatorView';
import LegacyBarcodeCreatorView from './LegacyBarcodeCreatorView';
import NativeBarcodeCreator from './NativeBarcodeCreatorModule';

const LINKING_ERROR =
  `The package 'react-native-barcode-creator' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n'

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

// Auto-detect Old vs New Architecture at runtime using multiple signals
const isFabricEnabled = Boolean(
  // RN >=0.72 sets this global
  (global as any).nativeFabricUIManager ||
  // Platform.constants heuristic
  (Platform as any)?.constants?.reactNativeVersion?.fabric === true
);

// Unified component wrapper with graceful fallback
export const BarcodeCreatorView = isFabricEnabled
  ? NativeBarcodeCreatorView
  : UIManager.getViewManagerConfig(ComponentName) != null
  ? LegacyBarcodeCreatorView
  : () => {
      throw new Error(
        LINKING_ERROR +
          '\n- Neither Fabric nor legacy view manager is available. Please ensure codegen/pods are installed.'
      );
    };

// Constants export with Fabric/Legacy support
const getConstants = () => {
  // Prefer TurboModule when available (New Architecture)
  try {
    return NativeBarcodeCreator.getConstants();
  } catch {}

  // Legacy fallback
  if (NativeModules.BarcodeCreatorModule?.getConstants) {
    return NativeModules.BarcodeCreatorModule.getConstants();
  }

  // Final fallback with hardcoded values to avoid runtime errors
  return {
    AZTEC: 'AZTEC',
    CODE128: 'CODE_128',
    PDF417: 'PDF_417',
    QR: 'QR_CODE',
    EAN13: 'EAN_13',
    UPCA: 'UPC_A',
  } as const;
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

import type { ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Int32,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

export interface NativeProps extends ViewProps {
  format?: WithDefault<string, 'QR_CODE'>;
  value?: WithDefault<string, ''>;
  background?: WithDefault<string, '#FFFFFF'>;
  foregroundColor?: WithDefault<string, '#000000'>;
  width?: WithDefault<Int32, 100>;
  height?: WithDefault<Int32, 100>;
  encodedValue?: Readonly<{
    base64: string;
    messageEncoded: string;
  }>;

  // Event handlers for Fabric
  onBarcodeError?: DirectEventHandler<
    Readonly<{
      error: string;
    }>
  >;
}

export default codegenNativeComponent<NativeProps>('BarcodeCreatorView');

import type {ViewProps} from 'react-native';
import type {
  DirectEventHandler,
  Double,
  Int32,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

export interface NativeProps extends ViewProps {
  format: string;
  value?: WithDefault<string, ''>;
  encodedValue?: Readonly<{
    base64: string;
    messageEncoded: string;
  }>;
  background?: WithDefault<string, '#FFFFFF'>;
  foregroundColor?: WithDefault<string, '#000000'>;
  width?: WithDefault<Int32, 100>;
  height?: WithDefault<Int32, 100>;
  onError?: DirectEventHandler<Readonly<{
    error: string;
    code?: WithDefault<Double, 0>;
  }>>;
}

export default codegenNativeComponent<NativeProps>('BarcodeCreatorView');
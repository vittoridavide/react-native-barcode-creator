import type { HostComponent, ViewProps } from 'react-native';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

export interface NativeProps extends ViewProps {
  format?: string;
  value?: string;
  encodedValueBase64?: string;
  messageEncoded?: string;
  background?: string;
  foregroundColor?: string;
}

export default codegenNativeComponent<NativeProps>(
  'BarcodeCreatorView'
) as HostComponent<NativeProps>;

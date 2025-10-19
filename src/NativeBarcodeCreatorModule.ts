import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  readonly getConstants: () => {
    AZTEC: string;
    CODE128: string;
    PDF417: string;
    QR: string;
    EAN13: string;
    UPCA: string;
  };
}

export default TurboModuleRegistry.getEnforcing<Spec>('BarcodeCreatorModule');
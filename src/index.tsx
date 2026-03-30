import React from 'react';
import type { ComponentType } from 'react';
import type { ViewStyle } from 'react-native';
import type { NativeProps } from './BarcodeCreatorNativeComponent';

export const BarcodeFormat = {
  AZTEC: 'AZTEC',
  CODE128: 'CODE_128',
  PDF417: 'PDF_417',
  QR: 'QR_CODE',
  EAN13: 'EAN_13',
  UPCA: 'UPC_A',
} as const;

export type BarcodeFormatValue =
  (typeof BarcodeFormat)[keyof typeof BarcodeFormat];

/** Numeric-only formats and their expected digit lengths. */
const NUMERIC_FORMAT_RULES: Partial<
  Record<BarcodeFormatValue, { name: string; minDigits: number; maxDigits: number }>
> = {
  [BarcodeFormat.UPCA]: { name: 'UPC_A', minDigits: 11, maxDigits: 12 },
  [BarcodeFormat.EAN13]: { name: 'EAN_13', minDigits: 12, maxDigits: 13 },
};

function warnIfInvalidValue(
  format: BarcodeFormatValue | undefined,
  value: string | undefined
): void {
  if (!format || value == null) return;
  const rule = NUMERIC_FORMAT_RULES[format];
  if (!rule) return;

  if (!/^\d+$/.test(value)) {
    console.warn(
      `[BarcodeCreator] ${rule.name} requires numeric digits only. Received: "${value}"`
    );
  } else if (value.length < rule.minDigits || value.length > rule.maxDigits) {
    console.warn(
      `[BarcodeCreator] ${rule.name} expects ${rule.minDigits}-${rule.maxDigits} digits. Received ${value.length} digits.`
    );
  }
}

export type EncodedValue = {
  base64: string;
  messageEncoded: string;
};

export type BarcodeCreatorProps = {
  format?: BarcodeFormatValue;
  value?: string;
  encodedValue?: EncodedValue;
  background?: string;
  foregroundColor?: string;
  style?: ViewStyle;
};

let NativeBarcodeCreatorView: ComponentType<NativeProps> | null = null;

const getNativeBarcodeCreatorView = (): ComponentType<NativeProps> => {
  if (NativeBarcodeCreatorView != null) {
    return NativeBarcodeCreatorView;
  }
  const reactNativeModule = require('react-native') as
    | {
        Platform?: {
          OS?: string;
        };
      }
    | undefined;
  const platform = reactNativeModule?.Platform?.OS;

  if (platform !== 'ios' && platform !== 'android') {
    const UnsupportedBarcodeCreatorView = (() => {
      throw new Error(
        `react-native-barcode-creator is not supported on platform "${platform ?? 'unknown'}".`
      );
    }) as ComponentType<NativeProps>;
    NativeBarcodeCreatorView = UnsupportedBarcodeCreatorView;
    return UnsupportedBarcodeCreatorView;
  }

  const nativeComponentModule = require('./BarcodeCreatorNativeComponent') as
    | ComponentType<NativeProps>
    | { default?: ComponentType<NativeProps> };
  const BarcodeCreatorNativeComponent =
    (typeof nativeComponentModule === 'object' &&
    nativeComponentModule != null &&
    'default' in nativeComponentModule
      ? nativeComponentModule.default
      : nativeComponentModule) as ComponentType<NativeProps> | undefined;

  if (BarcodeCreatorNativeComponent == null) {
    throw new Error(
      'react-native-barcode-creator failed to load its native component.'
    );
  }
  NativeBarcodeCreatorView = BarcodeCreatorNativeComponent;
  return BarcodeCreatorNativeComponent;
};
export const BarcodeCreatorView = ({
  encodedValue,
  value,
  format,
  ...props
}: BarcodeCreatorProps) => {
  if (__DEV__) {
    warnIfInvalidValue(format, value);
  }

  const NativeComponent = getNativeBarcodeCreatorView();
  return (
    <NativeComponent
      {...props}
      format={format}
      value={encodedValue == null ? value : undefined}
      encodedValueBase64={encodedValue?.base64}
      messageEncoded={encodedValue?.messageEncoded}
    />
  );
};

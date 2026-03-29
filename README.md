<div align="center">
  <br />
  <img src="https://randomstuffshared.s3.eu-west-2.amazonaws.com/logo_rnbc.png" alt="RNBC" width="140" />
  <h1>RNBC</h1>
  <p><strong>Barcode Creator</strong></p>
  <br />
  <p>
    <img src="https://img.shields.io/badge/New_Architecture-Fabric_&_Turbo_Modules-000000?style=flat-square&colorA=000000&colorB=888888" alt="new architecture" />
    <a href="https://www.npmjs.com/package/react-native-barcode-creator"><img src="https://img.shields.io/npm/v/react-native-barcode-creator?style=flat-square&colorA=000000&colorB=888888" alt="npm" /></a>
    <a href="https://www.npmjs.com/package/react-native-barcode-creator"><img src="https://img.shields.io/npm/dm/react-native-barcode-creator?style=flat-square&colorA=000000&colorB=888888&label=downloads" alt="downloads" /></a>
    <a href="https://github.com/nicovitt/react-native-barcode-creator/blob/main/LICENSE"><img src="https://img.shields.io/npm/l/react-native-barcode-creator?style=flat-square&colorA=000000&colorB=888888" alt="license" /></a>
  </p>
  <p>Native barcode generation for React Native</p>
  <p><sub>QR · Code128 · PDF417 · AZTEC · EAN-13 · UPC-A</sub></p>
  <br />
</div>

<div align="center">
  <img src="https://randomstuffshared.s3.eu-west-2.amazonaws.com/screenshot_rnbc.png" alt="Supported formats" width="380" />
</div>

<br />

## Getting Started

<details>
<summary><strong>React Native CLI</strong></summary>
<br />

```sh
yarn add react-native-barcode-creator
cd ios && pod install
```

</details>

<details>
<summary><strong>Expo</strong></summary>
<br />

```sh
npx expo install react-native-barcode-creator
npx expo prebuild
```

> Requires a **Development Build** — Expo Go is not supported.

</details>

## Usage

```jsx
import { BarcodeCreatorView, BarcodeFormat } from "react-native-barcode-creator";

<BarcodeCreatorView
  value={"Hello World"}
  background={"#FFFFFF"}
  foregroundColor={"#000000"}
  format={BarcodeFormat.AZTEC}
  style={styles.box}
/>
```

## Props

| Prop | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `value` | `string` | **\*** | — | Content to encode. EAN-13 expects 13 digits, UPC-A expects 12. |
| `encodedValue` | `{ base64, messageEncoded }` | | — | Alternative to `value`. Encoding: `ISO-8859-1`, `UTF-8`, `UTF-16`. |
| `format` | `BarcodeFormat` | **\*** | `QR` | `QR` · `AZTEC` · `PDF417` · `CODE128` · `EAN13` · `UPCA` |
| `style` | `ViewStyle` | | — | Standard [View style](https://reactnative.dev/docs/view-style-props). |
| `background` | `string` | | `#FFFFFF` | Background color (rgb/rgba). |
| `foregroundColor` | `string` | | `#000000` | Foreground color (rgb/rgba). |

## Contributing

See the [contributing guide](CONTRIBUTING.md).

## License

MIT

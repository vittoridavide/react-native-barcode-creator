# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Development Commands

### Core Build & Development
- `yarn`: Install dependencies for all packages (root and example)
- `yarn prepare`: Build the library using bob (react-native-builder-bob)
- `yarn clean`: Clean all build artifacts and generated files
- `yarn release`: Publish new version using release-it

### Quality Assurance
- `yarn test`: Run Jest unit tests
- `yarn typecheck`: Type-check files with TypeScript
- `yarn lint`: Lint files with ESLint
- `yarn lint --fix`: Auto-fix ESLint errors

### Example App Development
- `yarn example start`: Start Metro bundler for example app
- `yarn example android`: Run example app on Android
- `yarn example ios`: Run example app on iOS

### Single Test Execution
- `yarn test --testNamePattern="specific test name"`: Run specific test
- `yarn test src/__tests__/index.test.tsx`: Run specific test file

## Architecture

### Project Structure
This is a React Native library with native iOS (Swift) and Android (Kotlin/Java) implementations:

- **`src/index.tsx`**: Main TypeScript entry point exposing `BarcodeCreatorView` component and `BarcodeFormat` constants
- **`ios/BarcodeCreatorViewManager.swift`**: iOS native implementation using Core Image filters
- **`android/src/main/`**: Android implementation using ZXing library
- **`example/`**: Complete React Native test application

### Native Bridge Architecture
The library uses React Native's native module system:
- **View Manager Pattern**: `BarcodeCreatorViewManager` manages native view lifecycle
- **Props Bridge**: TypeScript props are bridged to native properties (`format`, `value`, `background`, `foregroundColor`)
- **Constants Export**: Native barcode format constants are exposed to JavaScript via `constantsToExport()`

### Barcode Generation Flow
1. JavaScript sets props on `BarcodeCreatorView`
2. Native view managers receive prop updates
3. **iOS**: Uses Core Image filters (CIQRCodeGenerator, CICode128BarcodeGenerator, etc.)
4. **Android**: Uses Google ZXing library for barcode generation
5. Generated barcode is rendered as native view

### Key Dependencies
- **iOS**: Core Image framework for barcode generation
- **Android**: `com.google.zxing:core:3.5.3` for barcode generation
- **Build**: `react-native-builder-bob` for TypeScript compilation and multi-format builds

### Development Workflow
1. Make changes to library source in `src/`
2. JavaScript changes reflect immediately in example app
3. Native changes require rebuilding example app (`yarn example android/ios`)
4. Use XCode for iOS debugging: `example/ios/BarcodeCreatorExample.xcworkspace`
5. Use Android Studio for Android debugging: `example/android`
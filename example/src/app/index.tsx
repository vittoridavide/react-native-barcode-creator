import { StyleSheet, View } from 'react-native';
import { BarcodeCreatorView, BarcodeFormat } from 'react-native-barcode-creator';
import { SafeAreaView } from 'react-native-safe-area-context';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { MaxContentWidth, Spacing } from '@/constants/theme';

const SQUARE_SAMPLES = [
  { label: 'QR Code', format: BarcodeFormat.QR, value: 'https://reactnative.dev' },
  { label: 'Aztec', format: BarcodeFormat.AZTEC, value: 'The cake is a lie' },
];

const BAR_SAMPLES = [
  { label: 'Code 128', format: BarcodeFormat.CODE128, value: 'REACT-NATIVE' },
  { label: 'PDF 417', format: BarcodeFormat.PDF417, value: 'To infinity and beyond!' },
  { label: 'EAN-13', format: BarcodeFormat.EAN13, value: '4006381333931' },
  { label: 'UPC-A', format: BarcodeFormat.UPCA, value: '036000291452' },
];

export default function HomeScreen() {
  return (
    <ThemedView style={styles.container}>
      <SafeAreaView style={styles.safeArea}>
        <View style={styles.topRow}>
          {SQUARE_SAMPLES.map((sample) => (
            <View key={sample.label} style={styles.squareCell}>
              <BarcodeCreatorView
                value={sample.value}
                background={'#FFFFFF'}
                foregroundColor={'#000000'}
                format={sample.format}
                style={styles.squareBarcode}
              />
              <ThemedText type="small" style={styles.label}>
                {sample.label}
              </ThemedText>
            </View>
          ))}
        </View>

        <View style={styles.bottomGrid}>
          {BAR_SAMPLES.map((sample) => (
            <View key={sample.label} style={styles.barCell}>
              <BarcodeCreatorView
                value={sample.value}
                background={'#FFFFFF'}
                foregroundColor={'#000000'}
                format={sample.format}
                style={styles.wideBarcode}
              />
              <ThemedText type="small" style={styles.label}>
                {sample.label}
              </ThemedText>
            </View>
          ))}
        </View>
      </SafeAreaView>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    flexDirection: 'row',
  },
  safeArea: {
    flex: 1,
    maxWidth: MaxContentWidth,
    paddingHorizontal: Spacing.four,
    justifyContent: 'center',
    alignItems: 'center',
    gap: Spacing.five,
  },
  topRow: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: Spacing.five,
  },
  squareCell: {
    alignItems: 'center',
    gap: Spacing.two,
  },
  squareBarcode: {
    width: 140,
    height: 140,
  },
  bottomGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'center',
    columnGap: Spacing.four,
    rowGap: Spacing.four,
  },
  barCell: {
    alignItems: 'center',
    gap: Spacing.two,
    width: '45%',
  },
  wideBarcode: {
    width: '100%',
    aspectRatio: 2.5,
  },
  label: {
    textAlign: 'center',
  },
});

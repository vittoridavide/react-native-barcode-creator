import { Platform, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { BarcodeCreatorView, BarcodeFormat } from 'react-native-barcode-creator';

import { Text, View } from '@/components/Themed';

export default function TabOneScreen() {
  return (
    <View style={styles.container}>
      <SafeAreaView style={styles.safeArea}>
        <Text style={styles.title}>react-native-barcode-creator</Text>
        <Text style={styles.subtitle}>AZTEC demo</Text>
        <BarcodeCreatorView
          value="Hello World"
          background="#FFFFFF"
          foregroundColor="#000000"
          format={BarcodeFormat.AZTEC}
          style={styles.box}
        />
        {Platform.OS === 'web' && (
          <Text style={styles.note}>Rendering on web may vary.</Text>
        )}
      </SafeAreaView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  safeArea: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 12,
    paddingHorizontal: 24,
  },
  title: {
    fontSize: 22,
    fontWeight: '700',
  },
  subtitle: {
    fontSize: 16,
    opacity: 0.7,
  },
  box: {
    width: 200,
    height: 200,
  },
  note: {
    fontSize: 12,
    opacity: 0.6,
  },
});

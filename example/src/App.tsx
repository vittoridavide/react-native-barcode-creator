import * as React from 'react';
import {useCallback, useMemo, useRef, useState} from 'react';
import {
  Button,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import {
  BarcodeFormat,
  BarcodeCreatorView,
} from 'react-native-barcode-creator';

export default function App() {
  const [value, setValue] = useState('Hello World');
  const [fg, setFg] = useState('#000000');
  const [bg, setBg] = useState('#FFFFFF');
  const formats = useMemo(() => (
    [
      BarcodeFormat.QR,
      BarcodeFormat.CODE128,
      BarcodeFormat.PDF417,
      BarcodeFormat.AZTEC,
      BarcodeFormat.EAN13,
      BarcodeFormat.UPCA,
    ] as const
  ), []);
  const [formatIndex, setFormatIndex] = useState(0);
  const format = formats[formatIndex % formats.length];

  const [error, setError] = useState<string | null>(null);

  const cycleFormat = useCallback(() => {
    setFormatIndex((i) => (i + 1) % formats.length);
  }, [formats.length]);

  const injectInvalidColor = useCallback(() => {
    setFg('#GGG'); // Will trigger onBarcodeError
  }, []);

  const isFabric = Boolean(
    (global as any).nativeFabricUIManager ||
      (Platform as any)?.constants?.reactNativeVersion?.fabric === true
  );

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>react-native-barcode-creator</Text>
      <Text style={styles.arch}>
        Architecture: {isFabric ? 'Fabric (New Arch)' : 'Legacy'}
      </Text>

      <View style={styles.row}>
        <Text style={styles.label}>Value</Text>
        <TextInput
          style={styles.input}
          value={value}
          onChangeText={setValue}
          placeholder="Content"
        />
      </View>

      <View style={styles.row}>
        <Text style={styles.label}>Foreground</Text>
        <TextInput style={styles.input} value={fg} onChangeText={setFg} />
      </View>
      <View style={styles.row}>
        <Text style={styles.label}>Background</Text>
        <TextInput style={styles.input} value={bg} onChangeText={setBg} />
      </View>

      <View style={styles.preview}>
        <BarcodeCreatorView
          value={value}
          background={bg}
          foregroundColor={fg}
          format={format}
          style={styles.box}
          onBarcodeError={(e) => setError(e.nativeEvent.error)}
        />
      </View>

      {!!error && <Text style={styles.error}>Error: {error}</Text>}

      <View style={styles.buttons}>
        <Button title={`Format: ${format}`} onPress={cycleFormat} />
        <View style={{width: 12}} />
        <Button title="Trigger Error" color="#c00" onPress={injectInvalidColor} />
      </View>

      <View style={styles.constants}>
        <Text style={styles.subtitle}>Constants</Text>
        <Text selectable>{JSON.stringify(BarcodeFormat, null, 2)}</Text>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 16,
    alignItems: 'stretch',
  },
  title: { fontSize: 18, fontWeight: '700', marginBottom: 4 },
  subtitle: { fontSize: 16, fontWeight: '600', marginBottom: 4 },
  arch: { marginBottom: 12, color: '#666' },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  label: { width: 100 },
  input: {
    flex: 1,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: '#ccc',
    paddingHorizontal: 8,
    paddingVertical: 6,
    borderRadius: 6,
  },
  preview: {
    alignItems: 'center',
    justifyContent: 'center',
    marginVertical: 16,
  },
  box: {
    width: 160,
    height: 160,
  },
  buttons: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-start',
    marginBottom: 16,
  },
  constants: { marginTop: 8 },
  error: { color: '#c00', marginTop: 8 },
});

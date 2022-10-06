## Usage

Welcome to Pickers
To use this plugin, add `pickers` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

```dart 

GestureDetector(
    onTap: () async {
        DateTime? dateTime = await Pickers.datePicker(context);
    },
)

GestureDetector(
    onTap: () async {
        DateTime? dateTime = await Pickers.timePicker(context);
        String time = Mixins.dateFormat(dateTime, format: 'HH:mm') // 10:30
    },
)

### iOS

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Example usage description</string>
```

### Android

Add the following permissions to your _AndroidManifest.xml_, located in `<project root>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```
## Usage

Welcome to Pickers, to use this plugin, add `pickers` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

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

GestureDetector(
    onTap: () async {
        List<Media>? images = await Pickers.imagePicker(context, maxImages: 5);
    },
),
```

### iOS

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Example usage description</string>
```

### Android

Add the following permissions to your _AndroidManifest.xml_, located in `<project root>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

Change the minimum Android sdk version to 21 (or higher) in your `android/app/build.gradle` file.

```groovy
minSdkVersion 21
```
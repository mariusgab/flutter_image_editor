# FlutterImageEditor

Image Editor Plugin with simple, easy support for image editing using Paints, Text, Filters, Emoji and Sticker like stories.

This is an updated version of the deprecated [ImageEditorPro](https://github.com/zeeshux7860/ImageEditorPro).

To start with this, we need to simply add the dependencies in the gradle file of our app module like this

## Installation

First, add 
```dart
flutter_image_editor:
    git:
    url: https://github.com/mariusgab/flutter_image_editor.git
    ref: master
```
as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

Import

```dart
import 'package:flutter_image_editor/flutter_image_editor.dart';
```

### iOS

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryUsageDescription` - describe why your app needs permission for the photo library. This is called _Privacy - Photo Library Usage Description_ in the visual editor.
* `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called _Privacy - Camera Usage Description_ in the visual editor.
* `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called _Privacy - Microphone Usage Description_ in the visual editor.

Or in text format add the key:

``` xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSCameraUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSMicrophoneUsageDescription</key>
<string>Used to capture audio for image picker plugin</string>
```

### Android

No configuration required - the plugin should work out of the box.

```dart
_editImage(String filePath) async {
  var editedImage = await Navigator.push(context, MaterialPageRoute(builder: (_) => FlutterImageEditor(
    defaultImage: File(filePath),
    appBarColor: Colors.blue,
    bottomBarColor: Colors.blue,
  )));
  // do something with the edited image
}
```

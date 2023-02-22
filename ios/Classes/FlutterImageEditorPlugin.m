#import "FlutterImageEditorPlugin.h"
#if __has_include(<fl_image_editor/fl_image_editor-Swift.h>)
#import <fl_image_editor/fl_image_editor-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fl_image_editor-Swift.h"
#endif

@implementation FlutterImageEditorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterImageEditorPlugin registerWithRegistrar:registrar];
}
@end

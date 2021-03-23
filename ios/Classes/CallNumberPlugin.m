#import "CallNumberPlugin.h"
#if __has_include(<call_number/call_number-Swift.h>)
#import <call_number/call_number-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "call_number-Swift.h"
#endif

@implementation CallNumberPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCallNumberPlugin registerWithRegistrar:registrar];
}
@end

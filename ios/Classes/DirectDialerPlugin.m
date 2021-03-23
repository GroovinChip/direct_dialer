#import "DirectDialerPlugin.h"
#if __has_include(<direct_dialer/direct_dialer-Swift.h>)
#import <direct_dialer/direct_dialer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "direct_dialer-Swift.h"
#endif

@implementation DirectDialerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDirectDialerPlugin registerWithRegistrar:registrar];
}
@end

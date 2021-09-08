#import "MedianCutPlugin.h"
#if __has_include(<median_cut/median_cut-Swift.h>)
#import <median_cut/median_cut-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "median_cut-Swift.h"
#endif

@implementation MedianCutPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMedianCutPlugin registerWithRegistrar:registrar];
}
@end

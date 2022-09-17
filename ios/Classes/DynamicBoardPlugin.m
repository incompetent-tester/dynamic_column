#import "DynamicBoardPlugin.h"
#if __has_include(<dynamic_board/dynamic_board-Swift.h>)
#import <dynamic_board/dynamic_board-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dynamic_board-Swift.h"
#endif

@implementation DynamicBoardPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDynamicBoardPlugin registerWithRegistrar:registrar];
}
@end

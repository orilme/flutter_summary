#import "ImeiPlugin.h"
#import <AdSupport/ASIdentifierManager.h>

@implementation ImeiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"unique_code"
                                     binaryMessenger:[registrar messenger]];
    ImeiPlugin* instance = [[ImeiPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getImei" isEqualToString:call.method]) {
        NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
        result([identifierForVendor UUIDString]);
    } else if([@"getIDFA" isEqualToString:call.method]) {
        if (NSClassFromString(@"ASIdentifierManager")) {
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            result(idfa);
            return;
        }
        result(nil);
    } else if([@"getImeiMulti" isEqualToString:call.method]){
        result(nil);
    } else if([@"getChannelName" isEqualToString:call.method]){
        result(nil);
    }else if([@"getMac" isEqualToString:call.method]){
        result(nil);
    }else if ([@"getIp" isEqualToString:call.method]){
        result(nil);
    }else if ([@"getUa" isEqualToString:call.method]){
        result(nil);
    }  else if([@"getOAID" isEqualToString:call.method]){
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
    
    
}

@end

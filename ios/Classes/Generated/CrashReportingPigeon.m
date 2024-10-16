// Autogenerated from Pigeon (v10.1.5), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import "CrashReportingPigeon.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}
static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

NSObject<FlutterMessageCodec> *CrashReportingHostApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

void CrashReportingHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<CrashReportingHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.instabug_flutter.CrashReportingHostApi.setEnabled"
        binaryMessenger:binaryMessenger
        codec:CrashReportingHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setEnabledIsEnabled:error:)], @"CrashReportingHostApi api (%@) doesn't respond to @selector(setEnabledIsEnabled:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_isEnabled = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api setEnabledIsEnabled:arg_isEnabled error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.instabug_flutter.CrashReportingHostApi.send"
        binaryMessenger:binaryMessenger
        codec:CrashReportingHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(sendJsonCrash:isHandled:error:)], @"CrashReportingHostApi api (%@) doesn't respond to @selector(sendJsonCrash:isHandled:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_jsonCrash = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_isHandled = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        [api sendJsonCrash:arg_jsonCrash isHandled:arg_isHandled error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.instabug_flutter.CrashReportingHostApi.sendNonFatalError"
        binaryMessenger:binaryMessenger
        codec:CrashReportingHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(sendNonFatalErrorJsonCrash:userAttributes:fingerprint:nonFatalExceptionLevel:error:)], @"CrashReportingHostApi api (%@) doesn't respond to @selector(sendNonFatalErrorJsonCrash:userAttributes:fingerprint:nonFatalExceptionLevel:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_jsonCrash = GetNullableObjectAtIndex(args, 0);
        NSDictionary<NSString *, NSString *> *arg_userAttributes = GetNullableObjectAtIndex(args, 1);
        NSString *arg_fingerprint = GetNullableObjectAtIndex(args, 2);
        NSString *arg_nonFatalExceptionLevel = GetNullableObjectAtIndex(args, 3);
        FlutterError *error;
        [api sendNonFatalErrorJsonCrash:arg_jsonCrash userAttributes:arg_userAttributes fingerprint:arg_fingerprint nonFatalExceptionLevel:arg_nonFatalExceptionLevel error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}

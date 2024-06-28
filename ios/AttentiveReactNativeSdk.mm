//
//  AttentiveReactNativeSdk.m
//  AttentiveReactNativeSdk
//
//  Created by Wyatt Davis on 2/13/23.
//

#import "AttentiveReactNativeSdk.h"
#import "AttentiveReactNativeSdk-Swift.h"

@implementation AttentiveReactNativeSdk {
    ATTNNativeSDK* _sdk;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initialize:(NSDictionary*)configuration) {
    _sdk = [[ATTNNativeSDK alloc] initWithDomain:configuration[@"attentiveDomain"] mode:configuration[@"mode"]];
}

RCT_EXPORT_METHOD(triggerCreative) {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    [self->_sdk trigger:topView];
  });
}

RCT_EXPORT_METHOD(destroyCreative) {
  dispatch_async(dispatch_get_main_queue(), ^{
//    [self->_sdk closeCreative]
  });
}

RCT_EXPORT_METHOD(identify:(NSDictionary*)identifiers) {
  // The dictionary already has the correct keys from the React code, so no translating necessary
  [_sdk identify:identifiers];
}

RCT_EXPORT_METHOD(clearUser) {
  [_sdk clearUser];
}

RCT_EXPORT_METHOD(recordAddToCartEvent:(NSDictionary*)attrs) {
  [_sdk recordAddToCartEvent:attrs];
}

RCT_EXPORT_METHOD(recordProductViewEvent:(NSDictionary*)attrs) {
  [_sdk recordProductViewEvent:attrs];
}

RCT_EXPORT_METHOD(recordPurchaseEvent:(NSDictionary*)attrs) {
  [_sdk recordPurchaseEvent:attrs];
}

RCT_EXPORT_METHOD(recordCustomEvent:(NSDictionary*)attrs) {
  [_sdk recordCustomEvent:attrs];
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeAttentiveReactNativeSdkSpecJSI>(params);
}
#endif

@end


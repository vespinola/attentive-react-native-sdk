//
//  AttentiveReactNativeSdk.m
//  AttentiveReactNativeSdk
//
//  Created by Wyatt Davis on 2/13/23.
//

#import "AttentiveReactNativeSdk.h"
#import "attentive-sdk-umbrella.h"

@implementation AttentiveReactNativeSdk {
    ATTNSDK* _sdk;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initialize:(NSDictionary*)configuration) {
    _sdk = [[ATTNSDK alloc] initWithDomain:configuration[@"attentiveDomain"] mode:configuration[@"mode"]];
    [ATTNEventTracker setupWithSdk:_sdk];
}

RCT_EXPORT_METHOD(triggerCreative) {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    [self->_sdk trigger:topView];
  });
}

RCT_EXPORT_METHOD(identifyUser:(NSDictionary*)identifiers) {
  // The dictionary already has the correct keys from the React code, so no translating necessary
  [_sdk identify:identifiers];
}

RCT_EXPORT_METHOD(clearUser) {
  [_sdk clearUser];
}

RCT_EXPORT_METHOD(recordAddToCartEvent:(NSDictionary*)attrs) {
  NSArray* items = [self parseItems:attrs[@"items"]];
  ATTNAddToCartEvent* event = [[ATTNAddToCartEvent alloc] initWithItems:items];
  [[ATTNEventTracker sharedInstance] recordEvent:event];
}

RCT_EXPORT_METHOD(recordProductViewEvent:(NSDictionary*)attrs) {
  NSArray* items = [self parseItems:attrs[@"items"]];
  ATTNProductViewEvent* event = [[ATTNProductViewEvent alloc] initWithItems:items];
  [[ATTNEventTracker sharedInstance] recordEvent:event];
}

RCT_EXPORT_METHOD(recordPurchaseEvent:(NSDictionary*)attrs) {
  NSArray* items = [self parseItems:attrs[@"items"]];
  ATTNOrder* order = [[ATTNOrder alloc] initWithOrderId:attrs[@"order"][@"id"]];
  ATTNPurchaseEvent* event = [[ATTNPurchaseEvent alloc] initWithItems:items order:order];
  [[ATTNEventTracker sharedInstance] recordEvent:event];
}

RCT_EXPORT_METHOD(recordCustomEvent:(NSDictionary*)attrs) {
  ATTNCustomEvent* customEvent = [[ATTNCustomEvent alloc] initWithType:attrs[@"type"] properties:attrs[@"properties"]];
  [[ATTNEventTracker sharedInstance] recordEvent:customEvent];
}

- (NSArray*)parseItems:(NSArray*)rawItems {
  NSMutableArray* itemsToReturn = [[NSMutableArray alloc] init];
  for (NSDictionary* rawItem in rawItems) {
    NSDictionary* rawPrice = rawItem[@"price"];
    ATTNPrice* price = [[ATTNPrice alloc] initWithPrice:[[NSDecimalNumber alloc] initWithString:rawPrice[@"price"]] currency:rawPrice[@"currency"]];
    
    ATTNItem* item = [[ATTNItem alloc] initWithProductId:rawItem[@"productId"] productVariantId:rawItem[@"productVariantId"] price:price];
    
    [itemsToReturn addObject:item];
  }
  return itemsToReturn;
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

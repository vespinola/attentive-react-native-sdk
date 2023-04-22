//
//  AttentiveReactNativeSdk.h
//  AttentiveReactNativeSdk
//
//  Created by Wyatt Davis on 2/13/23.
//

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNAttentiveReactNativeSdkSpec.h"

@interface AttentiveReactNativeSdk : NSObject <NativeAttentiveReactNativeSdkSpec>
#else
#import <React/RCTBridgeModule.h>

@interface AttentiveReactNativeSdk : NSObject <RCTBridgeModule>
#endif

@end

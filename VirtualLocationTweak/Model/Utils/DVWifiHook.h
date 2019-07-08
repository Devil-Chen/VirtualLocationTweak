//
//  DVWifiHook.h
//  HookDingDingDylib
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DVWifiHook : NSObject
+(NSDictionary *) getCurrentSSIDInfo;

+(void) saveCurrentWifi;

@end

NS_ASSUME_NONNULL_END

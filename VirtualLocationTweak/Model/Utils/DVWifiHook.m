//
//  DVWifiHook.m
//  HookDingDingDylib
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "DVWifiHook.h"
#import "fishhook.h"
#import "DataManage.h"
#import "DVWifiModel.h"

@implementation DVWifiHook
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct rebinding rebind1 = {"CNCopySupportedInterfaces", dv_CNCopySupportedInterfaces, (void *)&orig_CNCopySupportedInterfaces};
        struct rebinding rebind2 = {"CNCopyCurrentNetworkInfo", dv_CNCopyCurrentNetworkInfo, (void *)&orig_CNCopyCurrentNetworkInfo};
        //定义数组
        struct rebinding rebinds[] = {rebind1,rebind2};
        /*
         参数一 : 存放rebinding结构体的数组
         参数二 : 数组的长度
         */
        rebind_symbols(rebinds, 2);

    });
}



// CFArrayRef CNCopySupportedInterfaces        (void)
static CFArrayRef (*orig_CNCopySupportedInterfaces)();

static CFArrayRef dv_CNCopySupportedInterfaces() {
    CFArrayRef cfArray = NULL;
    DVWifiModel *wifi = [DVWifiModel getSaveWifiInfo];
    if(wifi && wifi.ifnam) {
        NSArray *array = [NSArray arrayWithObject:wifi.ifnam];
        cfArray = CFRetain((__bridge CFArrayRef)(array));
    }
    if(!cfArray) {
        cfArray = orig_CNCopySupportedInterfaces();
    }

    return cfArray;
}

// CFDictionaryRef CNCopyCurrentNetworkInfo        (CFStringRef interfaceName)
static CFDictionaryRef (*orig_CNCopyCurrentNetworkInfo)(CFStringRef interfaceName);

static CFDictionaryRef dv_CNCopyCurrentNetworkInfo(CFStringRef interfaceName) {
    CFDictionaryRef dic = NULL;
    DVWifiModel *wifi = [DVWifiModel getSaveWifiInfo];
    if(wifi) {
        NSDictionary *dictionary = @{
                                     @"BSSID" : (wifi.BSSID ? wifi.BSSID : @""),
                                     @"SSID" : (wifi.SSID ? wifi.SSID : @""),
                                     @"SSIDDATA" : (wifi.SSIDDATA ? wifi.SSIDDATA : @""),
                                     };
        dic = CFRetain((__bridge CFDictionaryRef)(dictionary));
    }
    if(!dic) {
        dic = orig_CNCopyCurrentNetworkInfo(interfaceName);
    }
    return dic;
}

+(NSDictionary *) getCurrentSSIDInfo
{
    NSString *currentSSID = @"";
    CFArrayRef myArray = orig_CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (__bridge NSDictionary *) orig_CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict!=nil){
            currentSSID=[myDict valueForKey:@"SSID"];
        } else {
            currentSSID=@"NULL";
        }
    } else {
        currentSSID=@"NULL";
    }
    
    NSArray *ifs = (__bridge id)orig_CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    NSMutableDictionary *resultDic = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)orig_CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            resultDic = [[NSMutableDictionary alloc] initWithDictionary:info];
            [resultDic setValue:ifnam forKey:@"ifnam"];
            break;
        }
    }
    
    NSLog(@"wifi info %@",resultDic);
    
    return resultDic;
}

+(void) saveCurrentWifi
{
    NSDictionary *info = [DVWifiHook getCurrentSSIDInfo];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:info[@"SSID"] forKey:@"SSID"];
    [dic setValue:info[@"BSSID"] forKey:@"BSSID"];
    [dic setValue:info[@"ifnam"] forKey:@"ifnam"];
    [DataManage saveDataForObject:dic AndKey:@"Wifi_info"];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"设置成功\nWifi名称：%@\nBSSID：%@\nifnam：%@",info[@"SSID"],info[@"BSSID"],info[@"ifnam"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}


@end

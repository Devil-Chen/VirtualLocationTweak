//
//  DVWifiModel.m
//  
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "DVWifiModel.h"
#import "DataManage.h"

@implementation DVWifiModel
+(instancetype) getSaveWifiInfo
{
    NSDictionary *dic = [DataManage getObjectFromKey:@"Wifi_info"];
    DVWifiModel *model = [DVWifiModel new];
    model.ifnam = dic[@"ifnam"];
    model.BSSID = dic[@"BSSID"];
    model.SSID = dic[@"SSID"];
    model.SSIDDATA = [model.SSID dataUsingEncoding:NSUTF8StringEncoding];
    return model;
}


@end

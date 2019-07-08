//
//  DVWifiModel.h
//  
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIkit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DVWifiModel : NSObject

// BSSID-->路由器的Mac地址
@property (nonatomic, copy) NSString *BSSID;

// SSID-->路由器的广播名称
@property (nonatomic, copy) NSString *SSID;

// SSIDDATA-->SSID的十六进制
@property (nonatomic, strong) NSData *SSIDDATA;

//CNCopySupportedInterfaces返回的数组里的对象
@property (nonatomic, copy) NSString *ifnam;

+(instancetype) getSaveWifiInfo;

@end

NS_ASSUME_NONNULL_END

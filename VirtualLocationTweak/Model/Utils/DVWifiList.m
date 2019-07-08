//
//  DVWifiList.m
//  DingTweak
//
//  Created by apple on 2019/5/13.
//

#import "DVWifiList.h"
@interface DVWifiList()
@property (nonatomic,assign) BOOL mark;
@property (nonatomic,strong) NSMutableArray *contentArray;
@end

@implementation DVWifiList
static DVWifiList *wifiList;
+(DVWifiList *)sharedInstances
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        wifiList = [[DVWifiList alloc] init];
        wifiList.contentArray = [[NSMutableArray alloc] init];
    });
    return wifiList;
}

-(void) observerWifiList
{
    if (!self.mark) {
        self.mark = YES;
        NSLog(@"开始");
        
        NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
        [options setObject:@"EFNEHotspotHelperDemo" forKey: kNEHotspotHelperOptionDisplayName];
        dispatch_queue_t queue = dispatch_queue_create("EFNEHotspotHelperDemo", NULL);
        __weak typeof(self) weakSelf = self;
        BOOL returnType = [NEHotspotHelper registerWithOptions: options queue: queue handler: ^(NEHotspotHelperCommand * cmd) {
            NSLog(@"完成");
            NEHotspotNetwork* network;
            if (cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList) {
                // 遍历 WiFi 列表，打印基本信息
                for (network in cmd.networkList) {
                    NSString* wifiInfoString = [[NSString alloc] initWithFormat: @"---------------------------\nSSID: %@\nMac地址: %@\n信号强度: %f\nCommandType:%ld\n---------------------------\n\n", network.SSID, network.BSSID, network.signalStrength, (long)cmd.commandType];
//                    NSLog(@"%@", wifiInfoString);
                    if (network.SSID && ![network.SSID isEqualToString:@""]) {
                        BOOL tempMark = NO;
                        for (NEHotspotNetwork* info in weakSelf.contentArray) {
                            if ([info.SSID isEqualToString:network.SSID]) {
                                tempMark = YES;
                            }
                        }
                        if (!tempMark) {
                            NSLog(@"添加了-->%@", wifiInfoString);
                            [weakSelf.contentArray addObject:network];
                        }
                    }
                    // 检测到指定 WiFi 可设定密码直接连接
                    //                if ([network.SSID isEqualToString: @"测试 WiFi"]) {
                    //                    [network setConfidence: kNEHotspotHelperConfidenceHigh];
                    //                    [network setPassword: @"123456789"];
                    //                    NEHotspotHelperResponse *response = [cmd createResponse: kNEHotspotHelperResultSuccess];
                    //                    NSLog(@"Response CMD: %@", response);
                    //                    [response setNetworkList: @[network]];
                    //                    [response setNetwork: network];
                    //                    [response deliver];
                    //                }
                }
                
            }
        }];
        
        // 注册成功 returnType 会返回一个 Yes 值，否则 No
        NSLog(@"结果: %@", returnType == YES ? @"成功" : @"失败");
    }else{
        NSLog(@"结果: 已注册");
    }
    
}
@end

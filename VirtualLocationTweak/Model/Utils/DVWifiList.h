//
//  DVWifiList.h
//  DingTweak
//
//  Created by apple on 2019/5/13.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>
NS_ASSUME_NONNULL_BEGIN

@interface DVWifiList : NSObject

@property (nonatomic,strong,readonly) NSMutableArray *contentArray;

+(DVWifiList *)sharedInstances;
-(void) observerWifiList;
@end

NS_ASSUME_NONNULL_END

//
//  SelectLocationVct.h
//  
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <NetworkExtension/NetworkExtension.h>

NS_ASSUME_NONNULL_BEGIN
/**
 选择位置
 */
@interface SelectLocationVct : UIViewController
//选择位置信息的按钮名称
+(NSString *) selectBtnName;
//获取保存的定位
+(CLLocationCoordinate2D) getSaveLocation;

@end

NS_ASSUME_NONNULL_END

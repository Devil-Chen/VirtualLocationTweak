//
//  DataManage.m
//
//  Created by devil on 14-3-19.
//  Copyright (c) 2014年 devil. All rights reserved.
//

#import "DataManage.h"

@implementation DataManage

#pragma mark - 保存数据和获取数据
+(void) saveDataForObject:(id)value AndKey:(NSString *)key
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    [defaluts setObject:value forKey:key];
    [defaluts synchronize];
}

+(id) getObjectFromKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

@end

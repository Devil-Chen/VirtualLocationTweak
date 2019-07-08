// See http://iphonedevwiki.net/index.php/Logos

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <UIKit/UIKit.h>
#import "SelectLocationVct.h"
#import <CoreLocation/CoreLocation.h>
#import "DVWifiHook.h"

%hook CLLocation
-(CLLocationCoordinate2D) coordinate
{
    return [%c(SelectLocationVct) getSaveLocation];;
}
%end
@interface DTSectionItem : NSObject
@property(copy, nonatomic) NSArray *dataSource;
@end
@interface DTSingleLineShowingCellItem : NSObject
- (id)initWithIconFont:(id)arg1 title:(id)arg2 comment:(id)arg3 showBadge:(_Bool)arg4 showIndicator:(_Bool)arg5 cellDidSelectedBlock:(void (^)())arg6;
-(void)setCellHeight:(CGFloat)size;
@end
@interface DTIconFontConf : NSObject
+ (id)confWithIconFont:(long long)arg1 color:(id)arg2 font:(id)arg3;
@end

@interface DTSettingViewController : UIViewController
@property(nullable, nonatomic,strong) UINavigationController *navigationController;
@end
%hook DTSettingViewController
//通过伪代码大致还原源码并增加所需按钮
- (id)createSection3
{

    DTSectionItem *sectionItem = %orig;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sectionItem dataSource]];
    UIColor *color = [UIColor blackColor];
    UIFont *font = [UIFont systemFontOfSize:16];
    //
    //    NSArray *sourceArray = sectionItem.dataSource;
    //    id a = [sourceArray lastObject];
    DTIconFontConf *conf = [%c(DTIconFontConf) confWithIconFont:71486741 color:color font:font];
    NSString *localizedString = [%c(SelectLocationVct) selectBtnName];
    DTSingleLineShowingCellItem *cellItem = [[%c(DTSingleLineShowingCellItem) alloc] initWithIconFont:conf title:localizedString comment:nil showBadge:NO showIndicator:YES cellDidSelectedBlock:^(){
        NSLog(@"点击-->选择位置信息");
        [self.navigationController pushViewController:[[%c(SelectLocationVct) alloc] init] animated:YES];
    }];
    [array addObject:cellItem];
    
    DTIconFontConf *conf2 = [%c(DTIconFontConf) confWithIconFont:71486741 color:color font:font];
    NSString *localizedString2 = @"选择Wifi";
    DTSingleLineShowingCellItem *cellItem2 = [[%c(DTSingleLineShowingCellItem) alloc] initWithIconFont:conf2 title:localizedString2 comment:nil showBadge:NO showIndicator:YES cellDidSelectedBlock:^(){
        NSLog(@"点击-->选择wifi信息");
        [self.navigationController pushViewController:[[%c(SelectWifiVct) alloc] init] animated:YES];
    }];
    [array addObject:cellItem2];
    
    DTIconFontConf *conf3 = [%c(DTIconFontConf) confWithIconFont:71486741 color:color font:font];
    NSString *localizedString3 = @"保存当前Wifi为之后获取的wifi";
    DTSingleLineShowingCellItem *cellItem3 = [[%c(DTSingleLineShowingCellItem) alloc] initWithIconFont:conf3 title:localizedString3 comment:nil showBadge:NO showIndicator:YES cellDidSelectedBlock:^(){
        [%c(DVWifiHook) saveCurrentWifi];
    }];
    [array addObject:cellItem3];
    
    [sectionItem setDataSource:[array copy]];
    return sectionItem;
}


%end


%ctor{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.happy.VirtualLocationTweak.plist"];
    if ([dic[@"isOpen"] boolValue]) {
        %init(_ungrouped);
    }
}

#line 1 "/Users/apple/Desktop/Devil_git_file/VirtualLocationTweak/VirtualLocationTweak/VirtualLocationTweak.xm"


#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <UIKit/UIKit.h>
#import "SelectLocationVct.h"
#import <CoreLocation/CoreLocation.h>
#import "DVWifiHook.h"


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class DTSingleLineShowingCellItem; @class SelectLocationVct; @class CLLocation; @class SelectWifiVct; @class DTIconFontConf; @class DTSettingViewController; @class DVWifiHook; 
static CLLocationCoordinate2D (*_logos_orig$_ungrouped$CLLocation$coordinate)(_LOGOS_SELF_TYPE_NORMAL CLLocation* _LOGOS_SELF_CONST, SEL); static CLLocationCoordinate2D _logos_method$_ungrouped$CLLocation$coordinate(_LOGOS_SELF_TYPE_NORMAL CLLocation* _LOGOS_SELF_CONST, SEL); static id (*_logos_orig$_ungrouped$DTSettingViewController$createSection3)(_LOGOS_SELF_TYPE_NORMAL DTSettingViewController* _LOGOS_SELF_CONST, SEL); static id _logos_method$_ungrouped$DTSettingViewController$createSection3(_LOGOS_SELF_TYPE_NORMAL DTSettingViewController* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$DTSingleLineShowingCellItem(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("DTSingleLineShowingCellItem"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SelectLocationVct(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SelectLocationVct"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$DVWifiHook(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("DVWifiHook"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$DTIconFontConf(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("DTIconFontConf"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SelectWifiVct(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SelectWifiVct"); } return _klass; }
#line 12 "/Users/apple/Desktop/Devil_git_file/VirtualLocationTweak/VirtualLocationTweak/VirtualLocationTweak.xm"


static CLLocationCoordinate2D _logos_method$_ungrouped$CLLocation$coordinate(_LOGOS_SELF_TYPE_NORMAL CLLocation* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return [_logos_static_class_lookup$SelectLocationVct() getSaveLocation];;
}

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



static id _logos_method$_ungrouped$DTSettingViewController$createSection3(_LOGOS_SELF_TYPE_NORMAL DTSettingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

    DTSectionItem *sectionItem = _logos_orig$_ungrouped$DTSettingViewController$createSection3(self, _cmd);
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sectionItem dataSource]];
    UIColor *color = [UIColor blackColor];
    UIFont *font = [UIFont systemFontOfSize:16];
    
    
    
    DTIconFontConf *conf = [_logos_static_class_lookup$DTIconFontConf() confWithIconFont:71486741 color:color font:font];
    NSString *localizedString = [_logos_static_class_lookup$SelectLocationVct() selectBtnName];
    DTSingleLineShowingCellItem *cellItem = [[_logos_static_class_lookup$DTSingleLineShowingCellItem() alloc] initWithIconFont:conf title:localizedString comment:nil showBadge:NO showIndicator:YES cellDidSelectedBlock:^(){
        NSLog(@"点击-->选择位置信息");
        [self.navigationController pushViewController:[[_logos_static_class_lookup$SelectLocationVct() alloc] init] animated:YES];
    }];
    [array addObject:cellItem];
    
    DTIconFontConf *conf2 = [_logos_static_class_lookup$DTIconFontConf() confWithIconFont:71486741 color:color font:font];
    NSString *localizedString2 = @"选择Wifi";
    DTSingleLineShowingCellItem *cellItem2 = [[_logos_static_class_lookup$DTSingleLineShowingCellItem() alloc] initWithIconFont:conf2 title:localizedString2 comment:nil showBadge:NO showIndicator:YES cellDidSelectedBlock:^(){
        NSLog(@"点击-->选择wifi信息");
        [self.navigationController pushViewController:[[_logos_static_class_lookup$SelectWifiVct() alloc] init] animated:YES];
    }];
    [array addObject:cellItem2];
    
    DTIconFontConf *conf3 = [_logos_static_class_lookup$DTIconFontConf() confWithIconFont:71486741 color:color font:font];
    NSString *localizedString3 = @"保存当前Wifi为之后获取的wifi";
    DTSingleLineShowingCellItem *cellItem3 = [[_logos_static_class_lookup$DTSingleLineShowingCellItem() alloc] initWithIconFont:conf3 title:localizedString3 comment:nil showBadge:NO showIndicator:YES cellDidSelectedBlock:^(){
        [_logos_static_class_lookup$DVWifiHook() saveCurrentWifi];
    }];
    [array addObject:cellItem3];
    
    [sectionItem setDataSource:[array copy]];
    return sectionItem;
}





static __attribute__((constructor)) void _logosLocalCtor_56bbeac0(int __unused argc, char __unused **argv, char __unused **envp){
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.happy.VirtualLocationTweak.plist"];
    if ([dic[@"isOpen"] boolValue]) {
        {Class _logos_class$_ungrouped$CLLocation = objc_getClass("CLLocation"); MSHookMessageEx(_logos_class$_ungrouped$CLLocation, @selector(coordinate), (IMP)&_logos_method$_ungrouped$CLLocation$coordinate, (IMP*)&_logos_orig$_ungrouped$CLLocation$coordinate);Class _logos_class$_ungrouped$DTSettingViewController = objc_getClass("DTSettingViewController"); MSHookMessageEx(_logos_class$_ungrouped$DTSettingViewController, @selector(createSection3), (IMP)&_logos_method$_ungrouped$DTSettingViewController$createSection3, (IMP*)&_logos_orig$_ungrouped$DTSettingViewController$createSection3);}
    }
}

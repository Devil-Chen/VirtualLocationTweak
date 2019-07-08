//
//  SelectLocationVct.m
//  
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SelectLocationVct.h"
#import "AMapFoundationKit.h"
#import "MAMapKit.h"
#import "AMapSearchAPI.h"
#import "MAPointAnnotation.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface SelectLocationVct ()<MAMapViewDelegate,AMapSearchDelegate,UISearchBarDelegate,UIActionSheetDelegate>
@property (nonatomic,assign) BOOL isFirstLocation;
@property (nonatomic,copy) NSString *firstLocationCity;
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) MAPointAnnotation *pointAnn;
@property (nonatomic,strong) AMapSearchAPI *search;
@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,strong) NSMutableArray *searchContentArray;
@end

@implementation SelectLocationVct

+(NSString *) selectBtnName
{
    return @"选择定位信息";
}
+(CLLocationCoordinate2D) getSaveLocation
{
   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   double latitude = [userDefault doubleForKey:@"save_latitude"];
   double longitude =  [userDefault doubleForKey:@"save_longitude"];
    if (latitude == 0 && longitude == 0) {
        CLLocationCoordinate2D location;
        location.latitude = 33.63235;
        location.longitude = 113.255743;
        return location;
    }
    return CLLocationCoordinate2DMake(latitude, longitude);
   
}

-(void) saveLocationWithLatitude:(double)latitude longitude:(double)longitude
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setDouble:latitude forKey:@"save_latitude"];
    [userDefault setDouble:longitude forKey:@"save_longitude"];
    [userDefault synchronize];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
}

/**
 修改位置并保存

 @param title 标题
 @param latitude 纬度
 @param longitude 经度
 */
-(void) changeLocationWithTitle:(NSString *)title latitude:(double)latitude longitude:(double)longitude
{
    self.pointAnn.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    self.pointAnn.title = title;
    [self.mapView selectAnnotation:self.pointAnn animated:YES];
    [self saveLocationWithLatitude:latitude longitude:longitude];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [SelectLocationVct selectBtnName];
    _pointAnn = [NSClassFromString(@"MAPointAnnotation") new];
    _search = [NSClassFromString(@"AMapSearchAPI") new];
    _search.delegate = self;
    _searchContentArray = [[NSMutableArray alloc] init];
   
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.mapView];
}

-(UISearchBar *) searchBar
{
    CGFloat navHeight = self.navigationController.navigationBar.bounds.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, navHeight, ScreenWidth , 40)];
    _searchBar.placeholder = @"请输入搜索地名";
    _searchBar.delegate = self;
    return _searchBar;
}

- (MAMapView *) mapView
{
    if (_mapView == nil) {
//        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 200 - 64)];
        _mapView = [NSClassFromString(@"MAMapView") new];
        CGFloat navHeight = self.navigationController.navigationBar.bounds.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
        _mapView.frame = CGRectMake(0, navHeight + 40, ScreenWidth,ScreenHeight - navHeight - _searchBar.frame.size.height);
        _mapView.delegate = self;
        /// 打开定位
        _mapView.showsUserLocation = YES;
        /*
         MAUserTrackingModeNone              = 0,    ///< 不追踪用户的location更新
         MAUserTrackingModeFollow            = 1,    ///< 追踪用户的location更新
         MAUserTrackingModeFollowWithHeading = 2     ///< 追踪用户的location与heading更新
         */
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        ///设定定位精度。默认为kCLLocationAccuracyBest
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        /// 是否显示指南针
        _mapView.showsCompass = NO;
        /// 设定定位的最小更新距离。默认为kCLDistanceFilterNone，会提示任何移动

        _mapView.distanceFilter = 15.0f;
        /// 是否显示比例尺，默认为YES
        _mapView.showsScale = NO;
        /// 是否支持缩放，默认为YES

        _mapView.zoomEnabled = YES;
        /// 是否支持平移，默认为YES
        _mapView.scrollEnabled = YES;
        /// 缩放级别, [3, 20]
        _mapView.zoomLevel = 15;
        /// 去掉高德地图logo
        for (UIView *view in _mapView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }

    }
    return _mapView;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark -- MAMapViewDelegate
/**
 * @brief 位置或者设备方向更新后调用此接口
 * @param mapView 地图View
 * @param userLocation 用户定位信息(包括位置与设备方向等数据)
 * @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"定位更新");
    NSLog(@"经度-->%f 纬度-->%f",userLocation.coordinate.longitude,userLocation.coordinate.latitude);
    if (!_isFirstLocation) {
        _isFirstLocation = true;
        self.pointAnn.coordinate = userLocation.coordinate;
        self.pointAnn.title = userLocation.title;
        [self.mapView addAnnotation:self.pointAnn];
        [self.mapView selectAnnotation:self.pointAnn animated:YES];
        [self saveLocationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        [self getLocationByCoordinate:userLocation.coordinate successAction:^(NSDictionary *addressDic) {
            NSString *city=[addressDic objectForKey:@"City"];
            self.firstLocationCity = city;
        } failAction:^{
            
        }];
    }
}

/**
 * @brief 在地图View将要启动定位时调用此接口
 * @param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView
{
    NSLog(@"开始定位");
}

/**
 * @brief 在地图View停止定位后调用此接口
 * @param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView
{
    NSLog(@"停止定位");
}

/**
 * @brief 单击地图底图调用此接口
 * @param mapView    地图View
 * @param coordinate 点击位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"单击地图");
    NSLog(@"经度-->%f 纬度-->%f",coordinate.longitude,coordinate.latitude);
    
    [self getLocationByCoordinate:coordinate successAction:^(NSDictionary *addressDic) {
        NSString *state=[addressDic objectForKey:@"State"];
        NSString *city=[addressDic objectForKey:@"City"];
        NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
        NSString *street=[addressDic objectForKey:@"Street"];
        //NSLog(@"%@,%@,%@,%@",state,city,subLocality,street);
        NSString *strLocation;
        if (street.length == 0 || street == NULL || [street isEqualToString:@"(null)"]) {
            strLocation= [NSString stringWithFormat:@"%@%@%@",state,city,subLocality];
        }else{
            strLocation= [NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
        }
        
        [self changeLocationWithTitle:strLocation latitude:coordinate.latitude longitude:coordinate.longitude];
    } failAction:^{
        
    }];
}
//通过坐标获取位置信息
-(void) getLocationByCoordinate:(CLLocationCoordinate2D)coordinate successAction:(void(^)(NSDictionary *info))success failAction:(void(^)())fail
{
    //反编码 经纬度---->位置信息
    CLLocation *location=[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"反编码失败:%@",error);
            if (fail) {
                fail();
            }
        }else{
            //NSLog(@"反编码成功:%@",placemarks);
            CLPlacemark *placemark=[placemarks lastObject];
            //NSLog(@"%@",placemark.addressDictionary[@"FormattedAddressLines"]);
            NSDictionary *addressDic=placemark.addressDictionary;
            if (success) {
                success(addressDic);
            }
        }
    }];
}


#pragma mark -- AMapSearchDelegate
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        NSLog(@"没有搜索到内容");
        return;
    }
    NSLog(@"搜索到了");
    //解析response获取POI信息
    [self.searchContentArray removeAllObjects];
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择位置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for (int i = 0 ; i < response.pois.count; i++) {
        AMapPOI *p = [response.pois objectAtIndex:i];
        [action addButtonWithTitle:[NSString stringWithFormat:@"%@-%@",p.name,p.address]];
        [self.searchContentArray addObject:p];
    }
    [action showInView:self.view];
}


#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    AMapPOIKeywordsSearchRequest *request = [NSClassFromString(@"AMapPOIKeywordsSearchRequest") new];

    request.keywords            = searchBar.text;
    request.city                = self.firstLocationCity ? self.firstLocationCity : @"广州";
//    request.types               = @"";
    request.requireExtension    = YES;
    /* 按照距离排序. */
    request.sortrule            = 0;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange-->%@",searchText);
    if ([searchText isEqualToString:@""]) {
        CLLocationCoordinate2D coordinate = self.mapView.userLocation.coordinate;
        [self changeLocationWithTitle:self.mapView.userLocation.title latitude:coordinate.latitude longitude:coordinate.longitude];
    }
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 8_3) __TVOS_PROHIBITED
{
 
    if(actionSheet.cancelButtonIndex != buttonIndex){
        AMapPOI *p = [self.searchContentArray objectAtIndex:buttonIndex-1];
        NSLog(@"%@*%@*%@",p.description,p.name,p.address);
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        [self changeLocationWithTitle:p.name latitude:coordinate.latitude longitude:coordinate.longitude];
    }
}
@end

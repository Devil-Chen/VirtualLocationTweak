//
//  SelectWifiVct.m
//  DingTweak
//
//  Created by apple on 2019/5/10.
//

#import "SelectWifiVct.h"
//#import <NetworkExtension/NetworkExtension.h>
#import "DataManage.h"
#import "DVWifiList.h"

@interface SelectWifiVct ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tv_content;
@property (nonatomic,strong) UIButton *btn_refresh;
@property (nonatomic,strong) UIButton *btn_openWifiSettingTop;
@property (nonatomic,strong) UIButton *btn_openWifiSetting;
@property (nonatomic,strong) NSMutableArray *contentArray;
@end

@implementation SelectWifiVct

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置Wifi";
    self.contentArray = [[NSMutableArray alloc] init];
    if ([DVWifiList sharedInstances].contentArray.count > 0) {
        [self.contentArray addObjectsFromArray:[DVWifiList sharedInstances].contentArray];
    }
    
    [self setupRightItem];
    [self scanWifiInfos];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view addSubview:self.tv_content];
    if (self.contentArray.count == 0) {
        [self showNoDataButton];
    }
    
}

- (void)setupRightItem{
    _btn_refresh = [UIButton buttonWithType:UIButtonTypeSystem];
    _btn_refresh.frame = CGRectMake(80, 0, 50, 40);
    [_btn_refresh setTitle:@"刷新" forState:UIControlStateNormal];
    [_btn_refresh setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _btn_refresh.titleLabel.font = [UIFont systemFontOfSize:17];
    [_btn_refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_openWifiSettingTop = [UIButton buttonWithType:UIButtonTypeSystem];
    _btn_openWifiSettingTop.frame = CGRectMake(0, 0, 80, 40);
    [_btn_openWifiSettingTop setTitle:@"打开设置" forState:UIControlStateNormal];
    [_btn_openWifiSettingTop setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _btn_openWifiSettingTop.titleLabel.font = [UIFont systemFontOfSize:17];
    [_btn_openWifiSettingTop addTarget:self action:@selector(openWifiSetting) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
    [view addSubview:_btn_refresh];
    [view addSubview:_btn_openWifiSettingTop];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void) showNoDataButton
{
    _btn_openWifiSetting = [UIButton buttonWithType:UIButtonTypeSystem];
    _btn_openWifiSetting.frame = CGRectMake(self.view.frame.size.width / 2 - 130, self.view.frame.size.height / 2 - 25,260 , 50);
    [_btn_openWifiSetting setTitle:@"到设置中刷新wifi信息后点右上角刷新" forState:UIControlStateNormal];
    [_btn_openWifiSetting setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _btn_openWifiSetting.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btn_openWifiSetting addTarget:self action:@selector(openWifiSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_openWifiSetting];
}

-(void) openWifiSetting
{
//    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];//打开设置界面
//    [[UIApplication sharedApplication] openURL:url];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"] options:@{} completionHandler:nil];//IOS 10之前
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"] options:@{} completionHandler:nil];//IOS 10之后
    }
}

-(void) refresh
{
//    NSLog(@"qq-->地址--》%p", self.contentArray);
    NSLog(@"qq-->刷新-->%@",[DVWifiList sharedInstances].contentArray);
    if (!self.btn_openWifiSetting.isHidden && [DVWifiList sharedInstances].contentArray.count > 0) {
        self.btn_openWifiSetting.hidden = YES;
    }
    [self.contentArray removeAllObjects];
    [self.contentArray addObjectsFromArray:[DVWifiList sharedInstances].contentArray];
    [self.tv_content reloadData];
}



-(UITableView *) tv_content
{
    if (!_tv_content) {
        _tv_content = [[UITableView alloc] initWithFrame:self.view.frame];
        _tv_content.delegate = self;
        _tv_content.dataSource = self;
        _tv_content.tableFooterView = [[UIView alloc] init];
    }
    
    return _tv_content;
}
- (void)scanWifiInfos
{
    [[DVWifiList sharedInstances] observerWifiList];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    NEHotspotNetwork *info = [self.contentArray objectAtIndex:indexPath.row];
    cell.textLabel.text = info.SSID;
    cell.detailTextLabel.text = info.BSSID;
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NEHotspotNetwork *info = [self.contentArray objectAtIndex:indexPath.row];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:info.SSID forKey:@"SSID"];
    [dic setValue:info.BSSID forKey:@"BSSID"];
    [DataManage saveDataForObject:dic AndKey:@"Wifi_info"];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"设置成功\nWifi名称：%@\nBSSID：%@",info.SSID,info.BSSID] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

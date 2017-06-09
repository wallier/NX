//
//  BNCommunityContentViewController.m
//  WorkBench
//
//  Created by wouenlone on 16/8/13.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "BNDisplayOtherNetTableViewController.h"
#import "BNAddBuildingViewController.h"
#import "BNCommunityContentViewController.h"
#import "BNBuildingCollectionViewCell.h"
#import "BNBuildingModel.h"
#import "BNCommunityContentModel.h"
#import "BNApartmentController.h"
#import "BNApartmentTableViewController.h"
#import "BNNetworkTool.h"
#import "MBProgressHUD+Extend.h"
#import <MJRefreshNormalHeader.h>
#import <AFNetworking.h>
#import "BNApartmentController.h"
#import "Tools.h"
#import "BNWaterMark.h"

@interface BNCommunityContentViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//端口数
@property (weak, nonatomic) IBOutlet UILabel *portsAmountLabel;
//已用端口
@property (weak, nonatomic) IBOutlet UILabel *usedPortsLabel;
//使用率
@property (weak, nonatomic) IBOutlet UILabel *usageRateLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *allBuildingCollectionView;

@property (nonatomic,strong) NSArray *allBuilding;
@property (weak, nonatomic) IBOutlet UILabel *otherNetAmountLabel;
@property (nonatomic,assign) NSInteger portsAmount;//端口总数
@property (nonatomic,assign) NSInteger usedPort;//以使用的端口数
@property (nonatomic,assign) NSInteger otherNetAmount;//他网占用数量

@property (nonatomic,assign) NSInteger markTimes;
@end

@implementation BNCommunityContentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
    self.title=self.name;
   // [[Tools sharedGestVisitTools] setBackgroundImageWithView:self.allBuildingCollectionView];
    //声明cell
    [self.allBuildingCollectionView registerClass:[BNBuildingCollectionViewCell class] forCellWithReuseIdentifier:@"buildingCell"];
 
    //设置下拉刷新
    self.allBuildingCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(drop_downRefresh)];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    self.portsAmount = 0;
    self.usedPort = 0;
    self.otherNetAmount = 0;
    [self getRequestWithUrl:[self getUrl]];
    self.allBuildingCollectionView.dataSource = self;
    self.allBuildingCollectionView.delegate = self;
   
}
- (void) viewWillDisappear:(BOOL)animated
{
    self.allBuildingCollectionView.dataSource = nil;
    self.allBuildingCollectionView.delegate = nil;
}


/*设置label下划线*/
- (void)otherNetAmountLabelAddUnderLine
{
    //待从传入模型获取数据
    NSMutableAttributedString *underLine = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",(long)self.otherNetAmount]];
    
    NSRange underLineRange = {0,[underLine  length]};
    NSDictionary *dic = @{NSForegroundColorAttributeName:RGB(255, 146, 50), NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSUnderlineColorAttributeName:RGB(255, 146, 50)};
    [underLine addAttributes:dic range:underLineRange];
//    [underLine addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:underLineRange];
//    [underLine addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:underLineRange];
//    [underLine addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:underLineRange];
    self.otherNetAmountLabel.attributedText = underLine;
    
    
    
}
- (void)setValueForFootLabel
{
    [self calculateAmountUseEveryBuilding];
    self.portsAmountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.portsAmount];
    self.usedPortsLabel.text = [NSString stringWithFormat:@"%ld",(long)self.usedPort];
    float usageRate = (self.usedPort*1.0)/(self.portsAmount*1.0);
    
    self.usageRateLabel.text = [NSString stringWithFormat:@"%.0f%%",usageRate*100];
    //等待计算完成后设置下划线
    [self otherNetAmountLabelAddUnderLine];
}
- (void)calculateAmountUseEveryBuilding
{
    
    for (int i = 0; i < self.allBuilding.count; i++) {
        BNBuildingModel *building = self.allBuilding[i];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *port =[numberFormatter numberFromString:building.PORT_ALL_NUM];
        self.portsAmount  += [port integerValue];
        
        NSNumber *usedPort = [numberFormatter numberFromString:building.PORT_OCCUPY_NUM];
        self.usedPort  += [usedPort integerValue];
        
        NSNumber *otherNet = [numberFormatter numberFromString:building.OTHER_WLAN_NUM];
        self.otherNetAmount += [otherNet integerValue];
    }
    
}
//下拉调用方法
- (void) drop_downRefresh
{
    self.portsAmount = 0;
    self.usedPort = 0;
    self.otherNetAmount = 0;
    [self getRequestWithUrl:[self getUrl]];
   
   
}
#pragma mark-他网占用点击事件
- (IBAction)displayingOtherNetBtn:(UIButton *)sender {
    NSLog(@"他网占用btn点击事件");
    BNDisplayOtherNetTableViewController *displayOtherNet = [[BNDisplayOtherNetTableViewController alloc]init];
    displayOtherNet.region_id = self.params[@"region_id"];
    displayOtherNet.wg_id = self.params[@"wg_id"];
    [self.navigationController pushViewController:displayOtherNet animated:YES];
}

#pragma  mark self.allBuildingCollectionViewDataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allBuilding.count+1;
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}
- (	UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BNBuildingCollectionViewCell *cell = [self.allBuildingCollectionView dequeueReusableCellWithReuseIdentifier:@"buildingCell" forIndexPath:indexPath];

    if (indexPath.row != self.allBuilding.count) {
         BNBuildingModel *building = self.allBuilding[indexPath.row];
        cell.buildingView_image.hidden = NO;
        cell.buildingView_image.backgroundColor = [UIColor clearColor];
        cell.addImageView.hidden = YES;
        cell.buildingView_image.image = [UIImage imageNamed:@"loudong"];
        cell.BuildingNUMLabel.hidden = NO;
        cell.usageRateLabel.hidden = NO;
        cell.usageRateLabel.text = [NSString stringWithFormat:@"使用率%@",building.USE_PERSENT];
        cell.BuildingNUMLabel.text = building.BUILDING_NO;
        cell.buildingPurposeLabel.hidden = NO;
        cell.buildingPurposeLabel.layer.cornerRadius = 3;
        cell.buildingPurposeLabel.clipsToBounds = YES;
        /** 从传回数据获取楼栋用途 设置buildingPurposeLabel 的text和backgroundColor */
        cell.buildingPurposeLabel.text = building.BUILDING_TYPE;
        if ([building.BUILDING_TYPE isEqualToString:@"住宅"]) {
            cell.buildingPurposeLabel.backgroundColor = UIColorFromRGB(0xf79700);
        }else if ([building.BUILDING_TYPE isEqualToString:@"商业"])
        {
        cell.buildingPurposeLabel.backgroundColor = UIColorFromRGB(0x69c803);
        }else if ([building.BUILDING_TYPE isEqualToString:@"公寓"]){
        cell.buildingPurposeLabel.backgroundColor = UIColorFromRGB(0x05b5d5);
        }else if ([building.BUILDING_TYPE isEqualToString:@"其他"])
        {
            cell.buildingPurposeLabel.backgroundColor = UIColorFromRGB(0x8f75aa);
        }
        
        return cell;
    }else{
        /*给cell的imageView添加图片*/
        cell.buildingView_image.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.buildingView_image.hidden = YES;
        cell.buildingPurposeLabel.hidden = YES;
        cell.addImageView.hidden = NO;
        cell.BuildingNUMLabel.hidden = YES;
        cell.usageRateLabel.hidden = YES;
        //NSLog(@"%ld",indexPath.row);
        return cell;
    }
    return cell;
}
#pragma mark self.allBuildingCollectionViewDelegate
- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中cell%ld",(long)indexPath.row);
    if (indexPath.row == self.allBuilding.count) {
        [self addBuilding];
    }else {
        //传参
        BNApartmentController *apartmentVC = [BNApartmentController new];
        apartmentVC.region_id = self.params[@"region_id"];
        BNBuildingModel *sd = self.allBuilding[indexPath.row];
        apartmentVC.building_no = sd.BUILDING_NO;
        apartmentVC.regionName = self.name;
        NSLog(@"---///---///---///选中住宅楼 向下个页面传参%@，%@，%@",apartmentVC.region_id,apartmentVC.building_no,apartmentVC.regionName);
        [self.navigationController pushViewController:apartmentVC animated:YES];
    }
}
#pragma mark 添加按钮点击事件
- (void)addBuilding
{
    BNAddBuildingViewController *newBuilding = [[BNAddBuildingViewController alloc]init];
    newBuilding.REGIO_ID = self.params[@"region_id"];
    [self.navigationController pushViewController:newBuilding animated:YES];
}

#pragma mark-网络请求
- (void)getRequestWithUrl:(NSString *)url
{
    
    WS;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"CommunityContentViewController请求回的数据个数%@",responseObject[@"SIZE"]);
        [weakSelf.allBuildingCollectionView.header endRefreshing];
        if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
            [MBProgressHUD showError:@"系统异常"];
        }else if ([responseObject[@"MSGCODE"] isEqualToString:@"300"]){
            
        weakSelf.allBuilding   = [weakSelf getArrFromDic:responseObject];
            NSLog(@"请求每栋楼的数据%@",responseObject);
                
                [weakSelf.allBuildingCollectionView reloadData];
                [weakSelf setValueForFootLabel];
           
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络请求失败"];
        [weakSelf.allBuildingCollectionView.header endRefreshing];
        
        NSLog(@"网络请求失败");
    }];

    
}
- (NSString *) getUrl
{
    NSString *region_id = self.params[@"region_id"];
    NSString *wg_id = self.params[@"wg_id"];
    NSString *urlstr = [REGION stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",region_id,wg_id]];
    NSLog(@"***URL****%@",urlstr);
   
    return urlstr;
}

- (NSArray *)getArrFromDic:(NSDictionary *)dic
{
    return [BNBuildingModel getAllBuildingInCommunityWithArray:dic[@"RESULT"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    NSLog(@"界面释放");
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

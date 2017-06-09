//
//  BNXiaoQuViewController.m
//  WorkBench
//
//  Created by wanwan on 16/9/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNXiaoQuViewController.h"
#import <MJRefresh.h>
//#import "BNCommunityContentViewController.h"
//#import "BNCommunityCollectionCell.h"
#import "BNNewCommunityContentViewController.h"
#import "BNXQCollectionCell.h"
#import "BNAddCommunityController.h"
#import "BNMetaDataTools.h"
#import <AFNetworking.h>
#import "BNCommunityModel.h"
#import "UIBarButtonItem+BNBarItems.h"
#import "BNAddCommunityController.h"
#import "BNOneTimeIncreseProductViewController.h"
// 水印
#import "BNWaterMark.h"

#define colletionCell 2  //设置具体几列

@interface BNXiaoQuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
//@property(nonatomic, strong) NSMutableArray *hArr;
// 装网格模型数据的
@property (strong,nonatomic)NSMutableArray *communityArray;
//记录当前请求的page的值
@property (nonatomic, assign) int page;
// 请求返回的数据
@property (strong,nonatomic)id responseObject;
// 悬浮按钮
@property(strong,nonatomic)UIButton *flowButton;
@end

static NSString * const reuseIdentifier = @"Cell";
static int buttonY;
@implementation BNXiaoQuViewController

// 懒加载数组
- (NSMutableArray *)communityArray {
    if (!_communityArray) {
        _communityArray = [NSMutableArray arrayWithCapacity:30];
    }
    return _communityArray;
}
// 实现popView后上个界面加载
- (void)viewWillAppear:(BOOL)animated {
    // 开始刷新
    [self.collectionView.header beginRefreshing];
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LoginModel shareLoginModel].NAME;// 网格名称
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self setupItems];
    UIImage *bgImage = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    [self initCollectionView];
    
    // 开始刷新
    [self.collectionView.header beginRefreshing];
    [self getRequest];
    // 判断权限是否一次性添加
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]) {
        //  添加悬浮按钮
        _flowButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-56, SCREEN_H-106, 30, 30)];
        [_flowButton setImage:[UIImage imageNamed:@"add_06"] forState:UIControlStateNormal];
        [_flowButton addTarget:self action:@selector(oneTimeIncreaseData) forControlEvents:UIControlEventTouchUpInside];
        [self.collectionView addSubview:_flowButton];
        [self.collectionView bringSubviewToFront:_flowButton];
        buttonY=(int)_flowButton.frame.origin.y;    }
    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%d",(int)_flowButton.frame.origin.y);
    _flowButton.frame = CGRectMake(_flowButton.frame.origin.x, buttonY+self.collectionView.contentOffset.y , _flowButton.frame.size.width, _flowButton.frame.size.height);
}

// 一次性添加按钮Action
- (void)oneTimeIncreaseData {
    BNOneTimeIncreseProductViewController *addOnceVC = [[BNOneTimeIncreseProductViewController alloc]init];
    
    // 传递网格名字
    addOnceVC.wg_name = [LoginModel shareLoginModel].NAME;
    // 传网格下小区的url
    addOnceVC.allCommunityURL = [self getUrl];
    addOnceVC.wg_id = [LoginModel shareLoginModel].ORG_ID;
    [self.navigationController pushViewController:addOnceVC animated:YES];
    
}


- (void)setupItems {
    //创建右边定位item
    UIBarButtonItem *addItem = [UIBarButtonItem itemWithImage:@"add_03" withHighLightedImage:nil withTarget:self withAction:@selector(clickAddItem)];
    self.navigationItem.rightBarButtonItem = addItem;
    
}

- (void)clickAddItem{
    BNAddCommunityController *addVC = [[BNAddCommunityController alloc]init];
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]) {
        addVC.WG_ID = [LoginModel shareLoginModel].ORG_ID;
    }else {
        addVC.WG_ID = self.org_id;
    }
   
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark - 请求地址

- (NSString *)getUrl{
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]) {
        return [REGIONURL stringByAppendingString:[LoginModel shareLoginModel].ORG_ID];

    }else {
        return [REGIONURL stringByAppendingString:self.org_id];

          }

   }

#pragma mark - 传递请求参数

//- (NSDictionary *)getParams{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgid"];
//    NSLog(@"++++%@",[LoginModel shareLoginModel].ORG_ID);
//    return dic;
//}

#pragma mark -- 请求数据
- (void)getRequest{
    WS
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[self getUrl] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [weakSelf endRefresh];
        [weakSelf.communityArray removeAllObjects];
        NSLog(@"--responseObject---%@",responseObject);
        NSArray * responseArray = [BNMetaDataTools getCommunityModelArray:responseObject[@"RESULT"]];
        
        [weakSelf.communityArray addObjectsFromArray: responseArray];
        
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
        [weakSelf endRefresh];
        
    }];
}
/**
 *  停止刷新
 */
-(void)endRefresh{
    [self.collectionView.header endRefreshing];
    [self.collectionView.footer endRefreshing];
}

- (void) initCollectionView {
    if (!_collectionView) {
        // 布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W-20 ,self.view.bounds.size.height-68) collectionViewLayout:layout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        // [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self.collectionView registerClass:[BNXQCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        //  self.view.backgroundColor = [UIColor blackColor];
        _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            
            [self getRequest];
        }];
        
        _collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getRequest];
            
        }];
    }
    // 去掉滚动条
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_collectionView];
}

#pragma mark -- UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.communityArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BNCommunityModel *communityModel = _communityArray[indexPath.row];
    BNXQCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BNXQCollectionCell" owner:nil options:nil]firstObject];
        return cell;
    }
    
    cell.communityName.text = communityModel.REDION_NAME;
//    cell.backgroundColor = [UIColor redColor];
    cell.UsersQuantity.text = communityModel.SELF_WLAN;
    cell.differentUsersQuantity.text = communityModel.OTHER_WLAN;
    //    cell.layer.borderColor=[UIColor darkGrayColor].CGColor;
    //    cell.layer.borderWidth=0.3;
    
    cell.AllSelfWlan.text = communityModel.SELF_WLAN_KD;
    cell.AllSelfItv.text = communityModel.SELF_WLAN_ITV;
    cell.otherWlan.text = communityModel.OTHER_WLAN_KD;
    cell.otherItv.text = communityModel.OTHER_WLAN_ITV;
    
    return cell;
    
    
}


#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_W/2-20, SCREEN_W/2-20);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
//    return UIEdgeInsetsMake(5, 25, 30, 25);
    return UIEdgeInsetsMake(8, 5, 0, 5);
    
}


#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    BNCommunityModel *communityModel = _communityArray[indexPath.row];
    BNNewCommunityContentViewController * communityCVC = [[BNNewCommunityContentViewController alloc]init];
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [LoginModel shareLoginModel].ORG_ID, @"wg_id",
                             communityModel.REGION_ID, @"region_id",
                             nil];
        communityCVC.params = dic;
        communityCVC.name = communityModel.REDION_NAME;

    }else {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.org_id, @"wg_id",
                             communityModel.REGION_ID, @"region_id",
                             nil];
        communityCVC.params = dic;
        communityCVC.name = communityModel.REDION_NAME;
    }


    

   // cell.backgroundColor = [UIColor greenColor];
    [self.navigationController pushViewController:communityCVC animated:YES];
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

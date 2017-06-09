//
//  BNCommunityController.m
//  WorkBench
//
//  Created by wanwan on 16/8/13.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNCommunityController.h"
#import <MJRefresh.h>
#import "BNCommunityContentViewController.h"
#import "BNCommunityCollectionCell.h"
#import "BNAddCommunityController.h"
#import "BNMetaDataTools.h"
#import <AFNetworking.h>
#import "BNCommunityModel.h"
#import "UIBarButtonItem+BNBarItems.h"
#import "BNAddCommunityController.h"

#import "BNAddProductOnceViewController.h"
#define colletionCell 2  //设置具体几列

@interface BNCommunityController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
//@property(nonatomic, strong) NSMutableArray *hArr;
// 装网格模型数据的
@property (strong,nonatomic)NSMutableArray *communityArray;
//记录当前请求的page的值
@property (nonatomic, assign) int page;
// 请求返回的数据
@property (strong,nonatomic)id responseObject;

@end

static NSString * const reuseIdentifier = @"Cell";

@implementation BNCommunityController

// 懒加载数组
- (NSMutableArray *)communityArray {
    if (!_communityArray) {
        _communityArray = [NSMutableArray arrayWithCapacity:30];
    }
    return _communityArray;
}
// 实现popView后上个界面加载
- (void)viewWillAppear:(BOOL)animated {

    //[self viewDidLoad];

}

- (void)viewDidLoad {
    
    BNAddProductOnceViewController *AddVC= [[BNAddProductOnceViewController alloc]init];
    
    [self.navigationController pushViewController:AddVC animated:YES];
    
    
    self.title = self.WG_DESC;// 网格名称
   // [super viewDidLoad];
    [self setupItems];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.jpg"]];
    [self initCollectionView];
    // 开始刷新
    [self.collectionView.header beginRefreshing];
    [self getRequest];
}

- (void)setupItems {
    //创建右边定位item
    UIBarButtonItem *addItem = [UIBarButtonItem itemWithImage:@"add_03" withHighLightedImage:nil withTarget:self withAction:@selector(clickAddItem)];
    self.navigationItem.rightBarButtonItem = addItem;

}

- (void)clickAddItem{
    BNAddCommunityController *addVC = [[BNAddCommunityController alloc]init];
    addVC.WG_ID = self.WG_ID;
    [self.navigationController pushViewController:addVC animated:YES];

}

#pragma mark - 请求地址

- (NSString *)getUrl{
    return [REGIONURL stringByAppendingString:self.WG_ID];
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
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[self getUrl] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [self endRefresh];
        [self.communityArray removeAllObjects];
        NSLog(@"--responseObject---%@",responseObject);
        NSArray * responseArray = [BNMetaDataTools getCommunityModelArray:responseObject[@"RESULT"]];
        
        [self.communityArray addObjectsFromArray: responseArray];
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
        [self endRefresh];
        
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
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W-20 ,self.view.bounds.size.height) collectionViewLayout:layout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
       // [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self.collectionView registerClass:[BNCommunityCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
    BNCommunityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BNCommunityCollectionCell" owner:nil options:nil]firstObject];
        return cell;
    }
    
    cell.communityName.text = communityModel.REDION_NAME;
    cell.UsersQuantity.text = communityModel.SELF_WLAN;
    cell.differentUsersQuantity.text = communityModel.OTHER_WLAN;
//    cell.layer.borderColor=[UIColor darkGrayColor].CGColor;
//    cell.layer.borderWidth=0.3;

    return cell;


}


#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    
    return CGSizeMake(115, 115);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
   
    return UIEdgeInsetsMake(5, 25, 30, 25);
    
}


#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    BNCommunityModel *communityModel = _communityArray[indexPath.row];
    BNCommunityContentViewController * communityCVC = [[BNCommunityContentViewController alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.WG_ID, @"wg_id",
                          communityModel.REGION_ID, @"region_id",
                         nil];
    
    communityCVC.params = dic;
    communityCVC.name = communityModel.REDION_NAME;
    cell.backgroundColor = [UIColor greenColor];
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

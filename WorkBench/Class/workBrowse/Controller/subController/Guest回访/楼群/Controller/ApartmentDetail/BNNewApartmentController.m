//
//  BNNewApartmentController.m
//  WorkBench
//
//  Created by wanwan on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNNewApartmentController.h"
//#import "BNApartmentCollectionCell.h"
#import "BNNewApartmentCollectionCell.h"
#import "BNLongCollectionViewCell.h"
#import "BNAddCollectionCell.h"
#import "BNApartmentTableViewController.h"
#import <AFNetworking.h>
#import "BNUnitSummaryModel.h"
#import "BNMetaDataTools.h"
#import "BNUnitDetailModel.h"
#import <MJRefresh.h>
#import "BNAddRoomController.h"
#import "BNWaterMark.h"

@interface BNNewApartmentController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** 页面控制变量 */
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;
// 创建collection数组
@property (nonatomic, strong) NSMutableArray *collectionViewArr;
@property (nonatomic, strong) NSArray *apartmentQuantityArray;
@property (nonatomic, assign) NSNumber *apartmentAcount;
@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) NSMutableArray *imageArray;
//UNIT_NUM --> 单元数
@property (nonatomic, assign) NSInteger unit_Num;
//FLOOR_NUM --> 楼层数
@property (nonatomic, assign) NSInteger floor_Num;
//ONE_FLOOR_HOUSES --> 每层户数
@property (nonatomic, assign) NSInteger oneFloor_Houses;
// 单元楼概况信息
@property (nonatomic, strong) NSArray *unitArray;
// 单元楼详细情况信息
@property (nonatomic, strong) NSArray *unitDetailArray;
// 判断scrollView是第几次加载
@property (nonatomic, assign) BOOL isFirstLoad;
// 判断collectionView是第几次加载
//@property (nonatomic, assign) BOOL isCVFirstLoad;
//记录当前请求的page的值
@property (nonatomic, assign) int page;
//记录当前pageControl page的值
@property (nonatomic, assign) int tempPage;
// 记录临时单元号
@property (nonatomic, assign) NSInteger tempNum;
/** 小区楼唯一标识 */
@property (nonatomic, copy) NSString *BUILDING_ID;

@end

@implementation BNNewApartmentController

static NSString * const reuseIdentifier = @"Cell";
//// 懒加载数组
- (NSMutableArray *)collectionViewArr {
    if (!_collectionViewArr) {
        _collectionViewArr = [NSMutableArray array];
    }
    return _collectionViewArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    _collectionViewArr = [NSMutableArray array];
    // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    self.title = [NSString stringWithFormat:@"%@-%@",self.regionName,self.building_no];
    // 刚加载时，动态page为0
    _tempPage = 0;
    _page = 0;
    _tempNum = 0;
    // 请求单元楼的梗概，以便初始化视图
    [self getUnitSummaryRequest];
    // 首次加载collectionView
     self.isFirstLoad = YES;
    //self.isCVFirstLoad = YES;
    // 加载视图
    [self addScrollView];
}

/**
 *  停止刷新
 */
-(void)viewWillAppear:(BOOL)animated
{    // 请求单元楼的梗概，以便初始化视图
  //  [self getUnitSummaryRequest];
    //[self viewDidLoad];
    [self.collectionView.header beginRefreshing];
}
-(void)endRefresh{
    [self.collectionView.header endRefreshing];
    [self.collectionView.footer endRefreshing];
}

#pragma mark -- <<<<----- 数据请求部分 ----->>>>

#pragma mark -- 请求单元楼概况信息数据
- (void)getUnitSummaryRequest{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSDictionary *param = @{@"REGION_ID":self.region_id ,@"BUILDING_NO":self.building_no};
    WS
    [mgr POST:UNIT_SUMMARY_URL parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"--unitRESPONSE--%@",responseObject);
        NSLog(@"当前登录人%@",[LoginModel shareLoginModel].USER_NAME);
        // 停止刷新
        [weakSelf endRefresh];
        NSArray *array = responseObject[@"RESULT"];
        weakSelf.unitArray = [BNMetaDataTools getUnitSummaryModelArray:array];
        BNUnitSummaryModel *unit = weakSelf.unitArray.firstObject;
        weakSelf.unit_Num = [unit.UNIT_NUM integerValue];
        weakSelf.floor_Num = [unit.FLOOR_NUM integerValue];
        weakSelf.oneFloor_Houses = [unit.ONE_FLOOR_HOUSES integerValue];
        weakSelf.BUILDING_ID = unit.BUILDING_ID;
        
        // 增加scrollView
        [weakSelf addScrollView];
        // 发送第一单元的请求
        [weakSelf getUnitDetailDataWithUnitNum:1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        // 停止刷新控件动画
        [weakSelf endRefresh];
    }];
}


#pragma mark -- 请求单元楼详细情况况信息数据
- (void)getUnitDetailDataWithUnitNum:(NSInteger)unitNum{
    NSLog(@"--%@单元--",[NSString stringWithFormat:@"%ld",unitNum]);
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    NSDictionary *param = @{@"REGION_ID":self.region_id,@"BUILDING_NO":self.building_no,@"UNIT_NO":[NSString stringWithFormat:@"%ld",(long)unitNum]};
    WS
    [manger POST:UNIT_DETAIL_URL parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // collectionView 创建的个数大于等于单元数（向左滑动时用）
        if (weakSelf.collectionViewArr.count >= unitNum) {
            weakSelf.collectionView = weakSelf.collectionViewArr[unitNum-1];
        }
        // 停止刷新控件动画
        [weakSelf endRefresh];
        // self.unitDetailArray = nil;
        // 请求回来的字典转模型
        NSArray *array = responseObject[@"RESULT"];
        weakSelf.unitDetailArray = [BNMetaDataTools getUnitDetailModelArray:array];
         NSLog(@"----NSArray元素个数-----%ld",_unitDetailArray.count);
        // 重新加载
      

        [weakSelf.collectionView reloadData];
        

        // 请求到数据后再加载collectionView 
        if (unitNum >= weakSelf.tempNum) {
            [weakSelf addCollectionViewWithUnitNum:unitNum-1];
            weakSelf.tempNum = unitNum+1;
            NSLog(@"___加载了%ld",(long)unitNum);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 停止刷新控件动画
        [weakSelf endRefresh];
        NSLog(@"----error-----%@",error);
    }];
    
}

#pragma mark -- addScrollView
- (void)addScrollView {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    _scrollView.pagingEnabled = YES;
    // 背景
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(self.unit_Num*SCREEN_W, SCREEN_H);
    _scrollView.delegate=self;
    // 水平划条去掉
    // scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    /** 页面控制 */
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 10, SCREEN_H*5/6, 20, 20)];
    // 当前页面是第一页
    //self.page = 0;
    _pageControl.currentPage = _page;
    // 一共多少页页
    _pageControl.numberOfPages = self.unit_Num;
    // 边线颜色 RGB(247, 151, 0)
    [_pageControl setCurrentPageIndicatorTintColor:RGB(247, 151, 0)];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [self.view addSubview:_pageControl];
}

#pragma mark -- UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewWidth =  scrollView.frame.size.width;
    // 获取scrollView距离x方向的偏移量
    CGFloat xOffset = scrollView.contentOffset.x;
    // 通过水平的偏移量计算当前应该显示哪页(只要超过一半就应该变成第二页:0/1)
    if (xOffset !=0) {// 防止如果只上下滑动，——page 变为0
          _tempPage = xOffset / scrollViewWidth + 0.5;
          _pageControl.currentPage = _tempPage;
        if (_page != _tempPage ) { // && _page < _tempPage 保证只请求一次，以及首次加载发送请求，返回不发送
            _page = _tempPage;
           
            self.isFirstLoad = YES;// 页面改变变为首次记载新的collection刷新头判断条件
            NSLog(@"----request------%d",_page+1);
            [self getUnitDetailDataWithUnitNum:_page+1];
        }

    }
 
    
    
}

#pragma mark -- 创建CollectionView

- (void)addCollectionViewWithUnitNum:(NSInteger)i {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
 
      UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(i*SCREEN_W, 0, SCREEN_W ,SCREEN_H-111) collectionViewLayout:layout];
    // 添加到数组
    [_collectionViewArr addObject:collectionView];
    NSLog(@"---VC个数---%lu",(unsigned long)_collectionViewArr.count);
//    if (_collectionViewArr.count<=i) {
//        return
//    }
        _collectionView = _collectionViewArr[i];

    // 设置tag
    [_collectionView setTag:10000+i];
    _collectionView.backgroundColor = [UIColor clearColor];
    
   
        // 背景
//        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cvc_bg"]];
//        imgView.frame = self.view.bounds;
//        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        [_collectionView setBackgroundView:imgView];
        // 注册
        
        
        if (self.oneFloor_Houses<5 && self.oneFloor_Houses>1) {
            //  一层业主在2~4之间用collection
            [_collectionView registerClass:[BNNewApartmentCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
           [_collectionView registerClass:[BNAddCollectionCell class] forCellWithReuseIdentifier:@"addCell"];
        } else {
            // 否则另外显示
            [_collectionView registerClass:[BNLongCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
            [_collectionView registerClass:[BNAddCollectionCell class] forCellWithReuseIdentifier:@"addCell"];
        }
        
        
        _collectionView.contentSize = CGSizeMake(SCREEN_W, 800);
        // 代理
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        // 刷新
   
        _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getUnitDetailDataWithUnitNum:_page+1];
            NSLog(@"-----_page+1------%d",_page+1);
        }];
        
        _collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getUnitDetailDataWithUnitNum:_page+1];
            NSLog(@"-----_page+1------%d",_page+1);
        }];
    if (_isFirstLoad) {
        // 开始刷新
        [self.collectionView.header beginRefreshing];
        _isFirstLoad = NO;
    }
    
        // 添加单元Title
        UILabel *TipLabel = [UILabel new];
        TipLabel.frame=CGRectMake(0, 0, SCREEN_W, 30);
        TipLabel.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:TipLabel];
    
    
    UILabel *TipLabel0 = [UILabel new];
    TipLabel0.frame=CGRectMake((SCREEN_W/10)*1, 0, SCREEN_W/10, 30);
    TipLabel0.text = @"电信";
    TipLabel0.textColor = UIColorFromRGB(0x0395fd);
    TipLabel0.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:TipLabel0];
    
    UILabel *TipLabel1 = [UILabel new];
    TipLabel1.frame=CGRectMake((SCREEN_W/10)*3, 0, SCREEN_W/10, 30);
    TipLabel1.text = @"移动";
    TipLabel1.textColor = UIColorFromRGB(0x8ada10);
    TipLabel1.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:TipLabel1];
    
    UILabel *TipLabel2 = [UILabel new];
    TipLabel2.frame=CGRectMake((SCREEN_W/10)*5, 0, SCREEN_W/10, 30);
    TipLabel2.text = @"联通";
    TipLabel2.textColor = UIColorFromRGB(0xefb9c5);
    TipLabel2.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:TipLabel2];
    
    UILabel *TipLabel3 = [UILabel new];
    TipLabel3.frame=CGRectMake((SCREEN_W/10)*7, 0, SCREEN_W/10, 30);
    TipLabel3.text = @"广电";
    TipLabel3.textColor = UIColorFromRGB(0xf29a31);
    TipLabel3.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:TipLabel3];
    
    UILabel *TipLabel4 = [UILabel new];
    TipLabel4.frame=CGRectMake((SCREEN_W/10)*9, 0, SCREEN_W/10, 30);
    TipLabel4.text = @"其他";
    TipLabel4.textColor = UIColorFromRGB(0x9070e8);
    TipLabel4.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:TipLabel4];
    
    
    UIView* circle0 = [UIView new];
    circle0.frame = CGRectMake(TipLabel0.frame.origin.x-(SCREEN_W*3/40), 7, 16, 16);
    circle0.backgroundColor = UIColorFromRGB(0x0395fd);
    circle0.layer.cornerRadius = 8;
    circle0.layer.masksToBounds = YES;
    [self.view addSubview:circle0];
    
    
    UIView* circle1 = [UIView new];
    circle1.frame = CGRectMake(TipLabel1.frame.origin.x-(SCREEN_W*3/40), 7, 16, 16);
    circle1.backgroundColor = UIColorFromRGB(0x8ada10);
    circle1.layer.cornerRadius = 8;
    circle1.layer.masksToBounds = YES;
    [self.view addSubview:circle1];
    
    
    UIView* circle2 = [UIView new];
    circle2.frame = CGRectMake(TipLabel2.frame.origin.x-(SCREEN_W*3/40), 7, 16, 16);
    circle2.backgroundColor = UIColorFromRGB(0xefb9c5);
    circle2.layer.cornerRadius = 8;
    circle2.layer.masksToBounds = YES;
    [self.view addSubview:circle2];
    
    
    UIView* circle3 = [UIView new];
    circle3.frame = CGRectMake(TipLabel3.frame.origin.x-(SCREEN_W*3/40), 7, 16, 16);
    circle3.backgroundColor = UIColorFromRGB(0xf29a31);
    circle3.layer.cornerRadius = 8;
    circle3.layer.masksToBounds = YES;
    [self.view addSubview:circle3];
    
    
    UIView* circle4 = [UIView new];
    circle4.frame = CGRectMake(TipLabel4.frame.origin.x-(SCREEN_W*3/40), 7, 16, 16);
    circle4.backgroundColor = UIColorFromRGB(0x9070e8);
    circle4.layer.cornerRadius = 8;
    circle4.layer.masksToBounds = YES;
    [self.view addSubview:circle4];
    
    
        UILabel *cellNumLabel = [UILabel new];
        cellNumLabel.frame=CGRectMake(SCREEN_W/2-25, 36, 50, 30);
        cellNumLabel.textAlignment = NSTextAlignmentCenter;
        cellNumLabel.font = [UIFont boldSystemFontOfSize:18];
        cellNumLabel.text=[NSString stringWithFormat:@"%ld单元",
                           i+1];
        cellNumLabel.textColor = UIColorFromRGB(0xb4bdcb);
    
        [cellNumLabel sizeToFit];
        [_collectionView addSubview:cellNumLabel];
        
        [_collectionView setShowsVerticalScrollIndicator:NO];
       // _collectionView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_collectionView];
            // 重新加载
        [self.collectionView reloadData];
    
}


#pragma mark -- UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    // ------<<<<-------具有扩展性的写法-------->>>>--------
    //    if (collectionView.tag == 10000) {
    //        return 10;
    //    }else if (collectionView.tag == 10001){
    //         return 3;
    //    }
    //    else if (collectionView.tag == 10002){
    //         return 6;
    //    }else {
    //         return 20;
    //    }
    // return self.floor_Num * self.oneFloor_Houses;
//    if (self.unitDetailArray.count != 0) {
//        return self.unitDetailArray.count+1;
//
//    }else {
        return self.unitDetailArray.count+1;
//    }
    
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.oneFloor_Houses<5 && self.oneFloor_Houses>1) {
        //  一层业主在2~4之间用collection
        if (indexPath.row != self.unitDetailArray.count){
            
            BNNewApartmentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"BNNewApartmentCollectionCell" owner:nil options:nil]firstObject];
                return cell;
            }
            // 画实线框
            CAShapeLayer *border = [CAShapeLayer layer];
            border.strokeColor = RGB(255, 143, 12).CGColor;
            border.fillColor = nil;
            border.lineDashPattern = nil;
            border.path = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
            border.frame = CGRectMake(0, 0,cell.bounds.size.width, cell.bounds.size.height);
            [cell.layer addSublayer:border];
            // 获取数据
            NSLog(@"--indexPath.row--%ld",(long)indexPath.row);
            BNUnitDetailModel *unitDetail = _unitDetailArray[indexPath.row];
            NSLog(@"%@---%@",unitDetail.ROOT_NO,unitDetail.USER_NUM);
            cell.apartmentNumLabel.text= unitDetail.ROOT_NO;
            cell.userAccount.text = unitDetail.USER_NUM;
            
            
            cell.circle00.text = unitDetail.SELF_WLAN_SJ;
            cell.circle01.text = unitDetail.YD_WLAN_SJ;
            cell.circle02.text = unitDetail.LT_WLAN_SJ;
            cell.circle03.text = unitDetail.GD_WLAN_SJ;
            cell.circle04.text = unitDetail.QT_WLAN_SJ;
            
            cell.circle10.text = unitDetail.SELF_WLAN_KD;
            cell.circle11.text = unitDetail.YD_WLAN_KD;
            cell.circle12.text = unitDetail.LT_WLAN_KD;
            cell.circle13.text = unitDetail.GD_WLAN_KD;
            cell.circle14.text = unitDetail.QT_WLAN_KD;
            
            cell.circle20.text = unitDetail.SELF_WLAN_ITV;
            cell.circle21.text = unitDetail.YD_WLAN_ITV;
            cell.circle22.text = unitDetail.LT_WLAN_ITV;
            cell.circle23.text = unitDetail.GD_WLAN_ITV;
            cell.circle24.text = unitDetail.QT_WLAN_ITV;
            
            if ([unitDetail.PRO_NUM intValue] > 1) {
                cell.cellImage.image = [UIImage imageNamed:@"mix"];
            } else {
            if ([unitDetail.OPERATOR_TYPE isEqualToString:@"1"]) {
                cell.cellImage.image = [UIImage imageNamed:@"telecom"];
            } else if ([unitDetail.OPERATOR_TYPE isEqualToString:@"2"]){
                cell.cellImage.image = [UIImage imageNamed:@"mobile"];
            } else if ([unitDetail.OPERATOR_TYPE isEqualToString:@"3"]){
                cell.cellImage.image = [UIImage imageNamed:@"unicom"];
            } else if ([unitDetail.OPERATOR_TYPE isEqualToString:@"4"]){
                cell.cellImage.image = [UIImage imageNamed:@"ccbn.png"];
            } else {
                // 提示数据有误
            }
            }
            // 停止刷新
//            [self endRefresh];
            return cell;
        } else {// 最后一个添加CollectionCell
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"BNAddCollectionCell" owner:nil options:nil]firstObject];
                return cell;
            }
//            // 画虚线框
//            CAShapeLayer *border = [CAShapeLayer layer];
//            border.strokeColor = RGB(255, 143, 12).CGColor;
//            border.fillColor = nil;
//            border.lineDashPattern = @[@8, @8];
//            border.path = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
//            border.frame = CGRectMake(0, 0,cell.bounds.size.width, cell.bounds.size.height);
//            [cell.layer addSublayer:border];
            return cell;
        }
    } else {
        // 否则另外单行显示
        if (indexPath.row != self.unitDetailArray.count){

        BNLongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BNLongCollectionViewCell" owner:nil options:nil]firstObject];
            return cell;
        }
            // Cell底线颜色
            UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, cell.bounds.size.width , 0.5)];
            lineview.backgroundColor = RGB(255, 146, 50);
            [cell addSubview:lineview];
            
        // 获取数据
        BNUnitDetailModel *unitDetail = _unitDetailArray[indexPath.row];
        cell.apartmentNumLabel.text= unitDetail.ROOT_NO;
        cell.userAccount.text = unitDetail.USER_NUM;
        if ([unitDetail.PRO_NUM intValue] > 1) {
            cell.cellImage.image = [UIImage imageNamed:@"mix"];
        } else {
        if ([unitDetail.OPERATOR_TYPE isEqualToString:@"1"]) {
            cell.cellImage.image = [UIImage imageNamed:@"telecom"];
        } else if ([unitDetail.OPERATOR_TYPE isEqualToString:@"2"]){
            cell.cellImage.image = [UIImage imageNamed:@"mobile"];
        } else if ([unitDetail.OPERATOR_TYPE isEqualToString:@"3"]){
            cell.cellImage.image = [UIImage imageNamed:@"unicom"];
        } else if ([unitDetail.OPERATOR_TYPE isEqualToString:@"4"]){
            cell.cellImage.image = [UIImage imageNamed:@"ccbn.png"];
        } else {
            // 提示数据有误
        }
        }
        // 停止刷新
//        [self endRefresh];
        return cell;
    } else {// 最后一个添加CollectionCell
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BNAddCollectionCell" owner:nil options:nil]firstObject];
            return cell;
        }
       
//        // 画虚线框
//        CAShapeLayer *border = [CAShapeLayer layer];
//        border.strokeColor = RGB(255, 143, 12).CGColor;
//        border.fillColor = nil;
//        border.lineDashPattern = @[@8, @8];
//        border.path = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
//        border.frame = CGRectMake(0, 0,cell.bounds.size.width, cell.bounds.size.height);
//        [cell.layer addSublayer:border];
        return cell;
        }
    }
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    // ------<<<<-------具有扩展性的写法-------->>>>--------
    //    if(collectionView.tag==10000){
    //        if (columns==2) {
    //            return CGSizeMake((SCREEN_W-120)/2, 70);
    //        } else if (columns==3){
    //            return CGSizeMake((SCREEN_W-120)/3, 70);
    //        }  else if (columns==4){
    //            return CGSizeMake((SCREEN_W-80)/4, 70);
    //        } else {
    //            return CGSizeMake(SCREEN_W, 70);
    //        }
    //
    //    }
    if (self.oneFloor_Houses==2) {
        return CGSizeMake(SCREEN_W/2-20, SCREEN_W/2-20);
//        return CGSizeMake((SCREEN_W-120)/2, 70);
    } else if (self.oneFloor_Houses==3){
        return CGSizeMake((SCREEN_W-120)/3, 70);
    } else if (self.oneFloor_Houses==4){
        return CGSizeMake((SCREEN_W-80)/4, 70);
    } else {
        return CGSizeMake(SCREEN_W, 70);
    }
    
}
// cell间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.oneFloor_Houses==2 || self.oneFloor_Houses==3 || self.oneFloor_Houses==4) {
        return 10;
    } else {
        return 0;
    }
    
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //    // ------<<<<-------具有扩展性的写法-------->>>>--------
    //    if(collectionView.tag==10000){
    //        if(columns==2){
    //            return UIEdgeInsetsMake(40, 40, 30, 40);
    //        }else if (columns==4){
    //            return UIEdgeInsetsMake(40, 20, 30, 20);
    //
    //        }else{
    //            return UIEdgeInsetsMake(40, 40, 30, 40);
    //        }
    //    }
    if (self.oneFloor_Houses==2) {
        return UIEdgeInsetsMake(62, 12, 0, 10);
//        return UIEdgeInsetsMake(40, 40, 30, 40);
    } else if (self.oneFloor_Houses==3){
        return UIEdgeInsetsMake(40, 40, 30, 40);
    } else if (self.oneFloor_Houses==4){
        return UIEdgeInsetsMake(40, 20, 30, 20);
    } else {
        return UIEdgeInsetsMake(40, 0, 0, 0);
    }
    
    
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到添加界面
    if (indexPath.row == self.unitDetailArray.count) {
        BNAddRoomController *houseVC = [[BNAddRoomController alloc]init];
        houseVC.BUILDING_ID = self.BUILDING_ID;
        houseVC.UNIT_NO = [NSString stringWithFormat:@"%ld",collectionView.tag-10000+1];
        [self.navigationController pushViewController:houseVC animated:YES];
    }else {
        // 跳转
    BNApartmentTableViewController *vc = [[BNApartmentTableViewController alloc]init];
    BNUnitDetailModel *unitDetail = [BNUnitDetailModel new];
    unitDetail = _unitDetailArray[indexPath.row];
    vc.building_id = unitDetail.BUILDING_ID;
    vc.unit_no = [NSString stringWithFormat:@"%ld",collectionView.tag-10000+1];
    vc.root_no = unitDetail.ROOT_NO;
    vc.address = [NSString stringWithFormat:@"%@  %@",self.regionName,self.building_no];
    
    [self.navigationController pushViewController:vc animated:YES];
        
    }
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



@end

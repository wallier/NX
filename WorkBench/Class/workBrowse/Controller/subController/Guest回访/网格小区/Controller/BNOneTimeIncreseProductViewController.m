//
//  BNOneTimeIncreseProductViewController.m
//  WorkBench
//
//  Created by wanwan on 16/9/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNOneTimeIncreseProductViewController.h"
#import "BNSelectedCellView.h"
#import <AFNetworking.h>
//#import "BNDataPickerView.h"
#import "BNMetaDataTools.h"
#import "BNGridRoleModel.h"
#import "BNCommunityModel.h"
#import "BNBuildingModel.h"
#import "BNUnitSummaryModel.h"
#import "UIScrollView+BNTouch.h"
#import "BNAddCommunityController.h"
#import "BNAddBuildingViewController.h"
#import "BNCustomTextField.h"
#import "DatePickerView.h"
#import "BNWaterMark.h"



@interface BNOneTimeIncreseProductViewController ()<UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate>
// 速率背景view
@property (nonatomic, strong) UIView *speedView;
// 速率speedLabel
@property (nonatomic, strong) UILabel *speedLabel;

// 添加小区
@property (nonatomic, strong) UIButton *addAreaBtn;
// 添加几号楼
@property (nonatomic, strong) UIButton *addBuildingBtn;
// 网格对象
@property (nonatomic, strong) BNGridRoleModel *gridModel;
// 小区对象
@property (nonatomic, strong) BNCommunityModel *areaModel;
// 楼对象
@property (nonatomic, strong) BNBuildingModel *buildingModel;
// 楼详情对象
@property (nonatomic, strong) BNUnitSummaryModel *unitModel;

@property (nonatomic, strong) UIScrollView *scrollView;
// 对象选择器
@property (nonatomic, strong) UIPickerView *pickerView;
// 时间选择器
@property (strong,nonatomic) DatePickerView *datePickerView;
// 网格数组
@property (nonatomic, strong) NSArray *wgArray;
// 小区数组
@property (nonatomic, strong) NSArray *areaArray;
// 楼号数组
@property (nonatomic, strong) NSArray *buildingNumArray;
// 单元数组
@property (nonatomic, strong) NSArray *unitArray;
// 运营商数组
@property (nonatomic, strong) NSArray *operatorsArray;
// 产品数组
@property (nonatomic, strong) NSArray *productArray;

// 背景View
@property (nonatomic, strong) UIView *bgview;

// 网格Label
@property (nonatomic, strong) UILabel *wgLabel;
// 小区Label
@property (nonatomic, strong) UILabel *areaLabel;
/** 楼号Label */
@property (nonatomic, strong) UILabel *buildingNumLabel;
 // BUILDING_ID --> 小区楼唯一标识
@property (nonatomic, strong) NSString *building_ID;
/** 单元数Label */
@property (nonatomic, strong) UILabel *cellNumLabel;
/** 楼层数Label */
@property (nonatomic, strong) UILabel *floorsNumLabel;
/** 每层户数Label */
@property (nonatomic, strong) UILabel *houseNumEachFloorLabel;
/** 楼类型Label */
@property (nonatomic, strong) UILabel *buildingTypeLabel;

// 单元
@property (nonatomic, strong) UILabel *cellLabel;
// 室
@property (nonatomic, strong) UITextField *roomTextField;
// 用户号码
@property (nonatomic, strong) UITextField *phoneNumTextField;
// 运营商
@property (nonatomic, strong) UILabel *operatorsLabel;
// 运营商类别供发给服务器
@property (nonatomic, strong) NSString *operatorsTypeStr;
// 产品类别
@property (nonatomic, strong) UILabel *productLabel;
// 产品类别供发给服务器
@property (nonatomic, strong) NSString *productTypeStr;
// 速率
@property (nonatomic, strong) BNCustomTextField *speedRateField;
// 套餐
@property (nonatomic, strong) UITextField *packageTextField;
// 到期时间
@property (nonatomic, strong) UITextField *deadlineTextField;
// 是否他往占我网
@property (assign, nonatomic) NSString *isOccupy;
// 占用创建时间
@property (strong, nonatomic) NSString *occupyTime;
// 备注
@property (nonatomic, strong) UITextView *remarkTextView;
// 取消保存Button
// 参数字典
@property (nonatomic, strong) NSDictionary *paraDic;
// 小区ID
@property (nonatomic, strong) NSString *area_id;
@end

@implementation BNOneTimeIncreseProductViewController

static NSInteger tag;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addScrollView];
    _datePickerView = [[DatePickerView alloc] initWithCustomeHeight:250];
     __weak typeof (self) weakSelf = self;
    _datePickerView.confirmBlock = ^(NSString *choseDate, NSString *restDate) {
        
        weakSelf.deadlineTextField.text = choseDate;
        
  
        
    };

    _datePickerView.cannelBlock = ^(){
        
        [weakSelf.view endEditing:YES];
        
    };
    
    //设置textfield的键盘 替换为我们的自定义view
    self.deadlineTextField.inputView = _datePickerView;

    // 判断从哪跳过来的
    if (_all_WG_URL) {
        [self getWGRequest];
      
    }else {
        // 给网格Label名字
        self.wgLabel.text = self.wg_name;
        // 网格Label不添加手势（在是否添加手势处有判断）
        [self getAreaRequest];
        
    }
    
    self.title = @"一次性添加信息";
    // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:img]];

    _operatorsArray = @[@"电信",@"移动",@"联通",@"广电",@"未知"];
    _productArray = @[@"固话",@"宽带",@"手机",@"IPTV"];
    // 默认值
    self.operatorsLabel.text = _operatorsArray[0];
    // 给服务器的
    self.operatorsTypeStr = @"1";
    self.productLabel.text = _productArray[0];
  //  [_pickerView selectRow:0 inComponent:0 animated:NO];
    // 给服务器的
    self.productTypeStr = @"1";
    // pickView背景
    self.bgview = [[UIView alloc]init];
    self.bgview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    self.bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgview];
    
    UIView *btnView = [[UIView alloc]init];
    btnView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    btnView.backgroundColor = [UIColor whiteColor];
    [self.bgview addSubview:btnView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 5, 60, 30);
    cancelBtn.backgroundColor = RGB(255, 146, 50);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = RGB(255, 146, 50);
    sureBtn.frame = CGRectMake(self.view.frame.size.width - 70, 5, 60, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtn) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:sureBtn];
    
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.frame = CGRectMake(0, 40, self.view.frame.size.width, 110);
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.bgview addSubview:_pickerView];

}
// 添加完后，返回刷新
- (void)viewWillAppear:(BOOL)animated{
    // 判断从哪跳过来的
    if (_all_WG_URL) {
        [self getWGRequest];
        
    }else {
        // 给网格Label名字
        self.wgLabel.text = self.wg_name;
        // 网格Label不添加手势（在是否添加手势处有判断）
        [self getAreaRequest];
        
    }

}

#pragma mark -- 获取网格数据

- (NSString *)getwgURL {
        return self.all_WG_URL;
}

- (void)getWGRequest{
    WS
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[self getwgURL] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSArray * responseArray = [BNMetaDataTools getGridRoleModelArray:responseObject[@"RESULT"]];
        weakSelf.wgArray = responseArray;
        if (_wgArray.count == 0) {
            return ;
        }else {
            // 设置第一个默认值
            _gridModel = _wgArray[0];
            weakSelf.wg_id = _gridModel.ID;
            weakSelf.wgLabel.text = _gridModel.NAME;
            [weakSelf getAreaRequest];

        }
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//

//        if ([responseObject[@"SIZE"] isEqualToString:@"0"]) {
//            hud.labelText = @"数据为空!";
//            [hud hide: YES afterDelay: 2];
//        } else if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
//            hud.labelText = @"系统异常!";
//            [hud hide: YES afterDelay: 2];
//        }else{
//          [self.pickerView reloadAllComponents];
//        }
//      
//
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
//        [self endRefresh];
        
    }];
}

#pragma mark -- 获取小区数据

- (NSString *)getAreaURL {
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]) {
        return [REGIONURL stringByAppendingString:[LoginModel shareLoginModel].ORG_ID];
        
    }else {
        NSLog(@"--REGIONURL---%@",[REGIONURL stringByAppendingString:self.wg_id]);
        return [REGIONURL stringByAppendingString:self.wg_id];
        
    }
    
}

- (void)getAreaRequest{
    WS
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[self getAreaURL] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSArray *responseArray = [BNMetaDataTools getCommunityModelArray:responseObject[@"RESULT"]];
        if (responseArray.count == 0) {
            // 清空上一数组
            weakSelf.areaArray = nil;
            weakSelf.areaLabel.text = nil;
           // return ;
        } else {
        weakSelf.areaArray = responseArray;
        _areaModel = _areaArray[0];
        // 为传给添加Building的默认region_id
        weakSelf.area_id = _areaModel.REGION_ID;
        weakSelf.region_id = _areaModel.REGION_ID;
        weakSelf.areaLabel.text = _areaModel.REDION_NAME;
            [weakSelf getBuildingRequest];
        }
              // [self getAreaRequest];
        
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hud.mode = MBProgressHUDModeText;
        //
        
        //        if ([responseObject[@"SIZE"] isEqualToString:@"0"]) {
        //            hud.labelText = @"数据为空!";
        //            [hud hide: YES afterDelay: 2];
        //        } else if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
        //            hud.labelText = @"系统异常!";
        //            [hud hide: YES afterDelay: 2];
        //        }else{
        //          [self.pickerView reloadAllComponents];
        //        }
        //
        //
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
        //        [self endRefresh];
        
    }];
}

#pragma mark -- 获取楼号

- (NSString *)getBuildingURL {
    return [REGION stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",self.region_id,self.wg_id]];
}

- (void)getBuildingRequest{
    WS
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[self getBuildingURL] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSArray *responseArray = [BNBuildingModel getAllBuildingInCommunityWithArray:responseObject[@"RESULT"]];
        if (responseArray.count == 0) {
            // 清空上一数组
            weakSelf.buildingNumArray = nil;
            weakSelf.buildingNumLabel.text = nil;
            return ;
        } else {
            weakSelf.buildingNumArray = responseArray;
            _buildingModel = _buildingNumArray[0];
            weakSelf.building_no = _buildingModel.BUILDING_NO;
            weakSelf.building_type = _buildingModel.BUILDING_TYPE;
            weakSelf.buildingNumLabel.text = _buildingModel.BUILDING_NO;
            weakSelf.building_ID = _buildingModel.BUILDING_ID;
            [weakSelf getUnitRequest];
        }
        // [self getAreaRequest];
        
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hud.mode = MBProgressHUDModeText;
        //
        
        //        if ([responseObject[@"SIZE"] isEqualToString:@"0"]) {
        //            hud.labelText = @"数据为空!";
        //            [hud hide: YES afterDelay: 2];
        //        } else if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
        //            hud.labelText = @"系统异常!";
        //            [hud hide: YES afterDelay: 2];
        //        }else{
        //          [self.pickerView reloadAllComponents];
        //        }
        //
        //
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
        //        [self endRefresh];
        
    }];
}

#pragma mark -- 获取楼的概况信息

- (NSString *)getUnitURL {
    return UNIT_SUMMARY_URL;
}

- (NSDictionary *)getUnitParameters {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.region_id forKey:@"REGION_ID"];
    [dic setValue:self.building_no forKey:@"BUILDING_NO"];
    return dic;
}

- (void)getUnitRequest{
    WS
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:[self getUnitURL] parameters:[self getUnitParameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSArray *responseArray = [BNMetaDataTools getUnitSummaryModelArray:responseObject[@"RESULT"]];
        weakSelf.unitModel = responseArray.firstObject;
        // 单元数
        weakSelf.unit_Num = weakSelf.unitModel.UNIT_NUM;
        weakSelf.unitArray = [weakSelf creatUnitArrayWith:weakSelf.unitModel.UNIT_NUM];
        // 显示默认1单元
        weakSelf.cellLabel.text= [NSString stringWithFormat:@"%@单元", weakSelf.unitArray[0]] ;
        // 显示
        weakSelf.cellNumLabel.text = weakSelf.unitModel.UNIT_NUM;
        weakSelf.floorsNumLabel.text = weakSelf.unitModel.FLOOR_NUM;
        weakSelf.houseNumEachFloorLabel.text = weakSelf.unitModel.ONE_FLOOR_HOUSES;
        weakSelf.buildingTypeLabel.text = weakSelf.building_type;
        
//        if (responseArray.count == 0) {
//            // 清空上一数组
//            self.buildingNumArray = nil;
//            self.buildingNumLabel.text = nil;
//            return ;
//        } else {
//            self.buildingNumArray = responseArray;
//            _buildingModel = _buildingNumArray[0];
//            self.buildingNumLabel.text = _buildingModel.BUILDING_NO;
//            
//        }
        // [self getAreaRequest];
        
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hud.mode = MBProgressHUDModeText;
        //
        
        //        if ([responseObject[@"SIZE"] isEqualToString:@"0"]) {
        //            hud.labelText = @"数据为空!";
        //            [hud hide: YES afterDelay: 2];
        //        } else if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
        //            hud.labelText = @"系统异常!";
        //            [hud hide: YES afterDelay: 2];
        //        }else{
        //          [self.pickerView reloadAllComponents];
        //        }
        //
        //
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
        //        [self endRefresh];
        
    }];
}

#pragma mark -- 发送到服务器保存数据
- (void)sendToServerRequest{
    WS
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:ADD_ONETIME_URL parameters:[self getProductParameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"---发送服务器---%@",responseObject);
        if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
            [MBProgressHUD showError:@"系统异常"];
        }else if ([responseObject[@"MSGCODE"] isEqualToString:@"606"]){
            [MBProgressHUD showError:@"插入成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showSuccess:@"插入失败"];
        }

//        NSArray *responseArray = [BNBuildingModel getAllBuildingInCommunityWithArray:responseObject[@"RESULT"]];
//  
        // [self getAreaRequest];
        
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        hud.mode = MBProgressHUDModeText;
        //
        
        //        if ([responseObject[@"SIZE"] isEqualToString:@"0"]) {
        //            hud.labelText = @"数据为空!";
        //            [hud hide: YES afterDelay: 2];
        //        } else if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
        //            hud.labelText = @"系统异常!";
        //            [hud hide: YES afterDelay: 2];
        //        }else{
        //          [self.pickerView reloadAllComponents];
        //        }
        //
        //
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
        //        [self endRefresh];
        
    }];



}

- (NSDictionary *)getProductParameters {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    // WG_ID --> 网格编码
    [dic setValue:self.wg_id forKey:@"WG_ID"];
    // REGION_ID --> 小区编码
    [dic setValue:self.region_id forKey:@"REGION_ID"];
    // BUILDING_NO --> 楼号
   // NSLog(@"----楼号----%@",self.buildingNumLabel.text);self.buildingNumLabel.text
    [dic setValue:self.buildingNumLabel.text forKey:@"BUILDING_NO"];
    // BUILDING_ID --> 小区楼唯一标识
    [dic setValue:self.building_ID forKey:@"BUILDING_ID"];
    // UNIT_NO --> 用户所属单元编号
    [dic setValue:self.cellLabel.text forKey:@"UNIT_NO"];
    // ROOT_NO --> 用户门牌号
    [dic setValue:self.roomTextField.text forKey:@"ROOT_NO"];
    // USER_NUMBER --> 用户号码
    [dic setValue:self.phoneNumTextField.text forKey:@"USER_NUMBER"];
    // OPERATOR_TYPE --> 运营商（电信：1，移动：2，联通：3，广电：4，未知：5）
    [dic setValue:self.operatorsTypeStr forKey:@"OPERATOR_TYPE"];
    // PRODUCT_TYPE --> 产品类别（固话：1，宽带：2，手机：3，IPTV：4）
    [dic setValue:self.productTypeStr forKey:@"PRODUCT_TYPE"];
    if ([self.productTypeStr isEqualToString:@"2"]) {
        // PRODUCT_RATE --> 速率
        [dic setValue:self.speedRateField.text forKey:@"PRODUCT_RATE"];
    }else{
        // PRODUCT_RATE --> 速率
        [dic setValue:@"" forKey:@"PRODUCT_RATE"];
    }
    // PACKAGE_MEAL --> 套餐
    [dic setValue:self.packageTextField.text forKey:@"PACKAGE_MEAL"];
    // EXPIRE --> 到期时间
    [dic setValue:self.deadlineTextField.text forKey:@"EXPIRE"];
    if (_remarkTextView.text) {
        // REMARKS --> 备注
        [dic setValue:self.remarkTextView.text forKey:@"REMARKS"];
    }else{
        // REMARKS --> 备注
        [dic setValue:@"" forKey:@"REMARKS"];
    
    }

    // IS_OCCUPY --> 是否他网占我网（无占用：0，占用：1）
    NSLog(@"--%@--",self.isOccupy);
    [dic setValue:self.isOccupy forKey:@"IS_OCCUPY"];
    if ([self.isOccupy isEqualToString:@"1"]) {
        // FIND_TIME --> 发现占用时间
        [dic setValue:self.occupyTime forKey:@"FIND_TIME"];
        // FIND_PERSON --> 发现人
        [dic setValue:[LoginModel shareLoginModel].USER_NAME forKey:@"FIND_PERSON"];
    }else {
        // FIND_TIME --> 发现占用时间
        [dic setValue:@""forKey:@"FIND_TIME"];
        // FIND_PERSON --> 发现人
        [dic setValue:@""forKey:@"FIND_PERSON"];
    
    }
    // MODIFIED_BY --> 当前登录人名称
    [dic setValue:[LoginModel shareLoginModel].USER_NAME forKey:@"MODIFIED_BY"];
    NSLog(@"---DIC---%@",dic);
    return dic;
}


// 创建单元数组
- (NSArray *)creatUnitArrayWith:(NSString *)unit_Num {

    int num = [unit_Num intValue];
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i < num; i++) {
        [mutArr addObject:[NSString stringWithFormat:@"%d",i+1]];
       
    }

    return [mutArr copy];
}

# pragma mark -- 初始化UI
- (void)addScrollView {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    //_scrollView.pagingEnabled = YES;
    // 背景
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_W, 2*SCREEN_H);
    _scrollView.delegate=self;
//    _scrollView.canCancelContentTouches = NO;
//    _scrollView.delaysContentTouches = NO;
    // 水平划条去掉
    // scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
 
    // 添加小区Btn
    _addAreaBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*3/4+10, 75, 30, 30)];
    [_addAreaBtn setBackgroundImage:[UIImage imageNamed:@"add_06"] forState:UIControlStateNormal];
    // 分割线
    UIView *areLineview = [[UIView alloc]initWithFrame:CGRectMake(0, 119.5, SCREEN_W , 0.5)];
    areLineview.backgroundColor = RGB(255, 146, 50);
    [_scrollView addSubview:areLineview];
    // 添加小区Button 添加手势
    UITapGestureRecognizer *btnTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAreaBtnAction)];
    [_addAreaBtn addGestureRecognizer:btnTap1];
        [_scrollView addSubview:_addAreaBtn];
    
    // 添加几号楼Btn
    _addBuildingBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*3/4+10, 135, 30, 30)];
    [_addBuildingBtn setBackgroundImage:[UIImage imageNamed:@"add_06"] forState:UIControlStateNormal];
    // 分割线
    UIView *buildLineview = [[UIView alloc]initWithFrame:CGRectMake(0, 179.5, SCREEN_W , 0.5)];
    buildLineview.backgroundColor = RGB(255, 146, 50);
    [_scrollView addSubview:buildLineview];
    // 添加小区Button 添加手势
    UITapGestureRecognizer *btnTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBuildingBtnAction)];
    [_addBuildingBtn addGestureRecognizer:btnTap2];
    [_scrollView addSubview:_addBuildingBtn];


    // 网格Label
    _wgLabel = [BNSelectedCellView createCellViewCGRectMakeX:0 andY:0 andW:SCREEN_W andH:60 andLabel1Content:@"网格" andScrollView:_scrollView];
    // 小区Label
    _areaLabel = [BNSelectedCellView createCellViewCGRectMakeX:0 andY:60 andW:SCREEN_W*3/4+10 andH:60 andLabel1Content:@"小区" andScrollView:_scrollView];
    // 楼号
    _buildingNumLabel = [BNSelectedCellView createCellViewCGRectMakeX:0 andY:120 andW:SCREEN_W*3/4+10 andH:60 andLabel1Content:@"楼号" andScrollView:_scrollView];
    // 单元数
    _cellNumLabel = [BNSelectedCellView showCellViewCGRectMakeX:0 andY:180 andW:SCREEN_W andH:60 andLabel1Content:@"单元数" andScrollView:_scrollView];
    // 楼层数
    _floorsNumLabel = [BNSelectedCellView showCellViewCGRectMakeX:0 andY:240 andW:SCREEN_W andH:60 andLabel1Content:@"楼层数" andScrollView:_scrollView];
    // 每层户数
    _houseNumEachFloorLabel = [BNSelectedCellView showCellViewCGRectMakeX:0 andY:300 andW:SCREEN_W andH:60 andLabel1Content:@"每户数" andScrollView:_scrollView];
    // 楼类型
    _buildingTypeLabel = [BNSelectedCellView showCellViewCGRectMakeX:0 andY:360 andW:SCREEN_W andH:60 andLabel1Content:@"楼类型" andScrollView:_scrollView];
    _buildingTypeLabel.text = @"商住楼";
    
    // 单元
    _cellLabel = [BNSelectedCellView createCellViewCGRectMakeX:0 andY:420 andW:SCREEN_W andH:60 andLabel1Content:@"单元" andScrollView:_scrollView];
    // 室
    _roomTextField = [BNSelectedCellView blankPutInCellViewCGRectMakeX:0 andY:480 andW:SCREEN_W andH:60 andLabel1Content:@"室" andTextFieldPlaceHolder:@"请输入室号" andScrollView:_scrollView];
    // 代理
    _roomTextField.delegate = self;
    // 注册通知(观察者)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldBeginAction:) name: UITextFieldTextDidBeginEditingNotification object:_roomTextField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldEndAction:) name: UITextFieldTextDidEndEditingNotification object:_roomTextField];
    // 用户号码
    _phoneNumTextField = [BNSelectedCellView blankPutInCellViewCGRectMakeX:0 andY:540 andW:SCREEN_W andH:60 andLabel1Content:@"电话号码"andTextFieldPlaceHolder:@"请输入电话号码" andScrollView:_scrollView];
    // 代理
    _phoneNumTextField.delegate = self;
    // 注册通知(观察者)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldBeginAction:) name: UITextFieldTextDidBeginEditingNotification object:_phoneNumTextField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldEndAction:) name: UITextFieldTextDidEndEditingNotification object:_phoneNumTextField];
    // 运营商
    _operatorsLabel = [BNSelectedCellView createCellViewCGRectMakeX:0 andY:600 andW:SCREEN_W andH:60 andLabel1Content:@"运营商" andScrollView:_scrollView];
    // 产品
    _productLabel = [BNSelectedCellView createCellViewCGRectMakeX:0 andY:660 andW:SCREEN_W/2 andH:60 andLabel1Content:@"产品" andScrollView:_scrollView];
    // 速率

    // view作为背景
    _speedView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_W/2, 660, SCREEN_W/2, 60)];
    _speedView.backgroundColor = [UIColor clearColor];
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, _speedView.bounds.size.width , 0.5)];
    lineview.backgroundColor = RGB(255, 146, 50);
    [_speedView addSubview:lineview];
    [_scrollView addSubview:_speedView];
    
    // 自定义控件
    _speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 , 0, SCREEN_W/8, 60)];
    _speedLabel.text= @"速率";
    //label1.font = [UIFont boldSystemFontOfSize:60.f];
    _speedLabel.font = [UIFont systemFontOfSize:16];
    // label1.textAlignment = NSTextAlignmentCenter;
    [_speedView addSubview:_speedLabel];
    
    // 速率输入框
    _speedRateField = [[BNCustomTextField alloc]initWithFrame:CGRectMake(SCREEN_W/8+10, 15, SCREEN_W/4-10, 30)];
    _speedRateField.delegate = self;
    // 设置tag
    // [_speedRateField setTag:40670];
    _speedRateField.placeholder = @"  MB";
    _speedRateField.font = [UIFont systemFontOfSize:13];
    _speedRateField.backgroundColor = [UIColor clearColor];
    
    // 注册通知观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldBeginAction:) name: UITextFieldTextDidBeginEditingNotification object:_speedRateField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldEndAction:) name: UITextFieldTextDidEndEditingNotification object:_speedRateField];
    
    // 设置textField中初始光标
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _speedRateField.leftView = leftView;
    _speedRateField.leftViewMode = UITextFieldViewModeAlways ;
    [_speedView addSubview:_speedRateField];
    // 加载时隐藏
    [_speedLabel setHidden:YES];
    [_speedRateField setHidden:YES];

    // 套餐
    _packageTextField = [BNSelectedCellView blankPutInCellViewCGRectMakeX:0 andY:720 andW:SCREEN_W andH:60 andLabel1Content:@"套餐"andTextFieldPlaceHolder:@"请输入套餐" andScrollView:_scrollView];
    // 代理
    _packageTextField.delegate = self;
    // 注册通知(观察者)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldBeginAction:) name: UITextFieldTextDidBeginEditingNotification object:_packageTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldEndAction:) name: UITextFieldTextDidEndEditingNotification object:_packageTextField];
    
    // 到期时间
    _deadlineTextField = [BNSelectedCellView putInCellViewCGRectMakeX:0 andY:780 andW:SCREEN_W andH:60 andLabel1Content:@"到期时间"andTextFieldPlaceHolder:@"--请选择截止时间--" andScrollView:_scrollView];
    // 代理
    _deadlineTextField.delegate = self;
    // 注册通知(观察者)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldBeginAction:) name: UITextFieldTextDidBeginEditingNotification object:_deadlineTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFieldEndAction:) name: UITextFieldTextDidEndEditingNotification object:_deadlineTextField];
    
    // 是否他往占我网
    UISwitch *swith = [[UISwitch alloc] initWithFrame:CGRectMake(60, 850, 20, 10)];
    [swith addTarget:self action:@selector(occupySwithAction:) forControlEvents:UIControlEventValueChanged];
    // 给默认值"0"代表关闭
    self.isOccupy = @"0";
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 850, 100, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"是否他网占我网";
    [_scrollView addSubview:label];
    [_scrollView addSubview:swith];
    
    // 备注
    _remarkTextView = [[UITextView alloc]initWithFrame:CGRectMake(60, 890, 200, 80)];
    _remarkTextView.backgroundColor = [UIColor clearColor];
    _remarkTextView.delegate = self;
    _remarkTextView.layer.borderWidth = 2.0f;
    _remarkTextView.layer.cornerRadius = 5;
    _remarkTextView.layer.borderColor = [UIColor darkGrayColor].CGColor;
     [_scrollView addSubview:_remarkTextView];
    
    UILabel *leftLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 915, 15, 10)];
    leftLabel1.font = [UIFont systemFontOfSize:13];
    leftLabel1.text = @"备";
    [_scrollView addSubview:leftLabel1];
    
    UILabel *leftLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 945, 15, 10)];
    leftLabel2.font = [UIFont systemFontOfSize:13];
    leftLabel2.text = @"注";
    [_scrollView addSubview:leftLabel2];
    // 注册通知(观察者)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewBeginAction:) name: UITextViewTextDidBeginEditingNotification object:_remarkTextView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEndAction:) name: UITextViewTextDidEndEditingNotification object:_remarkTextView];
    
    // 取消保存Button
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 1000, 70, 30)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundColor:RGB(255, 146, 50)];
    [_scrollView addSubview:cancelButton];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(180, 1000, 70, 30)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
     [saveButton setBackgroundColor:RGB(255, 146, 50)];
 
    [_scrollView addSubview:saveButton];
    // Label 添加手势
    // 判断从哪跳转来的，从第二个跳转来的就不增加手势啦
    if (_all_WG_URL) {
        // 网格手势
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabTap:)];
        [_wgLabel addGestureRecognizer:tap1];
    
    }
    // 小区手势
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabTap:)];
    [_areaLabel addGestureRecognizer:tap2];
    // 楼号手势
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabTap:)];
    [_buildingNumLabel addGestureRecognizer:tap3];
    // 单元手势
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabTap:)];
    [_cellLabel addGestureRecognizer:tap4];
    // 运营商手势
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabTap:)];
    [_operatorsLabel addGestureRecognizer:tap5];
    // 产品手势
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabTap:)];
    [_productLabel addGestureRecognizer:tap6];

    [self.view addSubview:_scrollView];
    
    NSLog(@"--wgtag---%ld",(long)_wgLabel.tag);
    NSLog(@"--xqtag---%ld",(long)_areaLabel.tag);
    NSLog(@"--lhtag---%ld",(long)_buildingNumLabel.tag);
    
}
#pragma mark -- 监测Swith状态
- (void)occupySwithAction:(UISwitch *)sender{
    if (sender.isOn) {
        self.isOccupy = [NSString stringWithFormat:@"%d",1];
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss SS"];
       // NSString *dateString = [dateFormatter stringFromDate:currentDate];
        self.occupyTime = [dateFormatter stringFromDate:currentDate];
    } else {
        self.isOccupy = [NSString stringWithFormat:@"%d",0];
        
    }

}
#pragma mark -- 添加Button事件
- (void)addAreaBtnAction {
    BNAddCommunityController *addCommunity = [BNAddCommunityController new];
    addCommunity.WG_ID = self.wg_id;
    [self.navigationController pushViewController:addCommunity animated:YES];

}

- (void)addBuildingBtnAction {
    BNAddBuildingViewController *addBuildingVC = [BNAddBuildingViewController new];
    if (_area_id) {
         addBuildingVC.REGIO_ID = self.area_id;
        [self.navigationController pushViewController:addBuildingVC animated:YES];
    }else {
        // 请先添加小区
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先添加小区!";
        [hud hide: YES afterDelay: 2];
    }
   
    
}

- (void)cancelButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma -- 监听TextField

// 输入框退键盘（textField）
- (void)customTextFieldBeginAction:(NSNotification*)didbegin {
    [self cancelBtn];
    int offset = self.view.frame.origin.y - 216.0;//iPhone键盘高
    WS
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.view.transform = CGAffineTransformMakeTranslation(0, offset);
    }];
    UITextField *textField = didbegin.object;
    textField.layer.borderWidth = 2.0f;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = RGB(255, 146, 50).CGColor;
    
}

- (void)customTextFieldEndAction:(NSNotification*)notifiction {
    UITextField *textField = notifiction.object;
    [textField endEditing:YES];
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    WS
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.view.transform = CGAffineTransformIdentity;
    }];
}

// 备注退键盘（TextView）
- (void)textViewBeginAction:(NSNotification*)didbegin {
   // [self cancelBtn];
    int offset = self.view.frame.origin.y - 216.0;//iPhone键盘高
    WS
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.view.transform = CGAffineTransformMakeTranslation(0, offset);
    }];
    UITextView *textView = didbegin.object;
    textView.layer.borderWidth = 2.0f;
    textView.layer.cornerRadius = 5;
    textView.layer.borderColor = RGB(255, 146, 50).CGColor;
    
}
- (void)textViewEndAction:(NSNotification*)notifiction {
    UITextView *textView = notifiction.object;
    [textView endEditing:YES];
    textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    WS
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.view.transform = CGAffineTransformIdentity;
    }];
}

// 点击ruturn 回退键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.remarkTextView endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

// 点击其他区域退键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}

// 隐藏键盘
- (void)hideKeyboard {
    [self.roomTextField endEditing:YES];
    [self.phoneNumTextField endEditing:YES];
    [self.packageTextField endEditing:YES];
    [self.deadlineTextField endEditing:YES];
    [self.speedRateField endEditing:YES];
    [self.remarkTextView endEditing:YES];
}

#pragma -- pickView部分
- (void)titleLabTap:(UITapGestureRecognizer *)gesture{
    // 隐藏键盘
    [self hideKeyboard];
    tag = gesture.view.tag;
    NSLog(@"--tag--%ld",gesture.view.tag);
    [_pickerView reloadAllComponents];
    // 默认选中第一行
    WS
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.bgview.frame = CGRectMake(0, weakSelf.view.frame.size.height - 200, weakSelf.view.frame.size.width, 200);
    }];
    
}

- (void)sureBtn{
    WS
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgview.frame = CGRectMake(0, weakSelf.view.frame.size.height, weakSelf.view.frame.size.width, 200);
    } completion:^(BOOL finished) {
    }];
}

- (void)cancelBtn{
    WS
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgview.frame = CGRectMake(0, weakSelf.view.frame.size.height, weakSelf.view.frame.size.width, 200);
    } completion:^(BOOL finished) {
    }];
    
}


#pragma mark -- 保存，取消Button
- (void)saveButtonAction {

//    NSLog(@"----wg_id----%@",self.wg_id);
//    NSLog(@"----region_id----%@",self.region_id);
//    NSLog(@"----buildingNumLabel----%@",self.buildingNumLabel.text);
//    NSLog(@"----building_ID----%@",self.building_ID);
//    NSLog(@"----cellLabel----%@",self.cellLabel.text);
//    NSLog(@"----roomTextField----%@",self.roomTextField.text);
//    NSLog(@"----phoneNumTextField----%@",self.phoneNumTextField.text);
//    NSLog(@"----operatorsTypeStr----%@",self.operatorsTypeStr);
//    NSLog(@"----productTypeStr----%@",self.productTypeStr);
//    NSLog(@"----speedRateField----%@",self.speedRateField.text);
//    NSLog(@"----packageTextField----%@",self.packageTextField.text);
//    NSLog(@"----deadlineTextField----%@",self.deadlineTextField.text);
//    NSLog(@"----isOccupy----%@",self.isOccupy);
//    NSLog(@"----occupyTime----%@",self.occupyTime);
//    NSLog(@"---登录人----%@",[LoginModel shareLoginModel].USER_NAME);
    // 判断是否为空
    if ([self.productTypeStr isEqualToString:@"2"]&&[self.isOccupy isEqualToString:@"1"]) {
        if ([self.wg_id isEqualToString:@""]||[self.region_id isEqualToString:@""]||[self.buildingNumLabel.text isEqualToString:@""]||[self.building_ID isEqualToString:@""]||[self.cellLabel.text isEqualToString:@""]||[self.roomTextField.text isEqualToString:@""]||[self.phoneNumTextField.text isEqualToString:@""]||[self.operatorsTypeStr isEqualToString:@""]||[self.productTypeStr isEqualToString:@""]||[self.speedRateField.text isEqualToString:@""]||[self.packageTextField.text isEqualToString:@""]||[self.deadlineTextField.text isEqualToString:@""]||[self.isOccupy isEqualToString:@""]||[self.occupyTime isEqualToString:@""]||[[LoginModel shareLoginModel].USER_NAME isEqualToString:@""]) {
            // 请完善信息
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请完善信息!";
            [hud hide: YES afterDelay: 2];
            
        }else {
            // 发请求
            [self sendToServerRequest];
        }
    }else if ([self.productTypeStr isEqualToString:@"2"]){
        if ([self.wg_id isEqualToString:@""]|| [self.region_id isEqualToString:@""]||[self.buildingNumLabel.text isEqualToString:@""]||[self.building_ID isEqualToString:@""]||[self.cellLabel.text isEqualToString:@""]||[self.roomTextField.text isEqualToString:@""]||[self.phoneNumTextField.text isEqualToString:@""]||[self.operatorsTypeStr isEqualToString:@""]||[self.productTypeStr isEqualToString:@""]||[self.speedRateField.text isEqualToString:@""]||[self.packageTextField.text isEqualToString:@""]||[self.deadlineTextField.text isEqualToString:@""]||[self.isOccupy isEqualToString:@""]||[[LoginModel shareLoginModel].USER_NAME isEqualToString:@""]) {
            // 请完善信息
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请完善信息!";
            [hud hide: YES afterDelay: 2];
            
        }else {
            // 发请求
            [self sendToServerRequest];
        }
        
    }else if ([self.isOccupy isEqualToString:@"1"]){
        if ( [self.wg_id isEqualToString:@""]||[self.region_id isEqualToString:@""]||[self.buildingNumLabel.text isEqualToString:@""]||[self.building_ID isEqualToString:@""]||[self.cellLabel.text isEqualToString:@""]||[self.roomTextField.text isEqualToString:@""]||[self.phoneNumTextField.text isEqualToString:@""]||[self.operatorsTypeStr isEqualToString:@""]||[self.productTypeStr isEqualToString:@""]||[self.packageTextField.text isEqualToString:@""]||[self.deadlineTextField.text isEqualToString:@""]||[self.isOccupy isEqualToString:@""]||[self.occupyTime isEqualToString:@""]||[[LoginModel shareLoginModel].USER_NAME isEqualToString:@""]) {
            // 请完善信息
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请完善信息!";
            [hud hide: YES afterDelay: 2];
            
        }else {
            // 发请求
            [self sendToServerRequest];
        }
        
    }else {
        if ([self.wg_id isEqualToString:@""]|| [self.region_id isEqualToString:@""]||[self.buildingNumLabel.text isEqualToString:@""]||[self.building_ID isEqualToString:@""]||[self.cellLabel.text isEqualToString:@""]||[self.roomTextField.text isEqualToString:@""]||[self.phoneNumTextField.text isEqualToString:@""]||[self.operatorsTypeStr isEqualToString:@""]||[self.productTypeStr isEqualToString:@""]||[self.packageTextField.text isEqualToString:@""]||[self.deadlineTextField.text isEqualToString:@""]||[self.isOccupy isEqualToString:@""]||[[LoginModel shareLoginModel].USER_NAME isEqualToString:@""]) {
            // 请完善信息
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请完善信息!";
            [hud hide: YES afterDelay: 2];
            
        }else {
            // 发请求
            [self sendToServerRequest];
        }
    }
    
    
}


#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (tag == 40000) {
        return _wgArray.count;
    } else if (tag == 40060){
        return _areaArray.count;
    } else if (tag == 40120) {
        return _buildingNumArray.count;
    }else if (tag == 40420){
        return _unitArray.count;
    }else if (tag == 40600){
        return _operatorsArray.count;
    }else if (tag == 40660){
        return _productArray.count;

    }else {
        // 要删除的
        return 20;
    }
    

    //return _wgArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (tag == 40000) {
        
        _gridModel = _wgArray[row];
         return _gridModel.NAME;
    } else if (tag == 40060){
        _areaModel = _areaArray[row];
        return _areaModel.REDION_NAME;
    } else if (tag == 40120) {
        _buildingModel = _buildingNumArray[row];
        return _buildingModel.BUILDING_NO;
    } else if (tag == 40420){
        return [NSString stringWithFormat:@"%@单元",  _unitArray[row]];
    }else if (tag == 40600){
        return _operatorsArray[row];
    }else if (tag == 40660){
        return _productArray[row];
        
    }else {
    // 要删除的
        return _gridModel.NAME;
    }
   
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"--WG数组数量--%lu",(unsigned long)_wgArray.count);
    if (tag == 40000) {
        // 如果数组数量为0，返回，防止选择崩溃
        if (_wgArray.count == 0) {
            return;
        }else {
            _gridModel = _wgArray[row];
            self.wgLabel.text = _gridModel.NAME;
            // 发送小区请求
            self.wg_id = _gridModel.ID;
            [self getAreaRequest];
        }
        
    } else if(tag == 40060) {
        
        if (_areaArray.count == 0) {
            return;
        }else {
            _areaModel = _areaArray[row];
            self.region_id = _areaModel.REGION_ID;
            self.areaLabel.text = _areaModel.REDION_NAME;
            // 为传给添加Building的
            self.area_id = _areaModel.REGION_ID;
            [self getBuildingRequest];
        }

    } else if (tag == 40120) {
    
        if (_buildingNumArray.count == 0) {
            return;
        }else {
            _buildingModel = _buildingNumArray[row];
            self.building_no = _buildingModel.BUILDING_NO;
            self.building_type = _buildingModel.BUILDING_TYPE;
            self.buildingNumLabel.text = _buildingModel.BUILDING_NO;
            self.building_ID = _buildingModel.BUILDING_ID;
             [self getUnitRequest];
        }

    }else if (tag == 40420){
        if (_unitArray.count == 0) {
            return;
        } else {
            // 记录选取的单元号
            self.unit_no = _unitArray[row];
            self.cellLabel.text = [NSString stringWithFormat:@"%@单元",  _unitArray[row]] ;
        
        }
        
    } else if (tag == 40600){
        if (_operatorsArray.count == 0) {
            return;
        } else {
            self.operatorsLabel.text = _operatorsArray[row];
            if ([self.operatorsLabel.text isEqualToString:@"电信"]) {
                _operatorsTypeStr = @"1";
            }else if ([self.operatorsLabel.text isEqualToString:@"移动"]){
                _operatorsTypeStr = @"2";
            }else if ([self.operatorsLabel.text isEqualToString:@"联通"]){
                _operatorsTypeStr = @"3";
            }else if ([self.operatorsLabel.text isEqualToString:@"广电"]){
                _operatorsTypeStr = @"4";
            }else {
                _operatorsTypeStr = @"5";
            }

        }
    }else if (tag == 40660){
        if (_productArray.count == 0) {
            return;
        } else {
            self.productLabel.text = _productArray[row];
            if ([self.productLabel.text isEqualToString:@"固话"]) {
                _productTypeStr = @"1";
                [_speedLabel setHidden:YES];
                [_speedRateField setHidden:YES];
            }else if ([self.productLabel.text isEqualToString:@"宽带"]){
                _productTypeStr = @"2";
                // 隐藏的速率显示
                [_speedLabel setHidden:NO];
                [_speedRateField setHidden:NO];
            }else if ([self.productLabel.text isEqualToString:@"手机"]){
                _productTypeStr = @"3";
                [_speedLabel setHidden:YES];
                [_speedRateField setHidden:YES];
            }else {
                _productTypeStr = @"4";
                [_speedLabel setHidden:YES];
                [_speedRateField setHidden:YES];
            }
            
        }

    }
   
    //[self selectedDate];
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

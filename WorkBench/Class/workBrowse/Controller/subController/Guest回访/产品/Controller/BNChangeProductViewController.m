//
//  BNAddAndChangeBaseViewController.m
//  WorkBench
//
//  Created by wouenlone on 16/8/18.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "LoginModel.h"
#import "BNChangeProductViewController.h"
#import "BNApartmentTableViewHeaderView.h"
#import "Tools.h"
#import <AFNetWorking.h>
#import "LoginModel.h"
#import "MBProgressHUD+Extend.h"

@interface BNChangeProductViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containInputField;
@property (weak, nonatomic) IBOutlet UITextField *userNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *operatorLabel;
@property (weak, nonatomic) IBOutlet UITextField *productLabel;
@property (weak, nonatomic) IBOutlet UITextField *combinationProductLabel;
@property (weak, nonatomic) IBOutlet UITextField *deadTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UISwitch *otherNetSwitch;
@property (weak, nonatomic) IBOutlet UITextField *speedLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *operatorPickView;
@property (weak, nonatomic) IBOutlet UIPickerView *productPickerView;

@property (nonatomic,strong) NSArray *operatorNameArray;
@property (nonatomic,strong) NSArray *productNameArray;

@property (nonatomic,strong) NSString *product_id;



@end

@implementation BNChangeProductViewController : UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改产品信息";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.operatorLabel.delegate = self;
    self.productLabel.delegate = self;
    self.userNumLabel.delegate = self;
    self.speedLabel.delegate = self;
    self.combinationProductLabel.delegate = self;
    self.deadTimeLabel.delegate = self;
    self.noteTextView.delegate = self;
    
    
    
    self.operatorPickView.dataSource = self;
    self.operatorPickView.delegate = self;
    self.productPickerView.dataSource = self;
    self.productPickerView.delegate = self;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.operatorLabel.delegate = nil;
    self.productLabel.delegate = nil;
    self.userNumLabel.delegate = nil;
    self.speedLabel.delegate = nil;
    self.combinationProductLabel.delegate = nil;
    self.deadTimeLabel.delegate = nil;
    self.noteTextView.delegate = nil;
    
   
    
    self.operatorPickView.dataSource = nil;
    self.operatorPickView.delegate = nil;
    self.productPickerView.dataSource = nil;
    self.productPickerView.delegate = nil;
}
//数组懒加载
-(NSArray *)operatorNameArray
{
    if (_operatorNameArray == nil) {
        _operatorNameArray = @[@"请选择",@"电信",@"移动",@"联通",@"广电",@"未知"];
    }
    return _operatorNameArray;
}
-(NSArray *)productNameArray
{
    if (_productNameArray == nil) {
        _productNameArray = @[@"请选择",@"固话",@"宽带",@"手机",@"IPTV"];
    }
    return _productNameArray;
}
- (instancetype)initWithHouseAddress:(NSString *)address andProductId:(NSString *)productId
{
    self = [super init];
    NSLog(@"PRODUCT_ID%@,USER_NAME%@",productId,[LoginModel shareLoginModel].USER_NAME);
    self.product_id = productId;
  //将地址加到视图中 在给视图画下边框
    UIView *headerView = [BNApartmentTableViewHeaderView getApartmentTableViewHeadViewWithAddress:address];
    headerView.frame = CGRectMake(0, 0, SCREEN_W, 64);
    [self.view addSubview:[[Tools sharedGestVisitTools] marginOfViewAtBottm:headerView withColor:[UIColor orangeColor] width:1]];
    [self productInfoRequestWithURL:[self getProductInfoURLWithId:productId]];
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-pickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.operatorPickView]) {
        return self.operatorNameArray.count;
    }else if ([pickerView isEqual:self.productPickerView]){
        return self.productNameArray.count;
    }
    return 0;

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.operatorPickView]) {
        return self.operatorNameArray[row];
    }else if ([pickerView isEqual:self.productPickerView]){
        return self.productNameArray[row];
    }
    return nil;
}
#pragma mark-pickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.operatorPickView] && row != 0) {
        self.operatorLabel.text = self.operatorNameArray[row];
    }else if ([pickerView isEqual:self.productPickerView]&& row != 0){
        self.productLabel.text = self.productNameArray[row];
        if (![self.productLabel.text isEqualToString:@"宽带"]) {
            self.speedLabel.text = nil;
        }
    }
}
#pragma mark-textViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    WS;
    self.operatorPickView.hidden = YES;
    self.productPickerView.hidden = YES;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.view.transform = CGAffineTransformMakeTranslation(0, -60);
    } completion:nil];
    [textView becomeFirstResponder];
}
- (void)viewRecover
{
    WS;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
}
#pragma mark-textField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.speedLabel] && ![self.productLabel.text isEqualToString:@"宽带"]) {
        return NO;
    }else if ([textField isEqual:self.operatorLabel] || [textField isEqual:self.productLabel])
    {
        if ([textField isEqual:self.operatorLabel]  ) {
            self.productPickerView.hidden = YES;
            self.operatorPickView.hidden = NO;
        }else{
            self.operatorPickView.hidden = YES;
            self.productPickerView.hidden = NO;
        }
        return NO;
    }
    
    return YES;
}
//收起键盘
- (IBAction) textFieldDoneEditing:(id)sender
{
   [sender resignFirstResponder];
    self.operatorPickView.hidden = YES;
    self.productPickerView.hidden = YES;
    
}
- (IBAction)backgroundTap:(id)sender
{
    [self.operatorLabel resignFirstResponder];
    [self.productLabel resignFirstResponder];
    [self.combinationProductLabel resignFirstResponder];
    [self.deadTimeLabel resignFirstResponder];
    [self.userNumLabel resignFirstResponder];
    [self.speedLabel resignFirstResponder];
    [self.noteTextView resignFirstResponder];
    self.operatorPickView.hidden = YES;
    self.productPickerView.hidden = YES;
    NSLog(@"触摸屏幕调用方法");
    if (self.view.frame.origin.y != 0) {
        [self viewRecover];
    }
}


//取消、确定 按钮触发事件
- (IBAction)clickSaveBtn:(UIButton *)sender
{
    NSLog(@"保存按钮被点击");
    sender.selected = NO;
    [self getRequest];
    
}
- (IBAction)clickCancelBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"取消按钮被点击");
}
#pragma mark 网络请求方法
- (void)getRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[self getURLForChangeInfo] parameters:[self getParam] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"网络请求发送成功");
        if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
            [MBProgressHUD showError:@"系统异常"];
        }else if ([responseObject[@"MSGCODE"] isEqualToString:@"600"]){
            [MBProgressHUD showError:@"修改数据失败"];
        }else{
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络请求失败"];
    }];
}
- (void) productInfoRequestWithURL:(NSString *)url
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
            [MBProgressHUD showError:@"系统异常"];
        }else if ([responseObject[@"MSGCODE"] isEqualToString:@"300"]){
            NSLog(@"查询具体产品详情成功%@",responseObject);
            NSArray *modelArray = [BNProductModel getProductModelFromDic:responseObject];
            BNProductModel *product = modelArray[0];
            self.operatorLabel.text = [[Tools sharedGestVisitTools] getOperatorNameByOPERATOR_TYPEinParam:product.OPERATOR_TYPE];
            self.userNumLabel.text = product.USER_NUMBER;
            self.productLabel.text = [[Tools sharedGestVisitTools] getProductNameByPRODUCT_TYPEinParam:product.PRODUCT_TYPE];
            self.combinationProductLabel.text = product.PACKAGE_MEAL;
            self.deadTimeLabel.text = product.EXPIRE;
            self.speedLabel.text = product.PRODUCT_RATE;
            self.noteTextView.text = product.note;
            if ([product.IS_OCCUPY isEqualToString:@"1"]) {
                [self.otherNetSwitch setOn:YES animated:YES];
            }else{
                [self.otherNetSwitch setOn:NO animated:YES];
            }
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"查询失败，网络错误"];
    }];
   
    
}
- (NSString *)getProductInfoURLWithId:(NSString *)product_id
{
    return [GET_A_PRODUCT stringByAppendingString:[NSString stringWithFormat:@"/%@",product_id]];
}
- (NSString *)getURLForChangeInfo
{
    
    return MODIFICATION_PRODUCT;
}
- (NSDictionary *)getParam
{
    /*
     参数解释：参数是个Map集合，集合名称是：Param，key值分别为：USER_NUMBER --> 用户号码，
     OPERATOR_TYPE --> 运营商（电信：1，移动：2，联通：3，广电：4,未知：5）                                                                       PRODUCT_TYPE --> 产品类别（固话：1，宽带：2，手机：3，IPTV：4）                                                                     PRODUCT_RATE --> 速率，
     PACKAGE_MEAL --> 套餐，
     EXPIRE --> 到期时间，
     REMARKS --> 备注，
     IS_OCCUPY --> 是否他网占我网（无占用：0，占用：1），
     FIND_TIME --> 发现占用时间，
     FIND_PERSON --> 发现人，
     PRODUCT_ID --> 用户产品信息编码（唯一标识，非空）
     
     **/
//    NSString *nul = @"";
//    NSRange range = {4,1};
//    NSRange rangeB = {6,1};
//    NSString *deadTime = [self.deadTimeLabel.text stringByReplacingCharactersInRange:range withString:nul];
//    deadTime = [deadTime stringByReplacingCharactersInRange:rangeB withString:nul];
    NSDictionary *Param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.userNumLabel.text],@"USER_NUMBER",[[Tools sharedGestVisitTools] getOPERATOR_TYPEinParamByOperatorName:self.operatorLabel.text],@"OPERATOR_TYPE",[[Tools sharedGestVisitTools] getPRODUCT_TYPEinParamByProductName:self.productLabel.text],@"PRODUCT_TYPE",self.speedLabel.text,@"PRODUCT_RATE",self.combinationProductLabel.text ,@"PACKAGE_MEAL",self.deadTimeLabel.text,@"EXPIRE",self.noteTextView.text,@"REMARKS",[self getParamFromSwitch],@"IS_OCCUPY",[self getFindTimeInParam],@"FIND_TIME",[self getFindPersonInParam],@"FIND_PERSON",self.product_id,@"PRODUCT_ID",[LoginModel shareLoginModel].USER_NAME,@"MODIFIED_BY",nil];
//    NSDictionary *params = @{@" USER_NUMBER":self.userNumLabel.text,@"OPERATOR_TYPE":[[Tools sharedGestVisitTools] getOPERATOR_TYPEinParamByOperatorName:self.operatorLabel.text],@"PRODUCT_TYPE":[[Tools sharedGestVisitTools] getPRODUCT_TYPEinParamByProductName:self.productLabel.text],@"PRODUCT_RATE":self.speedLabel.text,@"PACKAGE_MEAL":self.combinationProductLabel.text,@"EXPIRE":self.deadTimeLabel.text,@"REMARKS":self.noteTextView.text,@"IS_OCCUPY":[self getFindPersonInParam],@"FIND_TIME":[self getFindTimeInParam],@"FIND_PERSON":[self getFindPersonInParam],@"PRODUCT_ID":self.product_id,@"MODIFIED_BY":[LoginModel shareLoginModel].USER_NAME};
   
    
  
    NSLog(@"---++++++套餐：%@",self.combinationProductLabel.text);
    NSLog(@"---------PARAM-----------保存修改的参数%@",Param);
    
    return Param;
}
- (NSString *)getParamFromSwitch
{
    if (self.otherNetSwitch.isOn) {
        return [NSString stringWithFormat:@"%d",1];
    }
    return [NSString stringWithFormat:@"%d",0];
}
- (NSString *)getFindTimeInParam
{
    if (self.otherNetSwitch.isOn) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyyMMdd hh:mm:ss";
        NSString *time = [dateFormatter stringFromDate:date];
        NSLog(@"发现时间%@",time);
        
        return time;
    }
    
    return @"";
}
- (NSString *)getFindPersonInParam
{
    if (self.otherNetSwitch.isOn) {
        NSLog(@"%@",[LoginModel  shareLoginModel].USER_NAME);
        return  [LoginModel  shareLoginModel].USER_NAME ;
    }
    return @"";
}

-(void)dealloc
{
    NSLog(@"界面释放");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

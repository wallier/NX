//
//  BNAddAndChangeBaseViewController.m
//  WorkBench
//
//  Created by wouenlone on 16/8/18.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "MBProgressHUD+Extend.h"
#import "BNAddProductViewController.h"
#import "BNApartmentTableViewHeaderView.h"
#import "Tools.h"
#import "BNAddProductBtnView.h"
#import "AFNetWorking.h"
#import "BNWaterMark.h"

@interface BNAddProductViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *operatorLabel;
@property (weak, nonatomic) IBOutlet UITextField *productLabel;
@property (weak, nonatomic) IBOutlet UITextField *combinationProductLabel;
@property (weak, nonatomic) IBOutlet UITextField *deadTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UISwitch *otherNetSwitch;
@property (weak, nonatomic) IBOutlet UITextField *speedLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIView *labelAreaView;

@property (weak, nonatomic) IBOutlet UIPickerView *operatorPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *productNamePickView;

@property (nonatomic,strong) NSArray *operatorNameArray;
@property (nonatomic,strong) NSArray *productNameArray;

@property (nonatomic,assign) int hadAddProductAmount;
@property (weak, nonatomic) IBOutlet UIView *saveAndCancelBtnView;


@end

@implementation BNAddProductViewController : UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //保存 取消按钮 圆角
    self.saveButton.layer.cornerRadius = 4;
    self.cancelButton.layer.cornerRadius = 4;
    
    self.title = @"添加产品";
    // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    //等待传入以添加的产品的个数
    self.hadAddProductAmount +=1;
    BNAddProductBtnView *btnView = [[BNAddProductBtnView alloc]initWithProductAmount:self.hadAddProductAmount-1];
    btnView.frame = CGRectMake(0, 307.5, SCREEN_W, 67);
    
    //加底部边线
    [self.view addSubview:[[Tools sharedGestVisitTools] marginOfViewAtBottm:btnView withColor:[UIColor orangeColor] width:1]];

 
   
   // [self loadTextFieldWithCustomeHeight];
    
    // Do any additional setup after loading the view from its nib.
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
    
    
    self.operatorPickerView.delegate = self;
    self.operatorPickerView.dataSource = self;
    self.productNamePickView.delegate = self;
    self.productNamePickView.dataSource = self;

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
    
    self.operatorPickerView.delegate = nil;
    self.operatorPickerView.dataSource = nil;
    self.productNamePickView.delegate = nil;
    self.productNamePickView.dataSource = nil;
}
- (instancetype)initWithHouseAddress:(NSString *)address
{

    self = [super init];
  
    [self.view addSubview:[[Tools sharedGestVisitTools] marginOfViewAtBottm:[BNApartmentTableViewHeaderView getApartmentTableViewHeadViewWithAddress:address] withColor:[UIColor orangeColor] width:1]];
    
    return self;
}
- (NSArray *)operatorNameArray
{
    if (_operatorNameArray == nil) {
        _operatorNameArray = @[@"请选择",@"电信",@"移动",@"联通",@"广电",@"未知"];
    }
    return _operatorNameArray;
}
- (NSArray *)productNameArray
{
    if (_productNameArray == nil) {
        _productNameArray = @[@"请选择",@"固话",@"宽带",@"手机",@"IPTV"];
    }
    return _productNameArray;
}
- (void)clearTextFieldInThisView
{
    self.userNumLabel.text = nil;
    self.operatorLabel.text = nil;
    self.productLabel.text = nil;
    self.speedLabel.text = nil;
    self.combinationProductLabel.text = nil;
    self.deadTimeLabel.text = nil;
    self.noteTextView.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//触发添加产品按钮
- (IBAction)addProduct:(UIButton *)sender
{
    if (self.userNumLabel.text.length == 0 || self.operatorLabel.text.length == 0 || self.productLabel.text.length == 0||self.combinationProductLabel.text.length == 0||self.deadTimeLabel.text.length == 0) {
        [MBProgressHUD showError:@"信息不完善或有误"];
        return;
    }else if ([self.productLabel.text isEqualToString:@"宽带"] && self.speedLabel.text.length==0){
        [MBProgressHUD showError:@"信息不完善或有误"];
        return;
    }
    NSRange range = {4,1};
    NSRange rangeB = {7,1};
    NSString *str = self.deadTimeLabel.text;
    if ([[str substringWithRange:range] isEqualToString:@"-"] &&[[str substringWithRange:rangeB] isEqualToString:@"-"] ) {
        
        sender.enabled = NO;
        [self getRequest];
    }else{
       [MBProgressHUD showError:@"到期时间格式有误"];
        return;
    }
    
}
//完成按钮触发
- (IBAction)DoneBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//取消按钮触发
- (IBAction)cancelBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//收起键盘
- (IBAction) textFieldDoneEditing:(id)sender
{
   [sender resignFirstResponder];
    
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
    self.operatorPickerView.hidden = YES;
    self.productNamePickView.hidden = YES;
    if (self.view.frame.origin.y !=0) {
        [self viewRecover];
    }

    
    NSLog(@"触摸屏幕调用方法");
}
#pragma mark-textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    WS;
    self.operatorPickerView.hidden = YES;
    self.productNamePickView.hidden = YES;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.view.transform = CGAffineTransformMakeTranslation(0, -60);
    } completion:nil];
    [textView becomeFirstResponder];
}
- (void)viewRecover
{
        WS;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.view.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
}
#pragma mark-textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ( [textField isEqual:self.speedLabel]) {
        if ([self.productLabel.text isEqualToString:@"宽带"]) {
            return YES;
        }
        return NO;
    }else if ([textField isEqual:self.operatorLabel] || [textField isEqual:self.productLabel])
    {
        if ([textField isEqual:self.operatorLabel]  ) {
            self.productNamePickView.hidden = YES;
            self.operatorPickerView.hidden = NO;
        }else{
            self.operatorPickerView.hidden = YES;
            self.productNamePickView.hidden = NO;
        }
        return NO;
    }
    return YES;
}
#pragma mark-pickViewDataSource
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([pickerView isEqual: self.productNamePickView]) {
        return self.productLabel.frame.size.width;
    }
    return self.operatorLabel.frame.size.width;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.operatorPickerView]) {
        return self.operatorNameArray.count;
    }else if ([pickerView isEqual:self.productNamePickView]){
        return self.productNameArray.count;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.operatorPickerView]) {
        return self.operatorNameArray[row];
    }else{
        return self.productNameArray[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.operatorPickerView] && row != 0) {
        self.operatorLabel.text = self.operatorNameArray[row];
    }else if ([pickerView isEqual:self.productNamePickView]&& row != 0){
        self.productLabel.text = self.productNameArray[row];
        if (![self.productLabel.text isEqualToString:@"宽带"]) {
            self.speedLabel.text = nil;
        }
    }
   
}
#define mark - 网络请求方法
- (void) getRequest
{
    WS;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[self getURL] parameters:[self getParam] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
            [MBProgressHUD showError:@"系统异常"];
        }else if ([responseObject[@"MSGCODE"] isEqualToString:@"600"]){
            [MBProgressHUD showError:@"添加失败"];
        }else{
         [MBProgressHUD showSuccess:@"添加成功"];
            /**
             1.清空页面所有数据
             2.给已添加产品的个数加1
             */
                [weakSelf clearTextFieldInThisView];
                [weakSelf viewDidLoad];
            
        }
        weakSelf.saveButton.enabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络请求失败"];
        weakSelf.saveButton.enabled = YES;
    }];
   
    
}
- (NSString *) getURL
{
    return ADDPRODUCT;
}
- (NSDictionary *)getParam
{
    /**
     *参数：Param:{"BUILDING_ID":value,"UNIT_NO":value,"ROOT_NO":value,"USER_NUMBER":value,"OPERATOR_TYPE":value,
     "PRODUCT_TYPE":value,"PRODUCT_RATE":value,"PACKAGE_MEAL":value,"EXPIRE":value,"REMARKS":value,
     "IS_OCCUPY":value,"FIND_TIME":value,"FIND_PERSON":value}
     
     参数解释：参数是个Map集合，集合名称是：Param，key值分别为：BUILDING_ID --> 小区楼唯一标识，
     UNIT_NO --> 用户所属单元编号，
     ROOT_NO --> 用户门牌号，
     USER_NUMBER --> 用户号码，
     OPERATOR_TYPE --> 运营商（电信：1，移动：2，联通：3，未知：4），                                                                       PRODUCT_TYPE --> 产品类别（固话：1，宽带：2，手机：3，IPTV：4），                                                                      PRODUCT_RATE --> 速率，
     PACKAGE_MEAL --> 套餐，
     EXPIRE --> 到期时间，
     REMARKS --> 备注，
     IS_OCCUPY --> 是否他网占我网（无占用：0，占用：1），
     FIND_TIME --> 发现占用时间，
     FIND_PERSON --> 发现人
     */
    
    NSDictionary *dic = @{@"BUILDING_ID":self.BUILDING_ID,@"UNIT_NO":self.UNIT_NO,@"ROOT_NO":self.ROOT_NO,@"USER_NUMBER":self.userNumLabel.text,@"OPERATOR_TYPE":[[Tools sharedGestVisitTools] getOPERATOR_TYPEinParamByOperatorName:self.operatorLabel.text],@"PRODUCT_TYPE":[[Tools sharedGestVisitTools] getPRODUCT_TYPEinParamByProductName:self.productLabel.text],@"PRODUCT_RATE":self.speedLabel.text,@"PACKAGE_MEAL":self.combinationProductLabel.text,@"EXPIRE":self.deadTimeLabel.text,@"REMARKS":self.noteTextView.text,@"MODIFIED_BY":[LoginModel shareLoginModel].USER_NAME,@"IS_OCCUPY":[self getSwitchValue],@"FIND_TIME":[self getFindTimeInParam],@"FIND_PERSON":[self getFindPersonInParam]};
    NSLog(@"添加产品界面网络请求参数%@",dic);
    return dic;
}
- (NSString *)getSwitchValue
{
    if (self.otherNetSwitch.isOn) {
        return @"1";
    }
    return @"0";
}

- (NSString *)getFindTimeInParam
{
    if (self.otherNetSwitch.isOn) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyyMMdd hh:mm:ss";
        NSString *time = [dateFormatter stringFromDate:date];
        NSLog(@"含有中文的时间需要解码吗？%@",time);
        
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
/*#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

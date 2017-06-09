//
//  BNAddBuildingViewController.m
//  WorkBench
//
//  Created by wouenlone on 16/8/16.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNAddBuildingViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+Extend.h"
#import "LoginModel.h"
#import "BNWaterMark.h"

@interface BNAddBuildingViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *buildingNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *elementNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *floorAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyAmountInAFloorTextField;
@property (weak, nonatomic) IBOutlet UITextField *portAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *usedPortAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *buildingTypeTextField;


@end

@implementation BNAddBuildingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    self.title = @"增加楼";
    
   
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.buildingNumTextField.delegate = self;
    self.elementNumTextField.delegate = self;
    self.floorAmountTextField.delegate = self;
    self.familyAmountInAFloorTextField.delegate = self;
    self.portAmountTextField.delegate = self;
    self.usedPortAmountTextField.delegate = self;
    self.buildingTypeTextField.delegate = self;

}
- (void)viewWillDisappear:(BOOL)animated
{
    self.buildingNumTextField.delegate = nil;
    self.elementNumTextField.delegate = nil;
    self.floorAmountTextField.delegate = nil;
    self.familyAmountInAFloorTextField.delegate = nil;
    self.portAmountTextField.delegate = nil;
    self.usedPortAmountTextField.delegate = nil;
    self.buildingTypeTextField.delegate = nil;
}
- (IBAction)commitBtn:(UIButton *)sender
{
    if (![self meetTheNeedOfAddBuilding]) {
        //不满足添加需求 提示
        [MBProgressHUD showError:@"信息不完善或有误"];
        return;
    }
    NSLog(@"%@",self.portAmountTextField.text);
    sender.selected = NO;
    NSMutableDictionary *Param = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.REGIO_ID,@"REGION_ID",[NSString stringWithFormat:@"%@号楼",self.buildingNumTextField.text],@"BUILDING_NO",self.elementNumTextField.text,@"UNIT_NUM",self.floorAmountTextField.text,@"FLOOR_NUM",self.familyAmountInAFloorTextField.text,@"ONE_FLOOR_HOUSES",self.portAmountTextField.text,@"PORT_ALL_NUM",self.usedPortAmountTextField.text,@"PORT_OCCUPY_NUM", self.buildingTypeTextField.text,@"BUILDING_TYPE",[LoginModel shareLoginModel].USER_NAME,@"MODIFIED_BY",nil];
    
    WS;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:ADD_BUILDING parameters:Param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSString *str = responseObject[@"MSGCODE"];
            if ([str isEqualToString:@"000"]) {
                [MBProgressHUD showError:@"系统异常"];
                
            }else if ([str isEqualToString:@"600"]){
                [MBProgressHUD showError:@"添加失败"];
               
            }else{
                [MBProgressHUD showSuccess:@"添加成功"];
    
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"添加住宅楼失败%@",error);
            [MBProgressHUD showError:@"添加失败 网络故障"];
        }];
    
    sender.selected = YES;
}

//收起键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self rootViewFrameRecover];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self rootViewFrameRecover];
    
   return  [textField resignFirstResponder];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.frame.origin.y+textField.frame.size.height>self.view.frame.size.height-258) {//此处258为键盘最高高度
        //view 上移
        WS;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
          weakSelf.view.transform = CGAffineTransformMakeTranslation(0, -100);//100为预估键盘遮盖最下部textField的高度
        } completion:nil];
    }
}
//view视图恢复
- (void)rootViewFrameRecover
{
   if (self.view.frame.origin.y!=0) {
        WS;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.view.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
   }
}

//判断填入的信息是否完整 正确
- (BOOL)meetTheNeedOfAddBuilding
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *port =[numberFormatter numberFromString:self.portAmountTextField.text];
    NSNumber *usedport =[numberFormatter numberFromString:self.usedPortAmountTextField.text];
    if (self.buildingNumTextField.text.length==0||self.elementNumTextField.text.length==0||self.floorAmountTextField.text.length==0||self.familyAmountInAFloorTextField.text.length==0||self.portAmountTextField.text.length==0||self.usedPortAmountTextField.text.length==0||usedport>port||!([self.buildingTypeTextField.text isEqualToString:@"住宅"]||[self.buildingTypeTextField.text isEqualToString:@"公寓"]||[self.buildingTypeTextField.text isEqualToString:@"商业"]||[self.buildingTypeTextField.text isEqualToString:@"其他"])) {
        
        return NO;
    }
    
    return YES;
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

//
//  BNTSettingController.m
//  WorkBench
//
//  Created by mac on 16/2/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNTSettingController.h"
#import "BNBaseSetCellModel.h"
#import "BNSetTableViewCell.h"
#import "LoginViewController.h"
#import "KeychainItemWrapper.h"
#import <AFNetworking.h>
#import "BNWaterMark.h"

typedef void(^getResult) (NSString *);
@interface BNTSettingController ()<UIAlertViewDelegate>
@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, strong) NSMutableArray *arrModel;
@property (nonatomic, strong) NSMutableDictionary *dics;
@property (nonatomic, strong) getResult getresult;

@end

@implementation BNTSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    [self setDics];
    [self addmodel];
   
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.tableFooterView = view;
    
}

- (void)addmodel{
    
    WS;
    BNBaseSetCellModel *changeGesture = [[BNBaseSetCellModel alloc] initwithTitle:@"修改手势密码" Image:@"small_my_income" andTypt:0];

    changeGesture.function = ^(void){
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改手势密码需要重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [aler show];
    };
    
//    BNBaseSetCellModel *pushSet = [[BNBaseSetCellModel alloc] initwithTitle:@"推送设置" Image:@"small_my_bang" andTypt:1];
//    pushSet.function = ^(void){
//        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"模块开发中..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [aler show];
//    };
    
    BNBaseSetCellModel *terminer = [[BNBaseSetCellModel alloc] initwithTitle:@"终端绑定" Image:@"small_my_bang" andTypt:0];
    terminer.function = ^(void){
        [self requestWithurl:FindImeiByLoginId andParametes:_dics];
        self.getresult= ^(NSString *flag){
            if ([flag isEqualToString:@"0"]) {
                KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MPUUID" accessGroup:nil];
                weakSelf.uuid =[keyChain objectForKey:(__bridge NSString *)(kSecValueData)];
                NSString *msg = [NSString stringWithFormat:@"绑定手机IMIE:%@",weakSelf.uuid];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alert.delegate = weakSelf;
                alert.tag = 4000;
                [alert show];
            }else if([flag isEqualToString:@"1"]){
                [weakSelf.view makeToast:@"该终端已经绑定" duration:0.5 position:@"center"];
            }else if ([flag isEqualToString:@"300"]){
                [weakSelf.view makeToast:@"绑定成功" duration:0.5 position:@"center"];
            }
        };
        
    };
    
    [self.arrModel addObject:changeGesture];
 //   [self.arrModel addObject:pushSet];
    [self.arrModel addObject:terminer];
}

- (void)setDics{
    NSString *loginid = [LoginModel shareLoginModel].USER_ID;
    NSString *Sex = [LoginModel shareLoginModel].GENDER;
    NSString *userName = [LoginModel shareLoginModel].USER_NAME;
    NSString *userId = [LoginModel shareLoginModel].USER_ID;
    _dics = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dics setValue:loginid forKey:@"loginId"];
    [_dics setValue:Sex forKey:@"sex"];
    [_dics setValue:userName forKey:@"userName"];
    [_dics setValue:userId forKey:@"userId"];
    
}


-(void)requestWithurl:(NSString *)url andParametes:(NSDictionary*)paramets{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer.timeoutInterval = 20000.f;
    [manager POST:url parameters:paramets success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (self.getresult) {
            self.getresult([responseObject valueForKey:@"MSGCODE"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (NSMutableArray *)arrModel{
    if (!_arrModel) {
        _arrModel = [NSMutableArray array];
    }
    return _arrModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.arrModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNSetTableViewCell *cell = [BNSetTableViewCell initWithTableView:tableView
                                                       andIdentifier:@"cellId"];
    cell.model = self.arrModel[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BNBaseSetCellModel *model = self.arrModel[indexPath.row];
    if (model.function) {
        model.function();
    } else {
        
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag != 4000) {
        if (buttonIndex == 0) {
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
            KeychainItemWrapper *keychin2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"LOGIN_USER" accessGroup:nil];
            [keychin resetKeychainItem];
            [keychin2 resetKeychainItem];
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginView"];
            self.view.window.rootViewController = vc;
        }
    } else {
        if (buttonIndex == 0) {
            // 终端绑定
            [_dics setValue:_uuid forKey:@"imei"];
            [self requestWithurl:UpdateImeiByLoginId andParametes:_dics];
        }
        
        
    }
}
@end

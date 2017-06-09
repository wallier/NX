//
//  LoginViewController.h
//  text_pch
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "ViewController.h"
@interface LoginViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (nonatomic, assign) BOOL flag; ///< 提示标志

- (IBAction)loginButton:(id)sender;

-(void)loginFromOther:(NSString *)userName andHud:(MBProgressHUD *)hud;
@end

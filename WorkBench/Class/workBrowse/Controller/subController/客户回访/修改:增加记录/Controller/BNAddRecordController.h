//
//  BNAddRecordController.h
//  WorkBench
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNAddRecordModel.h"
@interface BNAddRecordController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *xiaoqu;
@property (weak, nonatomic) IBOutlet UITextField *louhao;
@property (weak, nonatomic) IBOutlet UITextField *danyuan;
@property (weak, nonatomic) IBOutlet UITextField *fanghao;

@property (weak, nonatomic) IBOutlet UITextField *proOther;
@property (weak, nonatomic) IBOutlet UITextField *yewuhao;
@property (weak, nonatomic) IBOutlet UIButton *pro;
@property (weak, nonatomic) IBOutlet UIButton *yunyingshang;
@property (weak, nonatomic) IBOutlet UIButton *xieyidaoqi;
@property (weak, nonatomic) IBOutlet UITextField *zoufangResult;

@property (nonatomic, strong) BNAddRecordModel *model;
@property (nonatomic, assign) BOOL flag;

- (IBAction)Save:(id)sender;
@end

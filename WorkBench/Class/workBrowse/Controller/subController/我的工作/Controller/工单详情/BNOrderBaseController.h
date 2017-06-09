//
//  BNOrderBaseController.h
//  WorkBench
//
//  Created by mac on 16/2/2.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNOrderBaseModel.h"

@interface BNOrderBaseController : UIViewController
@property (nonatomic, strong) NSMutableDictionary *params;
@property (weak, nonatomic) IBOutlet UITextView *introduce;
@property (weak, nonatomic) IBOutlet UIButton *msg;
@property (weak, nonatomic) IBOutlet UIButton *tele;
@property (nonatomic, strong) BNOrderBaseModel *model;
@property (weak, nonatomic) IBOutlet UILabel *accr;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userHy;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *statrTime;
@property (weak, nonatomic) IBOutlet UILabel *userDevice;
@property (nonatomic, strong) NSString *navTitle;

@end

//
//  BNLDViewController.h
//  WorkBench
//
//  Created by mac on 16/2/3.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNLDModel.h"

@interface BNLDViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *introduce;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *kind;
@property (weak, nonatomic) IBOutlet UILabel *accr;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *device;
@property (weak, nonatomic) IBOutlet UILabel *about;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *taocan;
@property (weak, nonatomic) IBOutlet UIButton *btncommit;
@property (weak, nonatomic) IBOutlet UITextView *textRecord;
@property (nonatomic, strong) BNLDModel *model;
@property (nonatomic, strong) NSMutableDictionary *params;

@end

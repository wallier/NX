//
//  BNApartmentTableViewHeaderView.m
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNApartmentTableViewHeaderView.h"

@interface BNApartmentTableViewHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end

@implementation BNApartmentTableViewHeaderView
+ (UIView *)getApartmentTableViewHeadViewWithAddress:(NSString *)address
{
   BNApartmentTableViewHeaderView *headView= [[[NSBundle mainBundle] loadNibNamed:@"headView" owner:nil options:nil] firstObject];
    headView.addressLabel.text = address;
    headView.height = 60;
    //设置label圆角
    headView.addressLabel.layer.cornerRadius = 14;
    headView.addressLabel.layer.masksToBounds = true;
    return headView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

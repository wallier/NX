//
//  BNAddProductBtnView.m
//  WorkBench
//
//  Created by wouenlone on 16/8/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNAddProductBtnView.h"
@interface BNAddProductBtnView()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *existingProductsAmountLabel;


@end

@implementation BNAddProductBtnView
//初始化时设定frame和显示产品个数 并注册按钮触发通知
- (instancetype) initWithProductAmount:(int)productAmount
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"headView" owner:nil options:nil] lastObject];
    self.existingProductsAmountLabel.layer.cornerRadius = 15;
    self.existingProductsAmountLabel.clipsToBounds = YES;
    
    NSDictionary  *attribute= @{NSForegroundColorAttributeName:[UIColor redColor]};
    NSAttributedString *amount = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",productAmount] attributes:attribute];
    
    NSMutableAttributedString *updateString = (NSMutableAttributedString *)self.existingProductsAmountLabel.attributedText;
    NSRange r = {5,1};
    [updateString replaceCharactersInRange:r withAttributedString:amount];
    self.existingProductsAmountLabel.attributedText = updateString;
    self.addBtn.layer.cornerRadius = 3;

    
    
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

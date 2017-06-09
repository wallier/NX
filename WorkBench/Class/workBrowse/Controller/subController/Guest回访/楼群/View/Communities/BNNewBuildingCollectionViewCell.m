//
//  BNNewBuildingCollectionViewCell.m
//  WorkBench
//
//  Created by wouenlone on 16/8/15.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNNewBuildingCollectionViewCell.h"

@implementation BNNewBuildingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    if (self) {
        //初始化时加载xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BNNewBuildingCollectionViewCell" owner:self options:nil];
        //如果路径不存在return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        //加载nib
        self = [arrayOfViews objectAtIndex:0];
        
    }
    return self;
}

@end

//
//  customBtn.h
//  BIBuilderApp
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNOrdeDetailTableCell;
@interface customBtn : UIButton
@property (nonatomic,assign) BOOL states;
@property (nonatomic,weak) BNOrdeDetailTableCell *cell;
@end

//
//  customBtn.h
//  BIBuilderApp
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNMyGrabOrdeDetailTableCell;
@interface customMyBtn : UIButton
@property (nonatomic,assign) BOOL states;
@property (nonatomic,weak) BNMyGrabOrdeDetailTableCell *cell;
@end

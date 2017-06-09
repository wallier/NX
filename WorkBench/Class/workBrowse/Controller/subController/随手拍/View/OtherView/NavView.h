//
//  NavView.h
//  WorkBench
//
//  Created by mac on 15/10/23.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^backNav) (void);
@interface NavView : UIView
@property (nonatomic,copy) NSString *title;         ///< 标题
@property (nonatomic,copy) NSString *rightTitle;    ///< 右边按钮标题
@property (nonatomic,strong) UIImage *rightImage;   ///< 右边按钮图片
@property (nonatomic,copy) backNav Pop;             ///< 左边按钮点击事件
@property (nonatomic,copy) backNav rightAction;     ///< 右边按钮点击事件

- (UIButton *)rightButton;
@end

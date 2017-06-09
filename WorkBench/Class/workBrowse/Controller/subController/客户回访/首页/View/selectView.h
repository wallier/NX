//
//  selectView.h
//  BIBuilderApp
//
//  Created by mac on 15/6/16.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define color(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
typedef void(^postName)(NSString *name);
@interface selectView : UIView<UITextFieldDelegate>
@property (nonatomic,strong) UIView *view_top;
@property (nonatomic,strong) UIView *view_down;
@property (nonatomic,strong) UITextField *text;
@property (nonatomic,strong) postName post_name;
@end

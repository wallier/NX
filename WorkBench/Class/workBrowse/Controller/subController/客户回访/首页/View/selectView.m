//
//  selectView.m
//  BIBuilderApp
//
//  Created by mac on 15/6/16.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import "selectView.h"
#import <Availability.h>
@implementation selectView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self addSubview:self.view_top];
    [self addSubview:self.view_down];
    [self registerKeyboardEvent];
    [self.text becomeFirstResponder];
    return self;
    
}
- (void)keyboardWillChangeFrame:(NSNotification *)notif{
    
    float keyboardHeightBegin = 0;
    float keyboardHeithtEnd = 0;
    float animationDuartion = [[[notif userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
   // UIViewAnimationCurve animationCurve = [[[notif userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
    CGRect keyboardBeginFrame = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
        keyboardHeightBegin = [UIScreen mainScreen].bounds.size.height - keyboardBeginFrame.origin.y;
    keyboardHeithtEnd = [UIScreen mainScreen].bounds.size.height - keyboardEndFrame.origin.y;
#else
    //these deprecated after iOS 3.2
    CGRect keyboardBounds = [[[notif userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    CGPoint keybordCenterBegin = [[[notif userInfo] objectForKey:UIKeyboardCenterBeginUserInfoKey] CGPointValue];
    CGPoint keybordCenterEnd = [[[notif userInfo] objectForKey:UIKeyboardCenterEndUserInfoKey] CGPointValue];
    keyboadHeightBegin = 480 - (keybordCenterBegin.y - keyboardBounds.size.height / 2);
    keyboadHeightEnd = 480 - (keybordCenterEnd.y - keyboardBounds.size.height / 2);
#endif
    if (keyboardHeithtEnd > 0) {
        [UIView animateWithDuration:animationDuartion delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setCenter:CGPointMake(self.frame.size.width/2, self.superview.bounds.size.height-self.frame.size.height/2-keyboardHeithtEnd)];
        } completion:^(BOOL finished) {
        }];
    } else {
    }
    
}

-(void)keyboardDidChangeFrame:(NSNotification*)notif{
}
-(void)keyboardWillShow:(NSNotification*)notif{
    [UIView animateWithDuration:0.3f animations:^{
    }];
}
-(void)keyboardWillHide:(NSNotification*)notif{
    [UIView animateWithDuration:0.3f animations:^{
    }];
}
- (void)registerKeyboardEvent{
    float systemVers = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVers >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    
}

- (void)unregisterKeyboardEvent{
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

-(UIView*)view_top{
    
    _view_top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2)];
    [_view_top setBackgroundColor:color(39, 48, 63, 1)];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 5,60 , _view_top.bounds.size.height-10);
    [button addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    button.layer.cornerRadius = 4;
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setBackgroundColor:color(215, 221, 224, 1)];
    [_view_top addSubview:button];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_view_top.bounds.size.width/2-50, 5, 100, _view_top.bounds.size.height-10)];
    lab.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    lab.text = @"小区名称";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    [_view_top addSubview:lab];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(_view_top.bounds.size.width-65, 5,60 , _view_top.bounds.size.height-10);
    [button2 addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    button2.layer.cornerRadius = 4;
    [button2 setTitle:@"确定" forState:UIControlStateNormal];
    [button2 setBackgroundColor:color(247, 97, 50, 1)];
    [_view_top addSubview:button2];
    
    
    return _view_top;
}

- (void)sure{
    if (self.post_name) {
        self.post_name(self.text.text);
    }
    [self unregisterKeyboardEvent];

    [self removeFromSuperview];
}
- (void)cancle{
    [self.text resignFirstResponder];
    [self unregisterKeyboardEvent];
    [self removeFromSuperview];
}
- (UIView *)view_down{
    _view_down = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2)];
    [_view_down setBackgroundColor:[UIColor whiteColor]];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _view_down.bounds.size.width, _view_down.bounds.size.height)];
    [img setImage:[UIImage imageNamed:@"search"]];
    
    [_view_down addSubview:img];
    
    
    _text = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, _view_down.bounds.size.width-28, _view_down.frame.size.height)];
    
    _text.keyboardType = UIKeyboardTypeDefault;
    _text.delegate = self;
    [_view_down addSubview:_text];
    
    return _view_down;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        [self setCenter:CGPointMake(self.frame.size.width/2,self.superview.frame.size.height-self.frame.size.height/2)];
    } completion:^(BOOL finished) {
        
    }];
    
    [textField resignFirstResponder];
    return YES;
}


@end

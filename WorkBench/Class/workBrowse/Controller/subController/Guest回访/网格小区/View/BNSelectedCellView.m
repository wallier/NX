//
//  BNSelectedCellView.m
//  WorkBench
//
//  Created by wanwan on 16/9/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNSelectedCellView.h"
#import "BNCustomTextField.h"
#import "BNOneTimeIncreseProductViewController.h"

@interface BNSelectedCellView()


@end

@implementation BNSelectedCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/** 选择框 */
+ (UILabel *)createCellViewCGRectMakeX:(CGFloat)viewX andY:(CGFloat)viewY andW:(CGFloat)viewW andH:(CGFloat)viewH andLabel1Content:(NSString *)label1Content andScrollView:(UIScrollView *)scrollView {
    // view作为背景
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    cellView.backgroundColor = [UIColor clearColor];
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, cellView.bounds.size.width , 0.5)];
    lineview.backgroundColor = RGB(255, 146, 50);
    [cellView addSubview:lineview];
    [scrollView addSubview:cellView];
    
    // 自定义控件
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/4, 60)];
    label1.text= label1Content;
    //label1.font = [UIFont boldSystemFontOfSize:60.f];
    label1.font = [UIFont systemFontOfSize:16];
    label1.textAlignment = NSTextAlignmentCenter;
    [cellView addSubview:label1];
    if (viewY == 660) {
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/4, 15, SCREEN_W/4, 30)];
    // 设置tag
    [label2 setTag:40000+viewY ];
    label2.font = [UIFont systemFontOfSize:13];
    label2.backgroundColor = [UIColor clearColor];
    // 边框颜色
    label2.layer.borderWidth = 2.0f;
    label2.layer.cornerRadius = 5;
    label2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label2.userInteractionEnabled = YES;
//    label2.backgroundColor = [UIColor lightGrayColor];
//    label2.text= label2Content;
//    label2.font = [UIFont systemFontOfSize:16];
//    label2.textAlignment = NSTextAlignmentLeft;
    label2.textAlignment=NSTextAlignmentCenter;
    label2.adjustsFontSizeToFitWidth=YES;
   // label2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"select_bg.png"]];
    [cellView addSubview:label2];
    return label2;
    }else {
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/4, 15, SCREEN_W/2, 30)];
        // 设置tag
        [label2 setTag:40000+viewY ];
        label2.font = [UIFont systemFontOfSize:13];
        label2.backgroundColor = [UIColor clearColor];
        // 边框颜色
        label2.layer.borderWidth = 2.0f;
        label2.layer.cornerRadius = 5;
        label2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label2.userInteractionEnabled = YES;
        //    label2.backgroundColor = [UIColor lightGrayColor];
        //    label2.text= label2Content;
        //    label2.font = [UIFont systemFontOfSize:16];
        //    label2.textAlignment = NSTextAlignmentLeft;
        label2.textAlignment=NSTextAlignmentCenter;
        label2.adjustsFontSizeToFitWidth=YES;
        //label2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"select_bg.png"]];
        [cellView addSubview:label2];
    
     return label2;
    
    }
       
 
}

/** 输入框 */
+ (UITextField *)putInCellViewCGRectMakeX:(CGFloat)viewX andY:(CGFloat)viewY andW:(CGFloat)viewW andH:(CGFloat)viewH andLabel1Content:(NSString*)label1Content andTextFieldPlaceHolder:(NSString*)textFieldPlaceHolder andScrollView:(UIScrollView *)scrollView {
    // view作为背景
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    cellView.backgroundColor = [UIColor clearColor];
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, cellView.bounds.size.width , 0.5)];
    lineview.backgroundColor = RGB(255, 146, 50);
    [cellView addSubview:lineview];
    [scrollView addSubview:cellView];
    
    // 自定义控件
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/4, 60)];
    label1.text= label1Content;
    //label1.font = [UIFont boldSystemFontOfSize:60.f];
    label1.font = [UIFont systemFontOfSize:16];
    label1.textAlignment = NSTextAlignmentCenter;
    [cellView addSubview:label1];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(cellView.bounds.size.width/4, 15, cellView.bounds.size.width/2, 30)];
    // 设置tag
    [textField setTag:40000+viewY ];
    textField.placeholder = textFieldPlaceHolder;
    textField.font = [UIFont systemFontOfSize:13];
    textField.backgroundColor = [UIColor clearColor];
    // 边框颜色
    textField.layer.borderWidth = 2.0f;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // 设置textField中初始光标
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways ;
    [cellView addSubview:textField];
    
    return textField;
}
/** 下划线输入框 */
+ (UITextField *)blankPutInCellViewCGRectMakeX:(CGFloat)viewX andY:(CGFloat)viewY andW:(CGFloat)viewW andH:(CGFloat)viewH andLabel1Content:(NSString*)label1Content andTextFieldPlaceHolder:(NSString*)textFieldPlaceHolder andScrollView:(UIScrollView *)scrollView {
    // view作为背景
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    cellView.backgroundColor = [UIColor clearColor];
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, cellView.bounds.size.width , 0.5)];
    lineview.backgroundColor = RGB(255, 146, 50);
    [cellView addSubview:lineview];
    [scrollView addSubview:cellView];
    
    // 自定义控件
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/4, 60)];
    label1.text= label1Content;
    //label1.font = [UIFont boldSystemFontOfSize:60.f];
    label1.font = [UIFont systemFontOfSize:16];
    label1.textAlignment = NSTextAlignmentCenter;
    [cellView addSubview:label1];
    
    BNCustomTextField *textField = [[BNCustomTextField alloc]initWithFrame:CGRectMake(cellView.bounds.size.width/4, 10, cellView.bounds.size.width/2, 40)];
    if (![label1Content isEqualToString:@"套餐"]) {
        // 只能输数字
        textField.keyboardType=UIKeyboardTypeNumberPad;
    }

    // 设置tag
    [textField setTag:40000+viewY ];
    textField.placeholder = textFieldPlaceHolder;
    textField.font = [UIFont systemFontOfSize:13];
    textField.backgroundColor = [UIColor clearColor];
//    // 边框颜色
//    textField.layer.borderWidth = 2.0f;
//    textField.layer.cornerRadius = 5;
//    textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
//    // 注册通知观察者
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldBeginAction:) name: UITextFieldTextDidBeginEditingNotification object:textField];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEndAction:) name: UITextFieldTextDidEndEditingNotification object:textField];
//    
    // 设置textField中初始光标
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways ;
    [cellView addSubview:textField];
    
    //    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/4, 15, SCREEN_W/2, 30)];
    //    label2.text= label2Content;
    //    label2.font = [UIFont systemFontOfSize:16];
    //    label2.textAlignment = NSTextAlignmentLeft;
    //    [cellView addSubview:label2];
    
    return textField;

}

//- (void)textFieldBeginAction:(NSNotification*)didbegin {
//    UITextField *textField = didbegin.object;
//    textField.layer.borderWidth = 2.0f;
//    textField.layer.cornerRadius = 5;
//    textField.layer.borderColor = RGB(255, 146, 50).CGColor;
//    
//}
//
//- (void)textFieldEndAction:(NSNotification*)notifiction {
//    UITextField *textField = notifiction.object;
//    [textField endEditing:YES];
//}

/** 展示框 */
+ (UILabel *)showCellViewCGRectMakeX:(CGFloat)viewX andY:(CGFloat)viewY andW:(CGFloat)viewW andH:(CGFloat)viewH andLabel1Content:(NSString *)label1Content andScrollView:(UIScrollView *)scrollView {
    // view作为背景
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    cellView.backgroundColor = [UIColor clearColor];
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, cellView.bounds.size.width , 0.5)];
    lineview.backgroundColor = RGB(255, 146, 50);
    [cellView addSubview:lineview];
    [scrollView addSubview:cellView];
    
    // 自定义控件
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/4, 0, SCREEN_W/4, 60)];
    label1.text= label1Content;
    //label1.font = [UIFont boldSystemFontOfSize:60.f];
    label1.font = [UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentCenter;
    [cellView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W/2, 15, SCREEN_W/4, 30)];
    // 设置tag
    [label2 setTag:40000+viewY ];
    label2.font = [UIFont systemFontOfSize:13];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentCenter;
//    // 边框颜色
//    label2.layer.borderWidth = 2.0f;
//    label2.layer.cornerRadius = 5;
//    label2.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    label2.userInteractionEnabled = YES;
    //    label2.backgroundColor = [UIColor lightGrayColor];
    //    label2.text= label2Content;
    //    label2.font = [UIFont systemFontOfSize:16];
    //    label2.textAlignment = NSTextAlignmentLeft;
    [cellView addSubview:label2];
    //
    return label2;
    
    
}


@end

//
//  BNSelectedCellView.h
//  WorkBench
//
//  Created by wanwan on 16/9/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNSelectedCellView : UIView
/** 选择框 */
+ (UILabel *)createCellViewCGRectMakeX:(CGFloat)viewX andY:(CGFloat)viewY andW:(CGFloat)viewW andH:(CGFloat)viewH andLabel1Content:(NSString*)label1Content andScrollView:(UIScrollView *)scrollView;
/** 显示框 */
+ (UILabel *)showCellViewCGRectMakeX:(CGFloat)viewX andY:(CGFloat)viewY andW:(CGFloat)viewW andH:(CGFloat)viewH andLabel1Content:(NSString*)label1Content andScrollView:(UIScrollView *)scrollView;
/** 输入框 */
+ (UITextField *)putInCellViewCGRectMakeX:(CGFloat)viewX andY:(CGFloat)viewY andW:(CGFloat)viewW andH:(CGFloat)viewH andLabel1Content:(NSString*)label1Content andTextFieldPlaceHolder:(NSString*)textFieldPlaceHolder andScrollView:(UIScrollView *)scrollView;
/** 横线输入 */
+ (UITextField *)blankPutInCellViewCGRectMakeX:(CGFloat)viewX andY:(CGFloat)viewY andW:(CGFloat)viewW andH:(CGFloat)viewH andLabel1Content:(NSString*)label1Content andTextFieldPlaceHolder:(NSString*)textFieldPlaceHolder andScrollView:(UIScrollView *)scrollView;
@end

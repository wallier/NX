//
//  myScrollerView.h
//  text_pch
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface myScrollerView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *labscroll ;

- (void)setSegmentCount:(int) count andTitle:(NSArray *)array;
- (void)reSetting;

@end


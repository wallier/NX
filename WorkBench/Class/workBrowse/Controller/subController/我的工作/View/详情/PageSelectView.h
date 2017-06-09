//
//  PageSelectView.h
//  BIBuilderApp
//
//  Created by mac on 15/7/2.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sendCount)(int count);
@interface PageSelectView : UIView
@property(nonatomic,assign) int maxPage;
@property(nonatomic,assign) int currentPage;
@property(nonatomic,strong) UILabel *lab_text;
@property(nonatomic,strong) UIButton *btn_left;
@property(nonatomic,strong) UIButton *btn_right;
@property(nonatomic,strong) sendCount sendcont;

@end

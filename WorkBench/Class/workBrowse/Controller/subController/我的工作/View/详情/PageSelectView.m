//
//  PageSelectView.m
//  BIBuilderApp
//
//  Created by mac on 15/7/2.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import "PageSelectView.h"
@implementation PageSelectView

-(instancetype)init{
    self = [super init];
    if (self) {
        _btn_left = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_left setBackgroundImage:[UIImage imageNamed:@"pre_workorder"] forState:UIControlStateNormal];
        [_btn_left addTarget:self action:@selector(PrePage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_left];
        
        _btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_right setBackgroundImage:[UIImage imageNamed:@"next_workorder"] forState:UIControlStateNormal];
        [_btn_right addTarget:self action:@selector(NextPage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn_right];
        
        _lab_text = [[UILabel alloc] init];
        _lab_text.textAlignment = NSTextAlignmentCenter;
        _lab_text.font = [UIFont systemFontOfSize:15];
        [self addSubview:_lab_text];
    }
    
    return self;
}

- (void)PrePage{
    if (self.currentPage >1 ) {
        NSLog(@"prePage%d",_currentPage);
        _currentPage--;

    [_lab_text setText:[NSString stringWithFormat:@"第%d页 共%d页",_currentPage,_maxPage]];
        if (self.sendcont) {
            self.sendcont(_currentPage);
        }
    }
    else{
        [self makeToast:@"当前已是首页" duration:0.5 position:CSToastPositionCenter];
    }
}

-(void)setCurrentPage:(int)currentPage{
    _currentPage = currentPage;
    NSLog(@"set:%d",_currentPage);

    [_lab_text setText:[NSString stringWithFormat:@"第%d页 共%d页",_currentPage,_maxPage]];
}

-(void)setMaxPage:(int)maxPage{
    NSLog(@"setMax%d",_currentPage);

    _maxPage = maxPage;
    [_lab_text setText:[NSString stringWithFormat:@"第%d页 共%d页",_currentPage,_maxPage]];

}
- (void)NextPage{
    

    if ( _currentPage+1 <= _maxPage) {
        _currentPage ++;
        if (self.sendcont) {
            self.sendcont(_currentPage);
        }
        NSLog(@"NextPage:currentPat :%d maxPage %d",_currentPage,_maxPage);
         [_lab_text setText:[NSString stringWithFormat:@"第%d页 共%d页",_currentPage,_maxPage]];

    }else{
    [self makeToast:@"当前已是最后一页" duration:0.5 position:CSToastPositionCenter];
    }
    

}

- (void)layoutSubviews{
    [_btn_left setFrame:CGRectMake(self.width/2-80, 10, 24, 20)];
    [_btn_right setFrame:CGRectMake(self.width/2+60, 10, 24, 20)];
    [_lab_text setFrame:CGRectMake(self.width/2-56, 5, 116, 30)];
}
@end

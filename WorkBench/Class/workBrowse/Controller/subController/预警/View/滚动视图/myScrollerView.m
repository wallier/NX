//
//  myScrollerView.m
//  text_pch
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "myScrollerView.h"
#import "PickerViewDateView.h"
typedef void (^VIEWCHANGE)(int);

@interface myScrollerView()
@property (nonatomic,strong) VIEWCHANGE viewChange;
@property (nonatomic,strong) NSMutableArray *arrCenterPoint;
@property (nonatomic,strong) NSMutableArray *arrBtn;
@property (nonatomic,strong) UIButton *selectBtn ;
@end

@implementation myScrollerView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _arrCenterPoint = [NSMutableArray array];
        _arrBtn = [NSMutableArray array];
        
        __weak myScrollerView *vc = self;
        
        _viewChange = ^(int tag){
            [UIView animateWithDuration:0.3f animations:^{
                [vc btnClick:vc.arrBtn[tag]];
                [vc.labscroll setCenter:CGPointFromString(vc.arrCenterPoint[tag])];
                for (PickerViewDateView *view in [UIApplication sharedApplication].keyWindow.subviews) {
                    if ([view isKindOfClass:[PickerViewDateView class]]) {
                        [view setHidden:YES];
                    }
                }
            }];
        };
        return self;
    }
    return nil;
}

- (void)setSegmentCount:(int) count andTitle:(NSArray *)array{
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = self.frame.size.width/count;
    CGFloat H = 30;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.tag = i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:array[i] forState:UIControlStateNormal];
         X = i*W;
        [btn setFrame:CGRectMake(X, Y, W, H)];
        [self addSubview:btn];

        CGPoint centerPoint = CGPointMake(X + W / 2,  H + 1);
        [_arrCenterPoint addObject:NSStringFromCGPoint(centerPoint)];
        [_arrBtn addObject:btn];
        if (i == 0) {
            [self btnClick:btn];
            _labscroll = [[UILabel alloc] initWithFrame:CGRectMake(X, Y + H, W, 2)];
            [_labscroll setBackgroundColor:[UIColor orangeColor]];
            [self addSubview:_labscroll];

        }
    }
    [self addSubview:self.scrollView];
    
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        [_scrollView setBackgroundColor:[UIColor redColor]];
        CGFloat Y = CGRectGetMaxY(_labscroll.frame);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Y, self.frame.size.width, self.frame.size.height - Y)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_arrBtn.count *self.frame.size.width, self.frame.size.height - Y);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;

}

- (void)reSetting{
    [_labscroll setCenter:CGPointFromString(_arrCenterPoint[0])];
    [self btnClick:_arrBtn[0]];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}
#pragma mark -buttonClick

- (void)btnClick:(UIButton *)sender{
    if (_selectBtn != sender) {
        [UIView animateWithDuration:0.3f animations:^{
            [_labscroll setCenter:CGPointFromString(_arrCenterPoint[sender.tag])];
        [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_scrollView setContentOffset:CGPointMake(sender.tag * self.frame.size.width, 0)];

        }];
        
        _selectBtn = sender;
       
    }
}

#pragma mark -scrollViewDelegate

// 减少停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat endScroll = scrollView.contentOffset.x;
    int tag = endScroll/self.frame.size.width;
    if (_viewChange) {
        _viewChange(tag);
    }
}

- (void)dealloc{
    
    NSLog(@"scrollView  dealloc");
}

@end

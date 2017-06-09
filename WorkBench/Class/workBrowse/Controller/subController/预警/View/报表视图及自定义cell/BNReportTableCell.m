//
//  BNReportTableCell.m
//  WorkBench
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#define CELLWIDTH (self.frame.size.width - (self.number - 1) * 2) / self.number

#import "BNReportTableCell.h"
#import "BNReprotView.h"
@interface BNReportTableCell()
@property (nonatomic, strong) NSMutableArray *arrLab;

@end
@implementation BNReportTableCell

- (instancetype)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    return self;
}

- (void)setModel:(BNReportCellModel *)model{
    _model = model;
    
}
- (void)setNumber:(int)number{
    _number = number;
    [self setLable];
}

- (NSMutableArray *)arrLab{
    if (!_arrLab) {
        _arrLab = [NSMutableArray array];
    }
    return _arrLab;
}

- (void)setLable{
    
    if (self.arrLab.count) {
        for (int i = 0; i<self.arrLab.count; i ++) {
            UILabel *lab = self.arrLab[i];
            if (![[self.model getValues][i] length]) {
                lab.text = @" ";
            } else {
                lab.text = [self.model getValues][i];
            }
            
        }
    } else {
        for ( int i = 0 ; i < self.number; i ++) {
            
            UILabel *lab = [[UILabel alloc] init];
            lab.font = [UIFont systemFontOfSize:12];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.numberOfLines = 0;
            lab.lineBreakMode = NSLineBreakByWordWrapping;
            if (![[self.model getValues][i] length]) {
                lab.text = @" ";
            } else {
                lab.text = [self.model getValues][i];
            }
            [self.arrLab addObject:lab];
            [self.contentView addSubview:lab];
        }
    }
}
- (void)setlableColor:(UIColor *)color{
    for (int i = 0 ;i < self.contentView.subviews.count ; i++) {
        UIView *view = self.contentView.subviews[i];
        if ([view isKindOfClass:[UILabel class]]) {
            [view setBackgroundColor:color];
        }
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0 ;i < self.contentView.subviews.count ; i++) {
        UIView *view = self.contentView.subviews[i];
        if ([view isKindOfClass:[UILabel class]]) {
            [view setFrame: CGRectMake(i * CELLWIDTH + i*2, 0, CELLWIDTH, 44)];
        }
    }
}


@end

//
//  PersonView.m
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "PersonView.h"
@interface PersonView()
@property (nonatomic,assign) CGFloat Y;
@end
@implementation PersonView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    
    }
    return self;
}
-(void)setDicPerson:(id)dicPerson{
    _person = [PersonInFoModel initWithPersonInFoModel:dicPerson];
    [self setView];
}

-(void)setView{
    
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat w = self.frame.size.width-15;
    CGFloat h = 20;
    for (int i = 0; i<_person.arrItems.count; i++) {
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        lab1.text = [NSString stringWithFormat:@"%@：%@",_person.arrItems[i],_person.arrValues[i]];
        lab1.font = [UIFont systemFontOfSize:12];
        [lab1 setBackgroundColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1]];
        [self addSubview:lab1];
        y = y+h;
        _Y=y;
    }
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, _Y+20, self.frame.size.width-20, self.frame.size.height-_Y-60)];
    [self addSubview:_webView];
}

@end

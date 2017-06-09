//
//  HomePhotoView.m
//  WorkBench
//
//  Created by xiaos on 15/12/7.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "HomePhotoView.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "ResultViewModel.h"

#import "UIImageView+WebCache.h"

@interface HomePhotoView ()<MJPhotoBrowserDelegate>

@end

@implementation HomePhotoView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpSubviews];
    }
    return self;
}

/** 设置9张图片控件 */
- (void)setUpSubviews
{
    for (NSInteger i = 0; i < 9; i++)
    {
        UIImageView *imgV = [UIImageView new];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.userInteractionEnabled = YES;
        imgV.layer.cornerRadius  = 3.0f;
        imgV.clipsToBounds = YES;
        imgV.tag = i ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImageBroswer:)];
        [imgV addGestureRecognizer:tap];
        [self addSubview:imgV];
    }
}

/** 赋值的时候 生成对应数量的图片控件 */
- (void)setPic_urls:(NSArray *)pic_urls
{
    _pic_urls = pic_urls;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgV = (UIImageView *)obj;
        if (idx < pic_urls.count)
        {//显示
            [imgV sd_setImageWithURL:[NSURL URLWithString:pic_urls[idx]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
            imgV.hidden = NO;
        }
        else
        {//隐藏
            imgV.hidden = YES;
        }
    }];
    
}

- (void)openImageBroswer:(UITapGestureRecognizer *)tap
{
    UIImageView *tapView = (UIImageView *)tap.view;
    // CZPhoto -> MJPhoto
    int i = 0;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *picURLStr in self.pic_urls) {
        
        MJPhoto *p = [[MJPhoto alloc] init];
        p.url = [NSURL URLWithString:picURLStr];
        p.index = i;
        p.srcImageView = tapView;
        [arrM addObject:p];
        i++;
    }
    // 弹出图片浏览器
    // 创建浏览器对象
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    // MJPhoto
    brower.photos = arrM;
    brower.delegate = self;
    brower.currentPhotoIndex = tapView.tag;
    [brower show];
}

- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    NSLog(@"%ld",(long)index);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.pic_urls.count == 1) {
        UIImageView *oneImgV = self.subviews.firstObject;
        oneImgV.frame = CGRectMake(0, 0, SCREEN_W - iconW - 3*subViewMargin, (SCREEN_W - iconW - 3*subViewMargin) * 0.618);
        return;
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat margin = 3;
    NSInteger col = 0;
    NSInteger rol = 0;
    NSInteger cols = self.pic_urls.count == 4 || self.pic_urls.count == 2 ? 2: 3;
    CGFloat w = (SCREEN_W - iconW - 3*subViewMargin - 2 * cols)/cols;
    CGFloat h = w;
   
    // 计算显示出来的imageView
    for (NSInteger i = 0; i < self.pic_urls.count; i++) {
        col = i % cols;
        rol = i / cols;
        UIImageView *imageV = self.subviews[i];
        x = col * (w + margin);
        y = rol * (h + margin);
        imageV.frame = CGRectMake(x, y, w, h);
    }
    
}

@end
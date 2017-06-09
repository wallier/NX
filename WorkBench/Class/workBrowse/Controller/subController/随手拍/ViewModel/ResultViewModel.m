//
//  ResultViewModel.m
//  WorkBench
//
//  Created by xiaos on 15/12/3.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "ResultViewModel.h"

#import "ResultModel.h"
#import "NSString+CGSize.h"

#import "MJExtension.h"
#import "MBProgressHUD+Extend.h"

const CGFloat subViewMargin = 5.0f;    
const CGFloat iconW         = 35.0f;   


@implementation ResultViewModel

#pragma mark - 计算子控件尺寸
- (void)setResult:(ResultModel *)result
{
    _result = result;
    
    CGFloat contentW = SCREEN_W - iconW - 3 * subViewMargin; ///< 正文宽度
    
    /** 头像 */
    CGFloat iconX = subViewMargin;
    CGFloat iconY = subViewMargin;
    CGSize iconSize = CGSizeMake(iconW, iconW);
    self.iconFrame = (CGRect){{iconX, iconY},iconSize};
    
    /** 昵称 */
    CGFloat nameX = subViewMargin + MAXX(self.iconFrame);
    CGFloat nameY = subViewMargin;
    CGSize nameSzie = [result.USER_NAME
                       sizeWithFont:NAME_FONT];
    self.nameFrame = (CGRect){{nameX, nameY}, nameSzie};
    
    /** 品牌 */
    CGFloat brandX = nameX;
    CGFloat brandY = subViewMargin + MAXY(self.nameFrame);
    CGSize brandSzie = [result.PHONE_BRAND
                        sizeWithFont:BRAND_FONT];
    self.brandFrame = (CGRect){{brandX, brandY}, brandSzie};
    
    /** 时间 */
    CGFloat timeX = subViewMargin + MAXX(self.brandFrame);
    CGFloat timeY = brandY;
    CGSize timeSzie = [result.PUBLISH_TIME
                       sizeWithFont:TIME_FONT];
    self.timeFrame = (CGRect){{timeX, timeY}, timeSzie};
    
    /** 正文 */
    CGFloat titleX = nameX;
    CGFloat titleY = MAXY(self.brandFrame) + subViewMargin;
    CGSize titleSzie = [result.OPINION_TITLE
                        sizeWithFont:TITLE_FONT
                        maxW:contentW];
    self.titleFrame = (CGRect){{titleX, titleY}, titleSzie};
    
    CGFloat praisY = 0;
    /** 图片 */
    if (![result.IMAGE_NUM isEqualToString:@"0"])
    { // 有配图
        CGFloat photosX   = nameX;
        CGFloat photosY   = MAXY(self.titleFrame) + subViewMargin;
        CGSize photosSize = [self photosSizeWithCount:[result.IMAGE_NUM integerValue]];
        self.photoFrame   = (CGRect){{photosX, photosY}, photosSize};
        praisY = MAXY(self.photoFrame) + subViewMargin;
    }
    else
    { // 没配图
        praisY = MAXY(self.titleFrame) + subViewMargin;
    }

    /** 点赞按钮 */
    CGFloat praisX = SCREEN_W - 100 - subViewMargin;
    CGSize praisSize = CGSizeMake(50, 35);
    self.praisButtonFrame = (CGRect){{praisX , praisY}, praisSize};
    
    /** 回复按钮 */
    CGFloat replyX = SCREEN_W - 50 - subViewMargin;
    CGFloat replyY = praisY;
    CGSize replySize = CGSizeMake(50, 35);
    self.replyButtonFrame = (CGRect){{replyX , replyY}, replySize};
    
    self.cellHeight = MAXY(self.replyButtonFrame) + subViewMargin;
    
    /** 赞 */
    if (![result.PRAISES_NUM isEqualToString:@"0"]) {//有赞
        
        if ([result.PRAISES_NUM integerValue] >= 20) {//超过20个赞 显示前20个
            NSArray *allPraisesNames = [result.PRAISES componentsSeparatedByString:@"，"];
            NSRange range = NSMakeRange(0, 20);
            NSArray *topTwentyNames = [allPraisesNames subarrayWithRange:range];
            
            __block NSString *tempStr = @"";
            [topTwentyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                tempStr = [NSString stringWithFormat:@"%@%@，",tempStr,obj];
            }];
            NSString *trueStr = [tempStr substringToIndex:tempStr.length - 1]; //日了🐶的服务端
            self.truePraisesStr = [NSString
                                   stringWithFormat:@"%@ 等%@人觉得很赞",trueStr,result.PRAISES_NUM];
        } else {//全部显示
            self.truePraisesStr = [NSString
                                   stringWithFormat:@"%@ 觉得很赞",result.PRAISES];
        }
        
        
        CGFloat praisesX = nameX;
        CGFloat praisesY = MAXY(self.replyButtonFrame) + subViewMargin;
        CGSize praisesSzie = [self.truePraisesStr
                              sizeWithFont:TIME_FONT
                              maxW:contentW];
        self.praisesFrame = (CGRect){{ praisesX, praisesY}, praisesSzie};
        
        self.cellHeight = MAXY(self.praisesFrame) + subViewMargin;
        
        if (![result.COMMENTS_NUM isEqualToString:@"0"]) {//有赞 有评论
            NSArray *comments = [result.COMMENTS componentsSeparatedByString:@"$$"];
            
            __block CGFloat commentHeight = 0;
            NSMutableArray *commentCellHeightArr = [NSMutableArray array];
            [comments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGSize commentSzie = [obj sizeWithFont:COMMENT_FONT maxW:contentW];
                [commentCellHeightArr addObject:[NSNumber numberWithFloat:commentSzie.height*1.2]];
                commentHeight += 1.2*commentSzie.height;
            }];
            self.commentsHeightArr = commentCellHeightArr;
            
            CGFloat commentX = nameX;
            CGFloat commentY = subViewMargin + MAXY(self.praisesFrame);
            CGSize commentsSize = CGSizeMake(contentW, commentHeight);
            self.commentFrame = (CGRect){{commentX, commentY}, commentsSize};
            
            self.cellHeight = MAXY(self.commentFrame) + subViewMargin;
        }else {
            /** 有赞没评论 */
            self.cellHeight = MAXY(self.praisesFrame) + subViewMargin;
        }
    }
    else
    {
        /** 没赞 有评论 */
        if (![result.COMMENTS_NUM isEqualToString:@"0"]) {//有赞 有评论
            NSArray *comments = [result.COMMENTS componentsSeparatedByString:@"$$"];
            __block CGFloat commentHeight = 0;
            NSMutableArray *commentCellHeightArr = [NSMutableArray array];
            [comments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGSize commentSzie = [obj sizeWithFont:COMMENT_FONT maxW:contentW];
                [commentCellHeightArr addObject:[NSNumber numberWithFloat:commentSzie.height*1.2]];
                commentHeight += 1.2*commentSzie.height;
            }];
            self.commentsHeightArr = commentCellHeightArr;
            
            CGFloat commentX = nameX;
            CGFloat commentY = subViewMargin + MAXY(self.replyButtonFrame);
            CGSize commentsSize = CGSizeMake(contentW, commentHeight);
            self.commentFrame = (CGRect){{commentX, commentY}, commentsSize};
            
            self.cellHeight = MAXY(self.commentFrame) + subViewMargin;
        }else {
            /** 没赞 没评论 */
            self.cellHeight = MAXY(self.replyButtonFrame) + subViewMargin;
        }
    }
}

#pragma mark - 计算配图视图的尺寸
- (CGSize)photosSizeWithCount:(NSInteger)count {
    if (count == 1) {
        return CGSizeMake(SCREEN_W - iconW - 3*subViewMargin,
                          (SCREEN_W - iconW - 3*subViewMargin) * 0.618);
    }
    
    // 获取总列数 列数为2或者4时显示两列  其他的显示3列
    NSInteger cols = count == 4 || count == 2 ? 2 : 3;
        
    // 获取总行数 = (总个数 - 1) / 总列数 + 1
    NSInteger rols = (count - 1) / cols + 1;
    CGFloat photoWH = (SCREEN_W - iconW - 3*subViewMargin - 2*cols)/cols;
    CGFloat w = cols * photoWH + (cols - 1) * cols;
    CGFloat h = rols * photoWH + (rols - 1) * cols;
    
    return CGSizeMake(w, h);
}

@end

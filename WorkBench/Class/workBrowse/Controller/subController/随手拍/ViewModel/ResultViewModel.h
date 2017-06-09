//
//  ResultViewModel.h
//  WorkBench
//
//  Created by xiaos on 15/12/3.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

/** cell的viewModel用来简化cell布局 */
#import <Foundation/Foundation.h>

// 字体样式
#define NAME_FONT       [UIFont systemFontOfSize:16.0f]     ///<昵称
#define TIME_FONT       [UIFont systemFontOfSize:12.0f]     ///<时间
#define BRAND_FONT      [UIFont systemFontOfSize:12.0f]     ///<品牌
#define TITLE_FONT      [UIFont systemFontOfSize:16.0f]     ///<正文
#define COMMENT_FONT    [UIFont systemFontOfSize:14.0f]     ///<评论

extern const CGFloat subViewMargin; ///< cell子控件之间的间距
extern const CGFloat iconW;         ///< 头像宽度

@class ResultModel;
@interface ResultViewModel : NSObject

@property (nonatomic,strong) ResultModel *result;       ///< 传入的model

//子控件尺寸
@property (nonatomic,assign) CGRect iconFrame;          ///< 头像
@property (nonatomic,assign) CGRect nameFrame;          ///< 昵称
@property (nonatomic,assign) CGRect brandFrame;         ///< 品牌
@property (nonatomic,assign) CGRect timeFrame;          ///< 时间
@property (nonatomic,assign) CGRect titleFrame;         ///< 正文
@property (nonatomic,assign) CGRect photoFrame;         ///< 图片
@property (nonatomic,assign) CGRect praisButtonFrame;   ///< 点赞按钮
@property (nonatomic,assign) CGRect replyButtonFrame;   ///< 回复按钮
@property (nonatomic,assign) CGRect praisesFrame;       ///< 点赞

@property (nonatomic,assign) CGRect commentFrame;       ///< 评论
@property (nonatomic,strong) NSArray *commentsHeightArr; ///< 每行评论高度数组

@property (nonatomic,assign) CGFloat cellHeight;         ///< 行高度

@property (nonatomic,copy) NSString *truePraisesStr;     ///< 真正要显示的点赞人名称

@end

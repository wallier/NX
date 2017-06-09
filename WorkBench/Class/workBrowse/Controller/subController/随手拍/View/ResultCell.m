//
//  ResultCell.m
//  WorkBench
//
//  Created by xiaos on 15/12/3.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "ResultCell.h"
#import "CommentView.h"
#import "HomePhotoView.h"
#import "PraisesView.h"

#import "ResultModel.h"
#import "ResultViewModel.h"

#import "UIImage+Eex.h"

@interface ResultCell ()

@property (nonatomic,weak) UIImageView   *iconView;      ///< 头像
@property (nonatomic,weak) UILabel       *nameLabel;     ///< 昵称
@property (nonatomic,weak) UILabel       *brandLabel;    ///< 手机品牌
@property (nonatomic,weak) UILabel       *timeLabel;     ///< 时间
@property (nonatomic,weak) UILabel       *titleLabel;    ///< 正文
@property (nonatomic,weak) UIButton      *praisesButton; ///< 点赞按钮
@property (nonatomic,weak) UIButton      *replyButton;   ///< 回复按钮
@property (nonatomic,weak) PraisesView   *praisesView;   ///< 点赞
@property (nonatomic,weak) CommentView   *commentView;   ///< 评论
@property (nonatomic,weak) HomePhotoView *photoView;     ///< 图片

@end

@implementation ResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

#pragma mark - 初始化子控件
- (void)initSubviews
{
    /** 头像 */
    UIImageView *iconView = [UIImageView new];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    /** 昵称 */
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.font = NAME_FONT;
    
    /** 品牌 */
    UILabel *brandLabel = [UILabel new];
    [self.contentView addSubview:brandLabel];
    self.brandLabel = brandLabel;
    brandLabel.font = BRAND_FONT;
    
    /** 时间 */
    UILabel *timeLabel = [UILabel new];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    timeLabel.font = TIME_FONT;
    
    /** 正文 */
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.font = TITLE_FONT;
    titleLabel.numberOfLines = 0;
    
    /** 图片 */
    HomePhotoView *photoView = [HomePhotoView new];
    [self.contentView addSubview:photoView];
    self.photoView = photoView;
    
    /** 点赞按钮 */
    UIButton *praisesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [praisesButton addTarget:self action:@selector(praisesButtonTaaped) forControlEvents:UIControlEventTouchUpInside];
    [praisesButton setTitle:@"赞" forState:UIControlStateNormal];
    [praisesButton setTitle:@"已赞" forState:UIControlStateDisabled];
    praisesButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [praisesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [praisesButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [praisesButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.contentView addSubview:praisesButton];
    self.praisesButton = praisesButton;
    
    /** 回复按钮 */
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [replyButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [replyButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [replyButton addTarget:self action:@selector(replyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [replyButton setTitle:@"回复" forState:UIControlStateNormal];
    [self.contentView addSubview:replyButton];
    self.replyButton = replyButton;
    
    /** 点赞 */
    PraisesView *praisesView = [PraisesView new];
    [self.contentView addSubview:praisesView];
    self.praisesView = praisesView;
    
    /** 评论 */
    CommentView *commentView = [CommentView new];
    [self.contentView addSubview:commentView];
    self.commentView = commentView;
}

#pragma mark - 设置子控件的位置与状态
- (void)setViewModel:(ResultViewModel *)viewModel
{
    _viewModel = viewModel;
    ResultModel *result = viewModel.result;
    
    /** 头像 */
    self.iconView.image = [UIImage imageNamed:@"people"];
    self.iconView.frame = viewModel.iconFrame;
    
    /** 昵称 */
    self.nameLabel.text = result.USER_NAME;
    self.nameLabel.frame = viewModel.nameFrame;
    
    /** 品牌 */
    self.brandLabel.text = result.PHONE_BRAND;
    self.brandLabel.frame = viewModel.brandFrame;
    
    /** 时间 */
    self.timeLabel.text = result.PUBLISH_TIME;
    self.timeLabel.frame = viewModel.timeFrame;
    
    /** 正文 */
    self.titleLabel.text = result.OPINION_TITLE;
    self.titleLabel.frame = viewModel.titleFrame;
    
    /** 图片 */
    if (![result.IMAGE_NUM isEqualToString:@"0"]) {//有配图
        NSArray *images = [result.IMAGE_NAMES componentsSeparatedByString:@","];
        NSMutableArray *tempArr = [NSMutableArray array];
        [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // http://202.100.110.55:81/scmimage/%@
            NSString *imageURLStr = [NSString stringWithFormat:@"http://202.100.110.55:9081/scmimage/%@",obj];
            [tempArr addObject:imageURLStr];
        }];
        self.photoView.frame = viewModel.photoFrame;
        self.photoView.pic_urls = tempArr;
        self.photoView.hidden = NO;
    }else {//没配图
        self.photoView.hidden = YES;
    }
    
    /** 点赞按钮 */
    if ([result.PRAISES
         containsString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"]]) {
        self.praisesButton.enabled = NO;
    }else {
        self.praisesButton.enabled = YES;
    }
    
    /** 点赞按钮 */
    self.praisesButton.frame = viewModel.praisButtonFrame;
    
    /** 回复按钮 */
    self.replyButton.frame = viewModel.replyButtonFrame;
    
    if (![result.PRAISES_NUM isEqualToString:@"0"]) {//有赞
        self.praisesView.hidden = NO;
        
        self.praisesView.praisesStr = [NSString stringWithFormat:@"%@",viewModel.truePraisesStr];
        self.praisesView.frame = viewModel.praisesFrame;
    }else {//没赞
        self.praisesView.hidden = YES;
    }
    
    if (![result.COMMENTS_NUM isEqualToString:@"0"]) {//有评论
        self.commentView.viewModel = self.viewModel;
        self.commentView.frame = viewModel.commentFrame;
        self.commentView.hidden = NO;
    }else{//没评论
        self.commentView.hidden = YES;
    }
}

#pragma mark - 点赞和回复
- (void)praisesButtonTaaped
{
    [UIView animateWithDuration:0.3 animations:^{
        self.praisesButton.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    } completion:^(BOOL finished) {
        self.praisesButton.transform = CGAffineTransformIdentity;
        self.praisesButton.enabled = NO;

        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
        NSString *praisNumber = self.viewModel.result.PRAISES_NUM;
        /** 处理赞 */
        NSString *praisesStr = [NSString
                                stringWithFormat:@"%ld",(long)[praisNumber integerValue] + 1];
        /** 处理新增赞的人名字 */
        NSString *praisesName = self.viewModel.result.PRAISES;
        NSString *name = @"";
        
        if ([praisNumber isEqualToString:@"0"]) {//没人赞
            name = userName;
        }else {//有人赞
            name = [NSString stringWithFormat:@"%@，%@",
                    praisesName,userName];
        }
        
        if ([self.delegate respondsToSelector:@selector(resultCell:praisesOpinionId:userName:praisesNum:)]) {
            [self.delegate resultCell:self praisesOpinionId:self.viewModel.result.OPINION_ID userName:name praisesNum:praisesStr];
        }
    }];
    
}


- (void)replyButtonTapped
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    NSString *opId = self.viewModel.result.OPINION_ID;
    /** 新增评论 */
    NSString *commentsStr = @"";
    if ([self.viewModel.result.COMMENTS_NUM isEqualToString:@"0"]) {//没评论
        commentsStr = [NSString stringWithFormat:@"%@:",userName];
    }else {//有评论
        commentsStr = [NSString stringWithFormat:@"%@$$%@:", self.viewModel.result.COMMENTS, userName];
    }
    /** 新增评论数 */
    NSString *commentsNumStr = [NSString stringWithFormat:@"%ld",(long)[self.viewModel.result.COMMENTS_NUM integerValue] + 1];

    if ([self.delegate respondsToSelector:@selector(resultCell:commentOpinionId:commentStr:commentNumStr:)]) {
        [self.delegate resultCell:self commentOpinionId:opId commentStr:commentsStr commentNumStr:commentsNumStr];
    }
}

@end

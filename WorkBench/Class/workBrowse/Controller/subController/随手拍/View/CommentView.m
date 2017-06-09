//
//  CommentView.m
//  WorkBench
//
//  Created by xiaos on 15/12/7.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "CommentView.h"

#import "ResultModel.h"
#import "ResultViewModel.h"

#import "UIImage+Eex.h"


@interface CommentView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initTableView];
    }
    return self;
}


- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollsToTop = NO;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage setStretchImg:@"cell_background"]];
    
    [self addSubview:tableView];
    self.tableView = tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView
                                          *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:reuseId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = COMMENT_FONT;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *cellH = self.viewModel.commentsHeightArr[indexPath.row];
    return cellH.floatValue;
}

- (void)setViewModel:(ResultViewModel *)viewModel
{
    _viewModel = viewModel;

    self.dataSource = [viewModel.result.COMMENTS componentsSeparatedByString:@"$$"];
    [self.tableView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

@end

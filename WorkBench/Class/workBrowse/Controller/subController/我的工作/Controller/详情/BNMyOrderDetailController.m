//
//  BNOrderDetailController.m
//  WorkBench
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNMyOrderDetailController.h"
#import "BNOrdeDetailTableCell.h"
#import "PageSelectView.h"
#import "WG_view.h"
#import "ZpChoseView.h"
#import "BNOrderBaseController.h"
#import "BNOrderBaseModel.h"


@interface BNMyOrderDetailController ()<UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    //数据部分
    NSArray *couponArry;
    NSArray *groupbuyArry;
    
    //页面展示部分
    UITableView *couponTableView;
    UITableView *groupbuyTableView;
    
    //左右滑动部分
    UIPageControl *pageControl;
    int currentPage;
    BOOL pageControlUsed;
}

@property (strong, nonatomic) UIButton *couponButton;
@property (strong, nonatomic) UIButton *groupbuyButton;
@property (strong, nonatomic) UILabel  *slidLabel;     //用于指示作用
@property (strong, nonatomic) UIScrollView *nibScrollView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *mytableView;
@property (nonatomic, strong) PageSelectView *selectView;
@property (nonatomic, strong) PageSelectView *myselectView;
@property (nonatomic, strong) NSMutableArray *arrZpCell;
@property (nonatomic, strong) WG_view *view_wg;
@property(nonatomic,strong) UIView *view_block;
@property(nonatomic,strong) ZpChoseView *zpView;
@property (nonatomic, strong) NSString *Navtitle;    ///<标题

@end

@implementation BNMyOrderDetailController

- (void)viewWillAppear:(BOOL)animated
{
    if(_flagLR==0)
    {
        [self getMyOrder:1];

    }
    else if(_flagLR==1)
    {
        //做公共池的请求，以及数据加载。。
        [self getPublic:1];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"HX-WG";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBasicView];
    
    [self initScrollView];
    
//    LMJTab * tab = [[LMJTab alloc] initWithFrame:CGRectMake(0, 0, 132, 30) lineWidth:1 lineColor:[UIColor blackColor]];
//    [tab setItemsWithTitle:[NSArray arrayWithObjects:@"我的",@"公共池", nil] normalItemColor:[UIColor whiteColor] selectItemColor:[UIColor blackColor] normalTitleColor:[UIColor blackColor] selectTitleColor:[UIColor whiteColor] titleTextSize:15 selectItemNumber:0];
//    tab.delegate           = self;
//    tab.layer.cornerRadius = 5.0;
//    [self.view addSubview:tab];
    
    NSString* pagecount = [NSString stringWithFormat:@"%d",1];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pagecount forKey:@"pagecountright"];
//
    _flagLR = 0;
//
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshDataGrab)
                                                 name:@"reload" object:nil];
    
}


- (void) addBasicView
{
    //实例化按钮并且 给高度宽度
    _couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _couponButton.frame = CGRectMake(0, 0, SCREEN_W/2, 36);
//    _couponButton.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [_couponButton setTitleColor:[UIColor colorWithRed:(249/255.0) green:(206/255.0) blue:(59/255.0) alpha:1] forState:UIControlStateNormal];//此时选中
    [_couponButton setTitle:@"我的" forState:UIControlStateNormal];
    _couponButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    _couponButton.backgroundColor = [UIColor whiteColor];
    [_couponButton addTarget:self action:@selector(couponButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_couponButton];

    
    _groupbuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _groupbuyButton.frame = CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, 36);
//    _groupbuyButton.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [_groupbuyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];//此时未被选中
    [_groupbuyButton setTitle:@"公共池" forState:UIControlStateNormal];
    _groupbuyButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    _groupbuyButton.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1];
//    [_groupbuyButton addTarget:self action:@selector(groupbuyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_groupbuyButton];
    
    
    _slidLabel = [[UILabel alloc] init];
    _slidLabel.backgroundColor = [UIColor colorWithRed:(249/255.0) green:(206/255.0) blue:(59/255.0) alpha:1];
    _slidLabel.frame = CGRectMake(0, 34, SCREEN_W/2, 2);
    [self.view addSubview:_slidLabel];
    
}

- (void) couponButtonAction
{
    _flagLR = 0;
    _rightBtn.hidden = YES;
    _selectBtn.hidden = YES;
    [self getMyOrder:1];
    
    [_couponButton setTitleColor:[UIColor colorWithRed:(249/255.0) green:(206/255.0) blue:(59/255.0) alpha:1] forState:UIControlStateNormal];//此时选中
    _couponButton.backgroundColor = [UIColor whiteColor];
    
    [_groupbuyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];//此时未被选中
    _groupbuyButton.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1];
    
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    
    _slidLabel.frame = CGRectMake(0, 34, SCREEN_W/2, 2);
    [_nibScrollView setContentOffset:CGPointMake(SCREEN_W*0, 0)];//页面滑动
    
    [UIView commitAnimations];
}

- (void) groupbuyButtonAction
{
    _flagLR = 1;
    _rightBtn.hidden = NO;
    _selectBtn.hidden = NO;
    [self getPublic:1];
    [_groupbuyButton setTitleColor:[UIColor colorWithRed:(249/255.0) green:(206/255.0) blue:(59/255.0) alpha:1] forState:UIControlStateNormal];//此时选中
    
    _groupbuyButton.backgroundColor = [UIColor whiteColor];
    
    _couponButton.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1];
    [_couponButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//此时未被选中
    
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    
    _slidLabel.frame = CGRectMake((SCREEN_W/2), 34, SCREEN_W/2, 2);
    [_nibScrollView setContentOffset:CGPointMake(SCREEN_W*1, 0)];
    
    [UIView commitAnimations];
}

- (void)initScrollView {
    //设置 tableScrollView
    // a page is the width of the scroll view
    _nibScrollView = [[UIScrollView alloc] init];
    _nibScrollView.frame = CGRectMake(0, 36, SCREEN_W, SCREEN_H-100);
    _nibScrollView.backgroundColor = [UIColor whiteColor];
    _nibScrollView.pagingEnabled = YES;
    _nibScrollView.clipsToBounds = NO;
    _nibScrollView.contentSize = CGSizeMake(_nibScrollView.frame.size.width * 2, _nibScrollView.frame.size.height);
    _nibScrollView.showsHorizontalScrollIndicator = NO;
    _nibScrollView.showsVerticalScrollIndicator = NO;
    _nibScrollView.scrollsToTop = NO;
    _nibScrollView.delegate = self;
    _nibScrollView.scrollEnabled = NO;
    
    [_nibScrollView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:_nibScrollView];
    
    //公用
    currentPage = 0;
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor whiteColor];
//    [self createAllEmptyPagesForScrollView];
}

- (void)createAllEmptyPagesForScrollView {
    
    //设置 tableScrollView 内部数据
    couponTableView = [[UITableView alloc]init ];
    couponTableView.frame = CGRectMake(SCREEN_W*0, 0, SCREEN_W, _nibScrollView.frame.size.height);
    groupbuyTableView = [[UITableView alloc]init ];
    groupbuyTableView.frame = CGRectMake(SCREEN_W*1, 0, SCREEN_W, _nibScrollView.frame.size.height);
    
    //设置tableView委托并添加进视图
    couponTableView.delegate = self;
    couponTableView.dataSource = self;
    [_nibScrollView addSubview: couponTableView];
    groupbuyTableView.delegate = self;
    groupbuyTableView.dataSource = self;
    [_nibScrollView addSubview: groupbuyTableView];
    
    //设置 nibTableView 数据源数组 -- 仅仅用与测试
    couponArry = [[NSArray alloc]initWithObjects:@"coupon1",@"coupon2",@"coupon3", @"coupon4",nil];
    groupbuyArry = [[NSArray alloc]initWithObjects:@"groupbuy1",@"groupbuy2",@"groupbuy3", nil];
    
}

- (UITableView *)tableView{
    
    if(!_titleLabLeft){
    _titleLabLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, 36)];
    _titleLabLeft.text = @"  ?/？户";
    [_titleLabLeft setTextColor:[UIColor blackColor]];
    _titleLabLeft.layer.borderColor = [UIColor grayColor].CGColor;
    _titleLabLeft.layer.borderWidth = 0.5;
    _titleLabLeft.font = [UIFont fontWithName:@"Helvetica" size:14];
    _titleLabLeft.textAlignment = NSTextAlignmentLeft;
    _titleLabLeft.backgroundColor = [UIColor whiteColor];
    [_nibScrollView addSubview:_titleLabLeft];

    }
    
    if(!_titleLabLeftWarning){
    _titleLabLeftWarning = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width*3/4, 36)];
    _titleLabLeftWarning.text = @"  注意24小时未做处理将自动释放！";
    [_titleLabLeftWarning setTextColor:[UIColor redColor]];
    _titleLabLeftWarning.textAlignment = NSTextAlignmentLeft;
    _titleLabLeftWarning.font = [UIFont fontWithName:@"Helvetica" size:14];
    _titleLabLeftWarning.layer.borderColor = [UIColor grayColor].CGColor;
    _titleLabLeftWarning.layer.borderWidth = 0.5;
    _titleLabLeftWarning.backgroundColor = [UIColor whiteColor];
    [_nibScrollView addSubview:_titleLabLeftWarning];
    }
    
    if(!_titleLabRight){
    _titleLabRight = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W*1, 0, self.view.frame.size.width, 36)];
    _titleLabRight.backgroundColor = [UIColor whiteColor];
    _titleLabRight.text = @"  剩余 ？户";
    [_titleLabLeft setTextColor:[UIColor blackColor]];
    _titleLabRight.layer.borderColor = [UIColor grayColor].CGColor;
    _titleLabRight.layer.borderWidth = 0.5;
    _titleLabRight.font = [UIFont fontWithName:@"Helvetica" size:14];
    _titleLabRight.textAlignment = NSTextAlignmentLeft;
    [_nibScrollView addSubview:_titleLabRight];
    }
    
    if (!_mytableView) {
        _mytableView =[[UITableView alloc] initWithFrame:CGRectMake(SCREEN_W*0, 36, SCREEN_W, self.view.frame.size.height-128) style:UITableViewStylePlain];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.scrollEnabled = NO;
        
        [_nibScrollView addSubview:_mytableView];
    }
    

    
    if (!_tableView) {
        
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(SCREEN_W*1, 36, SCREEN_W, self.view.frame.size.height-128) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        
        [_nibScrollView addSubview:_tableView];
    }
    return nil;
}

- (PageSelectView *)selectView{
    
    if (!_myselectView) {
        WS;
        _myselectView = [[PageSelectView alloc] init];
        NSLog(@"height==%f", self.view.frame.size.height);
        _myselectView.frame = CGRectMake(SCREEN_W*0, _nibScrollView.frame.size.height-44, SCREEN_W, 44);
        _myselectView.backgroundColor = [UIColor redColor];
        _myselectView.sendcont = ^(int count){
            
            [weakSelf.params setValue:[NSString stringWithFormat:@"%d",count] forKey:@"pageNum"];
            [weakSelf getINfoOfPage:count];
        };
        _myselectView.currentPage = 1;
        int count = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pagesize"] intValue];
        NSLog(@"count===%d", count);
        NSLog(@"count99===%d---%d", count,self.mymaxCout);
        _myselectView.maxPage = self.mymaxCout <= count ? 1 : self.mymaxCout/count+1;
        
        [_myselectView setBackgroundColor:[UIColor whiteColor]];
    }
        [_nibScrollView addSubview:_myselectView];
    
    
    if (!_selectView) {
        WS;
        _selectView = [[PageSelectView alloc] init];
        NSLog(@"height==%f", self.view.frame.size.height);
        _selectView.frame = CGRectMake(SCREEN_W*1, _nibScrollView.frame.size.height-44, SCREEN_W, 44);
        _selectView.backgroundColor = [UIColor redColor];
        _selectView.sendcont = ^(int count){
            
            [weakSelf.params setValue:[NSString stringWithFormat:@"%d",count] forKey:@"pageNum"];
            [weakSelf getINfoOfPage:count];
        };
        _selectView.currentPage = 1;
        int count = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pagesize"] intValue];
        NSLog(@"count99===%d---%d", count,self.maxCout);
        _selectView.maxPage = self.maxCout <= count ? 1 : self.maxCout/count+1;
        
        [_selectView setBackgroundColor:[UIColor whiteColor]];
    }
    [_nibScrollView addSubview:_selectView];
    
    _buttonLab = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W*1, _selectView.frame.origin.y-34, self.view.frame.size.width, 34)];
    _buttonLab.backgroundColor = [UIColor whiteColor];
    [_nibScrollView addSubview:_buttonLab];
    
    
    _btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnConfirm setFrame:CGRectMake(100, 2, 60, 30)];
//    [btnConfirm setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [_btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
    
    [_btnConfirm.layer setMasksToBounds:YES];
    [_btnConfirm.layer setCornerRadius:5.0];
    _btnConfirm.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1];
//    [btnConfirm setContentMode:UIViewContentModeCenter];
    [_btnConfirm addTarget:self action:@selector(btnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [_btnConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonLab addSubview:_btnConfirm];
    
    
    _btnReset = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnReset setFrame:CGRectMake(200, 2, 60, 30)];
//    [btnReset setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [_btnReset setTitle:@"重置" forState:UIControlStateNormal];
    _btnReset.backgroundColor = [UIColor colorWithRed:(228/255.0) green:(228/255.0) blue:(228/255.0) alpha:1];
    
    [_btnReset.layer setMasksToBounds:YES];
    [_btnReset.layer setCornerRadius:5.0];
//    [btnReset setContentMode:UIViewContentModeCenter];
    [_btnReset addTarget:self action:@selector(btnReset:) forControlEvents:UIControlEventTouchUpInside];
    [_btnReset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonLab addSubview:_btnReset];
    
    return nil;
}

- (void)btnConfirm:(id)sender
{
    NSLog(@"confirm");
    [self grabData];
}

- (void)revokeOrder:(id)sender
{
    NSLog(@"revokeOrder");
    UIButton* btn = sender;
//    NSLog(@"%ld", (long)btn.tag);
    [self revokeOrderRequest:(long)btn.tag];
}

- (void)revokeOrderRequest:(int)row
{
    //执行完毕刷新我的列表
    _myCellmodel = self.myarrModel[row];

    //拼接请求连接
    NSString* strUrl = @"";
    
    strUrl = [ReverceGrabWorkOrderURL stringByAppendingFormat:@"%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [LoginModel shareLoginModel].USER_ID, _myCellmodel.USER_ID];
    
    NSLog(@"url8001---%@", strUrl);
    
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData =
    ^(id requestData){
        NSLog(@"requestData===%@---%@",requestData,requestData[@"COUNT"]);

        [MBProgressHUD showSuccess:requestData[@"MSGTexT"]];
        [self getMyOrder:0];
        
    };
}

- (void)btnReset:(id)sender
{
    NSLog(@"reset");
    _isReset = NO;
    [self btnClear];
    [self getPublic:1];
}

- (UIView *)view_block{
    if (!_view_block) {
        _view_block = [[UIView alloc] initWithFrame:self.view.bounds];
        [_view_block setBackgroundColor:[UIColor blackColor]];
        [_view_block setAlpha:0];
        
    }
    return _view_block;
}


- (ZpChoseView *)zpView{
    if (!_zpView) {
        WS;
        _zpView = [[ZpChoseView alloc] initWithFrame:
                   self.view.bounds];
        _zpView.y = 40;
        _zpView.parameters = self.params;
        _zpView.getChoseData = ^(NSDictionary *dic){
            if (!dic) {
                [weakSelf.view_block setAlpha:0];
                [weakSelf.view_block removeFromSuperview];
                return ;
            }else
            {
                [weakSelf.view_block setAlpha:0];
                [weakSelf.view_block removeFromSuperview];
            }
            
            MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView: weakSelf.view.window];
            
            //链接一个参数的改变重新请求。
            NSLog(@"weakSelf.url===%@--dic%@",weakSelf.url,dic);
//            return; dic
            
            NSString* strUrl = @"";
            NSLog(@"sanFlag--%@---%d", [weakSelf.params objectForKey:@"sanFlag"],1);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString* pagecount = @"";
            
            if([defaults objectForKey:@"pagecountright"])
            {
                pagecount = [defaults objectForKey:@"pagecountright"];
            }
            else
            {
                pagecount = @"1";
            }
            
            NSString* executeState = @"";
            NSString* forwordSend = @"";
            NSString* orgIdIndex = @"";
            if(![[dic objectForKey:@"executeState"] isEqualToString:@""])
            {
                executeState = [[dic objectForKey:@"executeState"]substringToIndex:[[dic objectForKey:@"executeState"] length]-1];
            }
            else
            {
                executeState = @"-1";
            }
            
            if(![[dic objectForKey:@"forwordSend"] isEqualToString:@""])
            {
                forwordSend = [dic objectForKey:@"forwordSend"];
            }
            else
            {
                forwordSend = @"-1";
            }
            
            orgIdIndex = [dic objectForKey:@"orgIdIndex"];
            
//            if(_isReset)
//            {
//                NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
//                NSString * URLF = [userDefaultes stringForKey:@"URLF"];
//                NSString * URLS = [userDefaultes stringForKey:@"URLS"];
//                
//                NSString * newStr = [URLF stringByAppendingFormat:@"%@%@",pagecount,URLS];
//                //提取拼接
//                strUrl = newStr;//读取的，仅改变pagecount 改变斜杠后面的数字。
//            }
//            else
//            {
            if([[self judgeUrl] rangeOfString:@"getThreeHeartUserGrabList"].location !=NSNotFound)
            {
                strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], pagecount, [self.params objectForKey:@"pageSize"], executeState, forwordSend, orgIdIndex, @"-1"];
//                NSLog(@"F888===%@---%@",[[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"]],[@"" stringByAppendingFormat:@"/%@/%@/%@/%@/%@",[self.params objectForKey:@"pageSize"], executeState, forwordSend, orgIdIndex, @"-1"]);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"]] forKey:@"URLF"];
                
                [defaults setObject:[@"" stringByAppendingFormat:@"/%@/%@/%@/%@/%@",[self.params objectForKey:@"pageSize"], executeState, forwordSend, orgIdIndex, @"-1"] forKey:@"URLS"];
                
            }
            else
            {
                strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], pagecount, [self.params objectForKey:@"pageSize"], executeState, forwordSend, orgIdIndex, @"-1"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"]] forKey:@"URLF"];
                
                [defaults setObject:[@"" stringByAppendingFormat:@"/%@/%@/%@/%@/%@",[self.params objectForKey:@"pageSize"], executeState, forwordSend, orgIdIndex, @"-1"] forKey:@"URLS"];
            }
//            }
            
            //分两段保存，再去修改和拼接。

            NSLog(@"strUrl9909---%@",strUrl);
            //保存读取改变
            [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData =
            ^(id requestData){
                NSLog(@"requestData7272==%@",requestData);
                [hud setHidden:YES];
                _isReset = YES;
                
                if([requestData[@"SIZE"] intValue]>0)
                {
                NSLog(@"requestData999888000===%@",requestData[@"RESULT"][0][@"TOTAL_NUM"]);
                    _selectView.maxPage = [requestData[@"RESULT"][0][@"TOTAL_NUM"] intValue];
                }else
                {
                    _selectView.maxPage = 1;
                }
                
                
//                self.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
//                [self.tableView reloadData];
                
                self.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
                [_tableView reloadData];
                
            };
            NSLog(@"dic908==%@",dic);
        };
    }
    return _zpView;
    
}

- (NSMutableArray *)arrZpCell{
    if (!_arrZpCell) {
        _arrZpCell = [NSMutableArray array];
    }
    return _arrZpCell;
}

-(void)getMyOrder:(int)flag
{
//    WS;
//    _myselectView.sendcont = ^(int count){
//        
//        [weakSelf.params setValue:[NSString stringWithFormat:@"%d",3] forKey:@"pageNum"];
//        [weakSelf getINfoOfPage:3];
//    };
    //获取总页码 然后/13
//    _myselectView.maxPage = 3;
    
    if(flag!=0)
    {
        _hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
    }
    NSString* strUrl = @"";

    strUrl = [GetThreeHeartUserOwnGrabListURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[LoginModel shareLoginModel].USER_ID,[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], @"1", [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    
    NSString* pagecount = [NSString stringWithFormat:@"%d",1];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pagecount forKey:@"mypagecount"];
    
    
    NSLog(@"strUrlmy==%@", strUrl);

    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData
    = ^(id requestData){
        [_hud setHidden:YES];
        NSLog(@"requestData==%@", requestData[@"SIZE"]);
        
        
        self.myarrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
        [_mytableView reloadData];
        
//        _myselectView.maxPage = ;
        if([requestData[@"SIZE"] intValue]>0)
        {
            NSLog(@"requestData999000===%@",requestData[@"RESULT"][0][@"TOTAL_NUM"]);
            _myselectView.maxPage = [requestData[@"RESULT"][0][@"TOTAL_NUM"] intValue];
        }
        
        [self getLimitNum:0];
        
    };

}

-(void)getPublic:(int)flag
{

    _titleLabRight.text = @"  剩余 ？户";
    _isReset = NO;
    if(flag!=0)
    {
        _hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
    }
    //    NSString* strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    
    NSString* strUrl = @"";
    NSLog(@"sanFlag--%@---%d", [self.params objectForKey:@"sanFlag"],1);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* pagecount = @"";
    
    if([defaults objectForKey:@"pagecountright"])
    {
        pagecount = [defaults objectForKey:@"pagecountright"];
    }
    else
    {
        pagecount = @"1";
    }
    
    if([[self judgeUrl] rangeOfString:@"getThreeHeartUserGrabList"].location !=NSNotFound)
    {
        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], pagecount, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    }
    else
    {
        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], pagecount, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    }
    
//    NSString* pagecount = [NSString stringWithFormat:@"%d",1];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:pagecount forKey:@"pagecount"];
    
    //    if (![self.params objectForKey:@"sanFlag"])
    //    {
    //        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    //    }
    //    else
    //    {
    //        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    //    }
    
    
    NSLog(@"strUrl00==%@", strUrl);
    
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData
    = ^(id requestData){
        //        [_hud setHidden:YES];
//        NSLog(@"requestData999000===%@",requestData);
        
        
        if([requestData[@"SIZE"] intValue]>0)
        {
            NSLog(@"requestData999000===%@",requestData[@"RESULT"][0][@"TOTAL_NUM"]);
            _selectView.maxPage = [requestData[@"RESULT"][0][@"TOTAL_NUM"] intValue];
        }
        
        
        
        if(_flagLR==0)
        {
            self.myarrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
            [_mytableView reloadData];
            
//            [self showLeftView];
        }
        else
        {
            self.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
            [_tableView reloadData];
            
//            [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.1];
            
        }
        [self btnClear];
        [self getLimitNum:1];
        
    };

}

- (void)getLimitNum:(int)numflag
{
    NSString* strUrl = @"";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* pagecount = @"";
    
    if([defaults objectForKey:@"pagecountright"])
    {
        pagecount = [defaults objectForKey:@"pagecountright"];
    }

    strUrl = [GetLimitGrabURL stringByAppendingFormat:@"%@/%@",[LoginModel shareLoginModel].USER_ID, [self.params objectForKey:@"userType"]];
    
    NSLog(@"strUrl_limit00==%@", strUrl);
    
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData
    = ^(id requestData){
        [_hud setHidden:YES];

//        NSLog(@"SURPLUS==%@", requestData[@"RESULT"][0][@"SURPLUS"]);
        if(numflag==1)
        {
            _publicNum = [requestData[@"RESULT"][0][@"SURPLUS"] intValue];
            _titleLabRight.text = [NSString stringWithFormat:@"  剩余%d户",_publicNum];
        }
        else if(numflag==0)
        {
            _titleLabLeft.text = [NSString stringWithFormat:@"  %d/%d户", [requestData[@"RESULT"][0][@"CNT"] intValue],[requestData[@"RESULT"][0][@"LIMIT"] intValue]];
        }
    };
}

-(void)getINfoOfPage:(int)count{
    WS;
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
    
//    NSString* strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    
    NSString* strUrl = @"";
    NSLog(@"sanFlag--%@---%d", [self.params objectForKey:@"sanFlag"],count);
    
    if(_isReset)
    {
        NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString * URLF = [userDefaultes stringForKey:@"URLF"];
        NSLog(@"URLF--%@",URLF);
        NSString * URLS = [userDefaultes stringForKey:@"URLS"];
        NSLog(@"URLS--%@",URLS);
        NSString * newStr = [URLF stringByAppendingFormat:@"%d%@",count,URLS];
        //提取拼接
        strUrl = newStr;//读取的，仅改变pagecount 改变斜杠后面的数字。
    }
    else
    {
        
    if([[self judgeUrl] rangeOfString:@"getThreeHeartUserGrabList"].location !=NSNotFound)
    {
        if(_flagLR==1)
        {
        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
        }
        else if(_flagLR==0)
        {
            strUrl = [GetThreeHeartUserOwnGrabListURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[LoginModel shareLoginModel].USER_ID,[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
        }
    }
    else
    {
        if(_flagLR==1){
         strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
        
        }else if(_flagLR==0)
        {
            strUrl = [GetThreeHeartUserOwnGrabListURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[LoginModel shareLoginModel].USER_ID,[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
        }
    }
    }
    
    NSLog(@"count888===%d", count);
    if(_flagLR==1)
    {
        NSString* pagecount = [NSString stringWithFormat:@"%d",count];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:pagecount forKey:@"pagecountright"];
    }
    else
    {
        NSString* pagecount = [NSString stringWithFormat:@"%d",count];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:pagecount forKey:@"pagecountleft"];
    }

    
//    if (![self.params objectForKey:@"sanFlag"])
//    {
//        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
//    }
//    else
//    {
//        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%d/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], count, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
//    }
    
    
    NSLog(@"strUrl77==%@", strUrl);

    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData
    = ^(id requestData){
        [hud setHidden:YES];
        if(_flagLR==0)
        {
            self.myarrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
            [_mytableView reloadData];
            
            [self getLimitNum:0];

        }
        else
        {
            self.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
            [_tableView reloadData];


        }

    };
    
}


- (NSString *)judgeUrl{
    
    int flag = [[[NSUserDefaults standardUserDefaults] valueForKey:@"model"] intValue];
    
    switch (flag) {
        case 0:
            return DataPoolThreeHeartUserListURL; //三心
            break;
        case 1:
            return DataPoolDevChanceUserListURL; //发展
            break;
        case 2:
            return DataPoolThreeHeartItemUserListURL; //条目
            break;
        default:
            break;
    }
    return nil;
}

- (void)setNavLeftTitle:(NSString *)title{
    NSString *str = [NSString stringWithFormat:@"< %@",title];
    self.Navtitle = str;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0,self.view.frame.size.width / 2, 40)];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [back setTitle:str forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||
          [[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]){
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _rightBtn.layer.borderWidth = 1;
        _rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_rightBtn setTintColor:[UIColor clearColor]];
        _rightBtn.layer.cornerRadius = 6;
        [_rightBtn setFrame:CGRectMake(0, 4, 60, 30)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBtn setTitle:@"转派" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(sendTurnData) forControlEvents:UIControlEventTouchUpInside];
        
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _selectBtn.layer.borderWidth = 1;
        _selectBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_selectBtn setTintColor:[UIColor clearColor]];
        _selectBtn.layer.cornerRadius = 6;
        [_selectBtn setFrame:CGRectMake(0, 4, 60, 30)];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_selectBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(sendSelectData) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPressGR =
              [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(longPress:)];
        longPressGR.delegate =  self;
        longPressGR.minimumPressDuration = 0.5;
        [_rightBtn addGestureRecognizer:longPressGR];
        
//            NSArray *buttonArray = [[NSArray alloc]initWithObjects:_selectBtn,_rightBtn, nil];
        
//            self.navigationItem.rightBarButtonItems = buttonArray;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
        _rightBtn.hidden = YES;
        _selectBtn.hidden = YES;
          }
    
}

- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_flagLR==0)
    {
        return self.myarrModel.count;
    }
    else
    {
        return self.arrModel.count;
    }
//    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    BNOrdeDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BNOrdeDetailTableCell" owner:self options:nil] lastObject];
    }
    
    if(_flagLR==0)
    {
        cell.model = self.myarrModel[indexPath.row];

        cell.imgSxFlag.hidden = YES;
        
        cell.btnDate.hidden = YES;
        
        cell.btnChoseOrder.hidden = YES;
        
        CGFloat W = (cell.width - 2 ) / 3;
        
        //未执行、执行中、已执行
        self.btnKillOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnKillOrder setFrame:CGRectMake(2*W+16, 0, 44, 30)];
        [self.btnKillOrder.layer setMasksToBounds:YES];
//        [self.btnKillOrder.layer setCornerRadius:5.0];
        self.btnKillOrder.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [self.btnKillOrder setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
        
        //撤单按钮
        self.btnStatus = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnStatus setFrame:CGRectMake(self.btnKillOrder.frame.origin.x+62, 0, 30, 30)];
        [self.btnStatus.layer setMasksToBounds:YES];
//        [self.btnStatus.layer setCornerRadius:5.0];
        self.btnStatus.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [self.btnStatus setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        NSInteger row = [indexPath row];
        [self.btnStatus setTag:row];
        [self.btnStatus addTarget:self action:@selector(revokeOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if([cell.model.ORDER_STATE intValue]==0)
        {
            self.timeImg = [[UIImageView alloc ] init];
            UIImage *image = [UIImage imageNamed:@"ico_n_02"];
            self.timeImg.frame = CGRectMake(2*W+2, 7, 16, 16);
            self.timeImg.image = image;
            
            [self.btnKillOrder setTitle:@"未执行" forState:UIControlStateNormal];
//            self.btnKillOrder.backgroundColor = [UIColor redColor];
            self.btnKillOrder.frame = CGRectMake(2*W+15, 0, 44, 30);
            
            self.doorImg = [[UIImageView alloc ] init];
            UIImage *image2 = [UIImage imageNamed:@"ico_n_04"];
            self.doorImg.frame = CGRectMake(self.btnKillOrder.frame.origin.x+44, 7, 16, 16);
            self.doorImg.image = image2;
            
            [self.btnStatus setTitle:@"撤单" forState:UIControlStateNormal];
//            self.btnStatus.backgroundColor = [UIColor redColor];
            
            
            [cell.contentView addSubview:self.timeImg];
            [cell.contentView addSubview:self.btnStatus];
            [cell.contentView addSubview:self.doorImg];
        }
        else if([cell.model.ORDER_STATE intValue]==1)
        {
            self.rightImg = [[UIImageView alloc ] init];
            UIImage *image2 = [UIImage imageNamed:@"ico_n_03"];
            self.rightImg.frame = CGRectMake(2*W+2, 7, 16, 16);
            self.rightImg.image = image2;
            
            [self.btnKillOrder setTitle:@"已执行" forState:UIControlStateNormal];
            self.btnKillOrder.frame = CGRectMake(2*W+16, 0, 44, 30);
//            self.btnKillOrder.backgroundColor = [UIColor yellowColor];
            
            
            [cell.contentView addSubview:self.rightImg];
        }
        else if([cell.model.ORDER_STATE intValue]==2)
        {
            
            self.circleImg = [[UIImageView alloc ] init];
            UIImage *image2 = [UIImage imageNamed:@"ico_n_05"];
            self.circleImg.frame = CGRectMake(2*W+2, 7, 16, 16);
            self.circleImg.image = image2;
            
            [self.btnKillOrder setTitle:@"执行中" forState:UIControlStateNormal];
            self.btnKillOrder.frame = CGRectMake(2*W+16, 0, 44, 30);
//            self.btnKillOrder.backgroundColor = [UIColor greenColor];
            
            
            [cell.contentView addSubview:self.circleImg];
        }
        
        //    [self.btnKillOrder addTarget:self action:@selector(btnConfirm:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.contentView addSubview:self.btnKillOrder];
    }
    else
    {
        cell.model = self.arrModel[indexPath.row];
        
        cell.imgSxFlag.hidden = YES;
        
        cell.btnDate.hidden = YES;
    }
//    cell.contentView.imgSxFlag
    
    [[LoginModel shareLoginModel] setOrderDetail:cell.model];
    [cell.btnChoseOrder addTarget:self action:@selector(addZpData:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MBProgressHUD* hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view.window];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BNOrdeDetailTableCell *cell = (BNOrdeDetailTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [_params setValue:cell.model.USER_ACCR forKey:@"userAccr"];
    NSLog(@"%@",[self.params allKeys]);
    [_params setValue:cell.model.SAN_FALG forKey:@"sanFlag"];
    [_params setValue:[self judgeOrderType] forKey:@"workOrderType"];
    
    

    // 单条工单状态同步 HXdatacoordinationwithCR
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:cell.model.ORDER_NO forKey:@"orderNo"];     //工单流水
    [dic setValue:@"" forKey:@"orderBody"];                   //回单内容，传入是为空字符串
    [dic setValue:cell.model.USER_ID forKey:@"userId"];       //用户实例id
    [dic setValue:cell.model.POLICY_ID forKey:@"policyId"];   //策略ID
    [dic setValue:[LoginModel shareLoginModel].LOGIN_ID forKey:@"staffId"]; //登录工号 （staff_id）
    [dic setValue:cell.model.START_DATE forKey:@"startDate"];  //工单创建时间
    [dic setValue:cell.model.ORDER_STATE forKey:@"orderstate"];  //工单状态
    [dic setValue:@"" forKey:@"resultHs"];    //返回参数，传入是为空字符串
    
    [self.params setValue:dic[@"orderNo"] forKey:@"orderNo"];
//    NSLog(@"self.params==%@",self.params);
    NSString* strUrl = @"";
    strUrl = [GetGrabDpWorkOrderDetailURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"workOrderType"], [self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], [self.params objectForKey:@"userAccr"]];
//    NSLog(@"strUrl====%@",strUrl);
    
    
    if([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]||[[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]){
        
        //先判断pool表里的工单state，在判断CRM
        if([cell.model.ORDER_STATE isEqualToString:@"0"]){
            //调用CRM函数
            
            [BNNetworkTool initWitUrl:HXdatacoordinationwithCRM andParameters:dic andStyle:YES].requestData
            = ^(id request){
                //进入工单
                if ([request[@"MSGCODE"] intValue]==0) {
                    
                    //                    [self enterOrder:cell.img_state.image andIndex:indexPath.row andFlag:YES];
                    //DataPoolThreeHeartDefaultOrderURL
                    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData = ^(id requestData){
                        [hud setHidden:YES];
                        if([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"300"]){
                            
                            BNOrderBaseController *baseVC = [[BNOrderBaseController alloc] init];
                            baseVC.params = self.params;
                            baseVC.navTitle = self.Navtitle;

                            baseVC.model = [BNOrderBaseModel objectWithKeyValues:requestData[@"RESULT"][0]];
                            
                            [self.navigationController pushViewController:baseVC animated:YES];
                        }
                        
                    };
                }else{
                    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData = ^(id requestData){
                        [hud setHidden:YES];
                        if([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"300"]){
//                            NSLog(@"requestData99===%@", requestData);
                            BNOrderBaseController *baseVC = [[BNOrderBaseController alloc] init];
                            baseVC.params = self.params;

                            baseVC.model = [BNOrderBaseModel objectWithKeyValues:requestData[@"RESULT"][0]];
                            baseVC.navTitle = self.Navtitle;

                            [self.navigationController pushViewController:baseVC animated:YES];
                        }};
                }
            };
        }
        else {
            [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData = ^(id requestData){
                [hud setHidden:YES];
                if([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"300"]){
                    BNOrderBaseController *baseVC = [[BNOrderBaseController alloc] init];
                    baseVC.params = self.params;
                    
                    baseVC.model = [BNOrderBaseModel objectWithKeyValues:requestData[@"RESULT"][0] ];
                    baseVC.navTitle = self.Navtitle;
                    [self.navigationController pushViewController:baseVC animated:YES];
                    
                }
            };
            
        }
    } else {
        [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData = ^(id requestData){
            [hud setHidden:YES];
            if([[requestData valueForKey:@"MSGCODE"] isEqualToString:@"300"]){
                BNOrderBaseController *baseVC = [[BNOrderBaseController alloc] init];
                baseVC.params = self.params;
                baseVC.model = [BNOrderBaseModel objectWithKeyValues:requestData[@"RESULT"][0] ];
                baseVC.navTitle = self.Navtitle;
                
                [self.navigationController pushViewController:baseVC animated:YES];
            }
        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 33;
}


#pragma mark - UIEVENTSENDER
- (void)addZpData:(customBtn *)sender{
    
    if (!sender.selected) {
        [self.arrZpCell addObject:sender.cell];
        
        NSLog(@"zpcell-add==%@--%d",self.arrZpCell,self.arrZpCell.count);
        
        sender.selected = YES;
        
        if(self.arrZpCell.count>_publicNum)
        {
            //超过啦
            [MBProgressHUD showError:@"你所选中的用户已达到上限"];
//            _fullStatus = NO;
            [self.arrZpCell removeObject:sender.cell];
            NSLog(@"zpcell-rm==%@--%d",self.arrZpCell,self.arrZpCell.count);
            sender.selected = NO;
        }
    }else{
        [self.arrZpCell removeObject:sender.cell];
        NSLog(@"zpcell-rm==%@--%d",self.arrZpCell,self.arrZpCell.count);
        sender.selected = NO;
    }
    
}

- (void)longPress:(UIGestureRecognizer*)gesture{
    [self.view addSubview:self.view_block];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view_block setAlpha:0.5];
    }];
    [self.view addSubview:self.zpView];
    [self.zpView resetting];

}

- (void)sendSelectData{
    
    [self.view addSubview:self.view_block];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view_block setAlpha:0.5];
    }];
    [self.view addSubview:self.zpView];
    [self.zpView resetting];
    
//    _view_wg = [[ WG_view alloc] initWithFrame:
//                CGRectMake(0, 0, self.view.frame.size.width-20, self.view.frame.size.height-150)];
//    
//    _view_wg.center = CGPointMake(SCREEN_W/2, self.view.frame.size.height/2);
//    
//    [_view_wg setAlpha:0];
//    WS;
//    _view_wg.closed = ^(void){
//        [weakSelf btnClosed];
//    };
//    [self.view addSubview:self.view_block];
//    [self.view addSubview:_view_wg];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        [_view_block setAlpha:0.5];
//        [_view_wg setAlpha:1];
//    }];
//    _view_wg.sendorgid = ^(NSString *str_ordid){
//        MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在筛选..." toView:weakSelf.view.window];
//        for (BNOrdeDetailTableCell * cell in weakSelf.arrZpCell) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setValue:cell.model.USER_ACCR forKey:@"userAccr"];
//            [dic setValue:cell.model.SERVICE_TYPE forKey:@"serviceType"];
//            [dic setValue:cell.model.TASK_ID forKey:@"taskId"];
//            [dic setValue:cell.model.POLICY_ID forKey:@"policyId"];
//            [dic setValue:str_ordid forKey:@"orgId"];
//            [dic setValue:[weakSelf judgeOrderType] forKey:@"workOrderType"];
//            NSLog(@"dic==%@--accr%@", dic,cell.model.USER_ACCR);
//            [BNNetworkTool initWitUrl:DataPoolWGDataThreeURL andParameters:dic andStyle:YES].requestData
//            = ^(id requestData){
//                [hud setHidden:YES];
//                static int count;
//                if ([[requestData valueForKey:@"MSGCODE"] containsString:@"700"]) {
//                    count ++;
//                    if (count == [self.arrZpCell count]) {
//                        [weakSelf.view.window makeToast:@"转派成功" duration:0.5 position:CSToastPositionCenter];
//                        count = 0;
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
//                        [weakSelf btnClear];
//                    }
//                    [weakSelf btnClosed];
//                }
//            };
//        }
//        
//    };
}

- (void)sendTurnData{
    if (self.arrZpCell.count == 0) {
        [self.view makeToast:@"请选择数据" duration:0.5 position:CSToastPositionCenter];
//        [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.1];
        return;
    }
    _view_wg = [[ WG_view alloc] initWithFrame:
                CGRectMake(0, 0, self.view.frame.size.width-20, self.view.frame.size.height-150)];
    
    _view_wg.center = CGPointMake(SCREEN_W/2, self.view.frame.size.height/2);
    
    [_view_wg setAlpha:0];
    WS;
    _view_wg.closed = ^(void){
        [weakSelf btnClosed];
    };
    [self.view addSubview:self.view_block];
    [self.view addSubview:_view_wg];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_view_block setAlpha:0.5];
        [_view_wg setAlpha:1];
    }];
    _view_wg.sendorgid = ^(NSString *str_ordid){
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在转派..." toView:weakSelf.view.window];
        for (BNOrdeDetailTableCell * cell in weakSelf.arrZpCell) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:cell.model.USER_ACCR forKey:@"userAccr"];
            [dic setValue:cell.model.SERVICE_TYPE forKey:@"serviceType"];
            [dic setValue:cell.model.TASK_ID forKey:@"taskId"];
            [dic setValue:cell.model.POLICY_ID forKey:@"policyId"];
            [dic setValue:str_ordid forKey:@"orgId"];
            [dic setValue:[weakSelf judgeOrderType] forKey:@"workOrderType"];
            NSLog(@"dic==%@--accr%@", dic,cell.model.USER_ACCR);
            [BNNetworkTool initWitUrl:DataPoolWGDataThreeURL andParameters:dic andStyle:YES].requestData
            = ^(id requestData){
                [hud setHidden:YES];
                static int count;
                if ([[requestData valueForKey:@"MSGCODE"] containsString:@"700"]) {
                    count ++;
                    if (count == [self.arrZpCell count]) {
                        [weakSelf.view.window makeToast:@"转派成功" duration:0.5 position:CSToastPositionCenter];
                        count = 0;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
                        [weakSelf btnClear];
                        [self getPublic:0];
                    }
                    [weakSelf btnClosed];               
                 }
            };
        }

    };
}

- (void)grabData{
    NSLog(@"_publicNum==%d",_publicNum);
    if (self.arrZpCell.count == 0) {
        [MBProgressHUD showError:@"请勾选！"];
        return;
    }
//    _view_wg = [[ WG_view alloc] initWithFrame:
//                CGRectMake(0, 0, self.view.frame.size.width-20, self.view.frame.size.height-150)];
//    
//    _view_wg.center = CGPointMake(SCREEN_W/2, self.view.frame.size.height/2);
//    
//    [_view_wg setAlpha:0];
    WS;
//    _view_wg.closed = ^(void){
//        [weakSelf btnClosed];
//    };
//    [self.view addSubview:self.view_block];
//    [self.view addSubview:_view_wg];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        [_view_block setAlpha:0.5];
//        [_view_wg setAlpha:1];
//    }];
//    _view_wg.sendorgid = ^(NSString *str_ordid){
//        MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在转派..." toView:weakSelf.view.window];
    
        NSString* userAccr = @"";
        for (BNOrdeDetailTableCell * cell in weakSelf.arrZpCell) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setValue:cell.model.USER_ACCR forKey:@"userAccr"];
//            [dic setValue:cell.model.SERVICE_TYPE forKey:@"serviceType"];
//            [dic setValue:cell.model.TASK_ID forKey:@"taskId"];
//            [dic setValue:cell.model.POLICY_ID forKey:@"policyId"];
//            [dic setValue:str_ordid forKey:@"orgId"];
//            [dic setValue:[weakSelf judgeOrderType] forKey:@"workOrderType"];
//            NSLog(@"accr===%@",cell.model.USER_ACCR);
            
//            NSLog(@"cell.model==%@", cell.model);
            
            userAccr = [userAccr stringByAppendingString:[NSString stringWithFormat:@",%@",cell.model.USER_ID]];
            
//            NSLog(@"accr1===%@",userAccr);
//            [BNNetworkTool initWitUrl:DataPoolWGDataThreeURL andParameters:dic andStyle:YES].requestData
//            = ^(id requestData){
//                [hud setHidden:YES];
//                static int count;
//                if ([[requestData valueForKey:@"MSGCODE"] containsString:@"700"]) {
//                    count ++;
//                    if (count == [self.arrZpCell count]) {
//                        [weakSelf.view.window makeToast:@"转派成功" duration:0.5 position:CSToastPositionCenter];
//                        count = 0;
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
//                        [weakSelf btnClear];
//                    }
//                    [weakSelf btnClosed];
//                }
//            };
        }
        userAccr = [userAccr substringFromIndex:1];
//        userAccr.sub(1,userAccr.length-1);
        NSLog(@"accr2===%@",userAccr);
        //拼接请求连接
        NSString* strUrl = @"";

        strUrl = [GrabWorkOrderURL stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [LoginModel shareLoginModel].USER_ID, userAccr,[LoginModel shareLoginModel].ORG_MANAGER_TYPE];

    NSLog(@"url9001---%@", strUrl);
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData =
    ^(id requestData){
        NSLog(@"requestData===%@---%@",requestData,requestData[@"COUNT"]);
        if([requestData[@"COUNT"] intValue]==0)
        {
            [MBProgressHUD showError:requestData[@"MSGTexT"]];
        }
        else
        {
            [MBProgressHUD showSuccess:requestData[@"MSGTexT"]];
            [self getPublic:0];
//            [self showRightView];
        }
        [self btnClear];
//        if(_flagLR==0)
//        {
//            self.myarrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
//            [self.mytableView reloadData];
//        }else
//        {
//            self.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
//            [self.tableView reloadData];
//            [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.3];
//        }
        
    };
//    };
}

- (void)refreshDataGrab{
//    NSLog(@"url99---%@", self.url);
    NSString* strUrl = @"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* pagecount = [defaults objectForKey:@"pagecountright"];
    
    if([[self judgeUrl] rangeOfString:@"getThreeHeartUserGrabList"].location !=NSNotFound)
    {
        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], pagecount, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    }
    else
    {
        strUrl = [[self judgeUrl] stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], pagecount, [self.params objectForKey:@"pageSize"], @"-1", @"-1", @"-1", @"-1"];
    }
    NSLog(@"url99---%@", strUrl);
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData =
    ^(id requestData){
        if(_flagLR==0)
        {
            self.myarrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
            [self.mytableView reloadData];
        }else
        {
            self.arrModel = (NSMutableArray *)[BNOrderDetailModel objectArrayWithKeyValuesArray:requestData[@"RESULT"]];
            [self.tableView reloadData];
//            [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.3];
        }

    };
}

- (NSString *)judgeOrderType{
    
    int flag = [[[NSUserDefaults standardUserDefaults] valueForKey:@"model"] intValue];
    
    switch (flag) {
        case 0:
            return @"DP_WORKORDER_TYPE_SAN"; //三心
            break;
        case 1:
            return @"DP_WORKORDER_TYPE_DEVCHANCE"; //发展
            break;
        case 2:
            return @"DP_WORKORDER_TYPE_SAN_ITEM"; //条目
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)btnClear{
    [self.arrZpCell removeAllObjects];
}

- (void)viewWillLayoutSubviews{
    self.tableView.height = self.view.height - 50;
    self.tableView.width = self.view.width;
    self.selectView.y = self.tableView.y + self.tableView.height;
    self.selectView.x = 0;
    self.selectView.height = 49;
    self.selectView.width = self.view.width;
}

-(void)btnClosed{
    [_view_wg removeFromSuperview];
    [_view_block removeFromSuperview];
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.nibScrollView.frame.size.width;
    int page = floor((self.nibScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    pageControl.currentPage = page;
    currentPage = page;
    pageControlUsed = NO;
    [self btnActionShow];
}

- (void) btnActionShow
{
    if (currentPage == 0) {
        [self couponButtonAction];
    }
    else{
        [self groupbuyButtonAction];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //暂不处理 - 其实左右滑动还有包含开始等等操作，这里不做介绍
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"详情--dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

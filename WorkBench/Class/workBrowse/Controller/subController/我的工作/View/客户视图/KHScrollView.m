//
//  KHScrollView.m
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "dataModel.h"
#import "ThreeKHModel.h"
#import "FourKHModel.h"
#import "loginModel.h"
#import "KHScrollView.h"
#define Frame  self.frame
#import "MBProgressHUD.h"
@interface KHScrollView()
@property (nonatomic,strong) NSMutableArray *arrFlag;
@property (nonatomic,strong) NSMutableArray *group;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSMutableArray *item;
@property (nonatomic,strong) NSMutableArray *arrCellDate;
@property (nonatomic,strong) NSMutableDictionary *dicCellDate;
@end

@implementation KHScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _arrPoint = [NSMutableArray array];
        _arrCellDate = [NSMutableArray array];
        __weak KHScrollView *sc = self;
        _change = ^(int i){
            if (i != 0) {
                sc.hud = [MBProgressHUD showMessage:@"加载中..." toView:sc];
                [sc getdateByTag:i];

            }
            CGPoint point = CGPointFromString([sc.arrPoint objectAtIndex:i]);

            [UIView animateWithDuration:0.5 animations:^{
                [sc.changeView setCenter:point];
            } completion:nil];
            

                };
        [self setTopView];
    }
    return self;
}

- (NSMutableArray *)arrFlag{
    if (!_arrFlag ) {
        _arrFlag = [NSMutableArray arrayWithCapacity:1];
    }
    
    return _arrFlag;
}



- (NSMutableArray *)group{
    if (!_group) {
        _group = [NSMutableArray array];
    }
    return _group;
    
}

- (NSMutableArray *)item{
    if (!_item) {
        _item = [NSMutableArray array];
    }
    return _item;

}
- (void)getdateByTag:(int)tag{
  
    NSString *str = tag == 1?Getcustomerdetailtwo:tag == 2?Getcustomerdetailthree:Getcustomerdetailfour;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",str,/*@"61081322"*/[LoginModel shareLoginModel].orderDetail.USER_ID,[LoginModel shareLoginModel].LATEST_ACC_MON]];
    if (tag == 3){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",str,[LoginModel shareLoginModel].orderDetail.USER_ID]];
    }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        NSOperationQueue *queue=[NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self.hud setHidden:YES];
           
            self.item = content[@"RESULT"];
            if (!self.item.count) {
                [self makeToast:@"暂无数据" duration:0.5f position:CSToastPositionCenter];
                return ;
            }
            self.grouModel = nil;
            for(UIView *obj in self.scrollView.subviews){
                if ([obj isKindOfClass:[UITableView class]]&& obj.tag == tag) {
                    [(UITableView *)obj reloadData];
                }
            }
            if (self.sendData) {
                self.sendData(content);
            }
        }];
    }
    


- (void)setTopView{
    CGFloat space = 5;
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = (self.frame.size.width-space*5)/4;
    CGFloat H = 5;
    for(int i = 0 ;i<4 ; i++){
        
        X = i*W + space*(i+1);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [view setBackgroundColor:[UIColor colorWithRed:187.0/255 green:232.0/255 blue:249.0/255 alpha:1]];
        [self addSubview:view];
        CGPoint centerPoint = CGPointMake(view.frame.origin.x+view.frame.size.width/2, view.frame.origin.y + view.frame.size.height/2);
        [_arrPoint addObject:NSStringFromCGPoint(centerPoint)];
        if (i == 0) {
            self.changeView = [[UIView alloc] initWithFrame:view.frame];
            [self.changeView setBackgroundColor:[UIColor colorWithRed:0 green:122/255.0 blue:255/255.0 alpha:1]];
            
        }
    }
    [self addSubview:_changeView];
    [self setBotView];

    
}

- (KHGroupModel *)grouModel{
    if (!_grouModel) {
        _grouModel = [[KHGroupModel alloc] init];
        for (int i = 0; i < self.item.count ; i++) {
            if([self.item[i] allKeys].count == 7){
            KHCellModel *model = [KHCellModel initKHCellModel:self.item[i]];
             [_grouModel.arrCellModel addObject:model];
            } else if ([self.item[i] allKeys].count == 5){
                ThreeKHModel *model = [ThreeKHModel initKHCellModel:self.item[i]];
                [_grouModel.arrCellModel addObject:model];
            } else if ([self.item[i] allKeys].count == 4){
                FourKHModel *model = [FourKHModel initKHCellModel:self.item[i]];
                [_grouModel.arrCellModel addObject:model];
            }
        }
    }
    
    return _grouModel;
}

- (void)setBotView{

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.changeView.frame)+5, Frame.size.width-10, Frame.size.height-CGRectGetMaxY(self.changeView.frame)-5)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];

    for (int i = 0; i<4; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width *i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [self.scrollView addSubview:view];
        [view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"p%d",i + 1]]];
        if(i != 0){
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-65, 15 +i, 70, 30)];
            [view addSubview:lab];
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = [UIColor blackColor];
            if (i != 3)
                lab.text = [LoginModel shareLoginModel].LATEST_ACC_MON;
            
            UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width*i+8, 60, self.scrollView.frame.size.width-15, self.scrollView.frame.size.height - 55) style:UITableViewStylePlain];
            table.tag = i;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.delegate = self;
            table.dataSource = self;
            [self.scrollView addSubview:table];
        }
    }
    //加载滚动视图
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*4, self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    
    //加载个人信息
    _personView = [[PersonView alloc] initWithFrame:CGRectMake(10, self.scrollView.frame.origin.y+50, self.scrollView.frame.size.width-20, self.scrollView.frame.size.height-20)];
    [self.scrollView addSubview:_personView];
    
    
}

- (void)setDicPerson:(id )dicPerson{
    _dicPerson = dicPerson;
    _personView.dicPerson= self.dicPerson;

}

- (void)setModel{
    
}

#pragma mark --scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    static int count = -1;
    
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        NSLog(@"3....%f",scrollView.contentOffset.x);
        CGFloat EndContentOffX;
        EndContentOffX = scrollView.contentOffset.x;
        int index = EndContentOffX/(self.frame.size.width -10);
        if (count != index) {
            count = index;
            if ( self.change) {
                self.change(index);
            }
        }
        

    }
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
}

#pragma mark --tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.item.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    KHTableViewCell *cell = [KHTableViewCell cellWithTableView:tableView];
    if (tableView.tag == 3) {
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 80)];
    }
    cell.cellModel = self.grouModel.arrCellModel[indexPath.section];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 3) {
        return  80;
    }
    return 70;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection
                      :(NSInteger)section{
    KHCellModel *model = self.grouModel.arrCellModel[section];
    NSString * title = model.text_head;
    return title;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lab = [[UILabel alloc] init];
    KHCellModel *model = self.grouModel.arrCellModel[section];
    lab.text = model.text_head;
    [lab setBackgroundColor:[UIColor clearColor]];
    lab.font = [UIFont systemFontOfSize:14];
    return lab;
}




@end

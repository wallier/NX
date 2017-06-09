//
//  Tools.m
//  WorkBench
//
//  Created by wouenlone on 16/8/18.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "Tools.h"
@interface Tools()
@property (nonatomic, assign) int markTimes;
@end
@implementation Tools
static Tools *tool = nil;
+ (instancetype)sharedGestVisitTools
{
   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[super allocWithZone:NULL] init];
    });
    return tool;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [Tools sharedGestVisitTools];
}

- (id) copyWithZone:(struct _NSZone *)zone
{
    return [Tools sharedGestVisitTools];
}



- (void)setBackgroundImageWithView:(UIView *)view
{
   
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];

}

//给一个view 下边沿描边
- (UIView *) marginOfViewAtBottm:(UIView *)view withColor:(UIColor *)color width:(NSInteger) width
{
    CALayer *bottom = [CALayer layer];
    if (view.tag == 4) {
        bottom.frame = CGRectMake(20, view.frame.size.height-width, view.frame.size.width-40, width);
    }else if (view.tag ==  20){
        bottom.frame = CGRectMake(80, view.frame.size.height-width, view.frame.size.width-80, width);
        CALayer *white = [CALayer layer];
        white.frame = CGRectMake(0, view.frame.size.height-width, 80, width);
        white.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [view.layer addSublayer:white];
    }else{
    bottom.frame = CGRectMake(20, view.frame.size.height-width, view.frame.size.width-40, width);
    }
    bottom.backgroundColor = color.CGColor;
    [view.layer addSublayer:bottom];
    
    return view;
}
- (NSString *)getOperatorNameByOPERATOR_TYPEinParam:(NSString *)OPERATOR_TYPE
{
    if ([OPERATOR_TYPE isEqualToString:@"1"]) {
        return @"电信";
    }else if ([OPERATOR_TYPE isEqualToString:@"2"]){
        return @"移动";
    }else if ([OPERATOR_TYPE isEqualToString:@"3"]){
        return @"联通";
    }else if ([OPERATOR_TYPE isEqualToString:@"4"]){
        return @"广电";
    }else {
         return @"未知";
    }
    NSLog(@"Tools 中无对应转换");
    return nil;
}

- (NSString *)getOPERATOR_TYPEinParamByOperatorName:(NSString *)operatorName
{
    if ([operatorName isEqualToString:@"电信"]) {
        return @"1";
    }else if ([operatorName isEqualToString:@"移动"]){
        return @"2";
    }else if ([operatorName isEqualToString:@"联通"]){
        return @"3";
    }else if ([operatorName isEqualToString:@"广电"]){
        return @"4";
    } else {
        return @"5";

    
    }
    NSLog(@"Tools 中无对应转换");
    return nil;
}

- (NSString *)getProductNameByPRODUCT_TYPEinParam:(NSString *)PRODUCT_TYPE
{
    if ([PRODUCT_TYPE isEqualToString:@"1"]) {
        return @"固话";
    }else if ([PRODUCT_TYPE isEqualToString:@"2"]){
        return @"宽带";
    }else if ([PRODUCT_TYPE isEqualToString:@"3"]){
        return @"手机";
    }else if ([PRODUCT_TYPE isEqualToString:@"4"]){
        return @"IPTV";
    }
    NSLog(@"Tools 中无对应转换");
    return nil;

}

- (NSString *)getPRODUCT_TYPEinParamByProductName:(NSString *)ProductName
{
    if ([ProductName isEqualToString:@"固话"]) {
        return @"1";
    }else if ([ProductName isEqualToString:@"宽带"]){
        return @"2";
    }else if ([ProductName isEqualToString:@"手机"]){
        return @"3";
    }else if ([ProductName isEqualToString:@"IPTV"]){
        return @"4";
    }
    NSLog(@"Tools 中无对应转换");
    return nil;
}

-(void)testSpendTimeWithFunctionName:(NSString *)functionName
{
    self.markTimes +=1;
    NSDate *date = [NSDate date];
    NSLog(@"%@方法调用%@----总次数：%d",functionName,date,self.markTimes);
}
@end

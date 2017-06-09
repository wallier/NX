//
//  BNWaterMark.m
//  WorkBench
//
//  Created by wanwan on 16/10/13.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNWaterMark.h"

@implementation BNWaterMark

+ (UIImage *)getwatermarkImage
{
    UIImage *img = [UIImage imageNamed:@"bg.png"];
    NSString* mark = [NSString stringWithFormat:@"%@.%@",[LoginModel shareLoginModel].NAME, [LoginModel shareLoginModel].USER_NAME];
    
    int w = img.size.width;
    
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    NSDictionary *attr = @{
                           
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],  //设置字体
                           
                           NSForegroundColorAttributeName : RGB(237, 237, 237)   //设置字体颜色
                           
                           };
    
    [mark drawInRect:CGRectMake(10, 180, w, 20) withAttributes:attr];         //左上角
    
    [mark drawInRect:CGRectMake(w/2-20 ,50 ,w , 20) withAttributes:attr];      //右上角
    
    [mark drawInRect:CGRectMake(w/2+20, h -200 ,w , 20) withAttributes:attr];  //右下角
    
    [mark drawInRect:CGRectMake(100, h -20 -50 ,w , 20) withAttributes:attr];    //左下角
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return aimg;
    
}
@end

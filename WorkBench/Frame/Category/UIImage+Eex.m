//
//  UIImage+Eex.m
//  WorkBench
//
//  Created by xiaos on 15/12/4.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "UIImage+Eex.h"

@implementation UIImage (Eex)

+ (UIImage*)setStretchImg:(NSString*)imgName
{
    UIImage *bgImg = [UIImage imageNamed:imgName];
    bgImg = [bgImg stretchableImageWithLeftCapWidth:bgImg.size.width/2 topCapHeight:bgImg.size.height/2];
    
    return bgImg;
}


@end

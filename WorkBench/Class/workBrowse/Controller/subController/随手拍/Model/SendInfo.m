//
//  SendInfo.m
//  发微博界面1
//
//  Created by xiaos on 15/11/24.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import "SendInfo.h"

#import "MLSelectPhotoAssets.h"

#import "NSString+CGSize.h"

@implementation SendInfo

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;

    if (!photos) {
        _image_names = @"";
        _image_num = @"0";
        return;
    }
    /** 服务端非要上传图片名字
     还要在名字之间加逗号
     然后还要把图片数据用另一个接口上传 日🐶日🐶!! */
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyMMddHHmmss";
    NSString *publishTime = [fmt stringFromDate:[NSDate date]];
    
    NSMutableArray *imageNames = [NSMutableArray array];
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *imagesDataArr = [NSMutableArray array];
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MLSelectPhotoAssets class]]) {
            UIImage *image = [obj originImage];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1f);
            [imagesDataArr addObject:imageData];
        }else {
            NSData *imageData = UIImageJPEGRepresentation(obj, 0.1f);
            [imagesDataArr addObject:imageData];
        }
        NSString *md5Str = [[NSString stringWithFormat:@"%@%ld",publishTime,(unsigned long)idx] md5String];
        
        NSString *tempImageName = [NSString stringWithFormat:@"%@.jpeg",md5Str];
        [tempArr addObject:tempImageName];
        NSString *imageName = [NSString stringWithFormat:@"%@.jpeg,",md5Str];
        [imageNames addObject:imageName];
        
        _image_num = [NSString stringWithFormat:@"%ld",(unsigned long)idx+1];
    }];
    
    _imageNameArr = tempArr;
    
    [[NSUserDefaults standardUserDefaults] setObject:imagesDataArr forKey:@"imagesDataArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    __block NSString *tempStr = @"";
    [imageNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        tempStr = [NSString stringWithFormat:@"%@%@",tempStr,obj];
    }];
    _image_names = [tempStr substringToIndex:tempStr.length - 1]; //日了🐶的服务端
}

- (NSString *)user_id
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (userId) {
        return userId;
    }
    return @"unkownId";
}


- (NSString *)user_name
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    if (userName) {
        return userName;
    }
    return @"unkownUserName";
}

- (NSString *)publish_time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm";
    NSString *publishTime = [fmt stringFromDate:[NSDate date]];
    
    return publishTime;
}

- (NSString *)phone_brand
{
    NSString *phoneTypeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneType"];
    if (!phoneTypeStr) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString phoneType] forKey:@"phoneType"];
        return [NSString phoneType];
    }else {
        return phoneTypeStr;
    }
    
}

@end

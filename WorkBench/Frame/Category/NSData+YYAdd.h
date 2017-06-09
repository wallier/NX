//
//  NSData+YYAdd.h
//  WorkBench
//
//  Created by xiaos on 15/12/9.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <zlib.h>

@interface NSData (YYAdd)

- (NSString *)md5String;

@end

//
//  PhotoCell.m
//  发微博界面1
//
//  Created by xiaos on 15/11/23.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (IBAction)deleteBuutonTapped:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

@end

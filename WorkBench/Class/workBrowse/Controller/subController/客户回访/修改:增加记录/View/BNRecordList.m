//
//  BNRecordList.m
//  WorkBench
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNRecordList.h"

@implementation BNRecordList

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [self.data[indexPath.row] allKeys][0];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sendList) {
        self.sendList(self.data[indexPath.row]);
    }
}

@end

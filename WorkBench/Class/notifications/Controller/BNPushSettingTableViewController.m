//
//  BNPushSettingTableViewController.m
//  WorkBench
//
//  Created by wanwan on 16/10/19.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNPushSettingTableViewController.h"

@interface BNPushSettingTableViewController ()
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@end

@implementation BNPushSettingTableViewController

//- (NSUserDefaults *)userdefaults {
//    if (!_userdefaults) {
//        _userdefaults = [NSUserDefaults standardUserDefaults];
//    }
//    return _userdefaults;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送设置";
    self.tableView.scrollEnabled = NO;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    _userdefaults = userdefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *identifer = @"pushSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identifer];
     //    add a switch

    }
    // Configure the cell...
    UISwitch *swh = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_W-60, 10, 30, 10)];
    [swh addTarget:self action:@selector(swithAction:) forControlEvents:UIControlEventValueChanged];
    //[swh setOn:YES];
    cell.accessoryView = swh;
    swh.tag = 90000+indexPath.row;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"发展快报：";
        if (swh.tag == 90000) {
            [swh setOn:[_userdefaults boolForKey:@"fastNews"]];
            NSLog(@"----%d",[_userdefaults boolForKey:@"fastNews"]);
        }
    } else if (indexPath.row == 1) {
        if (swh.tag == 90001) {
            [swh setOn:[_userdefaults boolForKey:@"dailyNews"]];
        }
        cell.textLabel.text = @"发展日报：";
    } else if (indexPath.row == 2) {
        if (swh.tag == 90002) {
            [swh setOn:[_userdefaults boolForKey:@"moonNews"]];
        }
        cell.textLabel.text = @"发展月报：";
    }else if (indexPath.row == 3) {
        if (swh.tag == 90003) {
            [swh setOn:[_userdefaults boolForKey:@"moneypocket"]];
        }
        cell.textLabel.text = @"钱袋子月报：";
    }else {
        if (swh.tag == 90004) {
            [swh setOn:[_userdefaults boolForKey:@"warning"]];
        }
        cell.textLabel.text = @"到期预警：";
    }
  
    return cell;
}

- (void)swithAction:(UISwitch *)sender {
    if (sender.tag == 90000) {
        if (sender.isOn) {
            [_userdefaults setBool:YES forKey:@"fastNews"];
        } else {
            [_userdefaults setBool:NO forKey:@"fastNews"];
        }
        NSLog(@"--Senser.tag---%ld",(long)sender.tag);
    } else if (sender.tag == 90001){
        if (sender.isOn) {
            [_userdefaults setBool:YES forKey:@"dailyNews"];
        } else {
            [_userdefaults setBool:NO forKey:@"dailyNews"];
        }

        NSLog(@"--Senser.tag---%ld",(long)sender.tag);
    } else if (sender.tag == 90002){
        if (sender.isOn) {
            [_userdefaults setBool:YES forKey:@"moonNews"];
        } else {
            [_userdefaults setBool:NO forKey:@"moonNews"];
        }

        NSLog(@"--Senser.tag---%ld",(long)sender.tag);
    }else if (sender.tag == 90003){
        if (sender.isOn) {
            [_userdefaults setBool:YES forKey:@"moneypocket"];
        } else {
            [_userdefaults setBool:NO forKey:@"moneypocket"];
        }

        NSLog(@"--Senser.tag---%ld",(long)sender.tag);
    }else {
        if (sender.isOn) {
            [_userdefaults setBool:YES forKey:@"warning"];
        } else {
            [_userdefaults setBool:NO forKey:@"warning"];
        }

        NSLog(@"--Senser.tag---%ld",(long)sender.tag);
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

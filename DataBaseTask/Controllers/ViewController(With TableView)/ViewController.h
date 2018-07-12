//
//  ViewController.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/9/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditIInfoViewController.h"




@interface ViewController : UIViewController <EditInfoViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewOfTasks;
@property (weak, nonatomic) IBOutlet UILabel *currentTaskLabel;



- (IBAction)addNewRecord:(id)sender;
@end




//
//  ViewController.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/9/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "CustomCell.h"
#import "PopUpViewController.h"
#import "ManagerLayerForCoreDataAndSQLite.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

//mainManager
@property (strong, nonatomic) ManagerLayerForCoreDataAndSQLite* mainManager;

//dataSource
@property (strong, nonatomic) NSArray* dataSourceArrayOfTasks;
@property (nonatomic, assign) int recordIDToEdit;

//popUp
@property (strong, nonatomic) NSString* additionalInfoForAlert;
@property (strong, nonatomic) PopUpViewController* popUpVC;

//data methods
-(void)loadDataFromDataBaseAndRefreshTableWithAnimation:(ActionAnimation)animation;

@end





static NSInteger const kNewRecordID       = -1;
static NSString * const kStorageState     = @"storageTypeControl";
static NSString * cellIdentifier          = @"idCellIdentifier";
static NSString * segueIdentifierEditInfo = @"idSegueEditInfo";
static NSString * seguePopUpIdentidier    = @"showPopUpIdentifier";


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewOfTasks.tableFooterView = [[UIView alloc] init];
    
    self.tableViewOfTasks.delegate = self;
    self.tableViewOfTasks.dataSource = self;
    
    self.currentTaskLabel.layer.cornerRadius = 30;
    self.currentTaskLabel.layer.borderColor = UIColor.darkGrayColor.CGColor;
    self.currentTaskLabel.layer.borderWidth = 2;
    
    [self.deleteAllButton setEnabled:NO];
    [self.deleteAllButton setHidden:YES];
    
    //create main manager and load
    [self loadStorageStateAndCreateDataBaseManager];
    
    //loading data from DB
    [self loadDataFromDataBaseAndRefreshTableWithAnimation:ActionAnimationAdd];
    NSLog(@"Data Source %@",[self.dataSourceArrayOfTasks componentsJoinedByString:@" , "]);
}



#pragma mark Save And Load Storage State
- (void)saveStorageState {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:self.storageTypeControl.selectedSegmentIndex forKey:kStorageState];
    [userDefault synchronize];
}

-(void)loadStorageStateAndCreateDataBaseManager {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.storageTypeControl.selectedSegmentIndex = [userDefault integerForKey:kStorageState];
    self.mainManager = [[ManagerLayerForCoreDataAndSQLite alloc] initWithDataBaseType:
                        self.storageTypeControl.selectedSegmentIndex == 0 ? SQLiteType : CoreDataType];
}


#pragma mark - Actions

- (IBAction)deleteAllAction:(id)sender {
    [self.mainManager deleteAllData];
    [self loadDataFromDataBaseAndRefreshTableWithAnimation:ActionAnimationDelete];
}

- (IBAction)storageAction:(UISegmentedControl*)sender {
    self.mainManager.type = sender.selectedSegmentIndex == 0 ? SQLiteType : CoreDataType;
    [self saveStorageState];
    UITableViewRowAnimation action = sender.selectedSegmentIndex == 0 ? UITableViewRowAnimationRight: UITableViewRowAnimationLeft;
    [self.tableViewOfTasks reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation: action];
    NSLog(@"Storage change to %@", self.storageTypeControl.selectedSegmentIndex == 0 ? @"SQLiteType" : @"CoreDataType");
}


- (IBAction)addNewRecord:(id)sender {
    self.recordIDToEdit = kNewRecordID;
    [self performSegueWithIdentifier:segueIdentifierEditInfo sender:self];  //perform the segue
}


#pragma mark - Loading Data

- (void)loadDataFromDataBaseAndRefreshTableWithAnimation:(ActionAnimation)animation {
    if (self.dataSourceArrayOfTasks!= nil) {
        self.dataSourceArrayOfTasks = nil;
    }
    
    self.dataSourceArrayOfTasks = [self.mainManager fetchAllDataTaskObjects];
    
    if (self.dataSourceArrayOfTasks.count == 0) {
        [self.deleteAllButton setEnabled:NO];
        [self.deleteAllButton setHidden:YES];
        self.currentTaskLabel.text = @"No Tasks";
    } else {
        [self.deleteAllButton setEnabled:YES];
        [self.deleteAllButton setHidden:NO];
        //[self.deleteAllButton.titleLabel.text = @"Delete: %lu",(unsigned long)self.dataSourceArrayOfTasks.count;
        [self.deleteAllButton setTitle:[NSString stringWithFormat:@"Delete: %lu",(unsigned long)self.dataSourceArrayOfTasks.count] forState:UIControlStateNormal];
    }
    
    UITableViewRowAnimation action;
    if (animation == ActionAnimationAdd) {
        action = UITableViewRowAnimationFade;
    } else {
        action = UITableViewRowAnimationLeft;
    }
    [self.tableViewOfTasks reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:action];
}



#pragma mark - EditInfoViewControllerDelegate

- (void)editngInfoWasFinished {
   [self loadDataFromDataBaseAndRefreshTableWithAnimation:ActionAnimationAdd];
    NSLog(@"reload table with NEW DATASOURCE: \n%@ \nnumber of elements = %lu",
          [self.dataSourceArrayOfTasks componentsJoinedByString:@"\n"],
          [self.dataSourceArrayOfTasks count]);
}



#pragma mark - Navigation
//SETTING DELEGATE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:segueIdentifierEditInfo]) {
        EditIInfoViewController *editInfoController = [segue destinationViewController];
        editInfoController.delegate = self;
        editInfoController.recordIDToEdit = self.recordIDToEdit;
        editInfoController.mainManager.type = self.mainManager.type;
   
    } else if ([segue.identifier isEqualToString:seguePopUpIdentidier]) {
        self.popUpVC = [segue destinationViewController];
    }
    
}



#pragma mark - UItableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArrayOfTasks.count;
}



- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //dequeue the cell
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.priorityView.layer.cornerRadius = 40;
    
    TaskObject *task = [[TaskObject alloc] init];
    task.iD                 = [(TaskObject*)[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] iD];
    task.taskTitle          = [(TaskObject*)[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] taskTitle];
    task.taskAdditionalInfo = [(TaskObject*)[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] taskAdditionalInfo];
    task.taskPriority       = [(TaskObject*)[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] taskPriority];
    task.taskDate           = [(TaskObject*)[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] taskDate];

    //setting the data to cell label
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",task.taskTitle];
    cell.additionalInfo = task.taskAdditionalInfo;
    //set priority
    [self setPriority:task.taskPriority.integerValue ForCell:cell];
    
    //date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    cell.dateLabel.text = [dateFormatter stringFromDate:task.taskDate];

    NSLog(@"reuse cell add text - %@", cell.additionalInfo);
    
    return cell;
}


-(void)setPriority:(NSInteger)priority ForCell:(CustomCell*)cell {
    NSString *priorityString;
    switch (priority) {
        case 0:
            priorityString = @"High";
            [self changePriorityColor:0 forCell:cell];
            break;
        case 1:
            priorityString = @"Normal";
            [self changePriorityColor:1 forCell:cell];
            break;
        case 2:
            priorityString = @"Low";
            [self changePriorityColor:2 forCell:cell];
        default:
            break;
    }
    cell.priorityLabel.text = [NSString stringWithFormat:@"Priority: %@",priorityString];
}


-(void)changePriorityColor:(NSInteger)priority forCell:(CustomCell*)cell{
    switch (priority) {
        case 0:
            cell.priorityView.backgroundColor = UIColor.redColor;
            break;
        case 1:
            cell.priorityView.backgroundColor = UIColor.yellowColor;
            break;
        case 2:
            cell.priorityView.backgroundColor = UIColor.greenColor;
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Data Source array %@", [self.dataSourceArrayOfTasks componentsJoinedByString:@"-"]);
    
    // Get the record ID of the selected name and set it to the recordIDToEdit property
    TaskObject* task = [self.dataSourceArrayOfTasks objectAtIndex:indexPath.row];
    self.recordIDToEdit = [task.iD intValue];
    
    //perform the segue
    [self performSegueWithIdentifier:segueIdentifierEditInfo sender:self];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentTaskLabel.text = [(CustomCell*)[tableView cellForRowAtIndexPath:indexPath] titleLabel].text;
    NSLog(@"Select row number %li",(long)indexPath.row);
    self.popUpVC.textInfoTextView.text = [(CustomCell*)[tableView cellForRowAtIndexPath:indexPath] additionalInfo];
    NSLog(@"popUp Text %@",self.popUpVC.textInfoTextView.text);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIContextualAction * complete =
    [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                            title:@"Complete"
                                          handler:^(UIContextualAction *  action,  UIView *  sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                                              TaskObject* task = (TaskObject*)[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row];
                                              [self.mainManager deleteData:task];
                                              [self loadDataFromDataBaseAndRefreshTableWithAnimation:ActionAnimationDelete];
                                              completionHandler(YES);
                                              if (self.dataSourceArrayOfTasks.count == 0) {
                                                  [TaskObject resetID];
                                              }
                                          }];
    complete.backgroundColor = UIColor.orangeColor;

    UISwipeActionsConfiguration *swipe = [UISwipeActionsConfiguration configurationWithActions:@[complete]];
    return swipe;
}



@end














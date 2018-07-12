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


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) DBManager *dbManager;

//dataSource
@property (strong, nonatomic) NSArray* dataSourceArrayOfTasks;
@property (nonatomic, assign) int recordIDToEdit;

//popOver
@property (strong, nonatomic) NSString* additionalInfoForAlert;
@property (strong, nonatomic) PopUpViewController* popUpVC;

//data methods
-(void)loadData;

@end



static NSString* cellIdentifier = @"idCellIdentifier";
static NSString* segueIdentifierEditInfo = @"idSegueEditInfo";
static NSString* seguePopUpIdentidier = @"showPopUpIdentifier";


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewOfTasks.delegate = self;
    self.tableViewOfTasks.dataSource = self;
    
    self.currentTaskLabel.layer.cornerRadius = 30;
    self.currentTaskLabel.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.currentTaskLabel.layer.borderWidth = 0.5f;
    
    //load DB
    self.dbManager = [[DBManager alloc] initWithDataBaseFileName:@"tasksDB.db"];
    
    //loading data from DB
    [self loadData];
    
    NSLog(@"Data Source %@",[self.dataSourceArrayOfTasks componentsJoinedByString:@" , "]);
}



#pragma mark - Actions

- (IBAction)addNewRecord:(id)sender {
    
    // setting -1 value to the recordIDToEdit to add a new record
    self.recordIDToEdit = -1;

    //perform the segue
    [self performSegueWithIdentifier:segueIdentifierEditInfo sender:self];
}



#pragma mark - Loading Data

- (void)loadData {

    NSString* loadDataQuery = @"select * from Tasks;";
    
    //get the results
    if (self.dataSourceArrayOfTasks!= nil) {
        self.dataSourceArrayOfTasks = nil;
    }
    
    self.dataSourceArrayOfTasks = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:loadDataQuery]];
    
    //reload the table view
    [self.tableViewOfTasks reloadData];
    
}



#pragma mark - EditInfoViewControllerDelegate
- (void)editngInfoWasFinished {
   //reload the data
   [self loadData];
    NSLog(@"reload table with NEW data: \n%@ \nnumber of elements = %lu",[self.dataSourceArrayOfTasks componentsJoinedByString:@"\n"],
                                                                           [self.dataSourceArrayOfTasks count]);
}




#pragma mark - Navigation
//SETTING DELEGATE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:segueIdentifierEditInfo]) {
        EditIInfoViewController *editInfoController = [segue destinationViewController];
        editInfoController.delegate = self;
        editInfoController.recordIDToEdit = self.recordIDToEdit;
   
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
    
    NSInteger indexOfTaskTitle = [self.dbManager.arrColumnNames indexOfObject:@"taskTitle"];
    NSInteger indexOfPriority = [self.dbManager.arrColumnNames indexOfObject:@"taskPriority"];
    NSInteger indexOfAdditionalInfo = [self.dbManager.arrColumnNames indexOfObject:@"taskAdditionalInfo"];
    NSInteger indexOfDate = [self.dbManager.arrColumnNames indexOfObject:@"date"];
    
    //if cell not created
    if (!cell) {
        cell = [[CustomCell alloc] init];
        NSLog(@"new cell created %ld",(long)indexPath.row);
        return cell;
    }
    
    //setting the data to cell label
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",
                           [[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] objectAtIndex:indexOfTaskTitle]];
   
    //priority
    NSNumber *priorityNumber = (NSNumber*)[[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] objectAtIndex:indexOfPriority];
    NSString *priority;
    switch (priorityNumber.integerValue) {
        case 0:
            priority = @"High";
            [self changePriorityColor:0 forCell:cell];
            break;
        case 1:
            priority = @"Normal";
            [self changePriorityColor:1 forCell:cell];
            break;
        case 2:
            priority = @"low";
            [self changePriorityColor:2 forCell:cell];
        default:
            break;
    }
    
    cell.priorityLabel.text = [NSString stringWithFormat:@"Priority: %@",priority];

    //date
    NSNumber* numberWithDate = (NSNumber*)[[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] objectAtIndex:indexOfDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[numberWithDate doubleValue]];
    
    cell.dateLabel.text = [dateFormatter stringFromDate:date];
    
    //additionalInfo
    //popup info
    
    NSString* newInfo = [NSString stringWithFormat:@"%@",
                                 [[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row]
                                  objectAtIndex:indexOfAdditionalInfo]];
    cell.additionalInfo = newInfo;

    NSLog(@"add text - %@", cell.additionalInfo);
    
    return cell;
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
    return 50.0;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property
    self.recordIDToEdit = [[[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    //perform the segue
    [self performSegueWithIdentifier:segueIdentifierEditInfo sender:self];
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //delete the selected record
        //find the record ID
        int recordIDToDelete = [[[self.dataSourceArrayOfTasks objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        NSString *deleteQeuery = [NSString stringWithFormat:@"delete from Tasks where taskID = %d", recordIDToDelete];
        
        //execute the query
        [self.dbManager executeQuery:deleteQeuery];
        
        //reload table
        [self loadData];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.currentTaskLabel.text = cell.titleLabel.text;
    NSLog(@"Select row number %li",(long)indexPath.row);
    
    self.popUpVC.textInfoTextView.text = cell.additionalInfo;
    NSLog(@"opopopop %@",self.popUpVC.textInfoTextView.text);

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end

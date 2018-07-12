//
//  EditIInfoViewController.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/9/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "EditIInfoViewController.h"




@interface EditIInfoViewController ()

@end



@implementation EditIInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    self.titleOfTaskTextField.delegate = self;
    
    
    //customize TextView
    self.additionalInfoTextView.layer.cornerRadius = 10;
    self.additionalInfoTextView.layer.borderWidth = 1;
    self.additionalInfoTextView.layer.borderColor = UIColor.lightGrayColor.CGColor;
   
    //db create connection
    self.dbManager = [[DBManager alloc] initWithDataBaseFileName:@"tasksDB.db"];
    
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
}


- (IBAction)saveInfo:(id)sender {
    //prepare the query string
    NSString *query;
    
    [self.datePicker.date timeIntervalSince1970];
    
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    if (self.recordIDToEdit == -1) {
        NSLog(@"Segmented = %ld",(long)self.priorityControl.selectedSegmentIndex);
        query = [NSString stringWithFormat:@"insert into Tasks values(null, '%@', '%@', %ld, '%f')",
                 self.titleOfTaskTextField.text,
                 self.additionalInfoTextView.text,
                 (long)self.priorityControl.selectedSegmentIndex, [self.datePicker.date timeIntervalSince1970]];
        NSLog(@"Insert Query");
        
    } else {
        
        query = [NSString stringWithFormat:@"update Tasks set taskTitle = '%@', taskAdditionalInfo = '%@', taskPriority = %ld, date = '%f' where taskID = %d",
                 self.titleOfTaskTextField.text, self.additionalInfoTextView.text,
                 (long)self.priorityControl.selectedSegmentIndex, [self.datePicker.date timeIntervalSince1970], self.recordIDToEdit];
        NSLog(@"Update Query");
    }
    
    //execute the query
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed succesfully, AffectedRows = %d", self.dbManager.affectedRows);
        
        //inform the delegate that editing was finished
        [self.delegate editngInfoWasFinished];
        
        //pop the viewController
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"Could not execute the query");
    }
}

- (void)loadInfoToEdit {
    //create the Query
    
    NSString* query = [NSString stringWithFormat:@"select * from Tasks where taskID = %d",self.recordIDToEdit];
    
    //laod data
    NSArray* resultData = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSInteger indexOfTaskTitle = [self.dbManager.arrColumnNames indexOfObject:@"taskTitle"];
    NSInteger indexOfAdditionalInfo = [self.dbManager.arrColumnNames indexOfObject:@"taskAdditionalInfo"];
    NSInteger indexOfPriority = [self.dbManager.arrColumnNames indexOfObject:@"taskPriority"];
    NSInteger indexOfDate = [self.dbManager.arrColumnNames indexOfObject:@"date"];
    
    //set the loaded data to textFields
    self.titleOfTaskTextField.text = [NSString stringWithFormat:@"%@", [[resultData objectAtIndex:0] objectAtIndex:indexOfTaskTitle]];
    self.additionalInfoTextView.text = [NSString stringWithFormat:@"%@", [[resultData objectAtIndex:0] objectAtIndex:indexOfAdditionalInfo]];
    
    NSNumber *priorityNumber = (NSNumber*)[[resultData objectAtIndex:0] objectAtIndex:indexOfPriority];
    [self.priorityControl setSelectedSegmentIndex:[priorityNumber integerValue] ];
    
    //date
    NSNumber* numberWithDate = (NSNumber*)[[resultData objectAtIndex:0]objectAtIndex:indexOfDate];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[numberWithDate doubleValue]];
    NSLog(@"DATE!!!!!!");
    self.datePicker.date = date;
    
}



#pragma mark - TextFiledDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}


@end

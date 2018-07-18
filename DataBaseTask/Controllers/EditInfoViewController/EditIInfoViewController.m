//
//  EditIInfoViewController.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/9/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "EditIInfoViewController.h"
#import "TaskObject.h"





@interface EditIInfoViewController ()

@end



@implementation EditIInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    self.titleOfTaskTextField.delegate = self;
    self.additionalInfoTextView.delegate = self;
    
    //customize TextView
    self.additionalInfoTextView.layer.cornerRadius = 10;
    self.additionalInfoTextView.layer.borderWidth = 0.5;
    self.additionalInfoTextView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    
    //customize titleTextfield
    self.titleOfTaskTextField.layer.cornerRadius = 10;
    self.titleOfTaskTextField.layer.borderWidth = 0.5;
    self.titleOfTaskTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
    
    //customize date picker
    [self.datePicker setValue:UIColor.whiteColor forKey:@"textColor"];
   
    //create main manager
    
    [self createMainManagerWithIndexType:0];
    
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
}

-(void)createMainManagerWithIndexType:(NSInteger)type {
    if (type == 0) {
        self.mainManager = [[ManagerLayerForCoreDataAndSQLite alloc] initWithDataBaseType:SQLiteType];
    } else {
        self.mainManager = [[ManagerLayerForCoreDataAndSQLite alloc] initWithDataBaseType:CoreDataType];
    }
}


- (IBAction)saveInfo:(id)sender {
    
    [self.datePicker.date timeIntervalSince1970];
    TaskObject* task = [[TaskObject alloc] init];
    
    task.iD                 = [NSNumber numberWithInteger:self.recordIDToEdit];
    task.taskTitle          = self.titleOfTaskTextField.text;
    task.taskAdditionalInfo = self.additionalInfoTextView.text;
    task.taskPriority       = [NSNumber numberWithInteger: self.priorityControl.selectedSegmentIndex];
    task.taskDate           = self.datePicker.date;
    
    if (self.recordIDToEdit == -1) {
        [self.mainManager addData:task];
    } else {
        [self.mainManager updateData:task];
    }

    //inform the delegate that editing was finished
    [self.delegate editngInfoWasFinished];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)loadInfoToEdit {
    TaskObject *task = [self.mainManager fetchTaskObjectWithID:[NSNumber numberWithInteger:self.recordIDToEdit]];
    self.titleOfTaskTextField.text = task.taskTitle;
    self.additionalInfoTextView.text = task.taskAdditionalInfo;
    [self.priorityControl setSelectedSegmentIndex:[task.taskPriority integerValue]];
    self.datePicker.date = task.taskDate;
}





#pragma mark - TextFiledDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"enter");
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    NSLog(@"text view enter");
    return YES;
}

@end

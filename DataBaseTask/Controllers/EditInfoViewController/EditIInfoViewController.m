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


static NSInteger const kNewRecordID = -1;



@implementation EditIInfoViewController

-(void)loadView {
    [super loadView];
    self.navigationController.navigationBar.tintColor =
    self.navigationItem.rightBarButtonItem.tintColor;
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
    if (self.recordIDToEdit != kNewRecordID) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.titleOfTaskTextField becomeFirstResponder];
}


#pragma mark - Data Operations

-(void)createMainManagerWithIndexType:(NSInteger)type {
    if (type == 0) {
        self.mainManager = [[ManagerLayerForCoreDataAndSQLite alloc] initWithDataBaseType:SQLiteType];
    } else {
        self.mainManager = [[ManagerLayerForCoreDataAndSQLite alloc] initWithDataBaseType:CoreDataType];
    }
}


- (IBAction)saveDataAction:(id)sender {
    
    if (self.recordIDToEdit == kNewRecordID) {
        TaskObject* task = [[TaskObject alloc] initWithId];
        NSLog(@"task ID = %@",task.iD);
        [self setDataToTask:task];
        [self.mainManager addData:task];
        
    } else {
        TaskObject* task = [[TaskObject alloc] init];
        task.iD = [NSNumber numberWithInteger:self.recordIDToEdit];
        [self setDataToTask:task];
        [self.mainManager updateData:task];
    }

    //inform the delegate that editing was finished
    [self.delegate editngInfoWasFinished];
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)setDataToTask:(TaskObject*)task {
    task.taskTitle          = self.titleOfTaskTextField.text;
    task.taskAdditionalInfo = self.additionalInfoTextView.text;
    task.taskPriority       = [NSNumber numberWithInteger: self.priorityControl.selectedSegmentIndex];
    task.taskDate           = self.datePicker.date;
}


- (void)loadInfoToEdit {
    TaskObject *task = [self.mainManager fetchTaskObjectWithID:[NSNumber numberWithInteger:self.recordIDToEdit]];
    self.titleOfTaskTextField.text = task.taskTitle;
    self.additionalInfoTextView.text = task.taskAdditionalInfo;
    [self.priorityControl setSelectedSegmentIndex:[task.taskPriority integerValue]];
    self.datePicker.date = task.taskDate;
}



#pragma mark - Actions With Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.additionalInfoTextView becomeFirstResponder];
    NSLog(@"next");
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.additionalInfoTextView resignFirstResponder];
}
@end

//
//  EditIInfoViewController.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/9/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"


@protocol EditInfoViewControllerDelegate
-(void)editngInfoWasFinished;
@end

@interface EditIInfoViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) DBManager * dbManager;
@property (weak, nonatomic) id<EditInfoViewControllerDelegate> delegate;
@property (nonatomic, assign) int recordIDToEdit;

@property (weak, nonatomic) IBOutlet UITextField *titleOfTaskTextField;
@property (weak, nonatomic) IBOutlet UITextView *additionalInfoTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)saveInfo:(id)sender;
-(void)loadInfoToEdit;
@end

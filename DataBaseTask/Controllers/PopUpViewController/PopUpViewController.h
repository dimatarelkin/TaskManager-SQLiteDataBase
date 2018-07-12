//
//  PopUpViewController.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/11/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface PopUpViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UILabel *addInfoLabel;
@property (weak, nonatomic) IBOutlet UITextView *textInfoTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)cancelActionHandler:(id)sender;
@end

//
//  PopUpViewController.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/11/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()

@end


@implementation PopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //textInfo
    self.textInfoTextView.textColor = UIColor.whiteColor;
    self.textInfoTextView.layer.borderWidth = 0.5;
    self.textInfoTextView.layer.borderColor = UIColor.lightGrayColor.CGColor;
  
    //popUpView
    self.popUpView.layer.cornerRadius = 30;
    self.popUpView.layer.borderWidth =3;
    self.popUpView.layer.borderColor = UIColor.darkGrayColor.CGColor;
    self.addInfoLabel.layer.cornerRadius = 30;
    
    //buttons
    self.cancelButton.titleLabel.textColor = UIColor.whiteColor;
    self.cancelButton.layer.cornerRadius = 30;
    self.cancelButton.layer.borderWidth = 3;
    self.cancelButton.layer.borderColor = UIColor.darkGrayColor.CGColor;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
}

#pragma mark - Actions
- (IBAction)cancelActionHandler:(id)sender {
    NSLog(@"cancel action");
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)swipeDown:(UISwipeGestureRecognizer*)gesture {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

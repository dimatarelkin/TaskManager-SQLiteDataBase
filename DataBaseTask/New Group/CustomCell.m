//
//  CustomCell.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/10/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void)drawRect:(CGRect)rect {
    self.priorityView.layer.cornerRadius = 50;
    self.priorityView.layer.shadowColor = UIColor.blackColor.CGColor;
   
}



@end

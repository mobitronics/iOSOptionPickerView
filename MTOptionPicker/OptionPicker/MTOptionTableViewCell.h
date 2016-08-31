//
//  MTOptionTableViewCell.h
//  MTOptionPicker
//
//  Created by Pranay on 30/08/16.
//  Copyright © 2016 mobitronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTOptionTableViewCell : UITableViewCell
/**
 *  Option Title
 */
@property (weak, nonatomic) IBOutlet UILabel *optionTitle;
/**
 *  Option Button
 */
@property (weak, nonatomic) IBOutlet UIButton *optionButton;

@end

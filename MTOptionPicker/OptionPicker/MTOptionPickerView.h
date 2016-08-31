//
//  MTOptionPickerView.h
//  MTOptionPicker
//
//  Created by Pranay on 30/08/16.
//  Copyright © 2016 mobitronics. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Option picker view delegate called in option select
 */
@protocol MTOptionPickerViewDelegate <NSObject>
- (void)didSelectOption:(id)selectedOption;
@end

@interface MTOptionPickerView : UIView
/**
 *  Title label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  Option table view
 */
@property (weak, nonatomic) IBOutlet UITableView *optionTableView;
/**
 *  Option picker view delegate called in option select
 */
@property (weak, nonatomic) id<MTOptionPickerViewDelegate>delegate;

/**
 *  This method is used to instantiate the Option picker view with the given data array
 *
 *  @param optionDataArr  - Options data array
 *  @param title          - Title for the view
 *  @param selectedOption - Selected option string
 *
 *  @return MTOptionPickerView
 */
- (instancetype)initWithData:(NSArray *)optionDataArr title:(NSString *)title andSelecctedOption:(NSString *)selectedOption;

@end

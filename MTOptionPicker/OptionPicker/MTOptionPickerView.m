//
//  MTOptionPickerView.m
//  MTOptionPicker
//
//  Created by Pranay on 30/08/16.
//  Copyright © 2016 mobitronics. All rights reserved.
//

#import "MTOptionPickerView.h"
#import "MTOptionTableViewCell.h"

@interface MTOptionPickerView() {
  NSArray *optionsArray;
  NSInteger selectedIndex;
  UIView *blurView;
}

#define kTagConstant            100
#define kOptionTableViewCell    @"MTOptionTableViewCellIdentifier"

@end
@implementation MTOptionPickerView

/**
 *  This method is used to instantiate the Option picker view with the given data array
 *
 *  @param optionDataArr  - Options data array
 *  @param title          - Title for the view
 *  @param selectedOption - Selected option string
 *
 *  @return MTOptionPickerView
 */
- (instancetype)initWithData:(NSArray *)optionDataArr title:(NSString *)title andSelecctedOption:(NSString *)selectedOption {
  self = [super init];
  if (self) {
    
    if ([optionDataArr count]<=0) {
      //Display toast message
      [self showNoOptionsMessage];
      return self;
    }
    //Load Nib
    self = (MTOptionPickerView *)[[[NSBundle mainBundle] loadNibNamed:@"MTOptionPickerView" owner:self options:nil] objectAtIndex:0];
    
    CGFloat deviceWidth   = [[ UIScreen mainScreen] bounds].size.width;
    CGFloat deviceHeight  = [[ UIScreen mainScreen] bounds].size.height;
    
    //Add Blur View
    blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,deviceWidth,deviceHeight)];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [blurView setAlpha:0.5];
    [[UIApplication sharedApplication].delegate.window addSubview:blurView];

    //Update self view
    CGFloat width = deviceWidth-100;
    CGFloat height = 62 + [optionDataArr count]*44;
    [self setFrame:CGRectMake((deviceWidth-width)/2, 100, width, height)];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    optionsArray = optionDataArr;
    for (int iCount=0; iCount<[optionsArray count]; iCount++) {
      NSString *optionStr = [optionsArray objectAtIndex:iCount];
      if ([optionStr isEqualToString:selectedOption]) {
        selectedIndex = iCount + kTagConstant;
        break;
      }
    }

    [self.titleLabel setText:title];
    [self.optionTableView reloadData];
  }
  return self;
}

#pragma mark - UITableView Data Source

/**
 *  This method return the number of sections shown in table view
 *
 *  @param tableView - UItableView
 *
 *  @return - number of section
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

/**
 *  This method return the number of rows shown in the given section
 *
 *  @param tableView - UITableView
 *  @param section   - UITableView section
 *
 *  @return - number of rows
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [optionsArray count];
}

/**
 *  This method is used to prepare the UITableViewCell and configure the cell
 *
 *  @param tableView - UItableView
 *  @param indexPath - indexpath
 *
 *  @return - cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOptionTableViewCell];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOptionTableViewCell];
  }
  
  //Update text
  cell.textLabel.text = [optionsArray objectAtIndex:indexPath.row];
  [cell.textLabel setTextColor:[UIColor brownColor]];
  
  NSInteger btnTag = indexPath.row + kTagConstant;
  //Add Selection Button
  UIButton *radioButton = (UIButton *)[cell viewWithTag:btnTag];
  if (!radioButton) {
    radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    radioButton.tag = btnTag;
    [radioButton setSelected:FALSE];
    CGFloat btnSize = 25;
    [radioButton setFrame:CGRectMake(self.frame.size.width-btnSize-10, cell.frame.size.height/2-btnSize/2, btnSize, btnSize)];
    [radioButton addTarget:self action:@selector(radionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:radioButton];
  }
  
  if (radioButton.tag == selectedIndex) {
    [radioButton setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    [radioButton setSelected:TRUE];
  } else {
    [radioButton setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
    [radioButton setSelected:FALSE];
  }

  //Set cell style
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  [cell setBackgroundColor:[UIColor clearColor]];
  
  return cell;
}

/**
 *  This method get called before preparing the table view cell
 *
 *  @param tableView - UITableView
 *  @param cell      - UItablceViewCell
 *  @param indexPath - Indexpath
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  // Remove seperator inset
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }
  
  // Prevent the cell from inheriting the Table View's margin settings
  if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    [cell setPreservesSuperviewLayoutMargins:NO];
  }
  
  // Explictly set your cell's layout margins
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

#pragma mark - UITableView Delegate

/**
 *  This method get called when user Called after the user changes the selection.
 *
 *  @param tableView - UITableView
 *  @param indexPath - indexpath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  selectedIndex = indexPath.row + kTagConstant;
  [self.optionTableView reloadData];
 
  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismissOptionPickerView) userInfo:nil repeats:NO];
}

#pragma mark - Other Methods

/**
 *  This method is used to get the selected index
 *
 *  @param sender
 */
- (void)radionButtonAction:(id)sender {
  UIButton *radioButton = (UIButton *)sender;
  selectedIndex = radioButton.tag;
  [self.optionTableView reloadData];
  
  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismissOptionPickerView) userInfo:nil repeats:NO];
}

/**
 *  This method is used to dismiss the option picker view
 */
- (void)dismissOptionPickerView {
  if ([self.delegate respondsToSelector:@selector(didSelectOption:)]) {
    [self.delegate didSelectOption:[optionsArray objectAtIndex:selectedIndex-kTagConstant]];
  }
  [blurView removeFromSuperview];
  [self removeFromSuperview];
}

#pragma mark - Toast Message

/**
 *  This method is used to show the toast message
 */
- (void)showNoOptionsMessage {
  CGSize size = [UIApplication sharedApplication].delegate.window.frame.size;
  CGFloat width = size.width-100;
  CGFloat yPos = 150;

  UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(size.width/2-width/2, size.height-yPos, width, 30)];
  [toastLabel setTag:121];
  [toastLabel setText:@"No options available to display!"];
  [toastLabel setTextAlignment:NSTextAlignmentCenter];
  [toastLabel setTextColor:[UIColor whiteColor]];
  [toastLabel setBackgroundColor:[UIColor darkGrayColor]];
  toastLabel.layer.cornerRadius = 3;
  toastLabel.clipsToBounds = YES;
  [[UIApplication sharedApplication].delegate.window addSubview:toastLabel];
  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeToast:) userInfo:nil repeats:NO];
}

/**
 *  This method is get invoced to dismiss the toast message after specific time
 *
 *  @param sender
 */
- (void)removeToast:(id)sender {
  UILabel *toastLabel = (UILabel *)[[UIApplication sharedApplication].delegate.window viewWithTag:121];
  [toastLabel removeFromSuperview];
  toastLabel = nil;
}

@end

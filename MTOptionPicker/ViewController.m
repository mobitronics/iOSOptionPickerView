//
//  ViewController.m
//  MTOptionPicker
//
//  Created by Pranay on 30/08/16.
//  Copyright © 2016 mobitronics. All rights reserved.
//

#import "ViewController.h"
#import "MTOptionPickerView.h"

@interface ViewController ()<MTOptionPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *showOptionButton;
@property (strong, nonatomic) MTOptionPickerView *optionPickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.showOptionButton.layer.cornerRadius = 5.0;
  self.showOptionButton.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)showOptionButtonAction:(id)sender {
  self.optionPickerView = [[MTOptionPickerView alloc] initWithData:@[@"United States", @"Canada", @"Mexico", @"United Kingdom", @"India"] title:@"Select Country Preference" andSelecctedOption:self.showOptionButton.titleLabel.text];
  self.optionPickerView.delegate = self;
}

#pragma mark - MTOptionPickerViewDelegate

- (void)didSelectOption:(id)selectedOption {
  [self.showOptionButton setTitle:selectedOption forState:UIControlStateNormal];
}

@end

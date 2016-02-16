//
//  CustomPresentationSecondViewController.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/16.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "CustomPresentationSecondViewController.h"

@interface CustomPresentationSecondViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation CustomPresentationSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection
{
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 270 : 420);
    
    // To demonstrate how a presentation controller can dynamically respond
    // to changes to its presented view controller's preferredContentSize,
    // this view controller exposes a slider.  Dragging this slider updates
    // the preferredContentSize of this view controller in real time.
    //
    // Update the slider with appropriate min/max values and reset the
    // current value to reflect the changed preferredContentSize.
    self.slider.maximumValue = self.preferredContentSize.height;
    self.slider.minimumValue = 220.f;
    self.slider.value = self.slider.maximumValue;
}

- (IBAction)sliderChanged:(UISlider *)sender
{
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, sender.value);
}
- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

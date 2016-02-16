//
//  CustomPresentationFirstViewController.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/16.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "CustomPresentationFirstViewController.h"
#import "CustomPresentationSecondViewController.h"
#import "CustomPresentationController.h"

@interface CustomPresentationFirstViewController ()

@end

@implementation CustomPresentationFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)present:(id)sender
{
    CustomPresentationSecondViewController *secondCtl = [CustomPresentationSecondViewController new];
    
    CustomPresentationController *presentationController;
    
    presentationController = [[CustomPresentationController alloc] initWithPresentedViewController:secondCtl presentingViewController:self];
    secondCtl.transitioningDelegate = presentationController;
    
    [self presentViewController:secondCtl animated:YES completion:NULL];
}

@end

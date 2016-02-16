//
//  SwipeSecondViewController.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "SwipeSecondViewController.h"
#import "SwipeTransitionDelegate.h"

@interface SwipeSecondViewController ()

@end

@implementation SwipeSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //左边缘手势
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    interactiveTransitionRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interactiveTransitionRecognizerAction:(UIScreenEdgePanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        //调整代理
        SwipeTransitionDelegate *transitionDelegate = self.transitioningDelegate;
        
        if ([sender isKindOfClass:UIGestureRecognizer.class])
            transitionDelegate.gestureRecognizer = sender;
        else
            transitionDelegate.gestureRecognizer = nil;
        
        transitionDelegate.targetEdge = UIRectEdgeLeft;

        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}


- (IBAction)dismiss:(id)sender
{
    //调整代理
    SwipeTransitionDelegate *transitionDelegate = self.transitioningDelegate;
    transitionDelegate.targetEdge = UIRectEdgeLeft;
    transitionDelegate.gestureRecognizer = nil;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

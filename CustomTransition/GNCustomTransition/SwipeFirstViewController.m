//
//  SwipeFirstViewController.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "SwipeFirstViewController.h"
#import "SwipeSecondViewController.h"
#import "SwipeTransitionDelegate.h"

@interface SwipeFirstViewController ()

@property (nonatomic, strong) SwipeTransitionDelegate *customTransitionDelegate;

@end

@implementation SwipeFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //右边缘手势
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    interactiveTransitionRecognizer.edges = UIRectEdgeRight;
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
        SwipeSecondViewController *secondCtl = [SwipeSecondViewController new];
        
        SwipeTransitionDelegate *transitionDelegate = self.customTransitionDelegate;

        if ([sender isKindOfClass:UIGestureRecognizer.class])
            transitionDelegate.gestureRecognizer = sender;
        else
            transitionDelegate.gestureRecognizer = nil;

        transitionDelegate.targetEdge = UIRectEdgeRight;
        
        secondCtl.transitioningDelegate = transitionDelegate;

        secondCtl.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:secondCtl animated:YES completion:NULL];
    }
}


- (SwipeTransitionDelegate *)customTransitionDelegate
{
    if (_customTransitionDelegate == nil)
    {
        _customTransitionDelegate = [[SwipeTransitionDelegate alloc] init];
    }
    
    return _customTransitionDelegate;
}

- (IBAction)present:(id)sender
{
    SwipeSecondViewController *secondCtl = [SwipeSecondViewController new];
    
    SwipeTransitionDelegate *transitionDelegate = self.customTransitionDelegate;
    transitionDelegate.targetEdge = UIRectEdgeRight;
    secondCtl.transitioningDelegate = transitionDelegate;
    
    secondCtl.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:secondCtl animated:YES completion:NULL];
}

@end

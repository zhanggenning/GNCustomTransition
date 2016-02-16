//
//  SwipeTransitionDelegate.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "SwipeTransitionDelegate.h"
#import "SwipeTransitionAnimator.h"
#import "SwipeTransitionController.h"

@implementation SwipeTransitionDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[SwipeTransitionAnimator alloc] initWithTargetEdge:self.targetEdge];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[SwipeTransitionAnimator alloc] initWithTargetEdge:self.targetEdge];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if (self.gestureRecognizer)
    {
        return [[SwipeTransitionController alloc] initWithGestureRecognizer:self.gestureRecognizer edgeForDragging:self.targetEdge];
    }
    else
    {
        return nil;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if (self.gestureRecognizer)
    {
        return [[SwipeTransitionController alloc] initWithGestureRecognizer:self.gestureRecognizer edgeForDragging:self.targetEdge];
    }
    else
    {
        return nil;
    }
}

@end

//
//  SwipeTransitionController.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/16.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "SwipeTransitionController.h"

@interface SwipeTransitionController ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readonly) UIRectEdge edge;

@end

@implementation SwipeTransitionController

- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer edgeForDragging:(UIRectEdge)edge
{
    NSAssert(edge == UIRectEdgeTop || edge == UIRectEdgeBottom ||
             edge == UIRectEdgeLeft || edge == UIRectEdgeRight,
             @"edgeForDragging must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.");
    
    if (self = [super init])
    {
        _gestureRecognizer = gestureRecognizer;
        _edge = edge;
        
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (void)dealloc
{
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    [super startInteractiveTransition:transitionContext];
}


//获取手势偏移占比
- (CGFloat)percentForGesture:(UIScreenEdgePanGestureRecognizer *)gesture
{
    UIView *transitionContainerView = self.transitionContext.containerView;
    
    CGPoint locationInSourceView = [gesture locationInView:transitionContainerView];
    
    CGFloat width = CGRectGetWidth(transitionContainerView.bounds);
    CGFloat height = CGRectGetHeight(transitionContainerView.bounds);
    
    if (self.edge == UIRectEdgeRight)
    {
        return (width - locationInSourceView.x) / width;
    }
    else if (self.edge == UIRectEdgeLeft)
    {
        return locationInSourceView.x / width;
    }
    else if (self.edge == UIRectEdgeLeft)
    {
        return (height - locationInSourceView.y) / height;
    }
    else if (self.edge == UIRectEdgeTop)
    {
        return locationInSourceView.y / height;
    }
    else
        return 0.f;
}

- (void)gestureRecognizeDidUpdate:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            //开始的状态由view controller处理，这里不做处理
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if ([self percentForGesture:gestureRecognizer] >= 0.5f)
            {
                [self finishInteractiveTransition];
            }
            else
            {
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
        {
            [self cancelInteractiveTransition];
            break;
        }
    }
}

@end

//
//  SwipeTransitionAnimator.h
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface SwipeTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTargetEdge:(UIRectEdge)targetEdge;

@property (nonatomic, readwrite) UIRectEdge targetEdge;

@end

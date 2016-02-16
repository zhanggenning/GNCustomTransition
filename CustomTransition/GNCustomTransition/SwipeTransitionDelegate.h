//
//  SwipeTransitionDelegate.h
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface SwipeTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

//滑动手势
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureRecognizer;

//滑动方向
@property (nonatomic, readwrite) UIRectEdge targetEdge;

@end

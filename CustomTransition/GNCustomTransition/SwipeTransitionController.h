//
//  SwipeTransitionController.h
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/16.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeTransitionController : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer edgeForDragging:(UIRectEdge)edge;

@end

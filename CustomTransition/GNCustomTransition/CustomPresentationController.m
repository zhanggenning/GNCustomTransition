//
//  CustomPresentationController.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/16.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "CustomPresentationController.h"

#define CORNER_RADIUS   16.f

@interface CustomPresentationController ()<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIView *dimmingView; //阴影
@property (nonatomic, strong) UIView *presentationWrappingView; //包装视图

@end

@implementation CustomPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self)
    {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (UIView *)presentedView
{
    return self.presentationWrappingView;
}

//在这里实现自定义视图
- (void)presentationTransitionWillBegin
{
    UIView *presentedViewControllerView = [super presentedView]; //推出的视图view
    
    // Wrap the presented view controller's view in an intermediate hierarchy
    // that applies a shadow and rounded corners to the top-left and top-right
    // edges.  The final effect is built using three intermediate views.
    //
    // presentationWrapperView              <- shadow
    //   |- presentationRoundedCornerView   <- rounded corners (masksToBounds)
    //        |- presentedViewControllerWrapperView
    //             |- presentedViewControllerView (presentedViewController.view)
    //
    {
        UIView *presentationWrapperView = [[UIView alloc] initWithFrame:self.frameOfPresentedViewInContainerView];
        presentationWrapperView.layer.shadowOpacity = 0.44f;
        presentationWrapperView.layer.shadowRadius = 13.f;
        presentationWrapperView.layer.shadowOffset = CGSizeMake(0, -6.f);
        self.presentationWrappingView = presentationWrapperView;
        
        // presentationRoundedCornerView is CORNER_RADIUS points taller than the
        // height of the presented view controller's view.  This is because
        // the cornerRadius is applied to all corners of the view.  Since the
        // effect calls for only the top two corners to be rounded we size
        // the view such that the bottom CORNER_RADIUS points lie below
        // the bottom edge of the screen.
        UIView *presentationRoundedCornerView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationWrapperView.bounds, UIEdgeInsetsMake(0, 0, -CORNER_RADIUS, 0))];
        presentationRoundedCornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        presentationRoundedCornerView.layer.cornerRadius = CORNER_RADIUS;
        presentationRoundedCornerView.layer.masksToBounds = YES;
        
        // To undo the extra height added to presentationRoundedCornerView,
        // presentedViewControllerWrapperView is inset by CORNER_RADIUS points.
        // This also matches the size of presentedViewControllerWrapperView's
        // bounds to the size of -frameOfPresentedViewInContainerView.
        UIView *presentedViewControllerWrapperView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds, UIEdgeInsetsMake(0, 0, CORNER_RADIUS, 0))];
        presentedViewControllerWrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // Add presentedViewControllerView -> presentedViewControllerWrapperView.
        presentedViewControllerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds;
        [presentedViewControllerWrapperView addSubview:presentedViewControllerView];
        
        // Add presentedViewControllerWrapperView -> presentationRoundedCornerView.
        [presentationRoundedCornerView addSubview:presentedViewControllerWrapperView];
        
        // Add presentationRoundedCornerView -> presentationWrapperView.
        [presentationWrapperView addSubview:presentationRoundedCornerView];
    }


    // Add a dimming view behind presentationWrapperView.  self.presentedView
    // is added later (by the animator) so any views added here will be
    // appear behind the -presentedView.
    {
        UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        dimmingView.backgroundColor = [UIColor blackColor];
        dimmingView.opaque = NO;
        dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
        self.dimmingView = dimmingView;
        [self.containerView addSubview:dimmingView];
        
        id<UIViewControllerTransitionCoordinator> transitionCoordinator= self.presentingViewController.transitionCoordinator;
        self.dimmingView.alpha = 0.f;
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.dimmingView.alpha = 0.5f;
        } completion:NULL];
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (completed == NO)
    {
        self.presentationWrappingView = nil;
        self.dimmingView = nil;
    }
}

- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed == YES)
    {
        self.presentationWrappingView = nil;
        self.dimmingView = nil;
    }
}

#pragma mark -- Layout
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
    {
        [self.containerView setNeedsLayout];
    }
}


- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController)
        return ((UIViewController*)container).preferredContentSize;
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}


//| ----------------------------------------------------------------------------
- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    
    // The presented view extends presentedViewContentSize.height points from
    // the bottom edge of the screen.
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    presentedViewControllerFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height;
    return presentedViewControllerFrame;
}


//| ----------------------------------------------------------------------------
//  This method is similar to the -viewWillLayoutSubviews method in
//  UIViewController.  It allows the presentation controller to alter the
//  layout of any custom views it manages.
//
- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    
    self.dimmingView.frame = self.containerView.bounds;
    self.presentationWrappingView.frame = self.frameOfPresentedViewInContainerView;
}

#pragma mark - events
- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UIViewControllerAnimatedTransitioning
//| ----------------------------------------------------------------------------
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.35 : 0;
}

//这里实现推出的动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    // If NO is returned from -shouldRemovePresentersView, the view associated
    // with UITransitionContextFromViewKey is nil during presentation.  This
    // intended to be a hint that your animator should NOT be manipulating the
    // presenting view controller's view.  For a dismissal, the -presentedView
    // is returned.
    //
    // Why not allow the animator manipulate the presenting view controller's
    // view at all times?  First of all, if the presenting view controller's
    // view is going to stay visible after the animation finishes during the
    // whole presentation life cycle there is no need to animate it at all — it
    // just stays where it is.  Second, if the ownership for that view
    // controller is transferred to the presentation controller, the
    // presentation controller will most likely not know how to layout that
    // view controller's view when needed, for example when the orientation
    // changes, but the original owner of the presenting view controller does.
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    // This will be the current frame of fromViewController.view.
    CGRect __unused fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
    // For a presentation which removes the presenter's view, this will be
    // CGRectZero.  Otherwise, the current frame of fromViewController.view.
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    // This will be CGRectZero.
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
    // For a presentation, this will be the value returned from the
    // presentation controller's -frameOfPresentedViewInContainerView method.
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    // We are responsible for adding the incoming view to the containerView
    // for the presentation (will have no effect on dismissal because the
    // presenting view controller's view was not removed).
    [containerView addSubview:toView];
    
    if (isPresenting) {
        toViewInitialFrame.origin = CGPointMake(CGRectGetMinX(containerView.bounds), CGRectGetMaxY(containerView.bounds));
        toViewInitialFrame.size = toViewFinalFrame.size;
        toView.frame = toViewInitialFrame;
    } else {
        // Because our presentation wraps the presented view controller's view
        // in an intermediate view hierarchy, it is more accurate to rely
        // on the current frame of fromView than fromViewInitialFrame as the
        // initial frame (though in this example they will be the same).
        fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting)
            toView.frame = toViewFinalFrame;
        else
            fromView.frame = fromViewFinalFrame;
        
    } completion:^(BOOL finished) {
        // When we complete, tell the transition context
        // passing along the BOOL that indicates whether the transition
        // finished or not.
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

#pragma mark -
#pragma mark UIViewControllerTransitioningDelegate

//| ----------------------------------------------------------------------------
//  If the modalPresentationStyle of the presented view controller is
//  UIModalPresentationCustom, the system calls this method on the presented
//  view controller's transitioningDelegate to retrieve the presentation
//  controller that will manage the presentation.  If your implementation
//  returns nil, an instance of UIPresentationController is used.
//
- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    NSAssert(self.presentedViewController == presented, @"You didn't initialize %@ with the correct presentedViewController.  Expected %@, got %@.",
             self, presented, self.presentedViewController);
    
    return self;
}


//| ----------------------------------------------------------------------------
//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the presentation of the incoming view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  presentation animation should be used.
//
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}


//| ----------------------------------------------------------------------------
//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the dismissal of the presented view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  dismissal animation should be used.
//
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

@end

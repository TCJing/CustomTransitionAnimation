//
//  TCTransitionAnimationDelegate.m
//  CustomTransitionAnimation
//
//  Created by 敬庭超 on 2017/3/10.
//  Copyright © 2017年 敬庭超. All rights reserved.
//

#import "TCTransitionAnimationDelegate.h"
@interface TCTransitionAnimationDelegate()<CAAnimationDelegate>
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@end
@implementation TCTransitionAnimationDelegate
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0 );
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
    _transitionContext = transitionContext;
    /*--------转场动画二------------*/
    /*
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];
        [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    */
    /*--------转场动画三------------*/
    /*
    CATransition *transiton = [CATransition animation];
    transiton.type = @"pageCurl";
    transiton.subtype = @"fromLeft";
    transiton.duration = duration;
    transiton.delegate = self;
    transiton.removedOnCompletion = NO;
    transiton.fillMode = kCAFillModeForwards;
    [containerView.layer addAnimation:transiton forKey:nil];
    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    */
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}

@end

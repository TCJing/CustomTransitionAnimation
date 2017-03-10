//
//  TCNavigationControllerDelegate.m
//  CustomTransitionAnimation
//
//  Created by 敬庭超 on 2017/3/10.
//  Copyright © 2017年 敬庭超. All rights reserved.
//

#import "TCNavigationControllerDelegate.h"
#import "TCTransitionAnimationDelegate.h"
@interface TCNavigationControllerDelegate()
@property(nonatomic,weak) UINavigationController  *navigationController;
@property(nonatomic,strong) UIPercentDrivenInteractiveTransition  *percentDrivenInteractiveTransition;

@end
@implementation TCNavigationControllerDelegate
-(instancetype)initWithController:(UIViewController *)viewController{
    if (self = [super init]) {
        _navigationController = (UINavigationController *)viewController;
        _navigationController.delegate = self;
    }
    return self;
}


-(void)handleControllerPop:(UIPanGestureRecognizer *)recognizer{
    //通过translationInView获得的值可能会是负值，所以这里需要对这个值进行处理
    //计算得到可能是负值也可能大于1的这么一个值，这个就是进度值
   CGFloat progress = [recognizer translationInView:recognizer.view].x / recognizer.view.bounds.size.width;
    //[0 ,1]
    progress = MIN(1, MAX(0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //手势开始了，那么，这个时候就创建percentDrivenInteractiveTransition,percentDrivenInteractiveTransition的生命周期由手势的开始和结束控制
        self.percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        
        //当手势开始的时候，也就是用户开始滑动的时候，就需要出发系统的pop操作（这个操作本来就是交给系统来做的）
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        
        [self.percentDrivenInteractiveTransition updateInteractiveTransition:progress];
        
    }else{
        //当手势的移动范围>=0.5的时候
        if (progress >= 0.5) {
            [self.percentDrivenInteractiveTransition finishInteractiveTransition];
        }else if(recognizer.state == UIGestureRecognizerStateCancelled  || recognizer.state == UIGestureRecognizerStateEnded){
            [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        self.percentDrivenInteractiveTransition = nil;
        
        
    }
    
}

#pragma mark - UINavigationControllerDelegate
/**
 *  <#Description#>
 *
 *  @param navigationController <#navigationController description#>
 *  @param animationController  执行动画的控制器，也就是这里的UINavigationControllerOperationPop
 *
 *  @return 返回一个遵守了UINavigationControllerOperationPop协议的对象，这个对象控制着转场的进度
 * 系统提供了一个遵守了这个协议的类UIPercentDrivenInteractiveTransition
 */
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
        //这里就通过判断animationController 是不是TCTransitionAnimationDelegate来确定是否返回UIPercentDrivenInteractiveTransition
    if ([animationController isKindOfClass:[TCTransitionAnimationDelegate class]]) {
        return  self.percentDrivenInteractiveTransition;
    }
    return nil;
}
/**
 *  提供管理动画的对象
 *
 *  @param navigationController <#navigationController description#>
 *  @param operation            这个参数能够获取到当前执行的操作类型（pop push none）
 *  @param fromVC               <#fromVC description#>
 *  @param toVC                 <#toVC description#>
 *
 *  @return 返回的是一个遵守了UIViewControllerAnimatedTransitioning协议的对象
 *  这里是直接提供了一个专门处理转场动画的类
 */

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
       return  [[TCTransitionAnimationDelegate alloc] init];
    }
    return nil;
}
@end

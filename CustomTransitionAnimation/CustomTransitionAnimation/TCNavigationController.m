//
//  TCNavigationController.m
//  CustomTransitionAnimation
//
//  Created by 敬庭超 on 2017/3/10.
//  Copyright © 2017年 敬庭超. All rights reserved.
//

#import "TCNavigationController.h"
#import "TCNavigationControllerDelegate.h"
@interface TCNavigationController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong) TCNavigationControllerDelegate  *navigationControllerDelegate;

@end

@implementation TCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIGestureRecognizer *gestureRecognizer = self.interactivePopGestureRecognizer;
    //关闭系统的手势
    gestureRecognizer.enabled = NO;
    //获取手势作用的视图
    UIView *view = gestureRecognizer.view;
    //自己创建的手势作为视图的新的手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    pan.maximumNumberOfTouches = 1;
    [view addGestureRecognizer:pan];
    pan.delegate = self;
    //导航控制器的delegate交给一个专门管理的类，由这个专门的类来提供转场的动画对象，以及转场的进度控制对象
    TCNavigationControllerDelegate *navigationController = [[TCNavigationControllerDelegate alloc] initWithController:self];
    self.navigationControllerDelegate = navigationController;
    //手势的调用所触发的方法，交给代理类来处理，完全的转移出去
    [pan addTarget:navigationController action:@selector(handleControllerPop:)];
}
#pragma mark - UIGestureRecognizerDelegate
/**
 *  在一些情况下，手势应当处于关闭状态：
    ①： 作为导航控制器的根控制器是不需要手势的
    ②： 当正在进行转场的时候，应当关闭手势
 *
 *  _isTransitioning: UINavigationController私有属性，通过这个属性能够获取到当前是否正在转场
 *
 *  @return <#return value description#>
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    return  (self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue]);
}

@end

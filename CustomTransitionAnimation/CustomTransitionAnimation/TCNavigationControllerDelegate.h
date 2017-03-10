//
//  TCNavigationControllerDelegate.h
//  CustomTransitionAnimation
//
//  Created by 敬庭超 on 2017/3/10.
//  Copyright © 2017年 敬庭超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCNavigationControllerDelegate : NSObject<UINavigationControllerDelegate>
-(instancetype)initWithController:(UIViewController *)viewController;
- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;
@end

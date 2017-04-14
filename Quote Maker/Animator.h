//
//  Animator.h
//  Quote Maker
//
//  Created by Badhan Ganesh on 4/9/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Animator : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic) CGPoint startingPoint;
@property (nonatomic) Boolean isDismiss;

@end

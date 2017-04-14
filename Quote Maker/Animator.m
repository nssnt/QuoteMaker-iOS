//
//  Animator.m
//  Quote Maker
//
//  Created by Badhan Ganesh on 4/9/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import "Animator.h"


@implementation Animator
    
    
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 1;
}
    
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if(!self.isDismiss) {
        
        UIView *containerView = [transitionContext containerView];
        
        UIView *toVC = [transitionContext viewForKey:UITransitionContextToViewKey];
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, toVC.frame.size.width * 5, toVC.frame.size.width * 5)];
        circle.center = self.startingPoint;
        circle.layer.cornerRadius = circle.frame.size.width / 2;
        circle.layer.masksToBounds = YES;
        circle.clipsToBounds = YES;
        circle.backgroundColor = [UIColor whiteColor];
        
        circle.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        toVC.alpha = 0;
        
        [containerView addSubview:circle];
        [containerView addSubview:toVC];
        
        [UIView animateWithDuration: 0.45 animations:^{
            
            circle.transform = CGAffineTransformIdentity;
            toVC.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            circle.alpha = 0;
            [circle removeFromSuperview];
            [transitionContext completeTransition:finished];
            
        }];
        
    } else {
        
        //Dismiss
        
        UIView *containerView = [transitionContext containerView];
        
        UIView *toVC = [transitionContext viewForKey:UITransitionContextToViewKey];
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width * 5, containerView.frame.size.width * 5)];
        circle.center = self.startingPoint;
        circle.layer.cornerRadius = circle.frame.size.width / 2;
        circle.layer.masksToBounds = YES;
        circle.clipsToBounds = YES;
        circle.backgroundColor = [UIColor whiteColor];
        
        toVC.alpha = 0;
        
        containerView.center = self.startingPoint;
        [containerView addSubview:circle];
        [containerView addSubview:toVC];
        
        [UIView animateWithDuration: 0.45 animations:^{
            containerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            toVC.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            circle.alpha = 0;
            [circle removeFromSuperview];
            [transitionContext completeTransition:finished];
            
        }];
        
    }
}
    
    @end

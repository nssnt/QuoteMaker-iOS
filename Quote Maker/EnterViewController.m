//
//  EnterViewController.m
//  Quote Maker
//
//  Created by Badhan Ganesh on 2/3/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import "EnterViewController.h"
#import "SaveViewController.h"
#import "Animator.h"
#import <Lottie/Lottie.h>


@interface EnterViewController ()<UITextFieldDelegate, UITextViewDelegate, UIViewControllerTransitioningDelegate> {

    Animator *animator;
}

@end

@implementation EnterViewController

@synthesize mainTextView, previewButton;


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    animator.startingPoint = self.previewButton.center;
    animator.isDismiss = NO;
    
    return animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    animator = [[Animator alloc] init];
    self.previewButton.layer.cornerRadius = previewButton.frame.size.height / 2;
    self.previewButton.layer.masksToBounds = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [self.mainTextView endEditing:YES];
    
}

-(IBAction)previewButtonPressed:(id)sender{
    
    @autoreleasepool {
        
        __weak SaveViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SaveViewController"];
        
        SVC.quoteText = self.mainTextView.text;
        SVC.transitioningDelegate = self;
        SVC.modalPresentationStyle = UIModalPresentationCustom;
        
        [self.navigationController presentViewController:SVC animated:YES completion:nil];
        
    }
    
}

@end

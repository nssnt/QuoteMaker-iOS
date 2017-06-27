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
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface EnterViewController ()<UITextFieldDelegate, UITextViewDelegate, UIViewControllerTransitioningDelegate, GADBannerViewDelegate> {
    Animator *animator;
}

@end

@implementation EnterViewController

@synthesize mainTextView, previewButton, adView;


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
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    //[self createAndDisplayAd];
}

-(void)createAndDisplayAd {
    GADRequest *request = [[GADRequest alloc] init];
    request.testDevices = @[kGADSimulatorID, @"34816b235a91edd01c3d822d53c4bca8"];
    [self.adView loadRequest:request];
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

-(void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"*********************************Ad received successfully!*********************************");
}

-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"*********************************Ad did fail to receive. Error description: %@*********************************", error.description);
    
}

@end

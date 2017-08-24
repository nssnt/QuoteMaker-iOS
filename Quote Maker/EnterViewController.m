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
#import <MobileCoreServices/MobileCoreServices.h>
#import "SettingsViewController.h"

@interface EnterViewController ()<UITextFieldDelegate, UITextViewDelegate, UIViewControllerTransitioningDelegate, GADBannerViewDelegate, UIDropInteractionDelegate> {
    Animator *animator;
}

@end

@implementation EnterViewController

@synthesize mainTextView, previewButton, adView, adViewHeightConstraint;

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    animator.startingPoint = self.previewButton.center;
    animator.isDismiss = NO;
    return animator;
}

- (void)addDropCapability {
    //Add Drop capability
    if (@available(iOS 11.0, *)) {
        UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
        if (@available(iOS 11.0, *)) {
            [self.mainTextView addInteraction:dropInteraction];
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewDidLoad {
    self.adView.adSize = kGADAdSizeSmartBannerPortrait;
    animator = [[Animator alloc] init];
    self.previewButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.previewButton.layer.shadowOpacity = 0.36;
    self.previewButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.previewButton.layer.shadowRadius = 9;
    self.previewButton.clipsToBounds = NO;
    self.previewButton.layer.cornerRadius = previewButton.frame.size.height / 2;
    [self.previewButton setEnabled:NO];
    
    [self applyGradient];
    if (@available(iOS 11.0, *)) {
        [self addDropCapability];
    }
    [super viewDidLoad];
}

- (void)applyGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    if (@available(iOS 11.0, *)) {
        gradient.colors = @[(id)[UIColor colorNamed:@"Gradient Color Red"].CGColor, (id)[UIColor colorNamed:@"Gradient Color White"].CGColor];
    } else {
        gradient.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor whiteColor].CGColor];
    }
    gradient.startPoint = CGPointMake(-1, -1);
    gradient.endPoint = CGPointMake(2, 2);
    [self.view.layer insertSublayer:gradient atIndex:0];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    //[self createAndDisplayAd];
}

-(void)createAndDisplayAd {
    GADRequest *request = [[GADRequest alloc] init];
    request.testDevices = @[kGADSimulatorID, @"34816b235a91edd01c3d822d53c4bca8", @"aff0a883440f2b046b83bd9f8b8f92c237eac923", @"de2dcca5b1ce76c115864f1beda9b1d2a06e11a2"];
    [self.adView loadRequest:request];
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

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(IBAction)settingsButtonPressed:(id)sender{
    __weak SettingsViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:SVC animated:YES];
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

//MARK: UIDropInteraction Delegates
-(BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    return [session hasItemsConformingToTypeIdentifiers:@[(NSString *)kUTTypeText]] && session.items.count == 1;
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    
    CGPoint dropLocation = [session locationInView:self.view];
    UIDropOperation operation;
    
    if (CGRectContainsPoint(self.mainTextView.frame, dropLocation)) {
        operation = session.localDragSession == nil ? UIDropOperationCopy : UIDropOperationMove;
    } else {
        operation = UIDropOperationCancel;
    }
    
    return [[UIDropProposal alloc] initWithDropOperation:operation];
}

-(void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    [session loadObjectsOfClass:[UIImage class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *strings = objects;
            mainTextView.text = [strings firstObject];
        });
    }];
}

-(void)textViewDidChange:(UITextView *)textView {
    if ([textView hasText]) {
        [self.previewButton setEnabled:YES];
    } else {
        [self.previewButton setEnabled:NO];
    }
}

@end

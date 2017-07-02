//
//  EnterViewController.h
//  Quote Maker
//
//  Created by Badhan Ganesh on 2/3/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface EnterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet GADBannerView *adView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewHeightConstraint;

-(IBAction)previewButtonPressed:(id)sender;

@end


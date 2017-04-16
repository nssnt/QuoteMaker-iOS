//
//  EnterViewController.h
//  Quote Maker
//
//  Created by Badhan Ganesh on 2/3/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;

-(IBAction)previewButtonPressed:(id)sender;

@end


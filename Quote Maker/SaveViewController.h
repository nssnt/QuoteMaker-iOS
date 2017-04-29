//
//  SaveViewController.h
//  Quote Maker
//
//  Created by Badhan Ganesh on 2/3/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveViewController : UIViewController


//Outlets

@property(weak, nonatomic) IBOutlet UILabel *mainLabel;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;

@property(weak, nonatomic) IBOutlet UIButton *saveButton;
@property(weak, nonatomic) IBOutlet UIButton *closeButton;
@property(weak, nonatomic) IBOutlet UIButton *addImageButton;
@property(weak, nonatomic) IBOutlet UIButton *shareButton;

@property(weak, nonatomic) IBOutlet UIView *captureView;
@property(weak, nonatomic) IBOutlet UISlider *slider;


//Methods

-(IBAction)addImageButtonTouched:(id)sender;
-(IBAction)saveButtonTouched:(id)sender;
-(IBAction)closeButtonTouched:(id)sender;
-(IBAction)shareButtonTouched:(id)sender;
-(IBAction)sliderValueChanged:(UISlider *)sender;

//Properties

@property(strong, nonatomic) NSString *quoteText;

@end

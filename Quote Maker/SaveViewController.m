//
//  SaveViewController.m
//  Quote Maker
//
//  Created by Badhan Ganesh on 2/3/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import "SaveViewController.h"
#import "Utilities.h"
#import "UIImage+ImageEffects.h"
#import "Animator.h"

@interface SaveViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    UIImagePickerController *pickerController;
    UIImage *actualBGImage;
    UIImageView *biv;
    Animator *animator;
}

@end

@implementation SaveViewController
@synthesize quoteText, mainLabel, imageView, saveButton, closeButton, addImageButton, watermarkText, captureView, slider;

    
-(void)dealloc {
    
    NSLog(@"Save VC is being deallocated");
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(self.watermarkText){
        self.mainLabel.text = [quoteText stringByAppendingString:[NSString stringWithFormat:@"\n%@", self.watermarkText]];
        self.mainLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }else{
        self.mainLabel.text = quoteText;
        self.mainLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }
    
    self.saveButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.saveButton.layer.shadowOpacity = 0.36;
    self.saveButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.saveButton.layer.shadowRadius = 9;
    self.saveButton.layer.cornerRadius = saveButton.frame.size.height / 2;
    self.saveButton.layer.masksToBounds = NO;
    
    self.mainLabel.adjustsFontSizeToFitWidth = YES;
    self.mainLabel.layer.masksToBounds = NO;
    
    self.addImageButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.addImageButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.addImageButton.layer.shadowRadius = 3.0;
    self.addImageButton.layer.shadowOpacity = 0.45;
    self.addImageButton.layer.masksToBounds = NO;
    
    self.slider.maximumValue = 100;
    
    UIFont *font = [UIFont fontWithName:@"GrandHotel-Regular" size:160.0f];
    self.mainLabel.font = font;
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(IBAction)addImageButtonTouched:(id)sender{
    
    
    if(pickerController == nil){
        
        @autoreleasepool {
            pickerController = [[UIImagePickerController alloc]init];
            pickerController.delegate = self;
            pickerController.allowsEditing = NO;
            
            [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
    }
    [self presentViewController:pickerController animated:YES completion:nil];
    
}

-(IBAction)saveButtonTouched:(id)sender{
    
    @autoreleasepool {
        UIImage *image = [self imageWithView:self.view];
        
        self.addImageButton.hidden = NO;
        self.saveButton.hidden = NO;
        self.closeButton.hidden = NO;
        self.slider.hidden = NO;
        
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
}

-(IBAction)closeButtonTouched:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            actualBGImage = nil;
            self.imageView.image = nil;
            
            UIImage *compressedImage = [[Utilities sharedManager] scaleImage:[UIImage imageWithData: UIImageJPEGRepresentation([info valueForKey:UIImagePickerControllerOriginalImage], 0.5)] toSize:CGSizeMake(1200, 1200)]; ;
            
            self.imageView.image = compressedImage;
            actualBGImage = compressedImage;
            
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.clipsToBounds = YES;
            
            [biv removeFromSuperview];
            biv = nil;
            biv = [[UIImageView alloc] initWithFrame:self.view.frame];
            
            biv.image = [compressedImage applyBlurWithRadius: 28 tintColor:nil saturationDeltaFactor: 1.0 maskImage:nil];
            biv.alpha = slider.value / 100;
            
            biv.contentMode = UIViewContentModeScaleAspectFill;
            biv.clipsToBounds = YES;
            
            [self.imageView addSubview:biv];
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        });
    });
    
    
}

- (UIImage *)imageWithView:(UIView *)view{
    
    @autoreleasepool {
        
        self.addImageButton.hidden = YES;
        self.saveButton.hidden = YES;
        self.closeButton.hidden = YES;
        self.slider.hidden = YES;
        
        if(!self.imageView.image){
            self.captureView.backgroundColor = self.view.backgroundColor;
        }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return img;
        
    }
    
}

-(IBAction)sliderValueChanged:(UISlider *)sender {
    
    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    if(self.imageView.image) {
                        __weak typeof(self) weakSelf = self;
                        if(sender.value == 0) {
                            weakSelf.imageView.image = actualBGImage;
                        } else {
                            biv.alpha = sender.value / 100;
                        }
                    }
                }
            });
        });
    }
}

@end

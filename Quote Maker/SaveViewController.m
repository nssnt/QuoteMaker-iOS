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
#import <Social/Social.h>

@interface SaveViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    UIImagePickerController *pickerController;
    UIImage *actualBGImage;
    UIImageView *biv;
    Animator *animator;
}

@end

@implementation SaveViewController
@synthesize quoteText, mainLabel, imageView, saveButton, closeButton, addImageButton, captureView, slider;


-(void)dealloc {
    
    NSLog(@"Save VC is being deallocated");
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initViewController];
    
}

- (void)initViewController {
    
    UIFont *font = [UIFont fontWithName:@"GrandHotel-Regular" size:125];
    
    self.mainLabel.font = font;
    self.mainLabel.text = quoteText;
    self.mainLabel.lineBreakMode = NSLineBreakByClipping;
    self.mainLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    self.slider.maximumValue = 100;
    
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
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(IBAction)addImageButtonTouched:(id)sender{
    
    [self showImagePickingActionSheet];
    
}

-(IBAction)shareButtonTouched:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook]) {
        
        SLComposeViewController __weak *composeViewController = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
        [composeViewController addImage: [self imageWithView:self.view]];
        
        [composeViewController setCompletionHandler: ^(SLComposeViewControllerResult result) {
            
            switch (result) {
                    
                case SLComposeViewControllerResultCancelled:
                    [composeViewController dismissViewControllerAnimated:YES completion:nil];
                    break;
                case SLComposeViewControllerResultDone:
                    [composeViewController dismissViewControllerAnimated:YES completion:nil];
                    break;
                default:
                    break;
            }
            
        }];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        NSLog(@"Facebook sharing not enabled. This is a simulator");
    }
    
}

- (void)showImagePickingActionSheet {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pick image from:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPicker: CameraSourceTypeCamera];
        
    }];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPicker: CameraSourceTypeLibrary];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:library];
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)presentPicker:(NSInteger) sourceType {
    
    if(pickerController == nil){
        
        @autoreleasepool {
            
            pickerController = [[UIImagePickerController alloc]init];
            pickerController.delegate = self;
            pickerController.allowsEditing = NO;
            
            [pickerController setSourceType: sourceType == CameraSourceTypeLibrary ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera];
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
        self.shareButton.hidden = NO;
        
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
            
            //We compress the image so that it does not take too long to process large images
            UIImage *compressedImage = [[Utilities sharedManager] scaleImage:[UIImage imageWithData: UIImageJPEGRepresentation([info valueForKey:UIImagePickerControllerOriginalImage], 0.5)] toSize:CGSizeMake(1200, 1200)];
            
            //We save picked images to device (In future this feature can be toggled in settings)
            UIImageWriteToSavedPhotosAlbum([info valueForKey:UIImagePickerControllerOriginalImage], nil, nil, nil);
            
            //Set selected image as background
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
            
            //Set pickerController to nil to be able to choose another sourceType when clicking the '+' button again.
            self->pickerController = nil;
            
        });
    });
    
    
}

- (UIImage *)imageWithView:(UIView *)view{
    
    @autoreleasepool {
        
        self.addImageButton.hidden = YES;
        self.saveButton.hidden = YES;
        self.closeButton.hidden = YES;
        self.slider.hidden = YES;
        self.shareButton.hidden = YES;
        
        if(!self.imageView.image){
            self.captureView.backgroundColor = self.view.backgroundColor;
        }
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        self.addImageButton.hidden = NO;
        self.saveButton.hidden = NO;
        self.closeButton.hidden = NO;
        self.slider.hidden = NO;
        self.shareButton.hidden = NO;
        
        return img;
        
    }
    
}

-(IBAction)sliderValueChanged:(UISlider *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    if(self.imageView.image) {
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

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
#import <AVFoundation/AVFoundation.h>
#import "FCColorPickerViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface SaveViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, FCColorPickerViewControllerDelegate>{
    
    UIImagePickerController *pickerController;
    UIImage *actualBGImage;
    UIImageView *biv;
    Animator *animator;
    UIColor *textColor;
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

- (void)updateMainLabelTextColor {
    
    if (textColor != nil) {
        self.mainLabel.textColor = textColor ? textColor : [UIColor whiteColor];
    } else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData * colorData = [ud objectForKey: @"UD_TEXT_COLOR"];
        
        textColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        
        if (textColor != nil) {
            self.mainLabel.textColor = textColor ? textColor : [UIColor whiteColor];
        }
    }
}

- (void)initViewController {
    
    UIFont *font = [UIFont fontWithName:@"Langdon" size:125];
    
    [self updateMainLabelTextColor];
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
    [self.mainLabel sizeToFit];
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
    
    //Create photo object from our view
    FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:[self imageWithView:self.view] userGenerated:YES];
    //Create a content object
    FBSDKSharePhotoContent *photoContent = [[FBSDKSharePhotoContent alloc] init];
    //Add our photo to the content
    [photoContent setPhotos: @[photo]];
    
    //Init the dialog
    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
    [shareDialog setShouldFailOnDataError:YES];
    [shareDialog setShareContent:photoContent]; // This is the content that the dialog is going to show
    
    //Check if the fb app is installed in the user's device. If YES, use the app. Use browser otherwise
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]) {
        [shareDialog setMode:FBSDKShareDialogModeNative];
    } else {
        [shareDialog setMode:FBSDKShareDialogModeBrowser];
    }
    
    if ([shareDialog canShow]) {
        [shareDialog show];
    } else {
        NSLog(@"Cannot show share dialog for some reason....");
    }
    
//    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPickerWithColor: textColor delegate: self];
//
//    [self presentViewController:colorPicker animated:YES completion: nil];
}

- (void)showImagePickingActionSheet {
    
    pickerController = nil;
    
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
        
        [self saveCapturedImageToDevice:image];
        
    }
}

-(IBAction)closeButtonTouched:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)saveCapturedImageToDevice: (UIImage *)image {
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
            
        case AVAuthorizationStatusDenied:
        {
            NSLog(@"Redirect to settings page to enable camera access!");
            break;
        }
            
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                } else {
                    NSLog(@"Redirect to settings page to enable camera access or throw a message");
                }
                
            }];
            break;
        }
            
        case AVAuthorizationStatusAuthorized:
        {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Clearing previous images from background and from our variable 'actualBGImage'
            actualBGImage = nil;
            self.imageView.image = nil;
            
            //We compress the image so that it does not take too long to process large images
            UIImage *compressedImage = [[Utilities sharedManager] scaleImage:[UIImage imageWithData: UIImageJPEGRepresentation([info valueForKey:UIImagePickerControllerOriginalImage], 0.5)] toSize:CGSizeMake(1200, 1200)];
            
            //We save picked images (Camera) to device (In future this feature can be toggled in settings)
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
                [self saveCapturedImageToDevice:[info valueForKey:UIImagePickerControllerOriginalImage]];
            
            //Set selected image as background
            self.imageView.image = compressedImage;
            actualBGImage = compressedImage;
            
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.clipsToBounds = YES;
            
            //Comment yet to be added for this step
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
            pickerController = nil;
            
        });
    });
    
    
}

- (UIImage *)imageWithView:(UIView *)view{
    
    @autoreleasepool {
        
        //We hide these HUDs to make sure we get only the content to be shared clearly
        self.addImageButton.hidden = YES;
        self.saveButton.hidden = YES;
        self.closeButton.hidden = YES;
        self.slider.hidden = YES;
        self.shareButton.hidden = YES;
        
        if(!self.imageView.image){
            self.captureView.backgroundColor = self.view.backgroundColor;
        }
        
        //Create Image
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

-(void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    
    textColor = color;
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject: colorData forKey: @"UD_TEXT_COLOR"];
    
    [self updateMainLabelTextColor];
    [colorPicker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker {

    [colorPicker dismissViewControllerAnimated:YES completion:nil];
}

@end

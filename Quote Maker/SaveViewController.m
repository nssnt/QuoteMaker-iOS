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
#import <MobileCoreServices/MobileCoreServices.h>
#import "Constants.h"

@interface SaveViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, FCColorPickerViewControllerDelegate, UIDropInteractionDelegate, UIDragInteractionDelegate> {
    
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
    [self updateMainLabelTextColor];
    [self updateBackgroundImage];
    [self addDoubleTapGestureRecognizer];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self storeBGImage];
}

- (void)initViewController {
    
    UIFont *font;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [ud valueForKey:MAIN_FONT];
    
    if ([fontName isEqualToString:@""] || fontName == nil) {
        font = [UIFont fontWithName:@"Langdon" size:125];
    } else {
        font = [UIFont fontWithName:fontName size:125];
    }
    
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
    if (@available(iOS 11.0, *)) {
        [self addDragAbility];
        [self addDropAbility];
    }
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)addDragAbility {
    if (@available(iOS 11.0, *)) {
        for(UIDragInteraction *interaction in biv.interactions) {
            [self.mainLabel removeInteraction:interaction];
        }
        UIDragInteraction *dragInteraction = [[UIDragInteraction alloc] initWithDelegate:self];
        self.mainLabel.userInteractionEnabled = YES;
        [self.mainLabel addInteraction:dragInteraction];
    }
}

-(void)addDropAbility {
    if (@available(iOS 11.0, *)) {
        UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
        self.mainLabel.userInteractionEnabled = YES;
        [self.mainLabel addInteraction: dropInteraction];
    }
}

- (void)updateMainLabelTextColor {
    if (textColor != nil) {
        self.mainLabel.textColor = textColor ? textColor : [UIColor whiteColor];
    } else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData * colorData = [ud objectForKey: TEXT_COLOR];
        textColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        if (textColor != nil) {
            self.mainLabel.textColor = textColor ? textColor : [UIColor whiteColor];
        }
    }
}

- (void)updateBackgroundImage {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData * actualImageData = [ud objectForKey: BACKGROUND_IMAGE];
    NSData * blurredImageData = [ud objectForKey: BLURRED_IMAGE];
    
    if (actualImageData) {
        UIImage *actualImage = [NSKeyedUnarchiver unarchiveObjectWithData:actualImageData];
        UIImage *blurredImage = [NSKeyedUnarchiver unarchiveObjectWithData:blurredImageData];
        
        actualBGImage = actualImage;
        biv = [[UIImageView alloc] initWithFrame:self.view.frame];
        biv.clipsToBounds = YES;
        biv.alpha = slider.value / 100;
        biv.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.imageView addSubview:biv];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageView.image = actualBGImage;
        biv.image = blurredImage;
    } else {
        return;
    }
}

- (void)addDoubleTapGestureRecognizer {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTouchesRequired = 1;
    doubleTap.numberOfTapsRequired = 2;
    [self.captureView addGestureRecognizer:doubleTap];
}

- (void)doubleTapAction:(UITapGestureRecognizer *)gesture {
    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPickerWithColor:textColor delegate:self];
    [self presentViewController:colorPicker animated:YES completion:nil];
}

- (void)storeBGImage {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *actualImageData = [NSKeyedArchiver archivedDataWithRootObject:actualBGImage];
        [ud setObject:actualImageData forKey:BACKGROUND_IMAGE];
        NSData __block *blurredImageData;
        dispatch_async(dispatch_get_main_queue(), ^{
            blurredImageData = [NSKeyedArchiver archivedDataWithRootObject:[actualBGImage applyBlurWithRadius: 28 tintColor:nil saturationDeltaFactor: 1.0 maskImage:nil]];
            [ud setObject:blurredImageData forKey:BLURRED_IMAGE];
        });
    });
}

-(IBAction)addImageButtonTouched:(id)sender{
    [self showImagePickingActionSheetInViewController: self];
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
    
    //Self explanatory
    if ([shareDialog canShow]) {
        [shareDialog show];
    } else {
        NSLog(@"Cannot show fb share dialog");
    }
}

- (void)showImagePickingActionSheetInViewController:(UIViewController *)viewController {
    
    pickerController = nil;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Pick image from:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    actionSheet.popoverPresentationController.sourceView = self.view;
    actionSheet.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPickerWithSourceType: CameraSourceTypeCamera];
        
    }];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPickerWithSourceType: CameraSourceTypeLibrary];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:library];
    [actionSheet addAction:camera];
    [actionSheet addAction:cancel];
    
    [viewController presentViewController:actionSheet animated:YES completion:nil];
}

- (void)presentPickerWithSourceType:(CameraSourceType) sourceType {
    
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
        case AVAuthorizationStatusDenied: {
            NSLog(@"Redirect to settings page to enable camera access!");
            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                } else {
                    NSLog(@"Redirect to settings page to enable camera access or throw a message");
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            break;
        }
        default: {
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

//MARK: FCColorPickerViewController Delegates
-(void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    textColor = color;
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject: colorData forKey: TEXT_COLOR];
    [self updateMainLabelTextColor];
    [colorPicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker {
    [colorPicker dismissViewControllerAnimated:YES completion:nil];
}

//MARK: UIDragInteraction Delegate
- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForBeginningSession:(id<UIDragSession>)session {
    NSItemProvider *provider = [[NSItemProvider alloc] initWithObject:[self imageWithView:self.view]];
    UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:provider];
    item.localObject = [self imageWithView:self.view];
    
    return @[item];
}

//MARK: UIDropInteraction Delegates
-(BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    return [session hasItemsConformingToTypeIdentifiers:@[(NSString *)kUTTypeImage]] && session.items.count == 1;
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    
    CGPoint dropLocation = [session locationInView:self.view];
    UIDropOperation operation;
    
    if (CGRectContainsPoint(self.imageView.frame, dropLocation)) {
        operation = session.localDragSession == nil ? UIDropOperationCopy : UIDropOperationCancel;
    } else {
        operation = UIDropOperationCancel;
    }
    
    return [[UIDropProposal alloc] initWithDropOperation:operation];
}

-(void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    [session loadObjectsOfClass:[UIImage class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *images = objects;
            actualBGImage = [[Utilities sharedManager] scaleImage:[UIImage imageWithData: UIImageJPEGRepresentation([images firstObject], 0.5)] toSize:CGSizeMake(1200, 1200)];
            self.imageView.image = actualBGImage;
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            //Applying our frost filter here....
            UIImage *blurredImage = [actualBGImage applyBlurWithRadius: 28 tintColor:nil saturationDeltaFactor: 1.0 maskImage:nil];
            [biv removeFromSuperview];
            biv = nil;
            biv = [[UIImageView alloc] initWithFrame:self.view.frame];
            biv.clipsToBounds = YES;
            biv.alpha = slider.value / 100;
            biv.contentMode = UIViewContentModeScaleAspectFill;
            
            [self.imageView addSubview:biv];
            biv.image = blurredImage;
        });
    }];
}

@end

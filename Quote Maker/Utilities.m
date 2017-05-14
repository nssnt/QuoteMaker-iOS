//
//  Utilities.m
//  Quote Maker
//
//  Created by Badhan Ganesh on 4/1/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (id)sharedManager {
    static Utilities *sharedUtilities = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtilities = [[self alloc] init];
    });
    return sharedUtilities;
}


- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}


-(UIImage *)blurryGPUImage:(UIImage *)image withBlurLevel:(NSInteger)blur {
    
    @autoreleasepool {
        
        //Blur the UIImage
        CIImage *imageToBlur = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [gaussianBlurFilter setValue:imageToBlur forKey:@"inputImage"];
        [gaussianBlurFilter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
        
        CIImage *resultImage = gaussianBlurFilter.outputImage;
        UIImage *endImage = [[UIImage alloc] initWithCIImage:resultImage];
        
        
        return endImage;
    }
}


- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

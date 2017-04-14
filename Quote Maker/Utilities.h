//
//  Utilities.h
//  Quote Maker
//
//  Created by Badhan Ganesh on 4/1/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject


+ (id)sharedManager;
- (UIImage *)blurryGPUImage:(UIImage *)image withBlurLevel:(NSInteger)blur;
- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize;

@end

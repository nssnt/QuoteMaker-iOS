//
//  AppDelegate.m
//  Quote Maker
//
//  Created by Badhan Ganesh on 2/3/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UD_BG_IMAGE"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UD_BLURRED_IMAGE"];
    [NSThread sleepForTimeInterval: 1.5];
    
    return YES;
}


@end

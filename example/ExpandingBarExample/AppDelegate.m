//
//  AppDelegate.m
//  ExpandingBarExample
//
//  Created by Ryan Nystrom on 3/5/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    FirstView *view = [[FirstView alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    [[self window] setRootViewController:nav];
        
    return YES;
}

@end

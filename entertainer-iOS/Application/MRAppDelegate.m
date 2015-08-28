//
//  MRAppDelegate.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRAppDelegate.h"
#import "SHKConfiguration.h"
#import "MESHKConfiguration.h"

@implementation MRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MKStoreManager sharedManager];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Model.sqlite"];
    [self configureShareKit];
    return YES;
}

-(void)configureShareKit {
    DefaultSHKConfigurator *configurator = [[MESHKConfiguration alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end

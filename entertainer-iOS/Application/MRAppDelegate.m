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



#import "SHKFacebook.h"



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
							
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [SHKFacebook handleDidBecomeActive];
//    [[EvernoteSession sharedSession] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Save data if appropriate
    [SHKFacebook handleWillTerminate];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString* scheme = [url scheme];
    
    NSRange pocketPrefixKeyRange = [(NSString *)SHKCONFIG(pocketConsumerKey) rangeOfString:@"-"];
    NSRange range = {0, pocketPrefixKeyRange.location - 1};
    
    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        return [SHKFacebook handleOpenURL:url sourceApplication:sourceApplication];
    }
    
    return YES;
}

@end

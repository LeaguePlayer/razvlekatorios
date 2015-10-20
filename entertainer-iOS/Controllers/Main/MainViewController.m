//
//  MRViewController.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MainViewController.h"
#import "UIDeviceHardware.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initNavBar];
    UIDeviceHardware *device = [[UIDeviceHardware alloc] init];
    NSString *platformString = [device platformString];
    NSString *imageNameBg = @"";
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        imageNameBg = @"2048";
    }
    else
    {
        //iphone
        if(
           [platformString isEqualToString:@"iPhone 5 (GSM)"] ||
           [platformString isEqualToString:@"iPhone 5 (GSM+CDMA)"] ||
           [platformString isEqualToString:@"iPhone 5c (GSM)"] ||
           [platformString isEqualToString:@"iPhone 5c (GSM+CDMA)"] ||
           [platformString isEqualToString:@"iPhone 5s (GSM)"] ||
           [platformString isEqualToString:@"iPhone 5s (GSM+CDMA)"]
           )
            imageNameBg = @"5s";
        else if(
                [platformString isEqualToString:@"iPhone 1G"] ||
                [platformString isEqualToString:@"iPhone 3G"] ||
                [platformString isEqualToString:@"iPhone 3GS"]
                
                )
            imageNameBg = @"320";
        else if(
                [platformString isEqualToString:@"iPhone 4"] ||
                [platformString isEqualToString:@"Verizon iPhone 4"] ||
                [platformString isEqualToString:@"iPhone 4S"]
                
                )
            imageNameBg = @"retina";
        else if(
                [platformString isEqualToString:@"iPhone 6 Plus"]
                
                )
            imageNameBg = @"6plus";
        else if(
                [platformString isEqualToString:@"iPhone 6"]
                
                )
            imageNameBg = @"6";
        else
            imageNameBg = @"5s";
    }

    
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageNameBg] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

-(void)initNavBar{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

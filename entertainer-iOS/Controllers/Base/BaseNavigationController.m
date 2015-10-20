//
//  BaseNavigationController.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initBar];
}

-(void)hideNavigationBarAnimated:(BOOL)animated{
    
}

-(void)initBar{
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"2v_topbar"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setBackgroundColor:[UIColor redColor]];
    
    UINavigationBar *navigationBar = self.navigationBar;
    UIImage *topBar = nil;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        topBar = [[UIImage imageNamed:@"3v_topbar"]
                       resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    else
        topBar = [UIImage imageNamed:@"2v_topbar"];
    
    [navigationBar setBackgroundImage:topBar
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    
    
//    [navigationBar setShadowImage:[UIImage new]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

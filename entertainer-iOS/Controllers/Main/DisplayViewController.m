//
//  DisplayViewController.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "DisplayViewController.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController

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
    [self initTopBar];
}

-(void)initTopBar{
    [self initBackButton];
    [self initInfoButtonWithTarget:self];
    [self initTopLabel];
    [self initPhotoViewer];
}

-(void)initPhotoViewer{
    MRPhotoViewer *photoViewer = [[MRPhotoViewer alloc] initWithFrame:self.view.bounds];
    [photoViewer setDataSource:self];
    [photoViewer setDelegate:self];
    [self.view addSubview:photoViewer];
    self.photor = photoViewer;
    [self.photor reloadData];
}

-(void)initTopLabel{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 48)];
    label.numberOfLines = 2;
    [label setFont:[UIFont systemFontOfSize:16.0f]];
    [label setText:@""];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:label];
    topLabel = label;
}

-(void)rightItemClick:(id)sender{
    [self performSegueWithIdentifier:@"ToAbout" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - photo viewer data source methods

-(NSUInteger)numberOfPhotosInPhotoViewer:(MRPhotoViewer *)photoViewer{
    return self.block.items.count;
}

-(UIImage *)photoViewer:(MRPhotoViewer *)photoViewer imageAtIndex:(NSUInteger)index{
    MRItem *item = [self.block.items objectAtIndex:index];
    return item.image;
}

#pragma mark - photo viewer delegate methods

-(void)photoViewer:(MRPhotoViewer *)photoViewer positionChangedAtIndex:(NSUInteger)index{
    
}

-(void)photoViewerTaped:(MRPhotoViewer *)photoViewer{
    
}

@end

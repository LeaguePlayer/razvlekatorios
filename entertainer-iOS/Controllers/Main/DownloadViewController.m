//
//  DownloadViewController.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "DownloadViewController.h"
#import "MRDownloadCollectionViewItem.h"
#import "MRBlock.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

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
    [self initBackButton];
    [self initInfoButtonWithTarget:self];
    [self initContent];
    [self initCollectionView];
    [self initUI];
}

-(void)initContent{
    blocks = [MRBlock blocksMock];
}

-(void)initCollectionView{
    self.collectionView = [[SSCollectionView alloc] init];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0,10.0f,self.view.frame.size.width,self.view.frame.size.height);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view insertSubview:self.collectionView atIndex:0];
    self.collectionView.userInteractionEnabled = YES;
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"fon.png"]]];
    [self initTitle];
}

-(void)initTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 48)];
    label.numberOfLines = 1;
    [label setFont:[UIFont systemFontOfSize:17.0f]];
    [label setText:@"Загрузить развлекаторы"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSCollectionViewDataSource

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
    return 1;
}


- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    return blocks.count;
}

- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
    static NSString *const itemIdentifier = @"itemIdentifier";
    
    MRDownloadCollectionViewItem *item = [[MRDownloadCollectionViewItem alloc] initWithReuseIdentifier:itemIdentifier];
    MRBlock *block = [blocks objectAtIndex:indexPath.row];
    
    [item.nameLabel setText:block.name];
    [item.icon setImage:block.image];
    [item.priceLabel setText:@"Free"];
    
    return item;
}

#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
    return CGSizeMake(125.0f, 145.0f);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

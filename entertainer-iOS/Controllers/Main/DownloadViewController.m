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
#import "MRHTTPClient.h"
#import "UIImageView+AFNetworking.h"

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

-(void)rightItemClick:(id)sender{
    [self performSegueWithIdentifier:@"About" sender:self];
}

-(void)initContent{
    [SVProgressHUD showWithStatus:@"Загрузка" maskType:SVProgressHUDMaskTypeGradient];
    [CurrentClient allBlocksWithSuccess:^(NSArray *results) {
        [SVProgressHUD dismiss];
        blocks = results;
        [self.collectionView reloadData];
    } failure:^(int statusCode, NSArray *errors, NSError *commonError) {
        [SVProgressHUD dismiss];
    }];
}

-(void)initCollectionView{
    self.collectionView = [[SSCollectionView alloc] init];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0,5,self.view.frame.size.width,self.view.frame.size.height - 5);
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
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSCollectionViewDataSource

-(CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section{
    return 10;
}

-(UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section{
    return [[UIView alloc] init];
}

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
    NSURL *imageUrl = [NSURL URLWithString:block.imagePath];
    [item.icon setImageWithURL:imageUrl placeholderImage:[[UIImage alloc] init]];
    NSString *price;
    if ([block isStored]){
        price = @"Загружено";
    } else {
        price = block.price.floatValue == 0 ? @"Free" : [NSString stringWithFormat:@"%@",block.price];
    }
    [item.priceLabel setText:price];
    [item.priceLabel setAdjustsFontSizeToFitWidth:YES];
    
    return item;
}

#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
    return CGSizeMake(125.0f, 145.0f);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MRBlock *block = [blocks objectAtIndex:indexPath.row];
    if ([block isStored])
        return;
    MRDownloadCollectionViewItem *item = (MRDownloadCollectionViewItem *)[aCollectionView itemForIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
       [item.progressView setAlpha:1];
    }];
    item.progressView.progress = 0;
    [CurrentClient blockItemsWithBlock:block progress:^(CGFloat state){
        item.progressView.progress = state;
    }success:^(NSArray *results) {
        block.items = results;
        item.progressView.progress = 1.0f;
        [item.priceLabel setText:@"Загружено"];
        [UIView animateWithDuration:0.2 animations:^{
            [item.progressView setAlpha:0];
        }];
    } failure:^(int statusCode, NSArray *errors, NSError *commonError) {
        
    }];
}

@end

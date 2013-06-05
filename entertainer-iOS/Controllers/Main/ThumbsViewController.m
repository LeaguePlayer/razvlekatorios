//
//  ThumbsViewController.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "ThumbsViewController.h"
#import "MRItem.h"

@interface ThumbsViewController ()

@end

@implementation ThumbsViewController

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
    [self initCollectionView];
}

-(void)initCollectionView{
    self.collectionView = [[SSCollectionView alloc] initWithFrame:self.view.bounds];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.view addSubview:self.collectionView];
}

#pragma mark - collection view data source methods

-(UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section{
    return [[UIView alloc] init];
}

-(NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView{
    return 1;
}

-(NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section{
    return self.block.items.count;
}

-(SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath{
    NSString *itemIdentifier = @"collectionItem";
    SSCollectionViewItem *item = [[SSCollectionViewItem alloc] initWithStyle:SSCollectionViewItemStyleImage reuseIdentifier:itemIdentifier];
    MRItem *blockItem = [self.block.items objectAtIndex:indexPath.row];
    [item.imageView setImage:blockItem.image];
    [item.imageView setContentMode:UIViewContentModeScaleAspectFit];
    return item;
}

#pragma mark - collection view delegate methods

-(CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section{
    return 20.0;
}

-(CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section{
    return CGSizeMake(60, 60);
}

-(void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(thumbViewItemDidSelectAtIndex:)]){
        [self.delegate thumbViewItemDidSelectAtIndex:indexPath.row];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

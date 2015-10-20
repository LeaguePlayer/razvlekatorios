//
//  ThumbsViewController.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "ThumbsViewController.h"
#import "MRItem.h"
#import "SVProgressHUD.h"

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
//    items = [[NSMutableArray alloc] init];
//    itemsThumb = self.thumbs;
//    for (MRItem* item in self.thumbs)
//    {
//        [items addObject:item.thumbImage];
//    }
//    self.thumbs = nil;
//    NSLog(@"%i",self.block.id);
    [self initCollectionView];
    
    [SVProgressHUD dismiss];
}

-(void)viewWillAppear:(BOOL)animated{
    [self initTopBar];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)initTopBar{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStyleDone target:self action:@selector(onCancelButtonClick:)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    
    [self.navigationItem setRightBarButtonItem:item];
    [self.navigationItem setHidesBackButton:YES];
}

-(void)onCancelButtonClick:(id)sender{
    [self dismissByFlipping];
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
    return self.itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell
//    NSLog(@"TTT");
    
    return cell;
}


-(SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"HELLLO %i!!", indexPath.row);
    NSString *itemIdentifier = @"collectionItem";
    SSCollectionViewItem *item = [[SSCollectionViewItem alloc] initWithStyle:SSCollectionViewItemStyleImage reuseIdentifier:itemIdentifier];
    
//    NSLog(@"%@",item.imageView.image);
    
    MRItem* model = (MRItem *)[self.thumbs objectAtIndex:indexPath.row];
    UIImage *image = model.thumbImage;
    [item.imageView setImage:image];
//    [item.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
//    NSLog(@"%@",item.imageView.image);
    
    
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
    [self dismissByFlipping];
}

-(void)dismissByFlipping{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
//    itemsThumb = nil;
//    items = nil;
//    for (MRItem* item in itemsThumb)
//    {
//        [items addObject:item.image];
//    }
//    itemsThumb = [NSMutableArray arrayWithArray:[MRItem allItemsWithSelectedBlockId:self.block.id]];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

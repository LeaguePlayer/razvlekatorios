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
    [self initDownloader];
    [self initBackButton];
    [self initInfoButtonWithTarget:self];
    [self initContent];
    [self initCollectionView];
    [self initUI];
}

-(void)initDownloader{
    imageDownloader = [[SDWebImageDownloader alloc] init];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [DownloadManager addDelegate:self];
    [self updateProgressViews];
}

-(void)updateProgressViews{
    for (int i = 0; i < blocks.count; i++){
        MRBlock *block = [blocks objectAtIndex:i];
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        MRDownloadCollectionViewItem *item = (MRDownloadCollectionViewItem *)[self.collectionView itemForIndexPath:path];
        if ([DownloadManager loadsObjectWithId:block.id]){
            CGFloat state = [DownloadManager loadingStateOfObjectWithId:block.id];
            [item.progressView setAlpha:1];
            [item.progressView setProgress:state];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DownloadManager removeDelegate:self];
}

-(void)rightItemClick:(id)sender{
    [self performSegueWithIdentifier:@"About" sender:self];
}

-(void)initContent{
    [SVProgressHUD showWithStatus:@"Загрузка" maskType:SVProgressHUDMaskTypeGradient];
    [CurrentClient allBlocksWithSuccess:^(NSArray *results) {
        [SVProgressHUD dismiss];
        blocks = results;
//        images = [NSMutableArray array];
//        for (int i = 0; i < blocks.count; i++){
//            [images addObject:@(NO)];
//        }
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
    NSString *itemIdentifier = @"itemIdentifier";
    
    MRDownloadCollectionViewItem *item = [[MRDownloadCollectionViewItem alloc] initWithReuseIdentifier:itemIdentifier];
    MRBlock *block = [blocks objectAtIndex:indexPath.row];
    
    [item.nameLabel setText:block.name];
    NSURL *imageUrl = [NSURL URLWithString:block.imagePath];
    [imageDownloader downloadImageWithURL:imageUrl options:nil progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [item.icon setImage:image];
            [item.activityView removeFromSuperview];
        });
    }];
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
    __block MRBlock *block = [blocks objectAtIndex:indexPath.row];
    
    
    void(^downloadBLock)(void) = ^{
        MRDownloadCollectionViewItem *item = (MRDownloadCollectionViewItem *)[aCollectionView itemForIndexPath:indexPath];
        [UIView animateWithDuration:0.2 animations:^{
            [item.progressView setAlpha:1];
        }];
        item.progressView.progress = 0;
        [DownloadManager startLoadingBlock:block];
    };
    
    if ([block isStored] || [DownloadManager loadsObjectWithId:block.id])
        return;
    if ([block paid]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[MKStoreManager sharedManager] buyFeature:block.productID onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
            [SVProgressHUD showSuccessWithStatus:@"Покупка произведена успешно"];
            downloadBLock();
        } onCancelled:^{
            [SVProgressHUD showErrorWithStatus:@"Ошибка покупки"];
        }];
    } else {
        downloadBLock();
    }
    
    
}

#pragma mark - download manager delegate methods

-(void)downloadStateChangedWithObjectId:(int)id withState:(CGFloat)state{
    NSIndexPath *path;
    for (int i = 0; i < blocks.count; i++){
        MRBlock *block = [blocks objectAtIndex:i];
        if (block.id == id){
            path = [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    if (!path) return;
    MRDownloadCollectionViewItem *item = (MRDownloadCollectionViewItem *)[self.collectionView itemForIndexPath:path];
    [item.progressView setProgress:state];
}

-(void)downloadCompliteWithObjectId:(int)id{
    NSIndexPath *path;
    for (int i = 0; i < blocks.count; i++){
        MRBlock *block = [blocks objectAtIndex:i];
        if (block.id == id){
            path = [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    if (!path) return;
    MRDownloadCollectionViewItem *item = (MRDownloadCollectionViewItem *)[self.collectionView itemForIndexPath:path];
    item.priceLabel.text = @"Загружено";
    [UIView animateWithDuration:0.2 animations:^{
        [item.progressView setAlpha:0];
    }];
}

-(void)downloadFailedWithObjectId:(int)id{
    NSIndexPath *path;
    for (int i = 0; i < blocks.count; i++){
        MRBlock *block = [blocks objectAtIndex:i];
        if (block.id == id){
            path = [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    if (!path) return;
    MRDownloadCollectionViewItem *item = (MRDownloadCollectionViewItem *)[self.collectionView itemForIndexPath:path];
    [UIView animateWithDuration:0.2 animations:^{
        [item.progressView setAlpha:0];
    }];
}

@end

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
#import "DisplayViewController.h"

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
    DefaultContext;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initDownloader];
    [self initBackButton];
    [self initInfoButtonWithTarget:self];
    [self initContent];
    [self initCollectionView];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)initDownloader{
    imageDownloader = [[SDWebImageDownloader alloc] init];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [DownloadManager addDelegate:self];
    
}

-(void)updateProgressViews{
    NSLog(@"ww");
    NSLog(@"blocks.count is %i", blocks.count);
    for (int i = 0; i < blocks.count; i++){
        MRBlock *block = [blocks objectAtIndex:i];
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        MRDownloadCollectionViewItem *item = (MRDownloadCollectionViewItem *)[self.collectionView itemForIndexPath:path];
        
        NSLog(@"block.id is %i",block.id);
        if ([DownloadManager loadsObjectWithId:block.id]){
            CGFloat state = [DownloadManager loadingStateOfObjectWithId:block.id];
            [item.progressView setAlpha:1];
            [item.activityView setAlpha:1];
//            [item.icon setAlpha:0.3];
            [item.progressView setProgress:state animated:YES];
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
         NSLog(@"initContent");
//        images = [NSMutableArray array];
//        for (int i = 0; i < blocks.count; i++){
//            [images addObject:@(NO)];
//        }
        
        [self.collectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [DownloadManager addDelegate:self];
            [self updateProgressViews];
        });
        
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
    blocks = nil;
    images = nil;
    imageDownloader = nil;
    selectedPath = nil;
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
//            [item.activityView setAlpha:0];
        });
    }];
    NSString *price;
    if ([block isStored]){
        price = @"Загружено";
    } else {
        price = block.price.floatValue == 0 ? @"Free" : [NSString stringWithFormat:@"%@",block.price];
        if ([DownloadManager loadsObjectWithId:block.id]){
            CGFloat state = [DownloadManager loadingStateOfObjectWithId:block.id];
            [item.progressView setAlpha:1];
            [item.activityView setAlpha:1];
//            [item.icon setAlpha:0.3];
            [item.progressView setProgress:state animated:YES];
        }
    }
    [item.priceLabel setText:price];
    [item.priceLabel setAdjustsFontSizeToFitWidth:YES];
    
    return item;
}

#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
    return CGSizeMake(125.0f, 160.0f);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    MRDownloadCollectionViewItem *item =[aCollectionView itemForIndexPath:indexPath];
    
//    return;
    MRBlock *block = [blocks objectAtIndex:indexPath.row];
    NSString *information = block.desc;
    selectedPath = indexPath;
    if ([DownloadManager loadsObjectWithId:block.id])
        return;
    if ([block isStored]){
        [SVProgressHUD showWithStatus:@"Загружаю блок" maskType:SVProgressHUDMaskTypeGradient];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Do background work
            countItemsBySelectedBlock = [MRItem allItemsByBlockId:block.id];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"ToDisplay" sender:self];
            });
        });
//        [self performSegueWithIdentifier:@"ToDisplay" sender:self];
        return;
    }
    if ([block.desc isEqualToString:@""]){
        [self downloadBlock:block];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Информация о блоке" message:information delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Скачать", nil];
        
      
        
        [alertView show];
    }
}

#pragma mark - alert view delegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 1) return;
    
    MRBlock *block = [blocks objectAtIndex:selectedPath.row];
    [self downloadBlock:block];
}

-(void)downloadBlock:(MRBlock *)block{
    void(^downloadBLock)(void) = ^{
        MRDownloadCollectionViewItem *item = (MRDownloadCollectionViewItem *)[self.collectionView itemForIndexPath:selectedPath];
        [UIView animateWithDuration:0.2 animations:^{
            [item.progressView setAlpha:1];
            [item.activityView setAlpha:1];
//            [item.icon setAlpha:0.3];
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
    NSLog(@"progress is %f",state);
    [item.progressView setProgress:state animated:YES];
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
        [item.activityView setAlpha:0];
//        [item.icon setAlpha:1];
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
        [item.activityView setAlpha:0];
    }];
}

#pragma mark - segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ToDisplay"]){
        DisplayViewController *controller = (DisplayViewController *)segue.destinationViewController;
        
//        DisplayViewController *controller = (DisplayViewController *)segue.destinationViewController;
//        controller.block = selected;
        
        
        MRBlock *empty = [blocks objectAtIndex:selectedPath.row];
        NSArray *allDowned = [MRBlock allBlocks];
        MRBlock *loaded;
        for (MRBlock *block in allDowned){
            if (block.id == empty.id){
                loaded = block;
                break;
            }
        }
        controller.block = loaded;
//        controller.itemsCount = [MRItem allItemsByBlockId:loaded.id];
        controller.itemsCount = countItemsBySelectedBlock;
    }
}

@end

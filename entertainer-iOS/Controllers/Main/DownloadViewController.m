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
#import "MRAppDelegate.h"
#import "MRNoInternetLabel.h"
#import <QuartzCore/QuartzCore.h>

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
    
    if([self testInternetConnection])
        [self loadAll];
    else
         [self showNoInternet];
    
    [self initBackButton];
}

-(void)loadAll
{
    DefaultContext;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDownloader];
    
    [self initInfoButtonWithTarget:self];
    [self initContent];
    [self initCollectionView];
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetMyNotification:)
                                                 name:@"NoticeAfterDownload"
                                               object:nil];

}

-(void)showNoInternet
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    MRAppDelegate *appDelegate = (MRAppDelegate *)[[UIApplication sharedApplication] delegate];

    
    backgroundNoInternet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    backgroundNoInternet.backgroundColor = [UIColor colorWithRed:0.067 green:0.067 blue:0.067 alpha:0.8f];
    [backgroundNoInternet setAlpha:0.f];
    
    float topPadding = 40;
    float spacingBetweenObjects = 16;
    
  
    
    UIView* whiteView = [[UIView alloc] initWithFrame:CGRectMake(20, 150, screenWidth-40, 260)];
        whiteView.backgroundColor = [UIColor whiteColor];
    

    
    UIImageView* badSmile = [[UIImageView alloc] initWithFrame:CGRectMake((whiteView.frame.size.width/2)-(73/2), topPadding, 73, 59)];
    [badSmile setImage:[UIImage imageNamed:@"no_internet"]];
    [whiteView addSubview:badSmile];
    topPadding += badSmile.frame.size.height + spacingBetweenObjects;
    
    MRNoInternetLabel* bottomLabel = [[MRNoInternetLabel alloc] initWithFrame:CGRectMake(0, topPadding, whiteView.frame.size.width, 80)];
    [bottomLabel setText:@"Извините, нет соединения с интернетом, чтобы выбрать и загрузить новые развлекаторы"];
    [whiteView addSubview:bottomLabel];
    topPadding += bottomLabel.frame.size.height + spacingBetweenObjects;
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame = CGRectMake((whiteView.frame.size.width/2)-(179/2), topPadding, 179, 48);
    agreeButton.backgroundColor = [UIColor colorWithRed:0.024 green:0.604 blue:0.953 alpha:1];
    [whiteView addSubview:agreeButton];
    
    [agreeButton setTitle:@"Закрыть" forState:UIControlStateNormal];
    [agreeButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    agreeButton.layer.cornerRadius = 5;
    agreeButton.layer.masksToBounds = YES;
    [agreeButton addTarget:self action:@selector(agreeWithNoInternet) forControlEvents:UIControlEventTouchUpInside];
    
    topPadding += agreeButton.frame.size.height;
    
    
    
    CGRect frame = whiteView.frame;
    frame.size.height = topPadding+40;
    frame.origin.y = (screenHeight/2)-(frame.size.height/2);
    whiteView.frame = frame;
    
    whiteView.layer.cornerRadius = 20;
    whiteView.layer.masksToBounds = YES;
    
    [backgroundNoInternet addSubview:whiteView];
    [[appDelegate window] addSubview:backgroundNoInternet];
    
    [UIView animateWithDuration:0.5 animations:^{
        [backgroundNoInternet setAlpha:1.0f];
    }];
}

-(void)agreeWithNoInternet
{
    [UIView animateWithDuration:0.5 animations:^{
         [backgroundNoInternet setAlpha:0.f];
    } completion:^(BOOL finished) {
        if(backgroundNoInternet)
        {
            [backgroundNoInternet removeFromSuperview];
            backgroundNoInternet = nil;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
}

- (BOOL)testInternetConnection
{
//    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        //my web-dependent code
        return true;
    }
    else {
        //there-is-no-connection warning
        NSLog(@"ERROR!");
       
        return false;
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
//
//    // Internet is reachable
//    internetReachableFoo.reachableBlock = ^(Reachability*reach)
//    {
//        // Update the UI on the main thread
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"Yayyy, we have the interwebs!");
//            [self loadAll];
//        });
//    };
//    
//    // Internet is not reachable
//    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
//    {
//        // Update the UI on the main thread
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"Someone broke the internet :(");
//            [self.navigationController popViewControllerAnimated:YES];
//        });
//    };
//    
//    [internetReachableFoo startNotifier];
  

}


- (void)didGetMyNotification:(NSNotification*)notification {
     NSLog(@"Hello! I FINISH DOWNLAOD");
    NSNumber *gotObject = (NSNumber *)[notification object];
//    NSLog(@"%li",(long)[gotObject integerValue]);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self downloadCompliteWithObjectId:[gotObject integerValue]];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)initDownloader{
    imageDownloader = [[SDWebImageManager alloc] init];
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
        [self showNoInternet];
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
    label.numberOfLines = 2;
    [label setFont:[UIFont systemFontOfSize:16.0f]];
    [label setText:@"Загрузить развлекаторы"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
}

- (void)didReceiveMemoryWarning
{
//    blocks = nil;
//    images = nil;
//    imageDownloader = nil;
//    selectedPath = nil;
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
//    [imageDownloader downloadImageWithURL:imageUrl options:nil progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [item.icon setImage:image];
////            [item.activityView setAlpha:0];
//        });
//    }];
    
    [imageDownloader downloadImageWithURL:imageUrl options:nil progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [item.icon setImage:image];
            //            [item.activityView setAlpha:0];
        });
    }];
//    SDWebImageManager *a = [[SDWebImageManager alloc] init];
//    [a downloadImageWithURL:<#(NSURL *)#> options:<#(SDWebImageOptions)#> progress:<#^(NSInteger receivedSize, NSInteger expectedSize)progressBlock#> completed:<#^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)completedBlock#>]
    
    
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
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    return CGSizeMake(175.0f, 224.0f);
        else
    return CGSizeMake(125.0f, 160.0f);
}


- (void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    MRDownloadCollectionViewItem *item =[aCollectionView itemForIndexPath:indexPath];
    
//    return;
    if(![self testInternetConnection])
    {
        [self showNoInternet];
        return;
    }
    
    
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

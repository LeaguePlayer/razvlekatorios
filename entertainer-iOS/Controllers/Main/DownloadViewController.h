//
//  DownloadViewController.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseViewController.h"
#import <SSToolkit/SSCollectionView.h>
#import "MRDownloadManager.h"
#import "SDWebImageDownloader.h"
#import "MRBlock.h"

@interface DownloadViewController : BaseViewController <SSCollectionViewDataSource,SSCollectionViewDelegate, MRDownloadManagerDelegate, UIAlertViewDelegate>{
    NSArray *blocks;
    NSMutableArray *images;
    SDWebImageDownloader *imageDownloader;
    NSIndexPath *selectedPath;
}

@property (nonatomic,retain) SSCollectionView *collectionView;




@end

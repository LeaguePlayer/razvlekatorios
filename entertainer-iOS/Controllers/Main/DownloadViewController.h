//
//  DownloadViewController.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseViewController.h"
#import <SSToolkit/SSCollectionView.h>

@interface DownloadViewController : BaseViewController <SSCollectionViewDataSource,SSCollectionViewDelegate>{
    NSArray *blocks;
}

@property (nonatomic,retain) SSCollectionView *collectionView;


@end

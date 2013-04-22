//
//  ChooseViewController.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseViewController.h"
#import <SSToolkit/SSCollectionView.h>
#import "MRBlock.h"
#import "FGalleryViewController.h"

@interface ChooseViewController : BaseViewController <SSCollectionViewDataSource,SSCollectionViewDelegate, FGalleryViewControllerDelegate>{
    NSArray *blocks;
    MRBlock *selected;
}

@property (nonatomic,retain) SSCollectionView *collectionView;

@end

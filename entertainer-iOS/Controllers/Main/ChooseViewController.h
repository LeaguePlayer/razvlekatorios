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
#import "MRChooseCollectionViewItem.h"

@interface ChooseViewController : BaseViewController <SSCollectionViewDataSource,SSCollectionViewDelegate, FGalleryViewControllerDelegate, ChooseCollectionViewItemDelegate>{
    NSArray *blocks;
    MRBlock *selected;
    BOOL shaking;
}

@property (nonatomic,retain) SSCollectionView *collectionView;

@end

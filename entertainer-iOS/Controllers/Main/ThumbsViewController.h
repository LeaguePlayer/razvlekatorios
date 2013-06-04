//
//  ThumbsViewController.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseViewController.h"
#import "SSCollectionView.h"

@interface ThumbsViewController : BaseViewController <SSCollectionViewDataSource,SSCollectionViewDelegate>

@property (nonatomic, retain) SSCollectionView *collectionView;

@end

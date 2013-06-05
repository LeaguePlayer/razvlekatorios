//
//  ThumbsViewController.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseViewController.h"
#import "SSCollectionView.h"
#import "MRBlock.h"

@protocol ThumbViewDelegate <NSObject>

@optional

-(void)thumbViewItemDidSelectAtIndex:(NSUInteger)index;

@end

@interface ThumbsViewController : BaseViewController <SSCollectionViewDataSource,SSCollectionViewDelegate>

@property (nonatomic, retain) MRBlock *block;
@property (nonatomic, retain) SSCollectionView *collectionView;
@property (nonatomic, retain) id<ThumbViewDelegate> delegate;

@end

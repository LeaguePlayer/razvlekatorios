//
//  MRPhotoViewer.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRPhoto.h"
#import "MRBlock.h"

@class MRPhotoViewer;

@protocol MRPhotoViewerDataSource <NSObject>

@required

-(NSUInteger)numberOfPhotosInPhotoViewer:(MRPhotoViewer *)photoViewer;
-(UIImage *)photoViewer:(MRPhotoViewer *)photoViewer imageAtIndex:(NSUInteger)index;

@end

@protocol MRPhotoViewerDelegate <NSObject>

@optional

-(void)photoViewerTaped:(MRPhotoViewer *)photoViewer;
-(void)photoViewer:(MRPhotoViewer *)photoViewer positionChangedAtIndex:(NSUInteger)index;

@end

@interface MRPhotoViewer : UIView <UIScrollViewDelegate>{
    
        NSArray *titles;
    NSMutableDictionary *gotItemsFromCD;
//    NSMutableArray *progressViews;
        NSUInteger itemsCount;
        NSInteger currentIndex;
        NSInteger currentPart;
        NSUInteger partsCount;
        CGSize size;
    NSInteger lastCurrentIndex;
     NSInteger lastCounter;
    NSInteger shiftIndex;
    NSInteger shiftParts;
    BOOL initedFirst;
    BOOL IS_LOADING;
    NSInteger activePart;
    NSInteger counter;
    
    NSMutableArray *leftScrollHistory;
    NSMutableArray *rightScrollHistory;
}
@property (nonatomic, retain) NSMutableDictionary *items;
@property (nonatomic, retain) NSArray *suffleArrayKeys;
@property (nonatomic, retain) MRBlock *selectedBlock;

@property (nonatomic, retain) id<MRPhotoViewerDelegate> delegate;
@property (nonatomic, retain) id<MRPhotoViewerDataSource> dataSource;
@property (nonatomic, retain) UIScrollView *mainScroll;
-(void)reloadData;
-(void)moveAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end

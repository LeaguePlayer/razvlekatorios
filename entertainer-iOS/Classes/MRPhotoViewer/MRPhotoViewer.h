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
//    NSMutableDictionary *gotItemsFromCD;
//    NSMutableArray *progressViews;
        NSUInteger itemsCount;
       
        NSInteger currentPart;
        NSUInteger partsCount;
        CGSize size;
    NSInteger lastCurrentIndex;
     NSInteger lastCounter;
    NSInteger shiftIndex;
    NSInteger shiftParts;
    BOOL initedFirst;
    
    NSInteger activePart;
    
    
    NSMutableArray *leftScrollHistory;
    NSMutableArray *rightScrollHistory;
}
@property (nonatomic, retain) NSMutableDictionary *gotItemsFromCD;
@property (nonatomic) NSInteger counter;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL IS_LOADING;
@property (nonatomic) BOOL FROM_SHUFFLE;
@property (nonatomic, retain) NSMutableDictionary *items;
@property (nonatomic, retain) NSArray *suffleArrayKeys;
@property (nonatomic, retain) MRBlock *selectedBlock;

@property (nonatomic, retain) id<MRPhotoViewerDelegate> delegate;
@property (nonatomic, retain) id<MRPhotoViewerDataSource> dataSource;
@property (nonatomic, retain) UIScrollView *mainScroll;
-(void)reloadData;
-(void)moveAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)moveImageAtIndex:(int)atIndexPhoto ToIndexPhoto:(int)toIndexPhoto;
-(void)moveAtIndexStatic:(NSUInteger)index andIdPhoto:(NSUInteger)idPhoto animated:(BOOL)animated;

@end

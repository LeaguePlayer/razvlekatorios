//
//  MRPhotoViewer.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRPhoto.h"

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
        NSArray *items;
        NSArray *titles;
        NSUInteger itemsCount;
        NSInteger currentIndex;
        CGSize size;
}

@property (nonatomic, retain) id<MRPhotoViewerDelegate> delegate;
@property (nonatomic, retain) id<MRPhotoViewerDataSource> dataSource;
@property (nonatomic, retain) UIScrollView *mainScroll;
-(void)reloadData;
-(void)moveAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end

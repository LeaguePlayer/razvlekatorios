//
//  MRPhotoViewer.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRPhotoViewer.h"

@implementation MRPhotoViewer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        size = frame.size;
        itemsCount = 0;
        [self initGestures];
        self.mainScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.mainScroll setDelegate:self];
        [self.mainScroll setPagingEnabled:YES];
//        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.mainScroll];
    }
    return self;
}

-(void)initGestures{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTaped:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setCancelsTouchesInView:NO];
    [self addGestureRecognizer:recognizer];
}

-(void)viewTaped:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewerTaped:)]){
        [self.delegate photoViewerTaped:self];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    size = frame.size;
}

-(void)reloadData{
    for (MRPhoto *photo in items){
        [photo removeFromSuperview];
    }
    itemsCount = 0;
    currentIndex = 0;
    [self.mainScroll setContentOffset:CGPointZero];
    items = [NSArray array];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfPhotosInPhotoViewer:)]){
        itemsCount = [self.dataSource numberOfPhotosInPhotoViewer:self];
        if ([self.dataSource respondsToSelector:@selector(photoViewer:imageAtIndex:)]){
            CGFloat inset = 0;
            for (int i = 0; i < itemsCount; i++){
                MRPhoto *photo = [[MRPhoto alloc] initWithFrame:CGRectMake(inset, 0, size.width, size.height)];
                UIImage *photoImage = [self.dataSource photoViewer:self imageAtIndex:i];
                [photo setImage:photoImage];
                [self.mainScroll addSubview:photo];
                items = [items arrayByAddingObject:photo];
                
                inset += size.width;
            }
            [self.mainScroll setContentSize:CGSizeMake(inset, size.height)];
        }
    }
    [self sayDelegateIndexChanged];
}

#pragma mark - scroll view delegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    int index = floor((point.x - size.width / 2) / size.width) + 1;
    if (index == currentIndex) return;
    currentIndex = index;
    [self sayDelegateIndexChanged];
}

-(void)moveAtIndex:(NSUInteger)index animated:(BOOL)animated{
    CGFloat offset = index * size.width;
    CGPoint point = CGPointMake(offset, 0);
    if (animated){
        [UIView animateWithDuration:0.4 animations:^{
            [self.mainScroll setContentOffset:point];
        }];
    } else {
        [self.mainScroll setContentOffset:point];
    }
    
}

-(void)sayDelegateIndexChanged{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewer:positionChangedAtIndex:)]){
        [self.delegate photoViewer:self positionChangedAtIndex:currentIndex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

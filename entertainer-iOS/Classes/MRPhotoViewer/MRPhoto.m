//
//  MRPhoto.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRPhoto.h"

#define ZOOM_STEP 1.5

@implementation MRPhoto

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        size = frame.size;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setUserInteractionEnabled:YES];
        [self setContentSize:size];
        [self addSubview:imageView];
        [self setDelegate:self];
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [twoFingerTap setNumberOfTouchesRequired:2];        
        
        [imageView addGestureRecognizer:doubleTap];
        [imageView addGestureRecognizer:twoFingerTap];
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    [imageView setImage:image];
    CGRect frame = imageView.frame;
    frame.size = image.size;
    if (image.size.height > size.height){
        CGFloat height = image.size.height;
        if (image.size.width > size.width){
            CGFloat ratio = size.width/image.size.width;
            height = height * ratio;
            frame.size.width = size.width;
        }
        frame.size.height = height;
        frame.origin = CGPointZero;
    } else if (image.size.width > size.width){
        frame.size = size;
    } else {
//        frame.origin.x = (size.width - image.size.width)/2;
//        frame.origin.y = (size.height - image.size.height)/2;
    }
    frame.size.height = MAX(frame.size.height, size.height);
    [imageView setFrame:frame];
    frame.size.height = MAX(frame.size.height, self.frame.size.height);
    [self setContentSize:CGSizeMake(size.width, frame.size.height)];
    CGFloat minimumScale = self.frame.size.width  / imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale];
    [self setMaximumZoomScale:2.0];
    [self setZoomScale:1];
}

-(void)dismissZommingAnimated:(BOOL)animated{
    [self setZoomScale:1.0 animated:animated];
}

#pragma mark - scroll view delegate methods

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
    
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // double tap zooms in
    float newScale = [self zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    // two-finger tap zooms out
    float newScale = [self zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [self zoomToRect:zoomRect animated:YES];
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

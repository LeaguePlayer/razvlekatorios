//
//  MRPhoto.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRPhoto.h"

@implementation MRPhoto

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        size = frame.size;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self setContentSize:size];
        [self addSubview:imageView];
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
        frame.origin.x = (size.width - image.size.width)/2;
        frame.origin.y = (size.height - image.size.height)/2;
    }
    [imageView setFrame:frame];
    [self setContentSize:CGSizeMake(size.width, frame.size.height)];
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

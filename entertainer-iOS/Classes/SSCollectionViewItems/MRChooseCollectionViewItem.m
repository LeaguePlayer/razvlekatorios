//
//  MRBlockCollectionViewItem.m
//  entertainer-iOS
//
//  Created by Developer on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#import "MRChooseCollectionViewItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation MRChooseCollectionViewItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithReuseIdentifier:(NSString *)aReuseIdentifier {
    if ((self = [super initWithStyle:SSCollectionViewItemStyleBlank reuseIdentifier:aReuseIdentifier])) {
        self.imageView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.imageView = nil;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,125,20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor blueColor];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        [self.nameLabel setAdjustsFontSizeToFitWidth:NO];
        [self addSubview:self.nameLabel];
        self.icon = [[UIImageView alloc] init];
        [self.icon setContentMode:UIViewContentModeScaleAspectFit];
        [self.icon setFrame:CGRectMake(0, 21, 125, 125)];
        [self addSubview:self.icon];
        UIImage *removeImg = [UIImage imageNamed:@"remove.png"];
        self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.removeButton setImage:removeImg forState:UIControlStateNormal];
        CGRect frame = CGRectMake(126 - (removeImg.size.width+10), self.icon.frame.origin.y+10, removeImg.size.width+20, removeImg.size.height+20);
        [self.removeButton setFrame:frame];
        [self.removeButton setHidden:YES];
        [self addSubview:self.removeButton];
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemPressed:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

-(void)itemPressed:(UILongPressGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemLongPressed:)]){
        [self.delegate itemLongPressed:self];
    }
}

-(void)setRemoveButtonHidden:(BOOL)hide{
    CGFloat alpha = hide ? 0 : 1;
    [UIView animateWithDuration:0.3 animations:^{
        [self.removeButton setAlpha:alpha];
    }];
}

@end

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
        

        self.nameLabel = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? [[UILabel alloc] initWithFrame:CGRectMake(0,0,125*1.4f,35*1.4f)] : [[UILabel alloc] initWithFrame:CGRectMake(0,0,125,35)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor blueColor];
        self.nameLabel.font = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? [UIFont boldSystemFontOfSize:13] :  [UIFont boldSystemFontOfSize:9];
//        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setNumberOfLines:0];
        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        

        
        self.nameLabel.preferredMaxLayoutWidth =( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? 125*1.4f : 125;
        [self addSubview:self.nameLabel];
        
        
        
        self.icon = [[UIImageView alloc] init];
        [self.icon setContentMode:UIViewContentModeScaleAspectFit];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [self.icon setFrame:CGRectMake(0, 36*1.4f, 125*1.4f, 125*1.4f)];
        else
            [self.icon setFrame:CGRectMake(0, 36, 125, 125)];
        [self addSubview:self.icon];
        UIImage *removeImg = [UIImage imageNamed:@"remove"];
        self.removeImage = [[UIImageView alloc] initWithImage:removeImg];
        
        UIImage *infoImg = [UIImage imageNamed:@"info_block"];
        self.infoImage = [[UIImageView alloc] initWithImage:infoImg];
        
        
        self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? CGRectMake((126*1.4f) - removeImg.size.width*3, 0, removeImg.size.width*3, removeImg.size.height*3) :  CGRectMake(126 - removeImg.size.width*3, 0, removeImg.size.width*3, removeImg.size.height*3);
        [self.removeButton setFrame:frame];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            frame = CGRectMake((126*1.4f) - removeImg.size.width, 36*1.4f, removeImg.size.width, removeImg.size.height);
        else
            frame = CGRectMake(126 - removeImg.size.width, 36, removeImg.size.width, removeImg.size.height);
        [self.removeImage setFrame:frame];
        [self.removeImage setHidden:YES];
        [self.removeButton setHidden:YES];
        [self addSubview:self.removeButton];
        [self addSubview:self.removeImage];
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemPressed:)];
        [self addGestureRecognizer:recognizer];
        
        
        self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.infoButton setBackgroundColor:[UIColor redColor]];
        CGRect infoFrame = CGRectMake(0, 0, infoImg.size.width*3, infoImg.size.height*3);
        [self.infoButton setFrame:infoFrame];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            infoFrame = CGRectMake(0, 36*1.4f, infoImg.size.width, infoImg.size.height);
        else
            infoFrame = CGRectMake(0, 36, infoImg.size.width, infoImg.size.height);
        [self.infoImage setFrame:infoFrame];
        [self.infoImage setHidden:YES];
        [self.infoButton setHidden:YES];
        [self addSubview:self.infoButton];
        [self addSubview:self.infoImage];
//        UILongPressGestureRecognizer *recognizerInfo = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemPressed:)];
//        [self addGestureRecognizer:recognizerInfo];
        
        
        
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
        [self.infoButton setAlpha:alpha];
        [self.infoImage setAlpha:alpha];
        [self.removeImage setAlpha:alpha];
    }];
}

@end

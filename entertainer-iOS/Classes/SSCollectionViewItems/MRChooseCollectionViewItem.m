//
//  MRBlockCollectionViewItem.m
//  entertainer-iOS
//
//  Created by Developer on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRChooseCollectionViewItem.h"

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
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = [UIColor blueColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:self.nameLabel];
        self.icon = [[UIImageView alloc] init];
        [self.icon setContentMode:UIViewContentModeScaleAspectFit];
        [self.icon setFrame:CGRectMake(0, 21, 125, 125)];
        [self addSubview:self.icon];
        UIImage *removeImg = [UIImage imageNamed:@"remove.png"];
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeButton setImage:removeImg forState:UIControlStateNormal];
        CGRect frame = CGRectMake(126 - removeImg.size.width, self.icon.frame.origin.y, removeImg.size.width, removeImg.size.height);
        [removeButton setFrame:frame];
        [self addSubview:removeButton];
    }
    return self;
}

@end

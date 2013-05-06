//
//  MRDownloadCollectionViewItem.m
//  entertainer-iOS
//
//  Created by Developer on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRDownloadCollectionViewItem.h"

@implementation MRDownloadCollectionViewItem

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
        
        self.icon = [[UIImageView alloc] init];
        [self.icon setContentMode:UIViewContentModeScaleAspectFit];
        [self.icon setFrame:CGRectMake(0, 21, 125, 125)];
        
        UIImage *prBackImg = [UIImage imageNamed:@"bg_price.png"];
        UIImageView *priceBackView = [[UIImageView alloc] initWithImage:prBackImg];
        CGRect priceFrame = CGRectMake(126 - prBackImg.size.width, self.icon.frame.origin.y, prBackImg.size.width, prBackImg.size.height);
        [priceBackView setFrame:priceFrame];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
        [self.priceLabel setTextAlignment:NSTextAlignmentCenter];
        [self.priceLabel setFont:[UIFont systemFontOfSize:14]];
        [self.priceLabel setBackgroundColor:[UIColor clearColor]];
        [self.priceLabel setTextColor:[UIColor whiteColor]];
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [self.progressView setProgressTintColor:[UIColor blueColor]];
        [self.progressView setFrame:CGRectMake(12,125,100,15)];
        [self.progressView setAlpha:0];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityView setCenter:self.icon.center];
        CGRect frame = self.activityView.frame;
        frame.size = CGSizeMake(20, 20);
        [self.activityView setFrame:frame];
        [self.activityView startAnimating];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.icon];
        [self addSubview:priceBackView];
        [self addSubview:self.priceLabel];
        [self addSubview:self.progressView];
    }
    return self;
}

@end

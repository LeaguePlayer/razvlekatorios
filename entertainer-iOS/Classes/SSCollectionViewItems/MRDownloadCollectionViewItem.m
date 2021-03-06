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
        self.nameLabel = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? [[UILabel alloc] initWithFrame:CGRectMake(0,0,125*1.4f,35*1.4f)] : [[UILabel alloc] initWithFrame:CGRectMake(0,0,125,35)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor blueColor];
        self.nameLabel.font = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? [UIFont boldSystemFontOfSize:13] : [UIFont boldSystemFontOfSize:9];
        // Objective-C
        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.nameLabel.numberOfLines = 0;
        
        
        
        

        
        self.nameLabel.preferredMaxLayoutWidth = 125;
        

        
        self.icon = [[UIImageView alloc] init];
        [self.icon setContentMode:UIViewContentModeScaleAspectFit];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [self.icon setFrame:CGRectMake(0, 36*1.4f, 125*1.4f, 125*1.4f)]; //21
        else
            [self.icon setFrame:CGRectMake(0, 36, 125, 125)]; //21
        
        UIImage *prBackImg = [UIImage imageNamed:@"bg_price.png"];
        UIView *priceBackView = [[UIImageView alloc] init];
        CGRect priceFrame = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? CGRectMake((125*1.4f) - (prBackImg.size.width*1.4f), self.icon.frame.origin.y, (prBackImg.size.width*1.4f), prBackImg.size.height)
        : CGRectMake(125 - prBackImg.size.width, self.icon.frame.origin.y, prBackImg.size.width, prBackImg.size.height);
        [priceBackView setFrame:priceFrame];
        priceBackView.backgroundColor = [UIColor colorWithRed:0.027 green:0.631 blue:1 alpha:1];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
        [self.priceLabel setTextAlignment:NSTextAlignmentCenter];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [self.priceLabel setFont:[UIFont systemFontOfSize:20]];
        else
            [self.priceLabel setFont:[UIFont systemFontOfSize:14]];
        [self.priceLabel setBackgroundColor:[UIColor clearColor]];
        [self.priceLabel setTextColor:[UIColor whiteColor]];
        
        self.progressView = [[UCZProgressView alloc] initWithFrame:self.icon.frame];
        self.progressView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//        self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        self.progressView.radius = 40.0;
        //        [self.progressView2 setp]
        
//        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
//        [self.progressView setProgressTintColor:[UIColor blueColor]];
//        [self.progressView setFrame:CGRectMake(12,125,100,15)];
        [self.progressView setAlpha:0];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityView setCenter:self.icon.center];
        CGRect frame = self.activityView.frame;
        frame.size = CGSizeMake(20, 20);
        [self.activityView setFrame:frame];
        [self.activityView startAnimating];
        [self.activityView setAlpha:0];
        
        
        
        [self addSubview:self.progressView];
        
//        NSDictionary *views = NSDictionaryOfVariableBindings(_progressView2);
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_progressView]-0-|" options:0 metrics:nil views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_progressView]-0-|" options:0 metrics:nil views:views]];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.icon];
        [self addSubview:priceBackView];
        [self addSubview:self.priceLabel];
        [self addSubview:self.progressView];
        [self addSubview:self.activityView];
    }
    return self;
}

@end

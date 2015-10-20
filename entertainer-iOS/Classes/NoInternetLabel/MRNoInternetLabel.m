//
//  MRNoInternetLabel.m
//  entertainer-iOS
//
//  Created by Leonid Minderov on 16.09.15.
//  Copyright (c) 2015 Danyar Salahutdinov. All rights reserved.
//

#import "MRNoInternetLabel.h"

@implementation MRNoInternetLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 3;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [self setFont:[UIFont systemFontOfSize:21.0f]];
        else
            [self setFont:[UIFont systemFontOfSize:15.0f]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setTextColor:[UIColor colorWithRed:0.004 green:0.624 blue:0.98 alpha:1]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

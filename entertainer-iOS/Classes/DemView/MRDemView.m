//
//  MRDemView.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRDemView.h"

@implementation MRDemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"DemView" owner:self options:nil][0];
        view.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        [self addSubview:view];
        self.imageView = (UIImageView *)[view viewWithTag:1];
        self.titleLabel = (UILabel *)[view viewWithTag:2];
        self.descLabel = (UILabel *)[view viewWithTag:3];
        self.scrollView = (UIScrollView *)[view viewWithTag:4];
        self.borderOne = (UIView *)[view viewWithTag:5];
        self.borderTwo = (UIView *)[view viewWithTag:6];
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

@end

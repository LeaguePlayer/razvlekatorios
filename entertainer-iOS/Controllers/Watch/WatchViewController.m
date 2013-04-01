//
//  WatchViewController.m
//  entertainer-iOS
//
//  Created by Developer on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "WatchViewController.h"
#import "MRItem.h"
#import <QuartzCore/QuartzCore.h>

@interface WatchViewController ()

@end

@implementation WatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    demos = [NSMutableArray array];
    currentPage = 1;
    [self initBackButton];
    [self initTitle];
//    [self initInfoButtonWithTarget:self];
    [self initItems];
}

-(void)initTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 48)];
    label.numberOfLines = 2;
    [label setFont:[UIFont systemFontOfSize:16.0f]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:label];
    self.topLabel = label;
    [label setText:[NSString stringWithFormat:@"Страница %d из %d", currentPage, self.items.count]];
}

-(void)rightItemClick:(id)sender{
    
}

-(void)initItems{
    CGPoint center = CGPointMake(self.pageScroll.bounds.size.width/2, self.pageScroll.bounds.size.height/2);
    for (int i = 0; i < self.items.count; i++){
        MRDemView *view = [[MRDemView alloc] initWithFrame:CGRectMake(0, 0, self.pageScroll.frame.size.width, self.pageScroll.frame.size.height)];
        MRItem *item = [self.items objectAtIndex:i];
        [view.imageView setImage:item.image];
        [view.titleLabel setText:item.title];
        [view.descLabel setText:item.detail];
        [view.descLabel sizeToFit];
        CGRect frame = view.imageView.frame;
        frame.size = [self sizeForImage:item.image withMaxWidth:self.pageScroll.frame.size.width];
        frame.origin.x = self.pageScroll.frame.size.width/2 - frame.size.width/2;
        [view.imageView setFrame:frame];
        CGRect borderFrame = frame;
        borderFrame.origin.x -= 2;
        borderFrame.origin.y -= 2;
        borderFrame.size.width += 4;
        borderFrame.size.height += 4;
        [view.borderOne setFrame:borderFrame];
        borderFrame.origin.x -= 2;
        borderFrame.origin.y -= 2;
        borderFrame.size.width += 4;
        borderFrame.size.height += 4;
        [view.borderTwo setFrame:borderFrame];
        view.borderTwo.center = view.imageView.center;
        view.borderOne.center = view.imageView.center;
        CGRect titleFrame = view.titleLabel.frame;
        titleFrame.origin.y = frame.origin.y + frame.size.height + 20;
        [view.titleLabel setFrame:titleFrame];
        CGRect descFrame = view.descLabel.frame;
        descFrame.origin.y = titleFrame.origin.y + titleFrame.size.height + 10;
        descFrame.origin.x = self.pageScroll.frame.size.width/2 - descFrame.size.width/2;
        [view.descLabel setFrame:descFrame];
        [view.scrollView setContentSize:CGSizeMake(view.scrollView.frame.size.width, descFrame.origin.y + descFrame.size.height + 10)];
        view.center = center;
        [demos addObject:view];
        [self.pageScroll addSubview:view];
        center.x += self.pageScroll.bounds.size.width;
    }
    center.x -= self.pageScroll.bounds.size.width/2;
    CGSize size = CGSizeMake(center.x, 366);
    [self.pageScroll setContentSize:size];
}

-(CGSize)sizeForImage:(UIImage *)image withMaxWidth:(CGFloat)width{
    CGSize size = image.size;
    CGFloat newHeight = size.height;
    CGFloat newWidth = size.width;
    CGFloat optimalWidth = width - 30;
    CGFloat factor = 1;
    if (size.width > optimalWidth){
        factor = optimalWidth/size.width;
    }
    CGSize newSize;
    newSize.width = newWidth*factor;
    newSize.height = newHeight*factor;
    return newSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger index = lround(fractionalPage) + 1;
    if (index != currentPage){
        currentPage = index;
        [self.topLabel setText:[NSString stringWithFormat:@"Страница %d из %d", currentPage, self.items.count]];
    }
}

@end

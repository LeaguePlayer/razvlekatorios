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
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pageScroll.frame.size.width, self.pageScroll.frame.size.height)];
        MRItem *item = [self.items objectAtIndex:i];
        [view setImage:item.image];
        CGRect frame = view.frame;
        frame.size = [self sizeForImage:item.image withMaxWidth:self.pageScroll.frame.size.width];
        [view setFrame:frame];
        CGPoint cent = center;
        cent.y = view.center.y;
        view.center = cent;
        center.x += self.pageScroll.bounds.size.width;
        [demos addObject:view];
        [self.pageScroll addSubview:view];
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

- (IBAction)viewTaped:(UITapGestureRecognizer *)sender {
}
@end

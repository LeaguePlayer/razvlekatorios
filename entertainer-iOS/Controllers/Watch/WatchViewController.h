//
//  WatchViewController.h
//  entertainer-iOS
//
//  Created by Developer on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseViewController.h"
#import "MRDemView.h"

@interface WatchViewController : BaseViewController <UIScrollViewDelegate>{
    NSMutableArray *demos;
    NSInteger currentPage;
}

@property (weak, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,retain) UILabel *topLabel;

@property (nonatomic,retain) NSArray *items;
- (IBAction)viewTaped:(UITapGestureRecognizer *)sender;

@end

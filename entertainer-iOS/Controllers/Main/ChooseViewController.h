//
//  ChooseViewController.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseViewController.h"
#import <SSToolkit/SSCollectionView.h>
#import "MRBlock.h"
//#import "FGalleryViewController.h"
#import "MRChooseCollectionViewItem.h"

@interface ChooseViewController : BaseViewController <SSCollectionViewDataSource,SSCollectionViewDelegate, ChooseCollectionViewItemDelegate, UIAlertViewDelegate>{
    NSMutableArray *blocks;
    MRBlock *selected;
    NSIndexPath *removingPath;
    UITapGestureRecognizer *recognizer;
    
    int countItemsBySelectedBlock;
}

@property (nonatomic) BOOL shaking;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,retain) SSCollectionView *collectionView;
- (IBAction)shuffleButtonClicked:(id)sender;

@end

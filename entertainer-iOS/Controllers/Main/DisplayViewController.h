//
//  DisplayViewController.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseViewController.h"
#import "MRPhotoViewer.h"
#import "MRBlock.h"
#import "MRItem.h"
#import "ThumbsViewController.h"
#import "SHKShareItemDelegate.h"

@interface DisplayViewController : BaseViewController <MRPhotoViewerDelegate, MRPhotoViewerDataSource, UIActionSheetDelegate, ThumbViewDelegate, SHKShareItemDelegate>{
    BOOL isFullScreen;
    BOOL isShuffled;
    int currentIndex;
    
    NSMutableArray* thumbs;
    NSMutableArray* thumbsShuffled;
}

@property (nonatomic) NSInteger itemsCount;
@property (nonatomic, retain) MRBlock *block;
@property (nonatomic, retain) MRPhotoViewer *photor;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;

-(IBAction)onBackButtonClick:(id)sender;
-(IBAction)onInfoButtonClick:(id)sender;
- (IBAction)onShareButtonClick:(id)sender;
- (IBAction)onShuffleButtonClick:(id)sender;
- (IBAction)onDocumentsButtonClick:(id)sender;

-(void)showLoader:(NSString*)titleLoader;
-(void)hideLoader;

@end

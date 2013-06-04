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

@interface DisplayViewController : BaseViewController <MRPhotoViewerDelegate, MRPhotoViewerDataSource>{
    UILabel *topLabel;
}

@property (nonatomic, retain) MRBlock *block;
@property (nonatomic, retain) MRPhotoViewer *photor;

@end

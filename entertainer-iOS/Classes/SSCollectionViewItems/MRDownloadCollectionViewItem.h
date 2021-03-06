//
//  MRDownloadCollectionViewItem.h
//  entertainer-iOS
//
//  Created by Developer on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "SSCollectionViewItem.h"
#import "UCZProgressView.h"

@interface MRDownloadCollectionViewItem : SSCollectionViewItem

@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UIImageView *icon;
@property (nonatomic,retain) UILabel *priceLabel;
//@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) UCZProgressView *progressView;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;

- (id)initWithReuseIdentifier:(NSString *)aReuseIdentifier;
-(void)setRemoveButtonHidden:(BOOL)show;


@end

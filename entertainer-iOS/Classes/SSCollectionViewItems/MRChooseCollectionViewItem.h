//
//  MRBlockCollectionViewItem.h
//  entertainer-iOS
//
//  Created by Developer on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "SSCollectionViewItem.h"

@class MRChooseCollectionViewItem;

@protocol ChooseCollectionViewItemDelegate <NSObject>

@optional
-(void)itemLongPressed:(MRChooseCollectionViewItem *)item;

@end

@interface MRChooseCollectionViewItem : SSCollectionViewItem{
    BOOL toTheLeft;
}

@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UIImageView *icon;
@property (nonatomic, retain) UIButton *removeButton;
@property (nonatomic, retain) id<ChooseCollectionViewItemDelegate> delegate;
@property (nonatomic) BOOL shaking;

- (id)initWithReuseIdentifier:(NSString *)aReuseIdentifier;

@end

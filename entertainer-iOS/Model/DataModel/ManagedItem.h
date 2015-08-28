//
//  ManagedItem.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 15.04.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ManagedBlock,MRItem;

@interface ManagedItem : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) id thumbImage;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) ManagedBlock *block;

@end

@interface ManagedItem (Map)

+(id)createFromItem:(MRItem *)object;

@end

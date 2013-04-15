//
//  ManagedBlock.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 15.04.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MRBlock;

@interface ManagedBlock : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSSet *items;
@end

@interface ManagedBlock (CoreDataGeneratedAccessors)

- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end

@interface ManagedBlock (Map)

+(id)createFromBlock:(MRBlock *)block;

@end

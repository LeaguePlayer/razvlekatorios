//
//  MRBlock.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRJsoning.h"
#import "ManagedBlock.h"

@interface MRBlock : NSObject <MRJsoning>

@property (nonatomic) int id;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSArray *items;
@property (nonatomic,retain) NSString *imagePath;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) NSNumber *price;
@property (nonatomic,retain) NSString *productID;
@property (nonatomic) BOOL paid;
@property (nonatomic) BOOL shuffled;

-(id)initWithManagedBlock:(ManagedBlock *)block;

-(void)saveToDataBase;
-(void)removeFromDataBase;
-(BOOL)isStored;
+(NSArray *)allBlocks;

+(NSArray *)blocksMock;

@end

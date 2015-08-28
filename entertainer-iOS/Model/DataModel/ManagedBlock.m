//
//  ManagedBlock.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 15.04.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "ManagedBlock.h"
#import "ManagedItem.h"
#import "MRBlock.h"
#import "MRItem.h"
#import "MRUtils.h"

@implementation ManagedBlock

@dynamic id;
@dynamic name;
@dynamic slidesInBlock;
@dynamic sizeBlock;
@dynamic price;
@dynamic imagePath;
@dynamic image;
@dynamic items;
@dynamic desc;

@end

@implementation ManagedBlock (Map)

+(id)createFromBlock:(MRBlock *)block{
    ManagedBlock *item = [ManagedBlock MR_createInContext:DefaultContext];
    item.id = @(block.id);
    item.name = block.name;
    item.slidesInBlock =  @(block.slidesInBlock);

    item.sizeBlock = block.sizeBlock;
    item.desc = block.desc;
    item.imagePath = block.imagePath;
    item.image = [MRUtils transformedValue:block.image];
    item.price = block.price;
    

    
    int i = 0;
    ManagedItem *new = nil;
    for (MRItem *lol in block.items){
        NSLog(@"%i", i);
        new = [ManagedItem createFromItem:lol];
        new.block = item;
        [item addItemsObject:new];
//        new = nil;
        i++;
    }

    
    
    NSLog(@"MRSaveSynchronously");
    [DefaultContext MR_saveWithOptions:MRSaveSynchronously completion:nil];
    
    return item;
}

@end

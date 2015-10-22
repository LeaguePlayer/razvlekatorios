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
    @autoreleasepool {
        ManagedBlock *item = [ManagedBlock MR_createInContext:DefaultContext];
        item.id = @(block.id);
        item.name = block.name;
        item.slidesInBlock =  @(block.slidesInBlock);
        
        item.sizeBlock = block.sizeBlock;
        item.desc = block.desc;
        item.imagePath = block.imagePath;
        item.image = [MRUtils transformedValue:block.image];
        item.price = block.price;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Do background work
            
            int i = 0;
            ManagedItem *new = nil;
            for (MRItem *lol in block.items){
                @autoreleasepool {
                    NSLog(@"%i", i);
                    new = [ManagedItem createFromItem:lol];
                    new.block = item;
                    [item addItemsObject:new];
                    i++;
                    
                    
                }
            }
            //        block.items = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"MRSaveSynchronously");
                [DefaultContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoticeAfterDownload" object:item.id];
                }];
                
            });
            
        });
        return item;
    }
    

    

    
    
    
    
    
}

@end

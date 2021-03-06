//
//  MRBlock.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRBlock.h"
#import "MRItem.h"
#import "MRUtils.h"
#import "CoreData+MagicalRecord.h"
#import "NSArray+Shuffling.h"

@implementation MRBlock

@synthesize shuffled = _shuffled;

-(id)init{
    self = [super init];
    if (self){
        self.id = 0;
        self.name = @"";
        self.items = [NSArray array];
        self.price = @(0);
        self.slidesInBlock = @"";
        self.sizeBlock = @"";
        self.imagePath = @"";
        self.image = [[UIImage alloc] init];
        self.shuffled = NO;
        self.desc = @"";
    }
    return self;
}

-(id)initWithName:(NSString *)name id:(int)id{
    self = [self init];
    if (self){
        self.name = name;
        self.id = id;
    }
    return self;
}

-(BOOL)isStored{
    NSArray *array = [ManagedBlock MR_findByAttribute:@"id" withValue:@(self.id)];
    return array.count > 0;
}

+(id)objectWithDict:(NSDictionary *)dict{
    MRBlock *item = [[MRBlock alloc] init];
    if (item){
        
        item.id = ((NSString *)[dict objectForKey:@"id"]).intValue;
        item.desc = (NSString *)[dict objectForKey:@"desc"];
        item.sizeBlock = (NSString *)[dict objectForKey:@"sizeBlock"];
        item.slidesInBlock = ((NSString *)[dict objectForKey:@"slidesInBlock"]).intValue;
        
        item.name = [dict objectForKey:@"name"];
        item.price = @(((NSString *)[dict objectForKey:@"price"]).floatValue);
        item.paid = item.price.floatValue > 0;
        NSDictionary *images = (NSDictionary *)[dict objectForKey:@"images"];
//        item.imagePath = [MRUtils imageFromJSONDictionary:images];
        item.imagePath = (NSString *)[dict objectForKey:@"image"];
        item.productID = [@"com.amobile.blocks." stringByAppendingFormat:@"%d",item.id];
        //item.productID = @"com.amobile.blocks";
    }
    return item;
}

-(void)saveToDataBase{
    [ManagedBlock createFromBlock:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" object:nil];
}

-(void)removeFromDataBase{
    NSArray *favourites = [ManagedBlock MR_findByAttribute:@"id" withValue:@(self.id)];

    
    
    
    if (favourites.count > 0){
        
        int itemsCount = [MRItem allItemsByBlockId:self.id];
      
        NSMutableArray *results = [NSMutableArray array];
        NSMutableArray *ids_array_sorted = [[NSMutableArray alloc] init];
        
        double cycle = floor(itemsCount/10);
        
        for(int z = 0; z<=cycle;z++)
        {
            int max_cycle_value = MIN(10*(z+1),itemsCount);
            for(int i = z*10; i<max_cycle_value; i++)
            {
                NSLog(@"%i",i);
                [ids_array_sorted addObject:@(i)];
            }
            
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i && id in %@", @"block.id", self.id, ids_array_sorted];
            
            
            [ManagedItem MR_deleteAllMatchingPredicate:predicate];
            
            [DefaultContext MR_saveToPersistentStoreAndWait];

            ids_array_sorted = nil;
            ids_array_sorted = [[NSMutableArray alloc] init];
            favourites= nil;
            predicate = nil;
            
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id == %i", self.id];
        [ManagedBlock MR_deleteAllMatchingPredicate:predicate];
        [DefaultContext MR_saveToPersistentStoreAndWait];

        
//        for (ManagedBlock *block in favourites){
//            @autoreleasepool {
//                [block MR_deleteEntity];
//                [block MR_deleteAllMatchingPredicate:<#(NSPredicate *)#>]
//            }
//            
//        }
//        [DefaultContext MR_saveWithOptions:MRSaveSynchronously completion:nil];
//        [DefaultContext MR_saveToPersistentStoreAndWait];
       
    }
}

-(id)initWithManagedBlock:(ManagedBlock *)block{
    MRBlock *item = [[MRBlock alloc] init];
    if (item){
        item.id = block.id.intValue;
        item.name = block.name;
//        NSLog(@"%i",block.slidesInBlock);
        item.slidesInBlock = block.slidesInBlock.intValue;
        item.sizeBlock = block.sizeBlock;
        item.imagePath = block.imagePath;
        NSLog(@"MRBlock");
        item.image = [MRUtils reverseTransformedValue:block.image];
//        NSMutableArray *items = [NSMutableArray array];
//        for (ManagedItem *lol in block.items){
//            MRItem *new = [[MRItem alloc] initWithManagedObject:lol];
//            [items addObject:new];
//        }
//        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
//        items =[NSArray arrayWithArray:[items sortedArrayUsingDescriptors:@[descriptor]]];
//        item.items = items;
    }
    return item;
}

-(void)setShuffled:(BOOL)shuffled{
    if (_shuffled == shuffled) return;
    _shuffled = shuffled;
    if (shuffled){
        [self shuffleItems];
    } else {
        [self orderItems];
    }
}

-(BOOL)shuffled{
    return _shuffled;
}

-(void)shuffleItems{
    self.items = [NSArray arrayWithShuffledContentOfArray:self.items];
}

-(void)orderItems{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    self.items = [self.items sortedArrayUsingDescriptors:@[descriptor]];
}

+(NSArray *)allBlocks{
    NSArray *favourites = [ManagedBlock MR_findAll];
    NSMutableArray *results = [NSMutableArray array];
    for (ManagedBlock *block in favourites){
        MRBlock *item = [[MRBlock alloc] initWithManagedBlock:block];
        [results addObject:item];
    }
    return results;
}

+(NSArray *)blocksMock{
    NSArray *dems = [MRItem itemsMock];
    MRBlock *item0 = [[MRBlock alloc] initWithName:@"Название блока 1" id:0];
    item0.imagePath = @"1image.png";
    item0.items = dems;
    item0.price = @(0.99);
    MRBlock *item1 = [[MRBlock alloc] initWithName:@"Название блока 2" id:1];
    item1.items = dems;
    item1.imagePath = @"2image.png";
    item1.price = @(0);
    MRBlock *item2 = [[MRBlock alloc] initWithName:@"Название блока 3" id:2];
    item2.items = dems;
    item2.imagePath = @"3image.gif";
    item2.price = @(1.99);
    MRBlock *item3 = [[MRBlock alloc] initWithName:@"Название блока 4" id:3];
    item3.items = dems;
    item3.imagePath = @"4image.gif";
    MRBlock *item4 = [[MRBlock alloc] initWithName:@"Название блока 5" id:4];
    item4.items = dems;
    item4.imagePath = @"5image.gif";
    MRBlock *item5 = [[MRBlock alloc] initWithName:@"Название блока 6" id:5];
    item5.items = dems;
    item5.imagePath = @"6image.jpg";
    return @[item0,item1,item2,item3,item4,item5];
}

@end

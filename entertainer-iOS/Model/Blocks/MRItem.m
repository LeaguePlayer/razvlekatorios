//
//  MRItem.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRItem.h"
#import "MRUtils.h"

@implementation MRItem

-(id)init{
    self = [super init];
    if (self){
        self.id = 0;
        self.imagePath = @"";
        self.title = @"";
        self.detail = @"";
        self.image = [[UIImage alloc] init];
        self.thumbImage = [[UIImage alloc] init];
    }
    return self;
}

+(id)objectWithDict:(NSDictionary *)dict{
    MRItem *item = [[MRItem alloc] init];
    if (item){
        item.imagePath = [dict objectForKey:@"display"];
        
    }
    return item;
}

-(id)initWithManagedObject:(ManagedItem *)object{
    MRItem *item = [[MRItem alloc] init];
    if (item){
        item.id = object.id.intValue;
        item.title = object.title;
        item.detail = object.detail;
        item.imagePath = object.imagePath;
        item.image = [MRUtils reverseTransformedValue:object.image];
    }
    return item;
}

-(id)initWithManagedObjectWithoutConvertDataToImage:(ManagedItem *)object{
    MRItem *item = [[MRItem alloc] init];
    if (item){
        item.id = object.id.intValue;
        item.title = object.title;
        item.detail = object.detail;
        item.imagePath = object.imagePath;
        item.imageData = object.image;
        item.thumbImage = object.thumbImage;
//        item.image = [MRUtils reverseTransformedValue:object.image];
    }
    return item;
}

+(NSMutableDictionary *)partItems:(NSInteger)currentPart andSelectedBlockId:(NSInteger)idBlock andShuffleArray:(NSArray*)shuffleArray
{
    NSLog(@"partItems with %i !!!!!!",currentPart);
    NSMutableArray *ready;
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"ManagedItem" inManagedObjectContext:DefaultContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entitydesc];
    [request setFetchLimit:(10+3)];
    int offset = (((currentPart*10)-3)>0) ? ((currentPart*10)-3) : 0;
    [request setFetchOffset:offset];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i", @"block.id", idBlock];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *integer = [DefaultContext executeFetchRequest:request error:&error];
    

    
    if(integer.count <= 0){
        NSLog(@"%@",@"No records found");
    }
    else {
        
//        integer =[NSArray arrayWithArray:[integer sortedArrayUsingDescriptors:@[descriptor]]];
        
        
        if(shuffleArray)
        {
            ready = [[NSMutableArray alloc ] init];
            for (id index in shuffleArray){
                @autoreleasepool {
                    [ready addObject:[integer objectAtIndex:[index integerValue]]];
                }
            }
        }
        else
            ready = [NSMutableArray arrayWithArray:integer];

        

        
        for (ManagedItem *object in ready) {
            @autoreleasepool {
                MRItem *obj = [[MRItem alloc] initWithManagedObjectWithoutConvertDataToImage:object];
                [results setObject:obj forKey:@(obj.id)];
//                [results addObject:obj];
            }
            
        }
    }
    
    return results;
    
//    NSMutableArray *ready;
//    NSArray *favourites = [ManagedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"%K == %i", @"block.id", idBlock]];
//    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
//    favourites =[NSArray arrayWithArray:[favourites sortedArrayUsingDescriptors:@[descriptor]]];
//
//    NSMutableArray *results = [NSMutableArray array];
//
//    if(shuffleArray)
//    {
//        ready = [[NSMutableArray alloc ] init];
//        for (id index in shuffleArray){
//            [ready addObject:[favourites objectAtIndex:[index integerValue]]];
//        }
//    }
//    else
//        ready = [NSMutableArray arrayWithArray:favourites];
//    
//    favourites = nil;
//    shuffleArray = nil;
//    int i = 0;
//    for (ManagedItem *item in ready){
//        i++;
//        if(i <= currentPart*10) continue;
//        if(i > (currentPart*10)+12) break;
//        
//        MRItem *obj = [[MRItem alloc] initWithManagedObjectWithoutConvertDataToImage:item];
//        NSLog(@"obj id is %i",obj.id);
//        [results addObject:obj];
//        
//    }
//
//    return results;
}


+(NSArray *)allItemsWithSelectedBlockId:(NSInteger)idBlock
{
    NSArray *favourites = [ManagedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"%K == %i", @"block.id", idBlock]];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    favourites =[NSArray arrayWithArray:[favourites sortedArrayUsingDescriptors:@[descriptor]]];
    
    NSMutableArray *results = [NSMutableArray array];
    
 
    for (ManagedItem *item in favourites){
        @autoreleasepool {
            MRItem *obj = [[MRItem alloc] initWithManagedObjectWithoutConvertDataToImage:item];
            NSLog(@"obj id is %i",obj.id);
            [results addObject:obj];
        }
    }
    
    return results;
}



+(int)allItemsByBlockId:(NSInteger)idBlock
{
    NSArray *favourites = [ManagedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"%K == %i", @"block.id", idBlock]];
    NSLog(@"%lu",(unsigned long)[favourites count]);
    return [favourites count];
}





+(NSArray *)itemsMock{
    MRItem *item0 = [[MRItem alloc] init];
    item0.id = 0;
    item0.imagePath = @"1image.png";
    item0.title = @"Заголовок 1";
    item0.detail = @"Подзаголовок 1";
    MRItem *item1 = [[MRItem alloc] init];
    item1.id = 0;
    item1.imagePath = @"2image.png";
    item1.title = @"Заголовок 2";
    item1.detail = @"Подзаголовок 2";
    MRItem *item2 = [[MRItem alloc] init];
    item2.id = 0;
    item2.imagePath = @"3image.gif";
    item2.title = @"Заголовок 3";
    item2.detail = @"Подзаголовок 3";
    MRItem *item3 = [[MRItem alloc] init];
    item3.id = 0;
    item3.imagePath = @"4image.gif";
    item3.title = @"Заголовок 4";
    item3.detail = @"Подзаголовок 4";
    return @[item0,item1,item2,item3];
}

@end

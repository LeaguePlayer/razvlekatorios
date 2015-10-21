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
    int limit = 20+14;
    int offset = (((currentPart*20)-14)>0) ? ((currentPart*20)-14) : 0;
    
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    NSPredicate *predicate = nil;
    if(shuffleArray)
    {
        limit  = ((limit + offset) >= ([shuffleArray count]-1)) ? (([shuffleArray count])-offset) : limit;
        
        NSArray *itemsForView = [shuffleArray subarrayWithRange: NSMakeRange( offset, limit )];
        
        predicate = (idBlock == 0) ?
        [NSPredicate predicateWithFormat: @"id in %@", itemsForView] :
        [NSPredicate predicateWithFormat: @"%K == %i && id in %@", @"block.id", idBlock, itemsForView];
        

    }
    else
    {
        NSMutableArray *ids_array_sorted = [[NSMutableArray alloc] init];
        for(int i = offset; i<(limit+offset); i++)
        {
            [ids_array_sorted addObject:@(i)];
        }

        predicate = [NSPredicate predicateWithFormat: @"%K == %i && id in %@", @"block.id", idBlock, ids_array_sorted];
    }
    
    
    
    
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *integer = [DefaultContext executeFetchRequest:request error:&error];
    
    NSLog(@"error");
    NSLog(@"%@",error);
    
    if(integer.count <= 0){
        NSLog(@"%@",@"No records found");
    }
    else {
        

        ready = [NSMutableArray arrayWithArray:integer];
        
        
        
        
        for (ManagedItem *object in ready) {
            @autoreleasepool {
                MRItem *obj = [[MRItem alloc] initWithManagedObjectWithoutConvertDataToImage:object];
                [results setObject:obj forKey:@(obj.id)];
                //                [results addObject:obj];
            }
            
        }
    }
    
    return [NSMutableDictionary dictionaryWithObjects:@[@(currentPart), results] forKeys:@[@"returnPart",@"values"]];
    
}


+(NSArray *)allItemsWithSelectedBlockId:(NSInteger)idBlock withCount:(NSInteger)itemsCount
{
//    NSMutableArray *ids_array_sorted = [[NSMutableArray alloc] init];
//    for(int i = 0; i<98; i++)
//    {
//        [ids_array_sorted addObject:@(i)];
//    }
    
   
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

        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %i && id in %@", @"block.id", idBlock, ids_array_sorted];

        
        NSArray *favourites = [ManagedItem MR_findAllWithPredicate:predicate];
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
        favourites =[NSArray arrayWithArray:[favourites sortedArrayUsingDescriptors:@[descriptor]]];
        
        for (ManagedItem *item in favourites){
            @autoreleasepool {
                MRItem *obj = [[MRItem alloc] initWithManagedObjectWithoutConvertDataToImage:item];
                NSLog(@"obj id is %i",obj.id);
                [results addObject:obj];
            }
        }
        ids_array_sorted = nil;
        ids_array_sorted = [[NSMutableArray alloc] init];
        favourites= nil;

    }
    
    return results;
}



+(int)allItemsByBlockId:(NSInteger)idBlock
{
//    return 10;
//    NSArray *favourites = (idBlock == 0) ?
//    [ManagedItem MR_findAll] :
//    [ManagedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"%K == %i", @"block.id", idBlock]];
//    //    NSArray *favourites = [ManagedItem MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"%K == %i", @"block.id", idBlock]];
//    NSLog(@"%lu",(unsigned long)[favourites count]);
    
    
    // assuming NSManagedObjectContext *moc
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ManagedItem" inManagedObjectContext:DefaultContext]];
    [request setPredicate:[NSPredicate predicateWithFormat: @"%K == %i", @"block.id", idBlock]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [DefaultContext countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        //Handle error
    }
    
    return count;
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

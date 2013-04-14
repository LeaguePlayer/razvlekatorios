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

@implementation MRBlock

-(id)init{
    self = [super init];
    if (self){
        self.id = 0;
        self.name = @"";
        self.items = [NSArray array];
        self.price = @(0);
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

+(id)objectWithDict:(NSDictionary *)dict{
    MRBlock *item = [[MRBlock alloc] init];
    if (item){
        item.id = 1;
        item.name = [dict objectForKey:@"name"];
        item.price = (NSNumber *)[dict objectForKey:@"price"];
        NSDictionary *images = (NSDictionary *)[dict objectForKey:@"images"];
        item.imagePath = [MRUtils imageFromJSONDictionary:images];
    }
    return item;
}

-(BOOL)isStored{
    
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

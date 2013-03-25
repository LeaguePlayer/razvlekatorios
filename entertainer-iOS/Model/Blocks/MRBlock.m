//
//  MRBlock.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRBlock.h"
#import "MRItem.h"

@implementation MRBlock

-(id)init{
    self = [super init];
    if (self){
        self.id = 0;
        self.name = @"";
        self.items = [NSArray array];
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

+(NSArray *)blocksMock{
    NSArray *dems = [MRItem itemsMock];
    MRBlock *item0 = [[MRBlock alloc] initWithName:@"Название блока 1" id:0];
    item0.image = [UIImage imageNamed:@"1image.png"];
    item0.items = dems;
    MRBlock *item1 = [[MRBlock alloc] initWithName:@"Название блока 2" id:1];
    item1.items = dems;
    item1.image = [UIImage imageNamed:@"2image.png"];
    MRBlock *item2 = [[MRBlock alloc] initWithName:@"Название блока 3" id:2];
    item2.items = dems;
    item2.image = [UIImage imageNamed:@"3image.gif"];
    MRBlock *item3 = [[MRBlock alloc] initWithName:@"Название блока 4" id:3];
    item3.items = dems;
    item3.image = [UIImage imageNamed:@"4image.gif"];
    MRBlock *item4 = [[MRBlock alloc] initWithName:@"Название блока 5" id:4];
    item4.items = dems;
    item4.image = [UIImage imageNamed:@"5image.gif"];
    MRBlock *item5 = [[MRBlock alloc] initWithName:@"Название блока 6" id:5];
    item5.items = dems;
    item5.image = [UIImage imageNamed:@"6image.jpg"];
    return @[item0,item1,item2,item3,item4,item5];
}

@end

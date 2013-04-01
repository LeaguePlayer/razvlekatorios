//
//  MRItem.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRItem.h"

@implementation MRItem

-(id)init{
    self = [super init];
    if (self){
        self.id = 0;
        self.image = [[UIImage alloc] init];
        self.title = @"";
        self.detail = @"";
    }
    return self;
}

+(NSArray *)itemsMock{
    MRItem *item0 = [[MRItem alloc] init];
    item0.id = 0;
    item0.image = [UIImage imageNamed:@"1image.png"];
    item0.title = @"Заголовок 1";
    item0.detail = @"Подзаголовок 1";
    MRItem *item1 = [[MRItem alloc] init];
    item1.id = 0;
    item1.image = [UIImage imageNamed:@"2image.png"];
    item1.title = @"Заголовок 2";
    item1.detail = @"Подзаголовок 2";
    MRItem *item2 = [[MRItem alloc] init];
    item2.id = 0;
    item2.image = [UIImage imageNamed:@"3image.gif"];
    item2.title = @"Заголовок 3";
    item2.detail = @"Подзаголовок 3";
    MRItem *item3 = [[MRItem alloc] init];
    item3.id = 0;
    item3.image = [UIImage imageNamed:@"4image.gif"];
    item3.title = @"Заголовок 4";
    item3.detail = @"Подзаголовок 4";
    return @[item0,item1,item2,item3];
}

@end

//
//  NSArray+Shuffling.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 01.05.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "NSArray+Shuffling.h"

@implementation NSArray (Shuffling)

+(NSArray *)arrayWithShuffledContentOfArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < array.count; i++){
        int nextPosition = (arc4random() % array.count);
        id prevItem = [result objectAtIndex:i];
        id nextItem = [result objectAtIndex:nextPosition];
        [result replaceObjectAtIndex:i withObject:nextItem];
        [result replaceObjectAtIndex:nextPosition withObject:prevItem];
    }
    return result;
}

@end

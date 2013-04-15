//
//  ManagedItem.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 15.04.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "ManagedItem.h"
#import "ManagedBlock.h"
#import "MRItem.h"
#import "MRUtils.h"

@implementation ManagedItem

@dynamic id;
@dynamic title;
@dynamic detail;
@dynamic image;
@dynamic imagePath;
@dynamic block;

@end

@implementation ManagedItem (Map)

+(id)createFromItem:(MRItem *)object{
    ManagedItem *item = [ManagedItem MR_createInContext:DefaultContext];
    item.id = @(object.id);
    item.title = object.title;
    item.detail = object.detail;
    item.imagePath = object.imagePath;
    item.image = [MRUtils transformedValue:object.image];
    return item;
}

@end

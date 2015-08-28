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
@dynamic thumbImage;
@dynamic imagePath;
@dynamic block;

@end

@implementation ManagedItem (Map)

+(id)createFromItem:(MRItem *)object{
    @autoreleasepool {
        ManagedItem *item = [ManagedItem MR_createInContext:DefaultContext];
        item.id = @(object.id);
        item.title = object.title;
        item.detail = object.detail;
        item.imagePath = object.imagePath;
        item.image = object.imageData;
        
        UIImage *originalImage = [UIImage imageWithData:object.imageData];
        CGSize destinationSize = CGSizeMake(100, 100);
        UIGraphicsBeginImageContext(destinationSize);
        [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        item.thumbImage = newImage;
        return item;
    }
   
    
}

@end

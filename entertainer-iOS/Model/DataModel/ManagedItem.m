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
        item.title = object.name;
        item.detail = object.detail;
        item.imagePath = object.imagePath;
//        item.image = object.imageData;
        
        
        

        @autoreleasepool {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
            NSString *filePath = [documentsPath stringByAppendingPathComponent:item.title]; //Add the file name
            NSData *pngData = [NSData dataWithContentsOfFile:filePath];
//            UIImage *image = [UIImage imageWithData:pngData];
            
            
            UIImage *originalImage = [UIImage imageWithData:pngData];
            CGSize destinationSize = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(destinationSize);
            [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            item.thumbImage = newImage;
        }
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
//        [pngData writeToFile:filePath atomically:YES]; //Write the file
        

        return item;
    }
   
    
}

@end

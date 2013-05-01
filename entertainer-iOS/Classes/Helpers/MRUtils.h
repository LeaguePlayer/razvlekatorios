//
//  MRUtils.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 14.04.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRUtils : NSObject

+(NSString *)imageFromJSONDictionary:(NSDictionary *)dict;
+(NSData *)transformedValue:(UIImage *)value;
+(UIImage *)reverseTransformedValue:(NSData *)value;
+(void)saveImageToSavedPhotos:(UIImage *)image;

@end

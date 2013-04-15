//
//  MRUtils.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 14.04.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRUtils.h"
#import "Config.h"

@implementation MRUtils

+(NSString *)imageFromJSONDictionary:(NSDictionary *)dict{
    NSString *imagePath;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        imagePath = [NSString stringWithFormat:@"%@%@",MR_APIURL,[dict objectForKey:@"retina_display"]];
    } else {
        imagePath = [NSString stringWithFormat:@"%@%@",MR_APIURL,[dict objectForKey:@"display"]];
    }
    return imagePath;
}

//перевод UIIamge в NSData
+(NSData *)transformedValue:(UIImage *)value{
    if (value == nil)
        return nil;
    // I pass in raw data when generating the image, save that directly to the database
    if ([value isKindOfClass:[NSData class]])
        return (NSData *)value;
    return UIImagePNGRepresentation((UIImage *)value);
}

//перевод NSData в UIImage
+(UIImage *)reverseTransformedValue:(NSData *)value{
    return [UIImage imageWithData:value];
}

@end

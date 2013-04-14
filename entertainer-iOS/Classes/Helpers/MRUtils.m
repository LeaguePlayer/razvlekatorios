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
    NSLog (imagePath);
    return imagePath;
}

@end

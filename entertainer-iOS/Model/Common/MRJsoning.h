//
//  MRJsoning.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 14.04.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MRJsoning <NSObject>

@optional

+(id)objectWithDict:(NSDictionary *)dict;

@end
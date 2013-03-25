//
//  MRItem.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRItem : NSObject

@property (nonatomic) int id;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *detail;

+(NSArray *)itemsMock;

@end

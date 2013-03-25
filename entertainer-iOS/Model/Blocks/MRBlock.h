//
//  MRBlock.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRBlock : NSObject

@property (nonatomic) int id;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSArray *items;
@property (nonatomic,retain) UIImage *image;

+(NSArray *)blocksMock;

@end

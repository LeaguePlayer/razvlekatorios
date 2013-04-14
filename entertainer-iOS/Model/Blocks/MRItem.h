//
//  MRItem.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRJsoning.h"

@interface MRItem : NSObject <MRJsoning>

@property (nonatomic) int id;
@property (nonatomic,retain) NSString *imagePath;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *detail;

+(NSArray *)itemsMock;

@end

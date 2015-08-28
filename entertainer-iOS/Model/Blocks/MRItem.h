//
//  MRItem.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 22.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRJsoning.h"
#import "ManagedItem.h"

@interface MRItem : NSObject <MRJsoning>

@property (nonatomic) int id;
@property (nonatomic,retain) NSString *imagePath;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) UIImage *thumbImage;
@property (nonatomic,retain) NSData *imageData;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *detail;

+(NSArray *)itemsMock;
+(NSMutableDictionary *)partItems:(NSInteger)currentPart andSelectedBlockId:(NSInteger)idBlock andShuffleArray:(NSArray*)shuffleArray;
+(NSArray *)allItemsWithSelectedBlockId:(NSInteger)idBlock;
+(int)allItemsByBlockId:(NSInteger)idBlock;
-(id)initWithManagedObject:(ManagedItem *)object;
-(id)initWithManagedObjectWithoutConvertDataToImage:(ManagedItem *)object;


@end

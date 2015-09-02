//
//  MRDonwloadManager.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 02.05.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRDownloadManager.h"

static MRDownloadManager *_sharedManager;
@implementation MRDownloadManager

+(id)sharedManager{
    if (!_sharedManager){
        static dispatch_once_t onceTok;
        dispatch_once(&onceTok, ^{
            _sharedManager = [[self alloc] init];
        });
    }
    return _sharedManager;
}

-(id)init{
    self = [super init];
    if (self){
        loadingObjects = [NSMutableArray array];
        states = [NSMutableArray array];
        delegates = [NSMutableArray array];
    }
    return self;
}



-(BOOL)loadsObjectWithId:(int)id{
    for (MRBlock *block in loadingObjects){
        if (block.id == id){
            return YES;
        }
    }
    return NO;
}

-(CGFloat)loadingStateOfObjectWithId:(int)id{
    CGFloat result = 0;
    for (int i = 0; i < loadingObjects.count; i++){
        MRBlock *block = [loadingObjects objectAtIndex:i];
        if (block.id == id){
            result = ((NSNumber *)[states objectAtIndex:i]).floatValue;
            break;
        }
    }
    return result;
}

-(void)addDelegate:(id<MRDownloadManagerDelegate>)delegate{
    [delegates addObject:delegate];
}

-(void)removeDelegate:(id<MRDownloadManagerDelegate>)delegate{
    if (![self isDelegate:delegate]) return;
    [delegates removeObject:delegate];
}

-(void)removeAllDelegates{
    [delegates removeAllObjects];
}

-(BOOL)isDelegate:(id<MRDownloadManagerDelegate>)delegate{
    NSUInteger index = [delegates indexOfObject:delegate];
    return (index != NSNotFound);
}

-(void)startLoadingBlock:(MRBlock *)block{
    [loadingObjects addObject:block];
    [states addObject:@(0.0f)];
    [CurrentClient blockItemsWithBlock:block progress:^(CGFloat state){
        NSNumber *numberState = @(state);
        for (int i = 0; i < loadingObjects.count; i++){
            MRBlock *object = [loadingObjects objectAtIndex:i];
            if (object.id == block.id){
                [states replaceObjectAtIndex:i withObject:numberState];
                for (id<MRDownloadManagerDelegate> delegate in delegates){
                    if ([delegate respondsToSelector:@selector(downloadStateChangedWithObjectId:withState:)]){
                        [delegate downloadStateChangedWithObjectId:block.id withState:state];
                    }
                }
                break;
            }
        }
    }success:^(NSArray *results) {
        block.items = results;
//        for (id<MRDownloadManagerDelegate> delegate in delegates){
//            if ([delegate respondsToSelector:@selector(downloadCompliteWithObjectId:)]){
//                [delegate downloadCompliteWithObjectId:block.id];
//            }
//        }
        for (int i = 0; i < loadingObjects.count; i++){
            MRBlock *object = [loadingObjects objectAtIndex:i];
            if (object.id == block.id){
                [loadingObjects removeObject:object];
                [states removeObjectAtIndex:i];
            }
        }
    } failure:^(int statusCode, NSArray *errors, NSError *commonError) {
        for (id<MRDownloadManagerDelegate> delegate in delegates){
            if ([delegate respondsToSelector:@selector(downloadFailedWithObjectId:)]){
                [delegate downloadFailedWithObjectId:block.id];
            }
        }
    }];
}

@end

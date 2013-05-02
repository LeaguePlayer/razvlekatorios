//
//  MRDonwloadManager.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 02.05.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRBlock.h"
#import "MRHTTPClient.h"

@protocol MRDownloadManagerDelegate <NSObject>

@optional

-(void)downloadStateChangedWithObjectId:(int)id withState:(CGFloat)state;
-(void)downloadCompliteWithObjectId:(int)id;
-(void)downloadFailedWithObjectId:(int)id;

@end

@interface MRDownloadManager : NSObject{
    NSMutableArray *states;
    NSMutableArray *loadingObjects;
    NSMutableArray *delegates;
}

+(id)sharedManager;
-(BOOL)loadsObjectWithId:(int)id;
-(CGFloat)loadingStateOfObjectWithId:(int)id;
-(void)addDelegate:(id<MRDownloadManagerDelegate>)delegate;
-(void)removeDelegate:(id<MRDownloadManagerDelegate>)delegate;
-(void)removeAllDelegates;
-(BOOL)isDelegate:(id<MRDownloadManagerDelegate>)delegate;
-(void)startLoadingBlock:(MRBlock *)block;

@end

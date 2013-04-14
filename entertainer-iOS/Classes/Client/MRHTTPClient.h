//
//  MRHTTPClient.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 14.04.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "AFHTTPClient.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "MRBlock.h"

typedef void (^MRHTTPClientSuccessResults)(NSArray *results);
typedef void (^MRHTTPClientFailure)(int statusCode, NSArray *errors, NSError *commonError);

@interface MRHTTPClient : AFHTTPClient

+(id)sharedClient;

-(void)allBlocksWithSuccess:(MRHTTPClientSuccessResults)success failure:(MRHTTPClientFailure)failure;
-(void)blockItemsWithId:(int)blockId success:(MRHTTPClientSuccessResults)success failure:(MRHTTPClientFailure)failure;

@end

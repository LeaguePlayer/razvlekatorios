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
#import "SDWebImageDownloader.h"
#import "UIDeviceHardware.h"

typedef void (^MRHTTPClientSuccessResults)(NSArray *results);
typedef void (^MRHTTPClientFailure)(int statusCode, NSArray *errors, NSError *commonError);

@interface MRHTTPClient : AFHTTPClient

@property (nonatomic,retain) SDWebImageDownloader *downloader;
+(id)sharedClient;

-(NSArray *)allBlockSynchroniusly;
-(void)allBlocksWithSuccess:(MRHTTPClientSuccessResults)success failure:(MRHTTPClientFailure)failure;
-(void)blockItemsWithBlock:(MRBlock *)block progress:(void(^)(CGFloat state))progress success:(MRHTTPClientSuccessResults)success failure:(MRHTTPClientFailure)failure;
-(void)applicationInfoWithSuccess:(void(^)(NSString *info))success failure:(MRHTTPClientFailure)failure;
-(void)platformString;

@end

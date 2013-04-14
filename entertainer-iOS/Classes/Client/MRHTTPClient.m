//
//  MRHTTPClient.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 14.04.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "MRBlock.h"
#import "MRItem.h"

static MRHTTPClient *_sharedClient;
@implementation MRHTTPClient

+(id)sharedClient{
    if (!_sharedClient){
        static dispatch_once_t onceTok;
        dispatch_once(&onceTok, ^{
            _sharedClient = [[self alloc] init];
        });
    }
    return _sharedClient;
}

-(id)init{
    self = [super initWithBaseURL:MR_APIURL];
    if (self){
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

-(void)allBlocksWithSuccess:(MRHTTPClientSuccessResults)success failure:(MRHTTPClientFailure)failure{
    NSString *urlString = @"/api/allblocks";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [self requestWithMethod:@"GET" path:urlString parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSNumber *status = JSON[@"result"];
        if ([status isEqualToNumber:@(1)]){
            NSDictionary *respDict = (NSDictionary *)JSON[@"response"];
            NSArray *blocksArray = (NSArray *)respDict[@"blocks"];
            NSMutableArray *results = [NSMutableArray array];
            for (NSDictionary *dict in blocksArray){
                [results addObject:[MRBlock objectWithDict:dict]];
            }
            success(results);
        } else {
            failure(response.statusCode,@[],nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(response.statusCode,@[],error);
    }];
    [self enqueueHTTPRequestOperation:operation];
}

-(void)blockItemsWithId:(int)blockId success:(MRHTTPClientSuccessResults)success failure:(MRHTTPClientFailure)failure{
    NSString *urlString = [NSString stringWithFormat:@"/api/getblock/%d",blockId];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [self requestWithMethod:@"GET" path:urlString parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSNumber *status = JSON[@"result"];
        if ([status isEqualToNumber:@(1)]){
            NSDictionary *respDict = (NSDictionary *)JSON[@"response"];
            NSArray *imagesArray = (NSArray *)respDict[@"images"];
            NSMutableArray *results = [NSMutableArray array];
            for (NSDictionary *dict in imagesArray){
                [results addObject:[MRItem objectWithDict:dict]];
            }
            success(results);
        } else {
            failure(response.statusCode,@[],nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [self enqueueHTTPRequestOperation:operation];
}

@end

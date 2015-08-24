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
#import "SVProgressHUD.h"
#import "AFHTTPClient+Synchronous.h"

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
        self.downloader = [[SDWebImageDownloader alloc] init];
    }
    return self;
}

-(void)platformString
{
    NSString *platform = [UIDevice currentDevice].model;
    NSLog(@"platforn: %@",platform);
}

-(void)allBlocksWithSuccess:(MRHTTPClientSuccessResults)success failure:(MRHTTPClientFailure)failure{
//    [self platformString];
    UIDeviceHardware *device = [[UIDeviceHardware alloc] init];
//    NSLog(@"%@",[device platformString]);
    NSString *urlString = [NSString stringWithFormat:@"/api/allblocks/device/%@", [device platformString]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlString);
    NSURLRequest *request = [self requestWithMethod:@"GET" path:urlString parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSNumber *status = JSON[@"result"];
        if ([status isEqualToNumber:@(1)]){
            NSDictionary *respDict = (NSDictionary *)JSON[@"response"];
            NSLog(@"%@",respDict);
            NSArray *blocksArray = (NSArray *)respDict[@"blocks"];
            NSMutableArray *results = [NSMutableArray array];
            for (NSDictionary *dict in blocksArray){
                __block MRBlock *block = [MRBlock objectWithDict:dict];
                NSURL *imageUrl = [NSURL URLWithString:block.imagePath];
                
                [self.downloader downloadImageWithURL:imageUrl options:nil progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    block.image = image;
                }];
                [results addObject:block];
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

-(NSArray *)allBlockSynchroniusly {
    UIDeviceHardware *device = [[UIDeviceHardware alloc] init];
    NSDictionary *response = (NSDictionary *)[self synchronouslyGetPath:[NSString stringWithFormat:@"/api/allblocks/device/%@",[device platformString]] parameters:nil operation:NULL error:nil];
    if (response) {
        NSNumber *status = response[@"result"];
        if ([status isEqualToNumber:@(1)]){
            NSDictionary *respDict = (NSDictionary *)response[@"response"];
            NSArray *blocksArray = (NSArray *)respDict[@"blocks"];
            NSMutableArray *results = [NSMutableArray array];
            for (NSDictionary *dict in blocksArray){
                __block MRBlock *block = [MRBlock objectWithDict:dict];
                [results addObject:block];
                
            }
            return results;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

-(void)blockItemsWithBlock:(MRBlock *)block progress:(void(^)(CGFloat state))progress success:(MRHTTPClientSuccessResults)success failure:(MRHTTPClientFailure)failure{
    UIDeviceHardware *device = [[UIDeviceHardware alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"/api/getblock/%d?device=%@",block.id,[device platformString]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [self requestWithMethod:@"GET" path:urlString parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSNumber *status = JSON[@"result"];
        if ([status isEqualToNumber:@(1)]){
            NSDictionary *respDict = (NSDictionary *)JSON[@"response"];
            NSArray *imagesArray = (NSArray *)respDict[@"images"];
            __block NSMutableArray *results = [NSMutableArray array];
            __block NSInteger count = 0;
            int max = imagesArray.count;
            for (int i = 0; i < imagesArray.count; i++){
                NSDictionary *dict = [imagesArray objectAtIndex:i];
                __block MRItem *item = [MRItem objectWithDict:dict];
                item.id = i;
                NSURL *imageUrl = [NSURL URLWithString:item.imagePath];
                [self.downloader downloadImageWithURL:imageUrl options:nil progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    item.image = image;
                    [results addObject:item];
                    dispatch_queue_t queue = dispatch_get_main_queue();
                    dispatch_async(queue, ^{
                        count++;
                        NSLog (@"%d == %d",count,max);
                        if (count == max){
                            block.items = results;
                            success(results);
                            [block saveToDataBase];
                        } else {
                            CGFloat prog = (float)count/(float)max;
                            progress(prog);
                        }
                    });
                }];
            }
        } else {
            failure(response.statusCode,@[],nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [self enqueueHTTPRequestOperation:operation];
}

-(void)applicationInfoWithSuccess:(void(^)(NSString *info))success failure:(MRHTTPClientFailure)failure{
    NSString *urlString = @"/api/info";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [self requestWithMethod:@"GET" path:urlString parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *result = JSON[@"response"];
        NSLog(result);
        success(result);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(response.statusCode,@[],nil);
    }];
    [self enqueueHTTPRequestOperation:operation];
}

@end

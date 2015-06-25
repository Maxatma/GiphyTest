//
//  GTAPI.m
//  GiphyTest
//
//  Created by Alexander on 6/25/15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "GTAPI.h"
#import "AFNetworking.h"
#import "AXCGiphy.h"
#import <AnimatedGIFImageSerialization/AnimatedGIFImageSerialization.h>

@interface GTAPI ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *httpRequestManager;

@end

@implementation GTAPI
#pragma mark - Initialization
+ (instancetype)apiManager
{
    static GTAPI *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [self new];
    });
    
    return sharedManager;
}

- (instancetype) init
{
    self                                       = [super init];
    self.httpRequestManager                    = [AFHTTPRequestOperationManager manager];
    self.httpRequestManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    return self;
}

#pragma mark - Private
//Array of AXCGiphy
- (void)loadImagesGiphyArray:(NSArray*)array response:(GTManagerSuccessErrorCB)blk
{
    NSMutableArray *returnArray = [NSMutableArray new];
    dispatch_group_t group      = dispatch_group_create();
    
    for (AXCGiphy *giphy in array)
    {
        NSURL *url = giphy.originalImage.url;
        dispatch_group_enter(group);
        [self imageForURL:url completion:^(UIImage *image, NSError *error) {
            if (!error)
                [returnArray addObject:image];
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        blk(returnArray,nil);
    });
}

#pragma mark - Image
//Получение Image
- (void)imageForURL:(NSURL*)url completion:(GTManagerImageCB)blk
{
    [self.httpRequestManager GET:url.absoluteString
                      parameters:nil
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSData *data   = responseObject;
         UIImage *image = [UIImage imageWithData:data];
         blk(image,nil);
     }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         blk(nil, error);
     }];
}


@end

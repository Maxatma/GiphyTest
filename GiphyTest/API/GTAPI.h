//
//  GTAPI.h
//  GiphyTest
//
//  Created by Alexander on 6/25/15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "AXCGiphy.h"
@import Foundation;
@import UIKit;

typedef void(^GTManagerSuccessErrorCB)  (NSArray *responseObjects, NSError *error);
typedef void(^GTManagerImageCB) (UIImage *image, NSError *error);

@interface GTAPI : NSObject
+ (instancetype)apiManager;
- (void)loadImagesGiphyArray:(NSArray <AXCGiphy*> *)array
                    response:(GTManagerSuccessErrorCB)blk;

- (void)imageForURL:(NSURL *)url
         completion:(GTManagerImageCB)blk;

- (void)getImagesWithTerm:(NSString *)searchTerm
                 response:(GTManagerSuccessErrorCB)blk;

@end

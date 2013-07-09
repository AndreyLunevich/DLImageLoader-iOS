//
//  DLILCacheManager.h
//
//  Created by Andrey Lunevich on 7/9/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLILCache;

@interface DLILCacheManager : NSObject

/* Returns shared instance */
+ (DLILCacheManager *)sharedInstance;

/** Saves cache to file
 */
- (void)saveCache;

/** Add new image to cache
 @param image The image to cache
 @param url The key of the image
 */
- (void)addNewImageToCache:(NSData *)image url:(NSString *)url;

/** Delete image from cache
 @param url The key of the image
 */
- (void)deleteImageFromCache:(NSString *)url;

/** Get image from cache
 @param url The key of the image
 @return image from cache
 */
- (NSData *)imageFromCache:(NSString *)url;

@end
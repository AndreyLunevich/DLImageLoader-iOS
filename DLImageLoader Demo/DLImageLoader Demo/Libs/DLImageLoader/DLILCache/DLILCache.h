//
//  DLILCache.h
//
//  Created by Andrey Lunevich on 7/9/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLILCache : NSObject <NSCoding>

/* Array of all images in the cache */
@property (nonatomic, strong) NSMutableDictionary *images;

@end
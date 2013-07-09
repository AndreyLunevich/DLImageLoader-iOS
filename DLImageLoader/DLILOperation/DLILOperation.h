//
//  DLILOperation.h
//
//  Created by Andrey Lunevich on 7/9/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLILOperation : NSObject

+ (void)newOperationWithBlock:(void(^)(void))operation
                    completed:(void(^)(void))completed;

+ (void)newOperationWithBlock:(void(^)(void))operation;

@end
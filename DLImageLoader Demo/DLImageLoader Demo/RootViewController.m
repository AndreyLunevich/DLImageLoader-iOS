//
//  RootViewController.m
//  DLImageLoader Demo
//
//  Created by Andrew Lunevich on 6/19/15.
//  Copyright (c) 2015 Andrey Lunevich. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (IBAction)btnClearCachePressed:(id)sender
{
    [[DLImageLoader sharedInstance] clearCache];
}

@end
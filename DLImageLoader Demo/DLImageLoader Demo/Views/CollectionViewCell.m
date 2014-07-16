//
//  CollectionViewCell.m
//  DLImageLoader Demo
//
//  Created by Andrew Lunevich on 4/5/14.
//  Copyright (c) 2014 Andrey Lunevich. All rights reserved.
//

#import "CollectionViewCell.h"
#import "DLImageView.h"

@interface CollectionViewCell()

@property (weak, nonatomic) IBOutlet DLImageView *thumbnailView;

@end

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.thumbnailView cancelLoading];
}

- (void)fillWithUrl:(NSString *)url
{
    [self.thumbnailView displayImageFromUrl:url];
}

@end
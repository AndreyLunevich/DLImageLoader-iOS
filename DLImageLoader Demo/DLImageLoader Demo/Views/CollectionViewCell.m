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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)fillWithUrl:(NSString *)url
{
    [self.thumbnailView cancelLoading];
    self.thumbnailView.image = nil;
    [self.thumbnailView loadImageFromUrl:url completed:^(NSError *error, UIImage *image) {
        self.thumbnailView.image = image;
    }];
}

@end

//
//  TableViewCell.m
//  DLImageLoader Demo
//
//  Created by Andrew Lunevich on 4/5/14.
//  Copyright (c) 2014 Andrey Lunevich. All rights reserved.
//

#import "TableViewCell.h"
#import "DLImageLoader.h"

@interface TableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, copy) NSString *url;

@end

@implementation TableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [[DLImageLoader sharedInstance] cancelOperation:self.url];
}

- (void)fillWithUrl:(NSString *)url index:(NSInteger)index
{
    self.url = url;
    [self.title setText:[NSString stringWithFormat:@"Item = %ld", (long)index]];
    [[DLImageLoader sharedInstance] displayImageFromUrl:url
                                              imageView:self.thumbnailView];
}

@end
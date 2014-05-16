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

@end

@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillWithUrl:(NSString *)url index:(NSInteger)index
{
    [self.title setText:[NSString stringWithFormat:@"Item = %d", index]];
    [[DLImageLoader sharedInstance] displayImageFromUrl:url
                                              imageView:self.thumbnailView];
}

@end

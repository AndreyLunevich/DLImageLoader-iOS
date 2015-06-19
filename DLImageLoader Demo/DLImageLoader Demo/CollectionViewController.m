//
//  CollectionViewController.m
//  DLImageLoader Demo
//
//  Created by Andrew Lunevich on 4/5/14.
//  Copyright (c) 2014 Andrey Lunevich. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"

@interface CollectionViewController ()

@property (nonatomic, copy) NSArray *urls;

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.urls = @[
      @"http://p1.pichost.me/i/64/1885741.jpg",
      @"https://shechive.files.wordpress.com/2010/09/beautiful-nature-16.jpg",
      @"http://images4.fanpop.com/image/photos/22600000/Fall-beautiful-nature-22666764-900-562.jpg",
      @"http://media.idownloadblog.com/wp-content/uploads/2013/09/tinge-right.jpg",
      @"http://i.imgur.com/s30S2Vx.png",
      @"http://www.wired.com/wp-content/uploads/2014/12/9-credit-1.jpg"
    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.urls count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    [cell fillWithUrl:[self.urls objectAtIndex:indexPath.row]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

@end
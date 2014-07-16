//
//  CollectionViewController.m
//  DLImageLoader Demo
//
//  Created by Andrew Lunevich on 4/5/14.
//  Copyright (c) 2014 Andrey Lunevich. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "DLImageLoader.h"

@interface CollectionViewController ()

@property (nonatomic, copy) NSArray *urls;

@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.urls = @[
                  @"http://pavellunevich.com/Folders/Illustrations/2127681691.png",
                  @"http://pavellunevich.com/Folders/Illustrations/757637590.png",
                  @"http://pavellunevich.com/Folders/Illustrations/1429149926.png",
                  @"http://pavellunevich.com/Folders/Illustrations/1321129696.png",
                  @"http://pavellunevich.com/Folders/Graphics/1984135185.png",
                  @"http://pavellunevich.com/Folders/Paintings/1366779420.png",
                  @"http://pavellunevich.com/Folders/Paintings/1383399540.png",
                  @"http://pavellunevich.com/Folders/Paintings/1888084308.png",
                  @"http://pavellunevich.com/Folders/Paintings/58600467.png",
                  @"http://pavellunevich.com/Folders/Paintings/1287185856.png",
                  @"http://pavellunevich.com/Folders/Paintings/1428255199.png",
                  @"http://pavellunevich.com/Folders/Paintings/2125733428.png",
                  @"http://pavellunevich.com/Folders/Paintings/1209572488.png",
                  @"http://pavellunevich.com/Folders/Paintings/881602041.png",
                  @"http://pavellunevich.com/Folders/Paintings/1968578639.png",
                  ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.urls count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell"
                                                                         forIndexPath:indexPath];
    [cell fillWithUrl:[self.urls objectAtIndex:indexPath.row]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
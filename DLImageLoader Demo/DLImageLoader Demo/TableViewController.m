//
//  TableViewController.m
//  DLImageLoader Demo
//
//  Created by Andrey Lunevich on 7/12/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

@interface TableViewController ()

@property (nonatomic, copy) NSArray *urls;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.urls = @[
      @"http://p1.pichost.me/i/64/1885741.jpg",
      @"https://shechive.files.wordpress.com/2010/09/beautiful-nature-16.jpg",
      @"http://3.bp.blogspot.com/-6tN1I5I2E-I/VBPFPfQ6fXI/AAAAAAABhbY/XtHIECbqZiY/s1600/papers.co-ac96-wallpaper-apple-iphone6-plus-ios8-flower-green-9-wallpaper.jpg",
      @"http://www.joomlaworks.net/images/demos/galleries/abstract/7.jpg",
      @"http://www.online-image-editor.com//styles/2014/images/example_image.png",
      @"http://www.keenthemes.com/preview/metronic/theme/assets/global/plugins/jcrop/demos/demo_files/image2.jpg",
      @"http://www.heliconsoft.com/wp-content/uploads/2014/07/Andrea_Hallgass_30_images_full.jpg",
      @"http://wallpapers111.com/wp-content/uploads/2015/02/3d-nature-wallpapers-5.jpg",
      @"http://p1.pichost.me/640/67/1913110.jpg"
    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.urls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    [cell fillWithUrl:[self.urls objectAtIndex:indexPath.row] index:indexPath.row];
    return cell;
}

@end
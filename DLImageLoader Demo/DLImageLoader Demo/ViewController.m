//
//  ViewController.m
//  DLImageLoader Demo
//
//  Created by Andrey Lunevich on 7/12/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import "ViewController.h"
#import "DLImageLoader.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *urls;

@end

@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urls = [NSArray arrayWithObjects:
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
                 @"http://pavellunevich.com/Folders/Paintings/1968578639.png", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.urls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.imageView.image = nil;
    [DLImageLoader loadImageFromURL:[self.urls objectAtIndex:indexPath.row]
                          completed:^(NSError *error, NSData *imgData) {
                              cell.imageView.image = [UIImage imageWithData:imgData];
                              [cell setNeedsLayout];
    }];
    return cell;
}

@end
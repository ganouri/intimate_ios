//
//  ITMViewController.m
//  IntiMate
//
//  Created by Konstantin Kim on 17/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMRoomsViewController.h"
#import "ITMRoomViewController.h"
#import "UIActionSheet+MKBlockAdditions.h"
#import "ITMRoomCell.h"

#define ROOM_KEY @"ROOM_KEY"

@interface ITMRoomsViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_dataSource;
}

@end

@implementation ITMRoomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ITMRoomCell" bundle:nil]
     forCellReuseIdentifier:@"ITMRoomCell"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                           target:self
                                                                                           action:@selector(addButtonClicked)];
    
    self.title = @"My Rooms";
    
    _dataSource = [NSMutableArray array];
    
    for (int i = 0; i < 8; i ++) {
        [_dataSource addObject:[NSString stringWithFormat:@"Room %d", i]];
    }
    
}

#pragma mark - User Events

- (void)addButtonClicked {
    [UIActionSheet photoPickerWithTitle:@"Attach File"
                             showInView:self.view
                              presentVC:self
                          onPhotoPicked:^(UIImage *chosenImage) {
                              
                              // TODO: open address book

                          } onCancel:^{}];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"ITMRoomCell";
    ITMRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];

    cell.titleLabel.text = _dataSource[indexPath.row];
    cell.subtitleLabel.text = @"Me, Kate Ruby";
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ITMRoomViewController *roomVC = [ITMRoomViewController new];
    roomVC.title = _dataSource[indexPath.row];
    [self.navigationController pushViewController:roomVC animated:YES];
}

@end

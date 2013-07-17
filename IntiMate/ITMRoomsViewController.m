//
//  ITMViewController.m
//  IntiMate
//
//  Created by Konstantin Kim on 17/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMRoomsViewController.h"
#import "ITMRoomViewController.h"

#define ROOM_KEY @"ROOM_KEY"

@interface ITMRoomsViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_dataSource;
}

@end

@implementation ITMRoomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"My Rooms";
    
    _dataSource = [NSMutableArray array];
    
    for (int i = 0; i < 5; i ++) {
        [_dataSource addObject:[NSString stringWithFormat:@"Room %d", i]];
    }
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"CellIdent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
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

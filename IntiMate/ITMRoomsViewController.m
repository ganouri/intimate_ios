//
//  ITMViewController.m
//  IntiMate
//
//  Created by Konstantin Kim on 17/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMRoomsViewController.h"
#import "ITMRoomViewController.h"
#import "ITMRoomCell.h"

#define ROOM_KEY @"ROOM_KEY"

@interface ITMRoomsViewController () <UITableViewDataSource, UITableViewDelegate> {
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                          target:self
                                                                                          action:@selector(presentLockScreen)];
    self.title = @"My Rooms";
    
    NSString *secureToken = [[ITMAuthManager shared] secureToken];
    if (secureToken && secureToken.length > 0) {
        
        [ITMDataAPI getListOf:@"rooms"
                     forToken:[[ITMAuthManager shared] secureToken]
                   completion:^(BOOL success, NSArray *rooms) {
                       if (success) {
                           [[ITMInteractionManager shared] setRooms:rooms];
                           [_tableView reloadData];
                       } else {
                           [UIAlertView alertViewWithTitle:nil message:@"Could not get rooms"];
                       }
                   }];
        
        
        [ITMDataAPI getListOf:@"contacts"
                     forToken:secureToken
                   completion:^(BOOL success, NSDictionary *contacts) {
                       
                       [[ITMDataAPI shared] setUsers:contacts];
                       
                   }];
        
        
        [ITMDataAPI getAllDataForToken:[[ITMAuthManager shared] secureToken]
                            completion:^(BOOL success, NSDictionary *allDataDict) {
                                if (success) {
                                    NSLog(@"ALL DATA: %@", allDataDict);
                                    
                                    [[ITMAuthManager shared] setCurrentUser:allDataDict];
                                    
//                                    [[ITMInteractionManager shared] setRooms:[allDataDict[@"rooms"] allValues]];
//                                    [_tableView reloadData];
                                } else {
                                    [UIAlertView alertViewWithTitle:nil message:@"Could not get rooms"];
                                }
                            }];
        
        [ITMDataAPI getAllResourcesWithCompletion:^(BOOL success, id list) {
            [[ITMDataAPI shared] setResources:list];
        }];
         
    } else {
        
    }
}

// test
- (void)presentLockScreen {
    [[ITMAuthManager shared] presentLoginViewControllerPasswordOnly:YES
                                                           animated:YES
                                                         completion:^{}];
}

#pragma mark - User Events

- (void)addButtonClicked {
    
    NSString *testUsers = @"mark@gmail.com:k@m.com";
    
    if (TARGET_IPHONE_SIMULATOR) {
        [UIActionSheet photoPickerWithTitle:nil
                                 showInView:self.view
                                  presentVC:self
                              onPhotoPicked:^(UIImage *chosenImage) {
                                  [ITMDataAPI sendImage:chosenImage
                                             completion:^(BOOL success, NSString *resourceId) {
                                                 
                                                 [ITMDataAPI createRoomWithUsers:testUsers
                                                                      completion:^(BOOL success, NSString *roomId) {
                                                                          
                                                                          NSLog(@"ROOM ID FROM SERVER: %@", roomId);
                                                                          
                                                                          [ITMDataAPI associateResource:resourceId
                                                                                              withRoom:roomId
                                                                                             completion:^(BOOL success, NSString *associationTimestamp) {
                                                                                              
                                                                                                 if (success) {
                                                                                                     // TODO: resource & room are linked
                                                                                                     // open the room with the resource presented
                                                                                                     
                                                                                                     ITMRoomViewController *roomVC = [ITMRoomViewController new];
                                                                                                     // [[ITMInteractionManager shared] rooms]
                                                                                                     roomVC.title = resourceId;
                                                                                                     [roomVC addImageToDataSource:chosenImage];
                                                                                                     [self.navigationController pushViewController:roomVC animated:YES];
                                                                                                 }
                                                                                                 
                                                                                             }];
                                                                      }];                                                 
                                             }];
                              } onCancel:^{
                                  // user canceled sending picture
                              }];
    } else {
        [[ITMInteractionManager shared] presentCameraOnController:self
                                                        withBlock:^(UIImage *chosenImage) {
                                                            
                                                            // TODO: open address book
                                                            
                                                        } cancelBlock:^{
                                                            
                                                        }];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ITMInteractionManager shared] rooms] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ident = @"ITMRoomCell";
    ITMRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];

    NSDictionary *room = [[ITMInteractionManager shared] rooms][indexPath.row];
    
    NSArray *members = room[@"members"];
    NSMutableString *users = [NSMutableString string];
    for (NSString *memberId in members) {
        
        NSString *nickname = [[ITMDataAPI shared].users objectForKey:memberId][@"nickname"];
        if (nickname) {
            [users appendString:nickname];
            if (![memberId isEqualToString:members.lastObject]) {
                [users appendString:@", "];
            }
        } else {
            break;
        }
    }
    
    if ([users isEqualToString:@""]) {
        [users appendString:@"unable to get nicknames..."];
    }
    
    cell.titleLabel.text = users;
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.doesRelativeDateFormatting = YES;
    NSTimeInterval ti = [room[@"lastUpdated"] doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ti];
    NSString *dateString = [df stringFromDate:date];
    
    cell.subtitleLabel.text = dateString;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *room = [[ITMInteractionManager shared] rooms][indexPath.row];
    ITMRoomViewController *roomVC = [ITMRoomViewController new];
    roomVC.roomId = room[@"_id"];
    // [[ITMInteractionManager shared] rooms]
//    roomVC.title = _dataSource[indexPath.row];
    [self.navigationController pushViewController:roomVC animated:YES];
}

@end

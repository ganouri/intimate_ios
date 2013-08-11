//
//  ITMRoomViewController.m
//  IntiMate
//
//  Created by Konstantin Kim on 17/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMRoomViewController.h"
#import "UIBubbleTableView.h"
#import "UIImageView+LBBlurredImage.h"


@interface ITMRoomViewController () <UIBubbleTableViewDataSource> {
    UIBubbleTableView *_bubbleView;
    NSMutableArray *_dataSource;
    NSMutableDictionary *_mediaDict;
}

@end

@implementation ITMRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _dataSource = [NSMutableArray array];
        _mediaDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addButtonClicked)];
    
    _bubbleView = [[UIBubbleTableView alloc] initWithFrame:self.view.bounds];
    _bubbleView.bubbleDataSource = self;
    _bubbleView.showAvatars = YES;
    [self.view addSubview:_bubbleView];
    
    [ITMDataAPI getRoomData:self.roomId
                 completion:^(BOOL success, NSDictionary *list) {
                     [_dataSource setArray:list.allValues];
                     [_bubbleView reloadData];
                 }];
    
    for (NSDictionary *rsrc in [[ITMDataAPI shared] resources]) {

        if ([rsrc[@"type"] isEqualToString:@"image"]) {
            NSString *rsrcId = rsrc[@"_id"];
            NSString *mediaId = rsrc[@"mediaId"];
            // http://54.213.95.44:8080/secure/6f5d7f3d510096b01de02184a4879460/room/b0160e7873a3f404e02057a3289154b1/a120a230-ffff-11e2-959b-e3c7d4a5201e/media/a11fdee0-ffff-11e2-959b-e3c7d4a5201e
            
            NSString *urlString = [NSString stringWithFormat:@"%@/secure/%@/room/%@/resource/%@/media/%@",
                                   BASE_URL,
                                   [ITMAuthManager shared].secureToken, self.roomId, rsrcId, mediaId];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            AFImageRequestOperation *operation =
            [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                                                   success:^(UIImage *image) {
                                                                                                       [_mediaDict setObject:image forKey:mediaId];
                                                                                                       [_bubbleView reloadData];
                                                                                                   }];
            
//            [AFImageRequestOperation imageRequestOperationWithRequest:request
//                                                 imageProcessingBlock:^UIImage *(UIImage *image) {
//                                                     NSLog(@"");
//                                                     return nil;
//                                                 } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                                     NSLog(@"");
//                                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                                                                                                          NSLog(@"");
//                                                 }];
            
            [operation start];
            
        }
    }
}

#pragma mark - UIBubbleTableView Datasource

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView {
    return _dataSource.count;
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row {
    NSString *memberId = _dataSource[row][@"user"];
    static NSString *myMemberId = nil;
    myMemberId = [[ITMAuthManager shared] currentUser][@"_id"];
    
    NSBubbleType type = [memberId isEqualToString:myMemberId] ? BubbleTypeMine : BubbleTypeSomeoneElse;
    NSBubbleData *heyBubble = nil;
    
    NSString *rsrcId = _dataSource[row][@"resourceId"];
    NSDictionary *resourceDict = [[[[ITMDataAPI shared] resources] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"_id == %@", rsrcId]] lastObject];
    NSString *rsrcType = resourceDict[@"type"];
    NSTimeInterval ti = [resourceDict[@"lastUpdated"] doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ti];
    
    if ([rsrcType isEqualToString:@"image"]) {
        heyBubble = [NSBubbleData dataWithImage:_mediaDict[resourceDict[@"mediaId"]]
                                           date:date
                                           type:type];
        
    } else if ([rsrcType isEqualToString:@"text"]) {
        // text only
        heyBubble = [NSBubbleData dataWithText:resourceDict[@"message"]
                                          date:date
                                          type:type];
    } else {
        [UIAlertView alertViewWithTitle:nil message:@"UNKNOWN RSRC TYPE"];
    }
    
    if (type == BubbleTypeSomeoneElse) {
        heyBubble.avatar = [UIImage imageNamed:@"profile_picture_generic"];
    } else {
        heyBubble.avatar = nil;
    }


    return heyBubble;
}

#pragma mark - Add button clicked

- (void)addButtonClicked {
    
    [[ITMInteractionManager shared] presentCameraOnController:self
                                                    withBlock:^(UIImage *chosenImage) {
        [[ITMAuthManager shared] presentLoginViewControllerPasswordOnly:YES
                                                               animated:YES
                                                             completion:^{
                                                                 [_dataSource addObject:chosenImage];
                                                                 [_bubbleView reloadData];
                                                             }];
                                                    } cancelBlock:^{
                                                    }];
}

#pragma mark - Public

- (void)addImageToDataSource:(UIImage *)image {
    [_dataSource addObject:image];
    [_bubbleView reloadData];
}

@end

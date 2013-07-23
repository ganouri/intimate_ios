//
//  ITMRoomViewController.m
//  IntiMate
//
//  Created by Konstantin Kim on 17/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import "ITMRoomViewController.h"
#import "UIBubbleTableView.h"

@interface ITMRoomViewController () <UIBubbleTableViewDataSource> {
    UIBubbleTableView *_bubbleView;
    NSMutableArray *_dataSource;
}

@end

@implementation ITMRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _dataSource = [@[@"Hello", @"Test", @"Hi", @"Good day", @"Love"] mutableCopy];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addButtonClicked)];
    
    _bubbleView = [[UIBubbleTableView alloc] initWithFrame:self.view.bounds];
    _bubbleView.bubbleDataSource = self;
    _bubbleView.showAvatars = YES;
    [self.view addSubview:_bubbleView];
}

#pragma mark - UIBubbleTableView Datasource

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView {
    return _dataSource.count;
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row {
    NSBubbleType type = row%2 == 0 ? BubbleTypeMine : BubbleTypeSomeoneElse;
    NSBubbleData *heyBubble = nil;
    
    if ([_dataSource[row] isKindOfClass:[UIImage class]]) {
        heyBubble = [NSBubbleData dataWithImage:_dataSource[row]
                                           date:[NSDate date]
                                           type:type];
    } else {
        // text only
        heyBubble = [NSBubbleData dataWithText:_dataSource[row]
                                          date:[NSDate date]
                                          type:type];
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

@end

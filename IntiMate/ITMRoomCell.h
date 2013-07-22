//
//  ITMRoomCell.h
//  IntiMate
//
//  Created by Konstantin Kim on 22/07/13.
//  Copyright (c) 2013 IntiMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITMRoomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;


@end

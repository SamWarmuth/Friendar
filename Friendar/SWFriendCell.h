//
//  SWFriendCell.h
//  Friendar
//
//  Created by Sam Warmuth on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAConfirmButton.h"

@interface SWFriendCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *emailLabel, *locationLabelOne, *locationLabelTwo;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) MAConfirmButton *pushConfirmButton;


@end

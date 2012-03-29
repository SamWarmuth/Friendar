//
//  SWFriendCell.h
//  Friendar
//
//  Created by Sam Warmuth on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWFriendCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *emailLabel, *locationLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;


@end

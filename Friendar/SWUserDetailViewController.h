//
//  SWUserDetailViewController.h
//  Friendar
//
//  Created by Sam Warmuth on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWUserDetailViewController : UIViewController {
    NSArray *styledButtons;
}

@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *styledButtons;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;


@end

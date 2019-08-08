//
//  MainTableViewCell.h
//  Love Messages
//
//  Created by Muhammad Luqman on 1/10/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagesForCellIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelForTitleCell;
@property (weak, nonatomic) IBOutlet UILabel *labelForCounterItem;

@property (weak, nonatomic) IBOutlet UILabel *labelForDelailCel;
@end

//
//  DetailTableViewCell.h
//  Love Messages
//
//  Created by Muhammad Luqman on 1/11/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelForTitleCell;
@property (weak, nonatomic) IBOutlet UILabel *labelForCounterCell;
@property (weak, nonatomic) IBOutlet UIImageView *imagesForBookMarks;

@end

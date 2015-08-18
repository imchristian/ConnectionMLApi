//
//  SearchTableViewCell.h
//  ConnectionMLApi
//
//  Created by usuario on 13/8/15.
//  Copyright (c) 2015 RockAndApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *price;

@end

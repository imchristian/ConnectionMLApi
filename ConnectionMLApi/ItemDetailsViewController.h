//
//  ItemDetailsViewController.h
//  ConnectionMLApi
//
//  Created by usuario on 14/8/15.
//  Copyright (c) 2015 RockAndApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailsViewController : UIViewController

@property (weak, nonatomic) NSString *itemId;
@property (strong, nonatomic) IBOutlet UIScrollView *imagesView;
@property (strong, nonatomic) IBOutlet UITextView *itemTitle;

@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *itemSold;
@property (strong, nonatomic) IBOutlet UILabel *stock;
@end

//
//  ViewController.h
//  ConnectionMLApi
//
//  Created by usuario on 12/8/15.
//  Copyright (c) 2015 RockAndApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *emptySearchImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

- (IBAction)searchButton:(id)sender;
@end


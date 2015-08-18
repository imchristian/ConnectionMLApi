//
//  ItemDetailsViewController.m
//  ConnectionMLApi
//
//  Created by usuario on 14/8/15.
//  Copyright (c) 2015 RockAndApp. All rights reserved.
//
//  This Controller handle all the data about the current item. First use a simple delegate methods connections to bring all the data and then push a new queue to show the appropiate images.
//

#import "ItemDetailsViewController.h"

@interface ItemDetailsViewController () <NSURLConnectionDataDelegate>
@property (strong, nonatomic) NSMutableData *recievedData;
@property (weak, nonatomic) NSURLResponse *recievedResponse;
@property (weak, nonatomic) NSError *connectionError;
@property (weak, nonatomic) NSMutableDictionary  *resultsDictionary;
@property (strong, nonatomic) NSURLConnection *apiRequest;
@end

@implementation ItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    //Check if exist some item
    if(self.itemId){
        [self searchRequest:self.itemId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//API Connection
-(void)searchRequest:(NSString *)request{
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.mercadolibre.com/items/%@",request];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.apiRequest = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
    
    //initialize to recieve data
    self.recievedData = [[NSMutableData alloc]init];
    
    [self.apiRequest start];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.recievedResponse = response;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
        [self.recievedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.connectionError = error;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *error = nil;
    
    self.resultsDictionary = [NSJSONSerialization JSONObjectWithData:self.recievedData options:NSJSONReadingMutableContainers error:&error];
        
    if(error)
        NSLog(@"JSONObjectWithData error: %@", error);
        
    //Call to the fill method with the result data
    [self fillTheItemFields:self.resultsDictionary];
    
}

//Present all the information into the scene
-(void)fillTheItemFields:(NSDictionary *)dictionary {
    self.itemTitle.text = self.resultsDictionary[@"title"];
    self.stock.text = [NSString stringWithFormat:@"%@ disponibles", [self.resultsDictionary[@"available_quantity"] stringValue]];
    self.location.text = [NSString stringWithFormat:@"%@", self.resultsDictionary[@"seller_address"][@"city"][@"name"]];
    self.itemSold.text = [NSString stringWithFormat:@"%@ vendidos", [self.resultsDictionary[@"sold_quantity"] stringValue]];
    
    //Set NSFormatter to display product price
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setCurrencySymbol:@"$"];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.price.text = [currencyFormatter stringForObjectValue:self.resultsDictionary[@"price"]];
    
    //Load Id Images
    NSArray *picturesArray = self.resultsDictionary[@"pictures"];
    NSMutableArray *picturesId= [NSMutableArray new];
    
    for (NSDictionary *picturesDictionary in picturesArray){
        [picturesId addObject:picturesDictionary[@"id"]];
    }
    
    for (int i = 0; i < picturesId.count; i++){
        NSString *idImage = picturesId[i];
        NSString *urlString = [[NSString alloc]initWithFormat:@"https://api.mercadolibre.com/pictures/%@", idImage];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        //Send Async connection to load the 400x400 images
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            if(data.length > 0 && error == nil){
                NSError *error = nil;
                NSString *picturesUrl = [NSString new];
                NSDictionary *imageDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                for (NSMutableDictionary *picturesVariations in imageDictionary[@"variations"]){
                    if ([picturesVariations[@"size"] isEqual:@"400x400"]) {
                         picturesUrl =  picturesVariations[@"url"];
                    }
                }
                
                //Call the method to display the images into the UIScrollView
                [self showImages:picturesUrl index:i];
            }
        }];
    }
    
   self.imagesView.contentSize = CGSizeMake(self.imagesView.frame.size.width * picturesId.count, self.imagesView.frame.size.height);
}

-(void)showImages:(NSString *)picturesUrl index:(int)i{
        CGRect frame;
        frame.origin.x = self.imagesView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.imagesView.frame.size;
        
        self.imagesView.pagingEnabled = YES;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //Create a concurrent queue
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{
            //load url image into NSData
            NSString *url = picturesUrl;
            NSData *picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            //Call again the main queue to modify the UIScrollView
            dispatch_async(dispatch_get_main_queue(), ^{
                //convert data into image after completion
                imageView.image = [UIImage imageWithData:picture];
                [self.imagesView addSubview:imageView];
            });
            
        });
}
@end



















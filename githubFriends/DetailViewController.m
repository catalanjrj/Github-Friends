//
//  DetailViewController.m
//  githubFriends
//
//  Created by Jorge Catalan on 4/25/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<NSURLSessionDelegate>
@property NSMutableData* receivedData;
@end



@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        
        
        NSString * userName =[self.detailItem description];
        NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/users/%@", userName];
        
        //creating local value that set to default configuration
        NSURL *url = [NSURL URLWithString:urlString];
        //as long as app is running this is the session we will use
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        // dataTask gets data from a URl could possibly send data.
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
        
        [dataTask resume];
        
        
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}
//call method several times, keep around from call to call.
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveData:(NSData *)data
{
    if(!self.receivedData){
        self.receivedData =[[NSMutableData alloc]initWithData:data];
        
    }else{
        [self.receivedData appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didCompleteWithError:(nullable NSError *)error{
    if(!error){
       
        // NSLog(@"Download Succesful%@", [self.receivedData description]);
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", [jsonResponse description]);
    }

}
//https://api.github.com/users/%@/repos
@end

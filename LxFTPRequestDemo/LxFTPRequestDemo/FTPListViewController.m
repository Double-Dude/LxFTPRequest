//
//  FTPListViewController.m
//  LxFTPRequestDemo
//
//  Created by Ray Qu on 27/03/18.
//  Copyright © 2018 DeveloperLx. All rights reserved.
//

#import "FTPListViewController.h"
#import "LxFTPRequest.h"
#import "FTPList.h"
#import "FTPListCell.h"
#import "JGProgressHUD.h"
@interface FTPListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LxFTPRequest *request;
@property (strong, nonatomic) NSArray *ftpLists;
@property (weak, nonatomic) JGProgressHUD * progressHUD;

@end

@implementation FTPListViewController


static NSString *const FTP_ADDRESS = @"ftp://192.168.0.174/userdata/Logs/Sonar";
static NSString *const USERNAME = @"anonymous";
static NSString *const PASSWORD = @"guest";


- (void)viewDidLoad {
    [super viewDidLoad];

    self.ftpLists = [[NSArray alloc] init];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getList];
}
- (IBAction)refreshButtonDidClick:(id)sender {
    [self getList];
}

- (void) getList {
    self.request = [LxFTPRequest resourceListRequest];
    self.request.serverURL = [[NSURL URLWithString:FTP_ADDRESS] URLByAppendingPathComponent:@""];
    self.request.username = USERNAME;
    self.request.password = PASSWORD;
    
    typeof(self) __weak weakSelf = self;

    self.request.successAction = ^(Class resultClass, id result) {

        NSArray *results =(NSArray *) result;
        weakSelf.ftpLists = [FTPList ftpList:results];
        [weakSelf.tableView reloadData];
        NSLog(@"Result: %@", result);
//        typeof(weakSelf) __strong strongSelf = weakSelf;
//        [strongSelf->_progressHUD dismissAnimated:YES];
//        NSArray *resultArray = (NSArray *)result;
//        [strongSelf showMessage:[NSString stringWithFormat:@"%@", resultArray]];
    };
    
    self.request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString *errorMessage) {
//        typeof(weakSelf) __strong strongSelf = weakSelf;
//        [strongSelf->_progressHUD dismissAnimated:YES];
        NSLog(@"domain = %ld, error = %ld, errorMessage = %@", domain, error, errorMessage); //
    };
    [self.request start];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ftpLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FTPList *ftpList = [self.ftpLists objectAtIndex:indexPath.row];
    
    FTPListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FTPListCell" owner:nil options:nil] lastObject];
        [cell setFTPList:ftpList];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FTPList *ftpList = [self.ftpLists objectAtIndex:indexPath.row];
    [self download:ftpList];

}

- (void) download:(FTPList *)ftpList {
    
    typeof(self) __weak weakSelf = self;

    LxFTPRequest *request = [LxFTPRequest downloadRequest];
    request.serverURL = [[NSURL URLWithString:FTP_ADDRESS] URLByAppendingPathComponent:ftpList.name];
    
    request.localFileURL = [[NSURL URLWithString:@"file:///Users/RayQu/Desktop"] URLByAppendingPathComponent:ftpList.name];
    request.username = USERNAME;
    request.password = PASSWORD;
    
    __block NSDate *lastDate = [NSDate date];
    __block NSInteger lastFinishedSize = 0;
    request.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
//        NSLog(@"totalSize = %ld, finishedSize = %ld, finishedPercent = %f", totalSize, finishedSize, finishedPercent); //
        totalSize = MAX(totalSize, finishedSize);
        weakSelf.progressHUD.progress = (CGFloat)finishedSize / (CGFloat)totalSize;
        
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeDifference = [[NSDate date] timeIntervalSinceDate:lastDate];
        if (timeDifference >= 1) { //Greater than 1s
            
            double differenceMB = (finishedSize - lastFinishedSize) / 1024.0 / 1024.0;
            double mbps = differenceMB / timeDifference;
            NSLog(@"\n Download Speed: %.1f MB/s \n Downloaded percentage: %f", mbps, finishedPercent);
            
            lastFinishedSize = finishedSize;
            lastDate = currentDate;
        }
    };
    request.successAction = ^(Class resultClass, id result) {
        [weakSelf.progressHUD dismissAnimated:YES];
        [weakSelf showMessage:@"Download finished!!!"];
    };
    request.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString *errorMessage) {
        [weakSelf.progressHUD dismissAnimated:YES];
        [weakSelf showMessage:@"Download ERROR!!!"];
        NSLog(@"domain = %ld, error = %ld, errorMessage = %@", domain, error, errorMessage); //
    };
    [request start];
    
    _progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    _progressHUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] init];
    _progressHUD.progress = 0;
    [_progressHUD showInView:self.view animated:YES];
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)showMessage:(NSString *)message {
    NSLog(@"message = %@", message); //
    
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    hud.indicatorView = nil;
    hud.textLabel.text = message;
    [hud showInView:self.view];
    [hud dismissAfterDelay:3];
    [self sendNotification:message];
}

- (void) sendNotification:(NSString *)text {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
    notification.alertBody = text;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
@end

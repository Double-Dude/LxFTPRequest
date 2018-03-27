//
//  FTPListCell.m
//  LxFTPRequestDemo
//
//  Created by Ray Qu on 27/03/18.
//  Copyright © 2018 DeveloperLx. All rights reserved.
//

#import "FTPListCell.h"
@interface FTPListCell()
@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifiedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@end
@implementation FTPListCell

- (void) setFTPList:(FTPList *)ftpList {
    self.nameTextLabel.text = ftpList.name;
    self.modifiedDateLabel.text = [ftpList.dateModified description];
    self.sizeLabel.text = ftpList.size;
}

@end

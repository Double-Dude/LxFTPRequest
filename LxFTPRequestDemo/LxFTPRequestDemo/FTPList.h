//
//  FTPList.h
//  LxFTPRequestDemo
//
//  Created by Ray Qu on 27/03/18.
//  Copyright © 2018 DeveloperLx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTPList : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *dateModified;
@property (nonatomic, copy) NSString *size;

+ (NSArray<FTPList *> *) ftpList:(NSArray *) resultDictArray;

@end

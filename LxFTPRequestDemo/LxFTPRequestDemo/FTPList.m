//
//  FTPList.m
//  LxFTPRequestDemo
//
//  Created by Ray Qu on 27/03/18.
//  Copyright © 2018 DeveloperLx. All rights reserved.
//

#import "FTPList.h"

@implementation FTPList
- (FTPList *) initWithDict:(NSDictionary *) dict {
    FTPList *ftpList = [[FTPList alloc] init];
    ftpList.name = dict[@"kCFFTPResourceName"];
    ftpList.dateModified = dict[@"kCFFTPResourceModDate"];
    double size = [dict[@"kCFFTPResourceSize"] integerValue] / 1024.0 /1024.0;
    ftpList.size = [NSString stringWithFormat:@"%.1f MB", size];
    return ftpList;
}
+ (NSArray<FTPList *> *)ftpList:(NSArray *)resultDictArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in resultDictArray) {
        [array addObject:[[FTPList alloc] initWithDict:dict]];
    }
    
    return array;
}
@end

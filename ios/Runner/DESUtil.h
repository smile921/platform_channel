//
//  DESUtil.h
//  zhelitou
//
//  Created by saicheng on 14-11-16.
//  Copyright (c) 2014年 www.zimore.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESUtil : NSObject
+ (NSString *) encryptUseDES:(NSString *)data withSalt:(NSString*)salt;
@end

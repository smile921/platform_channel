//
//  ChannelMessenger.m
//  Runner
//
//  Created by 小阎王 on 2019/8/1.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "ChannelMessenger.h"
#import <Flutter/Flutter.h>

@interface ChannelMessenger ()<FlutterBinaryMessenger>

@end

@implementation ChannelMessenger

- (void)sendOnChannel:(nonnull NSString *)channel message:(NSData * _Nullable)message {
    
}

- (void)sendOnChannel:(nonnull NSString *)channel message:(NSData * _Nullable)message binaryReply:(FlutterBinaryReply _Nullable)callback {
    
}

- (void)setMessageHandlerOnChannel:(nonnull NSString *)channel binaryMessageHandler:(FlutterBinaryMessageHandler _Nullable)handler {
    
}

@end

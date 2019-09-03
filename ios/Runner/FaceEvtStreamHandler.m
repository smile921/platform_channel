//
//  FaceEvtStreamHandler.m
//  Runner
//
//  Created by 小阎王 on 2019/8/1.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "FaceEvtStreamHandler.h"

@interface FaceEvtStreamHandler ()

@end

@implementation FaceEvtStreamHandler
    
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    
    NSLog(@"onCancelWithArguments");
    
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    
    NSLog(@"onListenWithArguments");
    
    return nil;
}

@end

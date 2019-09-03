//
//  UDAuthViewController.h
//  Runner
//
//  Created by 小阎王 on 2019/7/31.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UDAuthViewController : UIViewController

- (NSString*)doIDcardOcr:(NSString*)orderId  sign:(NSString*)sign signTime:(NSString*)signTime;

@end

NS_ASSUME_NONNULL_END

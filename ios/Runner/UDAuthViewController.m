//
//  UDAuthViewController.m
//  Runner
//
//  Created by 小阎王 on 2019/7/31.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "UDAuthViewController.h"

#import "UDIDEngine.h"
#import "UDIDFaceCompareFactory.h"

#define UDPUBKEY @"377753b2-440d-444a-b61c-1966ce7d1af1"

@interface UDAuthViewController ()<UDIDEngineDelegate>

@end

@implementation UDAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString*)doIDcardOcr:(NSString*)orderId  sign:(NSString*)sign signTime:(NSString*)signTime {
    
    UDIDEngine *ocrEngine = [[UDIDEngine alloc] init];
    /* 身份证 OCR 扫描相关参数 */
    ocrEngine.actions = @[@0];
    // 或者下面的 actions 传入方式
    // ocrEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowOCR]];
    ocrEngine.showInfo = YES;
    
    /* 通用参数 */
    ocrEngine.pubKey = UDPUBKEY;
    ocrEngine.signTime = signTime;
    ocrEngine.partnerOrderId = orderId;
    ocrEngine.sign = sign;
    ocrEngine.delegate = self;
    
    [ocrEngine startIdSafeAuthInViewController:self];
    return @"";
}

- (void)idSafeEngineFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

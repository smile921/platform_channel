//
//  UDViewController.m
//  Runner
//
//  Created by 小阎王 on 2019/7/31.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "UDViewController.h"
#import "UDIDEngine.h"
#import "UDIDFaceCompareFactory.h"
#import "Md5.h"

#define UDPUBKEY @"377753b2-440d-444a-b61c-1966ce7d1af1"

#define UDSECURITYKEY   @"12121212-1212-1212-1212-121212121212" // 商户secretkey

@interface UDViewController ()<UDIDEngineDelegate>

@property (nonatomic, strong) NSString* sign;
@property (nonatomic, strong) NSString* partnerOrderId;
@property (nonatomic, strong) NSString* signTime;

@end

@implementation UDViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (instancetype)initWithPartnerOrderId:(NSString *)partnerOrderId sign:(NSString *)sign signTime:(NSString *)signTime {
    
    self = [super init];
    
    if (self) {
        self.partnerOrderId = partnerOrderId;
        self.sign = sign;
        self.signTime = signTime;
    }
    return self;
    
}

- (NSString*)doIDcardOcr:(NSString*)orderId  sign:(NSString*)sign signTime:(NSString*)signTime {
    
    /*
    UDIDEngine *ocrEngine = [[UDIDEngine alloc] init];
    ocrEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowOCR]];
    ocrEngine.showInfo = YES;
    ocrEngine.pubKey = UDPUBKEY;
    ocrEngine.signTime = signTime;
    ocrEngine.partnerOrderId = orderId;
    ocrEngine.sign = sign;
    ocrEngine.delegate = self;
    */
    
    
    
    return @"";
}
- (IBAction)click:(id)sender {
    
    UDIDEngine *ocrEngine = [[UDIDEngine alloc] init];
    ocrEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowOCR]];
    ocrEngine.showInfo = YES;
    ocrEngine.pubKey = UDPUBKEY;
    ocrEngine.signTime = [self getTimeSp];
    ocrEngine.partnerOrderId = [NSString stringWithFormat:@"ud_ios_%@", [self getTimeSp]];
    ocrEngine.sign = [self getSignatureByMd5];
    ocrEngine.delegate = self;
    
    [ocrEngine startIdSafeAuthInViewController:self];
    
}

- (void)idSafeEngineFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo {
    
}

- (NSString *)getTimeSp {
    NSString *resultString = nil;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] ;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSDate *datenow = [NSDate dateWithTimeIntervalSince1970:time];
    resultString = [formatter stringFromDate:datenow];
    return resultString;
}

- (NSString*)getSignatureByMd5 {
    NSString *resultString = nil;
    NSString* signature = [NSString stringWithFormat:@"pub_key=%@|partner_order_id=%@|sign_time=%@|security_key=%@",UDPUBKEY,self.partnerOrderId,self.signTime,UDSECURITYKEY];
    resultString = [Md5 encodeToLowerCase:signature];
    return resultString;
}

@end

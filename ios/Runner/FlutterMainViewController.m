//
//  FlutterMainViewController.m
//  Runner
//
//  Created by 小阎王 on 2019/8/26.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "FlutterMainViewController.h"

#import "DESUtil.h"

#import "UDIDEngine.h"
#import "UDIDFaceCompareFactory.h"
#import "UDIDSafeDataDefine.h"

#import "FaceEvtStreamHandler.h"
#import "FaceAuthEventBinaryMessenger.h"
#import "FaceAuthBinaryMessenger.h"

#import "GeneratedPluginRegistrant.h"

#define UDPUBKEY @"377753b2-440d-444a-b61c-1966ce7d1af1"

@interface FlutterMainViewController () <UDIDEngineDelegate, FlutterStreamHandler>

@property (nonatomic, strong) FlutterViewController* flutterViewController;

@property (nonatomic, strong) FlutterEventSink eventSink;

@property (nonatomic, strong) NSString* currentBizType;
@property (nonatomic, strong) NSString* methodNameSuccess;
@property (nonatomic, strong) NSString* methodNameFail;
@property (nonatomic, strong) NSMutableDictionary* JSONdict;
@property (nonatomic, strong) NSMutableDictionary* JSONdata;

@property(strong, nonatomic)UIImageView *imageView;

@end

@implementation FlutterMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _flutterViewController = [[FlutterViewController alloc] init];
    
    [GeneratedPluginRegistrant registerWithRegistry:_flutterViewController];
    
    FlutterMethodChannel* faceAuthChannel = [FlutterMethodChannel methodChannelWithName:@"com.zjex.equity/faceAll" binaryMessenger:_flutterViewController];
    
    [faceAuthChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        
        if ([@"doFullAuth" isEqualToString:call.method]) {//全流程
            
        } else if ([@"doIDcardOcr" isEqualToString:call.method]) {//身份证识别
            
            NSDictionary* dic = call.arguments;
            
            NSString* orderId = [dic objectForKey:@"orderId"];
            NSString* sign = [dic objectForKey:@"sign"];
            NSString* signTime = [dic objectForKey:@"signTime"];
            _currentBizType = [dic objectForKey:@"currentBizType"];
            
            _methodNameSuccess = @"onOcrSuccess";
            _methodNameFail = @"onOcrFail";
            
            UDIDEngine *engine = [[UDIDEngine alloc] init];
            
            engine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowOCR]];
            
            engine.showInfo = YES;
            engine.pubKey = UDPUBKEY;
            engine.signTime = signTime;
            engine.partnerOrderId = orderId;
            engine.sign = sign;
            engine.delegate = self;
            [engine startIdSafeAuthInViewController:_flutterViewController];
            
            result(@"doIDcardOcr");
            
        } else if ([@"doLivingness" isEqualToString:call.method]) {//活体检测
            
            NSDictionary* dic = call.arguments;
            
            NSString* orderId = [dic objectForKey:@"orderId"];
            NSString* sign = [dic objectForKey:@"sign"];
            NSString* signTime = [dic objectForKey:@"signTime"];
            _currentBizType = [dic objectForKey:@"currentBizType"];
            
            _methodNameSuccess = @"onLivingSuccess";
            _methodNameFail = @"onLivingFail";
            
            UDIDEngine *engine = [[UDIDEngine alloc] init];
            engine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowLiving]];
            engine.showInfo = YES;
            engine.pubKey = UDPUBKEY;
            engine.signTime = signTime;
            engine.partnerOrderId = orderId;
            engine.sign = sign;
            engine.delegate = self;
            [engine startIdSafeAuthInViewController:_flutterViewController];
            
            result(@"doLivingness");
            
        } else if ([@"doLivingAuth" isEqualToString:call.method]) {//活体检测 + 人像比对
            
            NSDictionary* dic = call.arguments;
            
            NSString* orderId = [dic objectForKey:@"orderId"];
            NSString* sign = [dic objectForKey:@"sign"];
            NSString* signTime = [dic objectForKey:@"signTime"];
            NSString* idName = [dic objectForKey:@"idName"];
            NSString* idNumber = [dic objectForKey:@"idNumber"];
            
            _currentBizType = [dic objectForKey:@"currentBizType"];
            
            _methodNameSuccess = @"onLivingAuthSuccess";
            _methodNameFail = @"onLivingAuthFail";
            
            UDIDEngine *engine = [[UDIDEngine alloc] init];
            
            engine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowLiving], [NSNumber numberWithUnsignedInteger:UDIDAuthFlowCompare_Verify]];
            
            engine.compareItemA = [UDIDFaceCompareFactory getBytype:UDIDSafePhotoTypeLiving];
            engine.compareItemB = [UDIDFaceCompareFactory getBytype:UDIDSafePhotoTypeNormal];
            
            engine.compareIDName = idName;
            engine.compareIDNumber = idNumber;
            
            engine.showInfo = YES;
            engine.pubKey = UDPUBKEY;
            engine.signTime = signTime;
            engine.partnerOrderId = orderId;
            engine.sign = sign;
            engine.delegate = self;
            [engine startIdSafeAuthInViewController:_flutterViewController];
            
            result(@"doLivingAuth");
            
        } else if([@"doEncrypt" isEqualToString:call.method]) {
            
            NSDictionary *dic = call.arguments;
            NSString * username = dic[@"username"];
            NSString * password = dic[@"password"];
            NSString* encStr = [DESUtil encryptUseDES:password withSalt:username];
            result(encStr);
            
        } else {
            
            result(FlutterMethodNotImplemented);
        }
    } ];
    
    FlutterEventChannel* faceAuthEventChannel = [FlutterEventChannel eventChannelWithName:@"com.zjex.equity/faceEvt" binaryMessenger:_flutterViewController];
    
    [faceAuthEventChannel setStreamHandler:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenRect.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat screenY = screenSize.height * scale;
    
    NSString* imageName = [NSString stringWithFormat:@"Image_%.0f", screenY];
    
    NSLog(@"screenY: %f", screenY);
    
    UIWindow* window = [[UIApplication sharedApplication]keyWindow];
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    _imageView.frame = [UIScreen mainScreen].bounds;
    [window addSubview:_imageView];
    
    [window bringSubviewToFront:_imageView];
    
    [self.navigationController pushViewController:_flutterViewController animated:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(hideImageView) userInfo:nil repeats:NO];
    
}

- (void)hideImageView {
    
    [_imageView removeFromSuperview];
    
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    _eventSink = events;
    return nil;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

- (void)idSafeEngineFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo {
    
    switch (result) {
        case UDIDEngineResult_OCR: {//身份证OCR识别
            
            if([userInfo isKindOfClass:[NSDictionary class]]) {
                
                _JSONdict = [[NSMutableDictionary alloc] init];
                _JSONdata = [[NSMutableDictionary alloc] init];
                
                BOOL success = [userInfo objectForKey:@"success"];
                if(!success) {
                    
                    NSString *message = [userInfo objectForKey:@"message"] ? [userInfo objectForKey:@"message"] : @"";
                    NSString *errorcode = [userInfo objectForKey:@"errorcode"] ? [userInfo objectForKey:@"errorcode"] : @"";
                    
                    [_JSONdict setObject:_methodNameFail forKey:@"methodName"];
                    [_JSONdict setObject:message forKey:@"message"];
                    [_JSONdict setObject:errorcode forKey:@"errorcode"];
                    [_JSONdict setObject:_currentBizType forKey:@"currentBizType"];
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    _eventSink([FlutterError errorWithCode:@"-100" message:message details:jsonString]);
                    return;
                }
                
                [_JSONdata setObject:[userInfo objectForKey:@"id_name"] forKey:@"id_name"];
                [_JSONdata setObject:[userInfo objectForKey:@"id_number"] forKey:@"id_number"];
                [_JSONdata setObject:[userInfo objectForKey:@"idcard_front_photo"] forKey:@"idcard_front_photo"];
                [_JSONdata setObject:[userInfo objectForKey:@"idcard_back_photo"] forKey:@"idcard_back_photo"];
                
                [_JSONdata setObject:_currentBizType forKey:@"currentBizType"];
                
                [_JSONdict setObject:_JSONdata forKey:@"data"];
                
                [_JSONdict setObject:_methodNameSuccess forKey:@"methodName"];
                
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                _eventSink(jsonString);
            }
            break;
        } case UDIDEngineResult_Liveness: {//活体检测
            
            if([userInfo isKindOfClass:[NSDictionary class]]) {
                
                _JSONdict = [[NSMutableDictionary alloc] init];
                _JSONdata = [[NSMutableDictionary alloc] init];
                
                BOOL success = [userInfo objectForKey:@"success"];
                if(!success) {
                    
                    NSString *message = [userInfo objectForKey:@"message"] ? [userInfo objectForKey:@"message"] : @"";
                    NSString *errorcode = [userInfo objectForKey:@"errorcode"] ? [userInfo objectForKey:@"errorcode"] : @"";
                    
                    [_JSONdict setObject:_methodNameFail forKey:@"methodName"];
                    [_JSONdict setObject:message forKey:@"message"];
                    [_JSONdict setObject:errorcode forKey:@"errorcode"];
                    [_JSONdict setObject:_currentBizType forKey:@"currentBizType"];
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    _eventSink([FlutterError errorWithCode:@"-100" message:message details:jsonString]);
                    return;
                }
                
                NSDictionary* risk_tag = [userInfo objectForKey:@"risk_tag"];
                if(risk_tag && [[risk_tag objectForKey:@"living_attack"] isEqualToString:@"1"]) {
                    NSString *message = [userInfo objectForKey:@"message"] ? [userInfo objectForKey:@"message"] : @"";
                    NSString *errorcode = [userInfo objectForKey:@"errorcode"] ? [userInfo objectForKey:@"errorcode"] : @"";
                    
                    [_JSONdict setObject:_methodNameFail forKey:@"methodName"];
                    [_JSONdict setObject:message forKey:@"message"];
                    [_JSONdict setObject:errorcode forKey:@"errorcode"];
                    [_JSONdict setObject:_currentBizType forKey:@"currentBizType"];
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    _eventSink([FlutterError errorWithCode:@"-100" message:@"活体检测存在作弊的风险" details:jsonString]);
                    return;
                }
                [_JSONdata setObject:[userInfo objectForKey:@"living_photo"] forKey:@"living_photo"];
                [_JSONdata setObject:_currentBizType forKey:@"currentBizType"];
                
                [_JSONdict setObject:_JSONdata forKey:@"data"];
                
                [_JSONdict setObject:_methodNameSuccess forKey:@"methodName"];
                
                if([_methodNameSuccess isEqualToString:@"onLivingSuccess"]) {
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    _eventSink(jsonString);
                }
                
            }
            break;
        } case UDIDEngineResult_FaceCompare: {//人脸比对
            
            if([userInfo isKindOfClass:[NSDictionary class]]) {
                BOOL success = [userInfo objectForKey:@"success"];
                if(!success) {
                    
                    NSString *message = [userInfo objectForKey:@"message"] ? [userInfo objectForKey:@"message"] : @"";
                    NSString *errorcode = [userInfo objectForKey:@"errorcode"] ? [userInfo objectForKey:@"errorcode"] : @"";
                    
                    [_JSONdict setObject:_methodNameFail forKey:@"methodName"];
                    [_JSONdict setObject:message forKey:@"message"];
                    [_JSONdict setObject:errorcode forKey:@"errorcode"];
                    [_JSONdict setObject:_currentBizType forKey:@"currentBizType"];
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    _eventSink([FlutterError errorWithCode:@"-100" message:[userInfo objectForKey:@"message"] details:jsonString]);
                    return;
                }
                
                NSString* suggest_result = [userInfo objectForKey:@"suggest_result"];
                
                if(suggest_result && [suggest_result isEqualToString: @"F"]) {
                    
                    NSString *message = [userInfo objectForKey:@"message"] ? [userInfo objectForKey:@"message"] : @"";
                    NSString *errorcode = [userInfo objectForKey:@"errorcode"] ? [userInfo objectForKey:@"errorcode"] : @"";
                    
                    [_JSONdict setObject:_methodNameFail forKey:@"methodName"];
                    [_JSONdict setObject:message forKey:@"message"];
                    [_JSONdict setObject:errorcode forKey:@"errorcode"];
                    [_JSONdict setObject:_currentBizType forKey:@"currentBizType"];
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    _eventSink([FlutterError errorWithCode:@"-101" message:[userInfo objectForKey:@"message"] details:jsonString]);
                    return;
                }
                
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                _eventSink(jsonString);
            }
            break;
        } case UDIDEngineResult_Cancel: {//取消
            
            _JSONdict = [[NSMutableDictionary alloc] init];
            
            NSString *message = [userInfo objectForKey:@"message"] ? [userInfo objectForKey:@"message"] : @"";
            NSString *errorcode = [userInfo objectForKey:@"errorcode"] ? [userInfo objectForKey:@"errorcode"] : @"";
            
            [_JSONdict setObject:_methodNameFail forKey:@"methodName"];
            [_JSONdict setObject:message forKey:@"message"];
            [_JSONdict setObject:errorcode forKey:@"errorcode"];
            [_JSONdict setObject:_currentBizType forKey:@"currentBizType"];
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            _eventSink([FlutterError errorWithCode:@"-100" message:message details:jsonString]);
            
            break;
        }
        default:
            
            _JSONdict = [[NSMutableDictionary alloc] init];
            
            NSString *message = [userInfo objectForKey:@"message"] ? [userInfo objectForKey:@"message"] : @"";
            NSString *errorcode = [userInfo objectForKey:@"errorcode"] ? [userInfo objectForKey:@"errorcode"] : @"";
            
            [_JSONdict setObject:_methodNameFail forKey:@"methodName"];
            [_JSONdict setObject:message forKey:@"message"];
            [_JSONdict setObject:errorcode forKey:@"errorcode"];
            [_JSONdict setObject:_currentBizType forKey:@"currentBizType"];
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_JSONdict options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            _eventSink([FlutterError errorWithCode:@"-100" message:message details:jsonString]);
            
            break;
    }
}

@end

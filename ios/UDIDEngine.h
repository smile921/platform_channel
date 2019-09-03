//
//  UDIDEngine.h
//  UubeeSuperReal
//
//  Created by Jin Jian on 2017/5/25.
//  Copyright © 2017年 Hydra. All rights reserved.
//
// SDK 版本号 V4.3.LL190719.20190719

#import <Foundation/Foundation.h>
#import "UDIDSafeDataDefine.h"
#import "UDIDFaceCompareItem.h"

@protocol UDIDEngineDelegate <NSObject>

/* 返回结果，cancel是用户取消操作，Done 是完成检测 ，userInfo是完成检测之后的返回信息 */
- (void)idSafeEngineFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo;

@end

@interface UDIDEngine : NSObject

@property (nonatomic, weak) id <UDIDEngineDelegate> delegate;


#pragma mark - 通用参数
/**
 商户公钥，必传
 */
@property (nonatomic, strong) NSString * pubKey;

/**
 签名，必传（签名规则请看文档）
 */
@property (nonatomic, strong) NSString * sign;

/**
 签名时间，必传，格式：yyyyMMddHHmmss
 */
@property (nonatomic, strong) NSString * signTime;

/**
 商户订单号，必传
 */
@property (nonatomic, strong) NSString * partnerOrderId;

/**
 异步通知地址
 */
@property (nonatomic, strong) NSString * notifyUrl;

/**
 关联 id
 */
@property (nonatomic, strong) NSString * sessionId;

/**
 作为备用的业务字段（预留字段，json格式）
 */
@property (nonatomic, strong) NSString * extInfo;

/**
 组建流程数组，必传,（枚举）
 */
@property (nonatomic, copy) NSArray *actions;


#pragma mark - 身份证OCR参数

/**
 是否只扫描身份证正面OCR（默认为否）
 */
@property (nonatomic, assign) BOOL isSingleFront;

/**
 是否开启OCR与活体震动提醒（默认为否）
 */
@property (assign, nonatomic) BOOL isOpenVibrate;

/**
 是否开启本地相册上传（默认为为否）
 */
@property (assign, nonatomic) BOOL isOpenLocalAlbum;

/**
 是否显示闪光灯按钮（默认为YES）
 */
@property (assign, nonatomic) BOOL isOpenFlashlight;

/**
 身份证号码是否可编辑（默认为否）
 */
@property (nonatomic, assign) BOOL canEditIDNumber;

/**
 是否显示身份证ocr信息,确认信息页面（默认为YES）
 */
@property (nonatomic, assign) BOOL showInfo;

/**
 手动拍照 OCR（默认为 YES）
 */
@property (nonatomic, assign) BOOL isManualOCR;

/**
 清晰度阈值，共2个等级（默认为一般）
 */
@property (nonatomic, assign) UDIDOCRClearness clearnessType;


#pragma mark - 活体检测参数

/**
 随机数量（传入5个活体动作，randomCount = 3；即为随机五选三）
 */
@property (nonatomic, assign) NSInteger randomCount;

/**
 活体动作数组（传入想要的活体动作）
 */
@property (nonatomic, copy)   NSArray *livingModeSettings;

/**
 活体检测模式，UDIDLivingMode 枚举（单个动作、四选三、自定义）
 */
@property (nonatomic, assign) UDIDLivingMode livingMode;

/**
 安全模式，共3个等级，即活体检测的动作要求难度, 默认最高等级
 */
@property (nonatomic, assign) UDIDSafeMode safeMode;

/**
 是否开启活体声音（默认为否）
 */
@property (assign, nonatomic) BOOL isOpenLivenessVoice;


#pragma mark - 身份认证参数

/**
 身份认证-姓名
 */
@property (nonatomic, copy)   NSString *idName;

/**
 身份认证-身份证号码
 */
@property (nonatomic, copy)   NSString *idNumber;

/**
 身份验证方式（UDIDVerifySimpleType - 简项验证、UDIDVerifyHumanType - 人像验证（默认）
 */
@property (nonatomic, assign) UDIDVerifyType verifyType;


#pragma mark - 人脸比对参数

/**
 比对项 A
 */
@property (nonatomic, strong) UDIDFaceCompareItem *compareItemA;

/**
 比对项 B
 */
@property (nonatomic, strong) UDIDFaceCompareItem *compareItemB;

/**
 是否网格照
 */
@property (nonatomic, assign) BOOL isGridPhoto;

/**
 人像比对-姓名
 */
@property (nonatomic, copy)   NSString *compareIDName;

/**
 人像比对-身份证
 */
@property (nonatomic, copy)   NSString *compareIDNumber;


#pragma mark - 驾驶证OCR参数

/**
 是否为单独驾驶证正面扫描
 */
@property (nonatomic, assign) BOOL isSingleDLFront;


#pragma mark - 行驶证OCR参数

/**
 是否为单独行驶证正面扫描
 */
@property (nonatomic, assign) BOOL isSingleVLFront;


/*----------开始方法---------*/
/* 传入当前 VC */
- (void)startIdSafeAuthInViewController:(UIViewController *)viewController;

@end

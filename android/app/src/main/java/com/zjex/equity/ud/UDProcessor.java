package com.zjex.equity.ud;

import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.alibaba.fastjson.JSONObject;
import com.zjex.equity.util.StringUtil;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

/**
 * 有盾接口调用
 * Created by theone on 2019/7/5.
 */
public class UDProcessor {

    /**
     * 人脸识别全流程
     * @param mContext
     * @param partnerOrderId
     * @param signTime
     * @param sign
     */
//    public static void doFullAuth(Context mContext, String partnerOrderId, String  signTime, String  sign,String currentBizType){
////        UDhelper.doFullAuth(mContext, partnerOrderId, signTime, sign, new FullAuthCallback() {
////            @Override
////            public void onFullAuthSuccess(String id_name, String id_number, String idcard_back_photo, String idcard_front_photo, String living_photo) {
//////                Toast.makeText(mContext,"实人认证成功",Toast.LENGTH_LONG).show();
////                JSONObject json = new JSONObject();
////                json.put("id_name",id_name);
////                json.put("id_number",id_number);
////                json.put("idcard_back_photo",idcard_back_photo);
////                json.put("idcard_front_photo",idcard_front_photo);
////                json.put("living_photo",living_photo);
////                json.put("currentBizType",currentBizType);
////                callFlutter(mContext,"onFullAuthSuccess",json.toJSONString(),true);
////            }
////
////            @Override
////            public void onFullAuthFail(String message) {
////                JSONObject json = new JSONObject();
////                json.put("message",message);
////                json.put("currentBizType",currentBizType);
////                callFlutter(mContext,"onFullAuthFail",json.toJSONString(),false);
////            }
////        });
////
////    }

    /**
     * 活体检测
     * @param mContext
     * @param partnerOrderId
     * @param signTime
     * @param sign
     */
    public static void doLivingness(Context mContext, String partnerOrderId, String  signTime, String  sign,String currentBizType){

        UDhelper.doLiving(mContext, partnerOrderId, signTime, sign, new LivingnessCallback() {
            @Override
            public void onLivingSuccess(String living_photo) {
                JSONObject json = new JSONObject();
                json.put("living_photo",living_photo);
                json.put("currentBizType",currentBizType);
                callFlutter(mContext,"onLivingSuccess",json.toJSONString(),true);
            }

            @Override
            public void onLivingFail(String message) {
                JSONObject json = new JSONObject();
                json.put("message",message);
                json.put("currentBizType",currentBizType);
                callFlutter(mContext,"onLivingFail",json.toJSONString(),false);
            }
        });

    }

    /**
     * 身份证扫描
     * @param mContext
     * @param partnerOrderId
     * @param signTime
     * @param sign
     */
    public static void doIDcardOcr(Context mContext, String partnerOrderId, String  signTime, String  sign,String currentBizType){

        UDhelper.doIDcardOcr(mContext, partnerOrderId, signTime, sign, new IDCardOcrCallback() {
            @Override
            public void onOcrSuccess(String id_name, String id_number,
                                     String idcard_back_photo, String idcard_front_photo) {
                JSONObject json = new JSONObject();
                json.put("id_name",id_name);
                json.put("id_number",id_number);
                json.put("idcard_back_photo",idcard_back_photo);
                json.put("idcard_front_photo",idcard_front_photo);
                json.put("currentBizType",currentBizType);
                callFlutter(mContext,"onOcrSuccess",json.toJSONString(),true);
            }

            @Override
            public void onOcrFail(String message) {
                JSONObject json = new JSONObject();
                json.put("message",message);
                json.put("currentBizType",currentBizType);
                callFlutter(mContext,"onOcrFail",json.toJSONString(),false);
            }
        });

    }

    /**
     * 活体检测+认证
     * @param mContext
     * @param partnerOrderId
     * @param signTime
     * @param sign
     */
    public static void doLivingAuth(Context mContext, String partnerOrderId, String  signTime, String  sign,
                                    String idName,String idNumber,String currentBizType){

        UDhelper.doLivingAuth(mContext, partnerOrderId, signTime, sign, idName,idNumber,new LivingAuthCallback() {
            @Override
            public void onLivingAuthSuccess(String living_photo) {
                JSONObject json = new JSONObject();
                json.put("living_photo",living_photo);
                json.put("currentBizType",currentBizType);
                callFlutter(mContext,"onLivingAuthSuccess",json.toJSONString(),true);
            }

            @Override
            public void onLivingAuthFail(String message,String living_photo) {
                JSONObject json = new JSONObject();
                json.put("message",message);
                json.put("currentBizType",currentBizType);
                json.put("living_photo",living_photo);
                // living_photo 是活体成功，但是实名认证失败场景，返回错误码-101
                json.put("errorCode", StringUtil.isNullOrEmpty(living_photo)?"":"-101");
                callFlutter(mContext,"onLivingAuthFail",json.toJSONString(),false);
            }
        });

    }

    private static void callFlutter(Context mContext, String methodName,String jsonData,boolean success){
        Intent intent = new Intent("ACTION_INVOKE_FLUTTER");
        intent.putExtra("methodName",methodName);
        intent.putExtra("jsonData",jsonData);
        intent.putExtra("success",success);
        mContext.sendBroadcast(intent);
    }

}

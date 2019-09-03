package com.zjex.equity.ud;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.authreal.api.AuthBuilder;
import com.authreal.api.FormatException;
import com.authreal.api.OnResultCallListener;
import com.authreal.component.AuthComponentFactory;
import com.authreal.component.CompareItemFactory;
import com.authreal.component.CompareItemSession;
import com.zjex.equity.util.Md5;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

/**
 * 有盾工具类
 * Created by theone on 2019/6/19.
 */
public class UDhelper {
    private static final String pubKey="377753b2-440d-444a-b61c-1966ce7d1af1";

    private static String id_name,id_number,idcard_back_photo,idcard_front_photo,living_photo;

//    /**
//     *
//     * 实人认证 全流程
//     * @param mContext
//     * @param partnerOrderId
//     * @param timestap
//     * @param sign
//     * @param callback
//     */
//    public static void doFullAuth(final Context mContext, String partnerOrderId, String timestap, String sign, final FullAuthCallback callback){
//        id_name="";
//        id_number="";
//        idcard_back_photo="";
//        idcard_front_photo="";
//        living_photo="";
//
//        AuthBuilder authBuilder = new AuthBuilder(partnerOrderId, pubKey, timestap, sign, new OnResultCallListener() {
//            @Override
//            public void onResultCall(int op_type, String result, JSONObject json) {
//                try{
//                    if(json.has("success") && json.getBoolean("success")){
//                        switch (op_type) {
//                            case AuthBuilder.OPTION_ERROR:
//                                callback.onFullAuthFail(getMessageFromJson(json,"实人认证出错"));
//                                break;
//                            case AuthBuilder.OPTION_OCR:
//                                //// TODO:  OCR扫描 回调
//                                id_name=json.getString("id_name");
//                                id_number=json.getString("id_number");
//                                idcard_back_photo=json.getString("idcard_back_photo");
//                                idcard_front_photo=json.getString("idcard_front_photo");
//                                break;
//                            case AuthBuilder.OPTION_LIVENESS:
//                                //// TODO:  活体 回调
//                                living_photo=json.getString("living_photo");
//                                break;
//                            case AuthBuilder.OPTION_VERIFY_COMPARE:
//                                //// TODO:  人像比对 回调
//                                Log.d("equity",id_name+"========="+id_number+"========="+idcard_back_photo+"========="+idcard_front_photo+"========="+living_photo);
//                                if(json.has("suggest_result") && "T".equals(json.getString("suggest_result"))){
//                                    callback.onFullAuthSuccess(id_name,id_number,idcard_back_photo,idcard_front_photo,living_photo);
//                                }else{
//                                    callback.onFullAuthFail("实人认证不通过");
//                                }
//                                break;
//                        }
//
//                    }else{
//                        String message = json.getString("message");
//                        String errorcode = json.getString("errorcode");
//                        if(!"900001".equals(errorcode)){
//                            callback.onFullAuthFail(message);
//                        }else{
//                            callback.onFullAuthFail("");
//                        }
//                    }
//                }catch (Exception e){
//                    Log.e("equity","实人认证出错",e);
//                    callback.onFullAuthFail("实人认证异常["+e.getMessage()+"]");
//                }
//            }
//        });
//
//        authBuilder
//                .addFollow(AuthComponentFactory.getOcrComponent()
//                        /**设置展示确认页面 ： 非必需 */
//                        .showConfirm(true)
//                        .isOpenVibrate(true)
//                )
//                .addFollow(AuthComponentFactory.getLivingComponent())
//                .addFollow(AuthComponentFactory.getVerifyCompareComponent()
//                    //此示例对比项B为活体过程中截图,
//                    .setCompareItem(CompareItemFactory.getCompareItemBySessionId(CompareItemSession.SessionType.PHOTO_LIVING))
//                )
//                .start(mContext);
//    }

    private static String getMessageFromJson(JSONObject json,String defaultMsg){
        if(json==null || !json.has("message")){
            return defaultMsg;
        }

        try {
            return json.getString("message");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return defaultMsg;
    }


    /**
     * 活体检测
     * @param mContext
     * @param partnerOrderId
     * @param timestap
     * @param sign
     * @param callback
     */
    public static void doLiving(final Context mContext, String partnerOrderId, String timestap, String sign, final LivingnessCallback callback){
        AuthBuilder authBuilder = new AuthBuilder(partnerOrderId, pubKey, timestap, sign, new OnResultCallListener() {
            @Override
            public void onResultCall(int op_type, String result, JSONObject json) {
                try{
                    if(json.has("success") && json.getBoolean("success")){
                        switch (op_type) {
                            case AuthBuilder.OPTION_ERROR:
                                Log.d("equity", "=====OPTION_ERROR========" + json);
                                callback.onLivingFail(getMessageFromJson(json,"人脸识别出错"));
                                break;
                            case AuthBuilder.OPTION_LIVENESS:
                                //// TODO:  活体 回调
                                String risk_tag = json.getString("risk_tag");
                                if("1".equals(risk_tag)){
                                    callback.onLivingFail("活体检测存在作弊风险");
                                }else{
                                    callback.onLivingSuccess(json.getString("living_photo"));
                                }

                                break;
                        }

                    }else{
                        String message = json.getString("message");
                        String errorcode = json.getString("errorcode");
                        Log.d("equity",message+"=========errorcode========="+errorcode);
                        if(!"900001".equals(errorcode)){
                            callback.onLivingFail(message);
                        }else{
                            callback.onLivingFail("");
                        }
                    }
                }catch (Exception e){
                    Log.e("equity","人脸识别异常",e);
                    callback.onLivingFail("人脸识别异常");
                }
            }
        });

        authBuilder.addFollow(AuthComponentFactory.getLivingComponent()).start(mContext);
    }

    /**
     *
     * 身份证ocr
     * @param mContext
     * @param partnerOrderId
     * @param timestap
     * @param sign
     * @param callback
     */
    public static void doIDcardOcr(final Context mContext, String partnerOrderId, String timestap, String sign, final IDCardOcrCallback callback){
        AuthBuilder authBuilder = new AuthBuilder(partnerOrderId, pubKey, timestap, sign, new OnResultCallListener() {
            @Override
            public void onResultCall(int op_type, String result, JSONObject json) {
                try{
                    if(json.has("success") && json.getBoolean("success")){
                        switch (op_type) {
                            case AuthBuilder.OPTION_ERROR:
                                Log.d("equity", "=====OPTION_ERROR========" + json);
                                callback.onOcrFail(getMessageFromJson(json,"操作出错"));
                                break;
                            case AuthBuilder.OPTION_OCR:
                                //// TODO:  活体 回调
                                callback.onOcrSuccess(json.getString("id_name"),json.getString("id_number"),json.getString("idcard_back_photo"),json.getString("idcard_front_photo"));
                                break;
                        }

                    }else{
                        String message = json.getString("message");
                        String errorcode = json.getString("errorcode");
                        Log.d("equity",message+"=========errorcode========="+errorcode);
                        if(!"900001".equals(errorcode)){
                            callback.onOcrFail(message);
                        }else{
                            callback.onOcrFail("");
                        }
                    }
                }catch (Exception e){
                    Log.e("equity","操作出错",e);
                    callback.onOcrFail("操作出错");
                }
            }
        });

        authBuilder.addFollow(AuthComponentFactory.getOcrComponent()
                        /**设置展示确认页面 ： 非必需 */
                        .showConfirm(true)
                        .isOpenVibrate(true)
                ).start(mContext);

    }


    public static void doLivingAuth(final Context mContext, String partnerOrderId, String timestap, String sign,
                                       String idName,String idNumber, final LivingAuthCallback callback){
        living_photo="";

        AuthBuilder authBuilder = new AuthBuilder(partnerOrderId, pubKey, timestap, sign, new OnResultCallListener() {
            @Override
            public void onResultCall(int op_type, String result, JSONObject json) {
                try{
                    if(json.has("success") && json.getBoolean("success")){
                        switch (op_type) {
                            case AuthBuilder.OPTION_ERROR:
                                callback.onLivingAuthFail(getMessageFromJson(json,"实人认证出错"),"");
                                break;
                            case AuthBuilder.OPTION_LIVENESS:
                                //// TODO:  活体 回调
                                String risk_tag = json.getString("risk_tag");
                                if("1".equals(risk_tag)){
                                    living_photo="risk";
                                }else{
                                    living_photo=json.getString("living_photo");
                                }
                                break;
                            case AuthBuilder.OPTION_VERIFY_COMPARE:
                                //// TODO:  人像比对 回调
                                Log.d("equity",id_name+"========="+id_number+"========="+idcard_back_photo+"========="+idcard_front_photo+"========="+living_photo);
                                if("risk".equals(living_photo)){
                                    callback.onLivingAuthFail("活体检测存在作弊风险","");
                                    break;
                                }
                                if( json.has("suggest_result") && "T".equals(json.getString("suggest_result"))){
                                    callback.onLivingAuthSuccess(living_photo);
                                }else{
                                    callback.onLivingAuthFail("实人认证不通过",living_photo);
                                }
                                break;
                        }

                    }else{
                        String message = json.getString("message");
                        String errorcode = json.getString("errorcode");
                        if(!"900001".equals(errorcode)){
                            callback.onLivingAuthFail(message,"");
                        }else{
                            callback.onLivingAuthFail("","");
                        }
                    }
                }catch (Exception e){
                    Log.e("equity","实人认证出错",e);
                    callback.onLivingAuthFail("实人认证异常["+e.getMessage()+"]","");
                }
            }
        });

        try {
            authBuilder
                    .addFollow(AuthComponentFactory.getLivingComponent())
                    .addFollow(AuthComponentFactory.getVerifyCompareComponent().setNameAndNumber(idName,idNumber)
                            //此示例对比项B为活体过程中截图,
                            .setCompareItem(CompareItemFactory.getCompareItemBySessionId(CompareItemSession.SessionType.PHOTO_LIVING))
                    ).start(mContext);
        } catch (FormatException e) {
            e.printStackTrace();
        }
    }



}

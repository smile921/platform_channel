package com.zjex.equity;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.alibaba.fastjson.JSONObject;
import com.zjex.equity.ud.FullAuthCallback;
import com.zjex.equity.ud.UDProcessor;
import com.zjex.equity.ud.UDhelper;
import com.zjex.equity.util.Des;
import com.zjex.equity.util.StringUtil;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.JSONMessageCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
public class MainActivity extends FlutterActivity {
    private static String CHANNEL_FACE_ALL="com.zjex.equity/faceAll";
    private static String CHANNEL_FACE_EVT="com.zjex.equity/faceEvt";
    private static final String EMPTY_MESSAGE = "";
    private static final String PING = "ping";
    private static final String CHANNEL = "com.zjex.equity.json/face";
    private Context mContext;

    private BasicMessageChannel<String> messageChannel;




    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = MainActivity.this;
        GeneratedPluginRegistrant.registerWith(this);

        messageChannel = new BasicMessageChannel(getFlutterView(), CHANNEL, JSONMessageCodec.INSTANCE);
        messageChannel.
                setMessageHandler(new BasicMessageChannel.MessageHandler<String>() {
                    @Override
                    public void onMessage(String json, BasicMessageChannel.Reply<String> reply) {
                        Log.d(" [JSONMessageCodec] "," json = "+json);
                        doFaceAuthJson();
                        reply.reply(EMPTY_MESSAGE);
                    }
                });


        new EventChannel(getFlutterView(), CHANNEL_FACE_EVT).setStreamHandler(
                new StreamHandler() {
                    private BroadcastReceiver msgReceiver;

                    @Override
                    public void onListen(Object arguments, EventSink events) {
                        msgReceiver = createMsgReceiver(events);
                        IntentFilter intentFilter = new IntentFilter();
                        intentFilter.addAction("ACTION_INVOKE_FLUTTER");
                        registerReceiver(msgReceiver, intentFilter);
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        unregisterReceiver(msgReceiver);
                        msgReceiver = null;
                    }
                }
        );

        new MethodChannel(getFlutterView(), CHANNEL_FACE_ALL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
//                        if (call.method.equals("doFullAuth")) {
//                            final String orderId = call.argument("orderId");
//                            final String signTime = call.argument("signTime");
//                            final String sign = call.argument("sign");
//                            final String currentBizType = call.argument("currentBizType");
//                            UDProcessor.doFullAuth(mContext,orderId,signTime,sign,currentBizType);
//                            result.success("success");
//                        }else
                        if (call.method.equals("doLivingness")) {
                            final String orderId = call.argument("orderId");
                            final String signTime = call.argument("signTime");
                            final String sign = call.argument("sign");
                            final String currentBizType = call.argument("currentBizType");
                            UDProcessor.doLivingness(mContext,orderId,signTime,sign,currentBizType);
                            result.success("success");
                        }else if (call.method.equals("doIDcardOcr")) {
                            final String orderId = call.argument("orderId");
                            final String signTime = call.argument("signTime");
                            final String sign = call.argument("sign");
                            final String currentBizType = call.argument("currentBizType");
                            UDProcessor.doIDcardOcr(mContext,orderId,signTime,sign,currentBizType);
                            result.success("success");
                        }else if (call.method.equals("doLivingAuth")) {
                            final String orderId = call.argument("orderId");
                            final String signTime = call.argument("signTime");
                            final String sign = call.argument("sign");
                            final String idName = call.argument("idName");
                            final String idNumber = call.argument("idNumber");
                            final String currentBizType = call.argument("currentBizType");
                            UDProcessor.doLivingAuth(mContext,orderId,signTime,sign,idName,idNumber,currentBizType);
                            result.success("success");
                        }  else if(call.method.equals("doEncrypt")){
                            String username = call.argument("username");
                            String password = call.argument("password");
                            String strEnc = Des.strEnc(password,username);
                            result.success(strEnc);
                        }  else {
                            result.notImplemented();
                        }

                    }
                }
        );
    }


    private void doFaceAuthJson(){
        // TODO business logic here
        messageChannel.send("{\"custId\":\"637832\",\"orderId\":\"ooooooooooo\"}");
    }


    private BroadcastReceiver createMsgReceiver(final EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String methodName = intent.getStringExtra("methodName");
                String jsonData = intent.getStringExtra("jsonData");
                boolean success = intent.getBooleanExtra("success",false);
                JSONObject json = new JSONObject();
                JSONObject jsonDataObj = JSONObject.parseObject(jsonData);
                json.put("methodName",methodName);
                json.put("data",jsonDataObj);
                Log.d("equity","调用flutter函数，传递参数json="+json);
                if(success){
                    events.success(json.toJSONString());
                }else{
                    String errorCode = jsonDataObj.getString("errorCode"); 
                    if(StringUtil.isNullOrEmpty(errorCode)){
                        errorCode = "-100"; // 默认-100
                    }
                    // Log.d("errorCode","=======================  errorCode="+errorCode);
                    events.error(errorCode,json.getString("message"),json.toJSONString());
                }
            }
        };
    }

}
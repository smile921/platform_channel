package com.zjex.equity.ud;

/**
 * Created by theone on 2019/6/20.
 */
public interface FullAuthCallback {

    public void onFullAuthSuccess(String id_name, String id_number,
                                  String idcard_back_photo, String idcard_front_photo, String living_photo);

    public void onFullAuthFail(String message);



}

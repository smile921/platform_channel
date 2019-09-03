package com.zjex.equity.ud;

/**
 * Created by theone on 2019/7/5.
 */
public interface LivingAuthCallback {
    public void onLivingAuthSuccess(String living_photo);
    public void onLivingAuthFail(String message,String living_photo);
}

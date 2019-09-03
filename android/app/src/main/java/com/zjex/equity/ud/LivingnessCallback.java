package com.zjex.equity.ud;

/**
 * Created by theone on 2019/7/5.
 */
public interface LivingnessCallback {
    public void onLivingSuccess(String living_photo);
    public void onLivingFail(String message);
}

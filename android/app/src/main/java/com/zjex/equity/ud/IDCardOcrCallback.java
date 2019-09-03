package com.zjex.equity.ud;

/**
 * Created by theone on 2019/7/5.
 */
public interface IDCardOcrCallback {
    public void onOcrSuccess(String id_name, String id_number,
                             String idcard_back_photo, String idcard_front_photo);
    public void onOcrFail(String message);
}

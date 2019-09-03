package com.zjex.equity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.WindowManager;
import android.widget.RelativeLayout;

import androidx.annotation.Nullable;

/**
 * Created by theone on 2019/8/27.
 */
public class InitActivity extends Activity {

    private RelativeLayout layout_top;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFormat(PixelFormat.TRANSLUCENT);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.init_activity);
        layout_top =findViewById(R.id.layout_top);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                layout_top.setVisibility(View.VISIBLE);

                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        Intent intent = new Intent(InitActivity.this,MainActivity.class);
                        startActivity(intent);
                        finish();
                    }
                },2000);

            }
        },1000);






    }
}

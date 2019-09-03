package com.zjex.equity.util;

import android.util.Base64;

import java.io.File;
import java.io.FileInputStream;
import java.security.MessageDigest;

/**
 * Created by Administrator on 2018/5/15.
 */

public class Md5 {

    public static String encrypt(String str) {
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("MD5");
            messageDigest.reset();
            messageDigest.update(str.getBytes("UTF-8"));
            return Code.hex_encode(messageDigest.digest());
        } catch (Exception e) {
            return "";
        }
    }

    public static String encryptFile(File file) {
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("MD5");
            messageDigest.reset();
            FileInputStream in = new FileInputStream(file);
            byte[] buffer = new byte[1024];
            while (true) {
                int read = in.read(buffer);
                if (read < 1) {
                    in.close();
                    return Code.hex_encode(messageDigest.digest());
                }
                messageDigest.update(buffer, 0, read);
            }
        } catch (Exception e) {
            return "";
        }
    }

    public static class Code {
        public static String hex_encode(byte[] bytes) {
            char[] hex = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
            StringBuilder builder = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) {
                builder.append(hex[(b >> 4) & 15]);
                builder.append(hex[b & 15]);
            }
            return builder.toString();
        }

        public static byte[] hex_decode(String str) {
            byte[] result = new byte[(str.length() / 2)];
            for (int i = 0; i < result.length; i++) {
                result[i] = Integer.valueOf(str.substring(i * 2, (i * 2) + 2), 16).byteValue();
            }
            return result;
        }

        public static String base64_encode(byte[] bytes) {
            return Base64.encodeToString(bytes, 0);
        }

        public static byte[] base64_decode(String str) {
            return Base64.decode(str, 0);
        }
    }
}

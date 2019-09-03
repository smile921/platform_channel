/**
 *
 * @(#) StringUtil.java
 * @Package com.zjex.util
 *
 */

package com.zjex.equity.util;

import android.graphics.Color;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.ForegroundColorSpan;
import android.widget.TextView;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *  类描述：字符串工具类
 * 
 *  @author:  theone
 *
 *  History:  2015-7-23 下午8:29:10   theone   Created.
 *           
 */
public class StringUtil {
	
	/**
	 * 方法说明：判断是否为空
	 *
	 * Author：        theone                
	 * Create Date：   2015-7-23 下午8:30:18
	 * History:  2015-7-23 下午8:30:18   theone   Created.
	 *
	 * @param str
	 * @return
	 *
	 */
	public static boolean isNullOrEmpty(Object str){
		return str==null || "".equals(str) || "null".equals(str);
	}
	
	/**
	 * 方法说明：数字转字符串，保留两位小数
	 * 如果是整数不带.0
	 *
	 * Author：        theone                
	 * Create Date：   2015-7-23 下午8:44:21
	 * History:  2015-7-23 下午8:44:21   theone   Created.
	 *
	 * @param num
	 * @return
	 *
	 */
	public static String formatNumber(double num){
		BigDecimal b =new BigDecimal(num);  
		double value=b.setScale(2,   BigDecimal.ROUND_HALF_UP).doubleValue(); 
//		String ret=(value+"").replace(".0", "");
		String ret=value+"";
		return ret;
	}
	
	/**
	 * 方法说明：字符串编码，防止中文乱码
	 *
	 * Author：        theone                
	 * Create Date：   2015-7-30 下午3:44:18
	 * History:  2015-7-30 下午3:44:18   theone   Created.
	 *
	 * @param str
	 * @return
	 *
	 */
	public static String endcodeString(String str){
		String ret="";
		try{
			ret = URLEncoder.encode(str, "utf-8");
		}catch(Exception ex){
			return str;
		}
		return ret;
	}

	//设置部分字体颜色
	public static void changePartStringColor(TextView tv,String text,int start, int end){
		SpannableStringBuilder style=new SpannableStringBuilder(text);
		style.setSpan(new ForegroundColorSpan(Color.RED),start,end, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
		//设置指定位置文字的颜色
		tv.setText(style);
	}

	public static void changePartStringColor(TextView tv,String text,int color,int start, int end){
		SpannableStringBuilder style=new SpannableStringBuilder(text);
		style.setSpan(new ForegroundColorSpan(color),start,end, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
		//设置指定位置文字的颜色
		tv.setText(style);
	}

	public static boolean isValideURL(String url){
		return url.startsWith("http://") || url.startsWith("https://") ? true : false;
	}

	//校验邮箱格式
	public static boolean judgeEmail(String email){
		Pattern pattern = Pattern.compile("^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1," +
				"3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$");
		Matcher matcher = pattern.matcher(email);

		if (matcher.matches()) {
			return true;
		}else{
			return false;
		}
	}

	private static boolean isMatch(String str,String regx){
		Pattern pattern = Pattern.compile(regx);
		Matcher matcher = pattern.matcher(str);
		return matcher.find();
	}

	public static boolean judgePhoneNumber(String phone){
		String regex1 = "^[\\w\\W]{6,16}$";
		String regex2 = "(\\d+)";
		String regex3 = "([a-zA-Z]+)";
		String regex4 = "([\\s]+)";

		boolean b1 = isMatch(phone,regex1);
		boolean b2 = isMatch(phone,regex2);
		boolean b3 = isMatch(phone,regex3);
		boolean b4 = isMatch(phone,regex4);

		if (b1 && b2 && b3 && !b4 ) {
			return true;
		}else{
			return false;
		}
	}

	//手势密码加密
	public static String encode(String str){
		try
        {
          	byte[] _ssoToken = str.getBytes("ISO-8859-1");
          	String name = new String();
         	// char[] _ssoToken = ssoToken.toCharArray();
          	for (int i = 0; i < _ssoToken.length; i++) {
              	int asc = _ssoToken[i];
              	_ssoToken[i] = (byte) (asc + 27);
              	name = name + (asc + 27) + "%";
          	}
          	return name;
        }catch(Exception e) {
          	e.printStackTrace() ;
          	return null;
        }
	}
	//手势密码解密
	public static String decode(String str){
		try
        {
			String name = new String();
			StringTokenizer st=new StringTokenizer(str,"%");
            while (st.hasMoreElements()) {
				int asc =  Integer.parseInt((String)st.nextElement()) - 27;
            	name = name + (char)asc;
          	}
			return name;
        }catch(Exception e) {
          	e.printStackTrace() ;
          	return null;
        }
	}
}

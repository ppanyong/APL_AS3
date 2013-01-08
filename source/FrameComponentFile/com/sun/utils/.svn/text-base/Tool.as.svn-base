package com.sun.utils{
	public class Tool {
		//参数：0||undefined>>按视频比例调整
		//      1>>铺满窗口
		//      2>>原始大小
		//      3>>以16:9播放
		//      4>>以4:3播放
		public static function getViewSize(view_w:uint,view_h:uint,flvw:uint,flvh:uint,type:int):Object {
			var tg_w:Number;
			var tg_h:Number;
			var w:Number = flvw;
			var h:Number = flvh;

			var r1:Number;
			var r2:Number = view_w/view_h;
			switch (type) {
				case 0 :
					r1 = w/h;
					break;
				case 1 :
					tg_w = view_w;
					tg_h = view_h;
					break;
				case 2 :
					tg_w = w;
					tg_h = h;
					break;
				case 3 :
					r1 = 16/9;
					break;
				case 4 :
					r1 = 4/3;
					break;
			}
			if (type==1||type==2) {
				return {width:tg_w,height:tg_h};
			}
			if (r1>r2) {
				tg_w = view_w;
				tg_h = view_w/r1;
			} else {
				tg_h = view_h;
				tg_w = view_h*r1;
			}
			return {width:tg_w,height:tg_h};
		}
		//格式化时间,t单位：ms
		//返回00:00或者00:00:00格式的时间
		public static function timeFormat(t:uint = 0,type:String = "00:00:00"):String {
			var m:uint = Math.floor(t/(60*1000));
			var s:uint = Math.round((t - m*60*1000)/1000);
			if(s==60){
				s = 0;
				m+=1;
			}
			if(type=="00:00"){
				return ((m<10) ? "0"+String(m)+":" : String(m)+":")+((s<10) ? "0"+String(s) : String(s));
			}
			var h:uint = Math.floor(m/60);
			m=m-h*60;
			if(m==60){
				m=0;
				h+=1;
			}
			return ((h<10) ? "0"+String(h)+":" : String(h)+":")+((m<10) ? "0"+String(m)+":" : String(m)+":")+((s<10) ? "0"+String(s) : String(s));
		}
		//从URL中提取HOST
		public static function getHostFromURL(url:String):String
		{
			//http://v.video.qq.com/80525776/5uDlVpRa0ux.flv
			return url.split("/")[2];
		}
		//简单的获取单字节的Hex码
		public static function getStrUnicode(orgStr:String):String
		{
			var str:String = "";
			var len:uint = orgStr.length;
			for(var i:uint = 0;i<len;i++){
				var ddd:String = orgStr.charCodeAt(i).toString(16);
				str+=ddd;
			}
			return str.toUpperCase();
		} 
	}
}
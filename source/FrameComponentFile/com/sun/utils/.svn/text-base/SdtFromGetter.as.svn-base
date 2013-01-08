package com.sun.utils
{
	/*
	sdtfrom=v0 其他(找得到，但不在v3中)
	sdtfrom=v1 QQLive点播
	sdtfrom=v2 QQVideo

	sdtfrom=v3  网站部 
	comic.qq.com|games.qq.com|www.qq.com|news.qq.com|view.qq.com|sports.qq.com|2008.qq.com|ent.qq.com|yue.qq.co

	m|finance.qq.com|auto.qq.com|tech.qq.com|games.qq.com|comic.qq.com|edu.qq.com|cam

	pus.qq.com|book.qq.com|lady.qq.com|luxury.qq.com|kid.qq.com|baby.qq.com|gongyi.qq

	.com|house.qq.com|bbs.qq.com|blog.qq.com|mil.qq.com|cf.qq.com|x5.qq.com 

	qqhx.qq.com|nana.qq.com|speed.qq.com

	sdtfrom=v4 外部转贴

	sdtfrom=v5 qzone业务  qzone.qq.com
	sdtfrom=v6 QBar    qbar.qq.com
	sdtfrom=v7 paipai  paipai.com
	sdtfrom=v8 soso    soso.com
	sdtfrom=v9 mail    mail.qq.com
	*/
	public class SdtFromGetter
	{
		//网站不的域名
		private static var netStr:String = "comic.qq.com|games.qq.com|www.qq.com|news.qq.com|view.qq.com|sports.qq.com|2008.qq.com|ent.qq.com|yue.qq.com|finance.qq.com|auto.qq.com|tech.qq.com|games.qq.com|comic.qq.com|edu.qq.com|campus.qq.com|book.qq.com|lady.qq.com|luxury.qq.com|kid.qq.com|baby.qq.com|gongyi.qq.com|house.qq.com|bbs.qq.com|blog.qq.com|mil.qq.com|cf.qq.com|x5.qq.com|qqhx.qq.com|nana.qq.com|speed.qq.com";
		
		public static function getSdtFrom(host:String = "null"):String
		{
			if(host=="null"||host=="undefined"){
				return "v4";
			}
			//video.qq.com|v.qq.com|video_1.qq.com
			if(host.indexOf("video.qq.com")>-1||host.indexOf("v.qq.com")>-1||host.indexOf("video_1.qq.com")>-1){
				return "v2";
			}
			if(host.indexOf("qzone")>-1&&host.indexOf("qq.com")>-1){
				return "v5";
			}
			if(host.indexOf("qbar.qq.com")>-1){
				return "v6";
			}
			if(host.indexOf("paipai.com")>-1){
				return "v7";
			}
			if(host.indexOf("soso.com")>-1){
				return "v8";
			}
			if(host.indexOf("mail.qq.com")>-1){
				return "v9";
			}
			if(isNet(host)){
				return "v3";
			}
			
			return "v0";
		}
		private static function isNet(host:String):Boolean
		{
			var net_a:Array = netStr.split("|");
			var len:uint = net_a.length;
			for(var i:uint = 0;i<len;i++){
				if(host.indexOf(net_a[i])>-1){
					return true;
				}
			}
			return false;
		}
	}
}
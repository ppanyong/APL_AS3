package com.andy.utility {
	import flash.external.ExternalInterface;	
	
	/**
	 * 与浏览器地址栏相关操作
	 * @author andypan
	 */
	public class WebURL {
		/**
		 * 获得swf所在页面的地址栏中的？后的参数
		 * @param valuename 参数名
		 */
		public static function GetParams(valuename:String):String{
			 if (ExternalInterface.available)
			    {
			        try
			        {
			        	//var url = document.location.href;
			        	var url:String = ExternalInterface.call("eval","document.location.href");
			        	//trace("GetParams="+url);
			        	//ExternalInterface.call("alert",url)
			        	var arrStr = url.substring(url.indexOf("?")+1).split("&");
						//return arrStr;
						for(var i:Number =0;i<arrStr.length;i++)
						{
							   var loc = arrStr[i].indexOf(valuename+"=");
							   if(loc!=-1)
							   {
								return arrStr[i].replace(valuename+"=","").replace("?","");
								break;
							   }
						}
			        }catch(e){
			        }	
				}
				return null;
		}
		/**
		 * 获得swf所在页面的地址栏中的#后的参数
		 * @param valuename 参数名
		 */
		public static function GetHash(valuename:String):String{
			 if (ExternalInterface.available)
			    {
			        try
			        {
			        	//var url = document.location.hash;
			        	var url:String = ExternalInterface.call("eval","document.location.hash");
			        	//trace("GetParams="+url);
			        	//var arrStr = url.substring(url.indexOf("#")+1).split("&");
			        	var arrStr = url.substring(url.indexOf("#")+1).split("&");
						//return arrStr;
						for(var i:Number =0;i<arrStr.length;i++)
						{
							   var loc = arrStr[i].indexOf(valuename+"=");
							   if(loc!=-1)
							   {
								return arrStr[i].replace(valuename+"=","").replace("#","");
								break;
							   }
						}
			        }catch(e){
			        }	
				}
				return null;
		}
	}
		
}

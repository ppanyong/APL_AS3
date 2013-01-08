package com.andy.utility {
	import flash.external.ExternalInterface;	
	
	/**
	 * @author andypan
	 */
	public class Cookie {
		/**
		 * 返回指定昵称的Cookie值
		 */
		static public function getCookie(name:String){
			if (ExternalInterface.available)
			    {
			        try
			        {
			        	 var cookie:String = ExternalInterface.call("eval","document.cookie");
			        	 //ExternalInterface.call("alert",cookie)
			        	 var aCookie:Array = cookie.split("; ");
			        	
			        	 for (var i=0; i < aCookie.length; i++)
					    {
					    // a name/value pair (a crumb) is separated by an equal sign
					    var aCrumb = aCookie[i].split("=");
					    //ExternalInterface.call("alert",aCrumb)
					    if (name == aCrumb[0]){
					    	
						    return decodeURI(aCrumb[1]);}
					    }
					    // a cookie with the requested name does not exist
					    return null;
			        	}catch(e){
			        		trace("Warnning:需要在浏览器中使用 写Cookie功能")
			        }	
				}
				return null;
		}
		static public function  setCookie(name:String,value:String,expiresday:Number=0){

            var LargeExpDate:Date = new Date (); 
            LargeExpDate.setTime(LargeExpDate.getTime() + (expiresday*1000*3600*24));         

	        var c = name + "=" + escape (value)+((expiresday == 0) ? "" : ("; expires=" +LargeExpDate.toUTCString()))+";path=/"; 
	        if (ExternalInterface.available)
			    {
			        try
			        {
			        	ExternalInterface.call("eval","document.cookie="+c);
			        	}catch(e){
			        	trace("Warnning:需要在浏览器中使用 写Cookie功能");
			        }	
				}
	        
		}
		static public function delCookie(name:String){
			        var expdate:Date = new Date(); 
					expdate.setTime(expdate.getTime() - (86400 * 1000 * 1));  
					Cookie.setCookie(name, "", 0);
		}
	}
}

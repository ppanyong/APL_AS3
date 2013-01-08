package com.sun.utils {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;

	import com.sun.events.VidUrlEvent;

	/**
	 * @author jiajialiu
	 */
	public class VidUrl extends EventDispatcher {

		private var _url_lnk : String;
		private var _vid : String = "";
		private var _lnk : String = "";
		//访问这个获取比较快的服务器地址，同时写进shareobject 
		private var hostcgi : String = "http://video.qq.com/bin/loc?s=video";
		//cdn视频路径查询
		private var pubs : String = "http://video.qq.com/v1/vstatus/pubstat?vid=";

		private var myXML : XML = new XML();
		private var vt : Number;
		var myLoader : URLLoader ;	
		var myLoader2 : URLLoader;

		public function VidUrl() {
		}

		public function getURL(vid : String, f:String) : void {
			_vid = vid;
			_lnk = vid;
			var XML_URL : String = pubs + vid + "&f="+f+"ran="+Math.random();
			var myXMLURL : URLRequest = new URLRequest(XML_URL);
			if(myLoader!=null){
				try{
					myLoader.close();
				}catch(e:Error){
					trace(e);
				}
				myLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
				myLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				myLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioHandler);
			}else{
				myLoader = new URLLoader();
			}
			
			myLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, ioHandler);
			try{
				ExternalInterface.call("console.info","getURL::开始加载XML数据:"+XML_URL);
			}catch(e:Error){
				trace(e);
			}
			try{
				myLoader.load(myXMLURL);
			}catch(e:Error){
				trace(e);
			}
		}
		//不通过CGI,直接根据vid和vt获取路径
		//ft和ext和奥运有关,ft：视频类型,0普通视频;1加密视频;2FMS视频列；
		//					ext:视频扩展名"flv"或者"mp4"
		public function getURLByVType(vid:String,vt:uint,ft:uint = 0,ext:String="flv"):String
		{
			return getURLByVidAndVType(vid,vt,ft,ext);
		}
		//
		public function get vtype():uint
		{
			return vt;
		}
		
		private function xmlLoaded(e : Event) : void {
			try{
				myXML = XML(e.target.data);
			}catch(e:Error){
				trace("xml 创建失败");
				//myXML.s = "o";
			}
			myXML.ignoreWhitespace = true;
			try{
				ExternalInterface.call("console.info","xmlData:"+myXML.toString());
			}catch(e:Error){
				trace(e);
			}
			if(myXML.s == undefined) {
				genVdUrl2();
			} else {
				if (myXML.s == "o" ) {
					vt = Number(myXML.vt);
					_lnk = myXML.lnk;
					genVdUrl(_lnk);
				}else {
					genVdUrl2();
				}
			}
		}

		private function xmlLoadedhttps(e : HTTPStatusEvent) : void {
			try{
				ExternalInterface.call("console.info","xmlLoadedhttps:"+e.status);
			}catch(e:Error){
				trace(e);
			}
			if (e.status > 400 || e.status == 0) {
				genVdUrl2();
			}
		}
		private function securityErrorHandler(e : SecurityErrorEvent) : void {
			try{
				ExternalInterface.call("console.info","SecurityErrorEvent");
			}catch(e:Error){
				trace(e);
			}
			genVdUrl2();
		}
		private function ioHandler(e : IOErrorEvent) : void {
			try{
				ExternalInterface.call("console.info","ioHandler");
			}catch(e:Error){
				trace(e);
			}
			genVdUrl2();
		}

		private function genVdUrl(vid : String) : void {
			_url_lnk = getURLByVidAndVType(vid,vt);

			var urlEvent : VidUrlEvent = new VidUrlEvent();
			urlEvent.URL_LNK = _url_lnk;
			urlEvent.VID = _vid;
			urlEvent.CDN = true;
			dispatchEvent(urlEvent);				
		}
		
		private function getStreamName(vid:String,ft:uint = 0,ext:String="flv"):String
		{
			var n:String = "";
			switch(ft){
				case 0:
					n = "video/"+vid+"."+ext;
					break;
				case 1:
					n = "videodrm/"+vid+"_tdrm."+ext;
					break;
				case 2:
					n = "video/"+vid+"."+ext;
					break;
			}
			return n;
		}
		
		private function getURLByVidAndVType(vid:String,vt:uint,ft:uint = 0,ext:String="flv"):String
		{
			var url : String;
			var ss_server:String;
			/*
			//CDN
			1 - vkp.video.qq.com 
			2 - vhot.video.qq.com 
			4 - vhot1.video.qq.com 
			5 - vhot2.video.qq.com 
			11 - vcm1.video.qq.com 
			12 - vcm2.video.qq.com 
			13 - vcm3.video.qq.com 
			14 - vcm3.video.qq.com 
			15 - vcm4.video.qq.com 
			100 - vhotws.video.qq.com 
			
			
			//公司CDN
			3 - vhot.qqvideo.tc.qq.com 
			200 - vhot2.qqvideo.tc.qq.com 
			201 - vtop.qqvideo.tc.qq.com
			//奥运频道
			20 - vkp2.video.qq.com，vfms1.video.qq.com 
			21 - vkp3.video.qq.com，vfms2.video.qq.com 
			22 - vkp4.video.qq.com，vfms3.video.qq.com 
			*/
			//优先取奥运频道，要分3种流
			if(vt==20){
				ss_server = ft!=2?"http://vkp2.video.qq.com/":"rtmp://vfms1.video.qq.com:80/";
				url = ss_server+getStreamName(vid,ft,ext);
				return url;
			}else if(vt==21){
				ss_server = ft!=2?"http://vkp3.video.qq.com/":"rtmp://vfms2.video.qq.com:80/";
				url = ss_server+getStreamName(vid,ft,ext);
				return url;
			}else if(vt==22){
				ss_server = ft!=2?"http://vkp4.video.qq.com/":"rtmp://vfms3.video.qq.com:80/";
				url = ss_server+getStreamName(vid,ft,ext);
				return url;
			}
			
			var fpath1 : String;
			var dir1 : Number = 256;
			var dir2 : Number = 256;
			var dirnum : Number = dir1 * dir2;

			var svid : String = vid;

			var inx : Number;
			var tot : Number = 0;
			//CDN 视频文件,目录中Hash值的生成算法
			for (inx = 0;inx < svid.length; inx++) {
				var uint_max : Number = 0xffffffff + 1;
			}
			for (inx = 0;inx < svid.length; inx++) {
				var char_num : Number = svid.charCodeAt(inx);
				////trace("index: "+inx+", char_num: "+char_num);
				tot = (tot * 32) + tot + char_num;
				if (tot >= uint_max) {
					tot = tot % uint_max;
				}
			}
			var res : Number = tot % dirnum;
			var dir1_inx : Number = Math.floor(res / dir1);
			var dir2_inx : Number = Math.floor(res % dir2);

			if (vt == 1) {
				fpath1 = "http://vkp.video.qq.com";
			}
			if (vt == 2) {
				fpath1 = "http://vhot.video.qq.com";
			}
			if (vt == 4) {
				fpath1 = "http://vhot1.video.qq.com";
			}
			//新加频道5
			if(vt==5){
				fpath1 = "http://vhot2.video.qq.com";
			}
			if (vt == 11) {
				fpath1 = "http://vcm1.video.qq.com";
			}
			if (vt == 12) {
				fpath1 = "http://vcm2.video.qq.com";
			}
			if (vt == 13) {
				fpath1 = "http://vcm3.video.qq.com";
			}
			if (vt == 14) {
				fpath1 = "http://vcm3.video.qq.com";
			}
			if (vt == 15) {
				fpath1 = "http://vcm4.video.qq.com";
			}
			//新加
			if (vt == 100) {
				fpath1 = "http://vhotws.video.qq.com";
			}
			
			url = fpath1 + "/flv/" + dir1_inx + "/" + dir2_inx + "/" + vid + ".flv";
			//公司自建CDN 视频文件URL生成算法
			if (vt == 3|| vt==200||vt==201) {
				var uin : Number;
				var hash_bucket : Number = 10000 * 10000;
				svid  = vid;
				//var inx : Number;
				tot = 0;
				for (inx = 0;inx < svid.length; inx++) {
					char_num  = svid.charCodeAt(inx);
					trace("index: " + inx + ", char_num: " + char_num);
					tot = (tot * 32) + tot + char_num;
					if (tot >= uint_max) {
						tot = tot % uint_max;
					}
				}
				uin = tot % hash_bucket;
				var temp_host:String = "";
				//vt==3?"http://vhot.qqvideo.tc.qq.com/":"http://vhot2.qqvideo.tc.qq.com/";
				switch(vt){
					case 3:
						temp_host = "http://vhot.qqvideo.tc.qq.com/";
						break;
					case 200:
						temp_host = "http://vhot2.qqvideo.tc.qq.com/";
						break;
					case 201:
						temp_host = "http://vtop.qqvideo.tc.qq.com/";
						break;
				}
				url = temp_host + uin + "/" + vid + ".flv";
			}
			return url;
		}
		
		private function genVdUrl2() : void {		
			//修改：如果不在CDN上，默认就取http://v.video.qq.com/，而不在从SO和访问hostcgi获取
			_url_lnk = "http://v.video.qq.com/" + getUin(_vid) + "/" + _vid + ".flv";
			sendEvent();
			return;
			
			var my_so : SharedObject = SharedObject.getLocal("mediaPlayerIP");
			var time : Date = new Date();
			if (my_so.data.host != undefined && (my_so.data.time.date - time.date < 2 && my_so.data.time.month == time.month)) {
				//trace("get shareobject IP:" + my_so.data.host);
				_url_lnk = "http://" + my_so.data.host + "/" + getUin(_vid) + "/" + _vid + ".flv";
				sendEvent();
			} else {
				var myXMLURL : URLRequest = new URLRequest(hostcgi);
				if(myLoader2!=null){
					try{
						myLoader2.close();
					}catch(e:Error){
						trace(e);
					}
					myLoader2.removeEventListener(Event.COMPLETE, xmlLoaded);
					myLoader2.removeEventListener(HTTPStatusEvent.HTTP_STATUS, xmlLoadedhttps);
					myLoader2.removeEventListener(IOErrorEvent.IO_ERROR, ioHandler);
				}
				myLoader2 = new URLLoader(myXMLURL);
				myLoader2.addEventListener(Event.COMPLETE, hostLoaded);
				myLoader2.addEventListener(HTTPStatusEvent.HTTP_STATUS, xmlLoadedhttps2);
				myLoader2.addEventListener(IOErrorEvent.IO_ERROR, ioHandler2);
			}
		}

		private function hostLoaded(e : Event) : void {
			var arr : Array = new Array();
			//trace("loc  host loaded:" + e.target.data);
			arr = String(e.target.data).split("=");
			if(arr[1].indexOf(".video.qq.com") != -1) {				
				_url_lnk = "http://" + arr[1] + "/" + getUin(_vid) + "/" + _vid + ".flv";
				//trace("playurl====" + _url_lnk);
				//trace("set share object IP:" + arr[1]);
				var mydate : Date = new Date();
				var my_so : SharedObject = SharedObject.getLocal("mediaPlayerIP");
				my_so.clear();
				my_so.data.host = arr[1];
				my_so.data.time = mydate;
				my_so.flush();
			}else {
				_url_lnk = "http://v.video.qq.com/" + getUin(_vid) + "/" + _vid + ".flv";
			}		
			sendEvent();
		}

		private function xmlLoadedhttps2(e : HTTPStatusEvent) : void {
			//trace("hostcgi ----httpstatus:" + e.status);
			if (e.status >= 400) {
				_url_lnk = "http://v.video.qq.com/" + getUin(_vid) + "/" + _vid + ".flv";
				sendEvent();
			}
		}

		private function ioHandler2(e : IOErrorEvent) : void {
			_url_lnk = "http://v.video.qq.com/" + getUin(_vid) + "/" + _vid + ".flv";
			sendEvent();
		}

		private function sendEvent() : void {
			var urlEvent : VidUrlEvent = new VidUrlEvent();
			urlEvent.URL_LNK = _url_lnk;
			urlEvent.VID = _vid;
			dispatchEvent(urlEvent);				
		}

		private function getUin(vid : String) : Number {

			var uint_max : Number = 0x00ffffffff + 1;
			var uin : Number;
			var hash_bucket : Number = 10000 * 10000;
			var svid : String = vid;
			////trace("getpicURL:" + svid);
			var inx : Number;
			var tot : Number = 0;
			for (inx = 0;inx < svid.length; inx++) {
				var char_num : Number = svid.charCodeAt(inx);
				////trace("index: " + inx + ", char_num: " + char_num);
				tot = (tot * 32) + tot + char_num;
				if (tot >= uint_max) {
					tot = tot % uint_max;
				}
			}
			return uin = tot % hash_bucket;
		}
	}
}
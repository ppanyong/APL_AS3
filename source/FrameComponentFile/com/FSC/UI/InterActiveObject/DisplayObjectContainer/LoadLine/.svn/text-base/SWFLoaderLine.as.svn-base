package com.FSC.UI.InterActiveObject.DisplayObjectContainer.LoadLine
{
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.*;
	
	import com.FSC.UI.InterActiveObject.DisplayObjectContainer.SWFLoader.*;
	
	/**下载队列类 单例 使用swfLoader 与LoadLine部分重合了 要重构
	 * @ panyong
	 * @ v1.080509
	 */
	public class SWFLoaderLine extends MovieClip
	{
		private static var loadLine:SWFLoaderLine;
		private static var key:Boolean=false;
		private var myLoader:SWFLoader= new SWFLoader();
		private var myLoaderList:Array = new Array();
		private var myTimer:Timer = new Timer(100);
		private var isNowLoading:Boolean=false;
		//加载失败尝试次数
		private var tryErrorTime:Number=1;
		//当前加载失败次数
		private var tryErrorNowTime:Number = 0;

		public function SWFLoaderLine()
		{
			if( !key ){
	            throw new Error ("单例,请用 getInstance() 取实例。");
	        }
	        key=false;
	        myTimer.addEventListener(TimerEvent.TIMER,EverySedHandler); 
	        myTimer.start();
	        InitLoadEvent();
		}
		/**
		 * 初始化下载器
		 */
		private function InitLoadEvent():void {
			this.myLoader.addEventListener(LoadEvent.COMPLETE,this.CompleteHandler);
			this.myLoader.addEventListener(ProgressEvent.PROGRESS,this.ProgressHandler);
			this.myLoader.addEventListener(IOErrorEvent.IO_ERROR,this.ErrorHandler);
			this.myLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.ErrorHandler);
		}
		
		public static function GetInstance() : SWFLoaderLine {
            if ( loadLine == null ){
            	 key=true;
                loadLine = new SWFLoaderLine();
            }
            return loadLine;
        }
        
        /**静态函数 下载命令
        * @param target下载地址
        */
        public function LoadFile(target:URLRequest,emergent:Number=10):void{
        	if(emergent==0){
        		myLoaderList.unshift(target);
        		if(isNowLoading){
        			//如果有正在加载的项目则 暂停
        			CancelNowLoad();
        		}
        	}else{
				myLoaderList.push(target);
        	}
        }
        /**终止当前下载
        */
        private  function CancelNowLoad():void{
        	myLoader.CloseLoader();
        }
        /**每秒监听 队列是否有下载
        * @param e 时间参数
        */
        private function EverySedHandler(e:TimerEvent):void{
        	//但下载器空闲时
        	if((!isNowLoading)&&(myLoaderList.length>0)){
        		var tmp_url:URLRequest = myLoaderList[0] as URLRequest;     		
        		myLoader.load(tmp_url.url,SWFLoader.TARGET_SAME);
        		isNowLoading = true;
        	}
        }
        /**当前下载中的侦听
        */
        private function ProgressHandler(e:ProgressEvent):void{
        	this.dispatchEvent(new LoadLineProgressEvent(ProgressEvent.PROGRESS,myLoaderList[0],false,false,e.bytesLoaded,e.bytesTotal));
        }
        /**当前下载完成
        */
        private function CompleteHandler(e:LoadEvent):void{
        	this.dispatchEvent(new LoadLineEvent(LoadLineEvent.ONLOADLINECOMPLETE,myLoaderList[0],myLoader));
        	myLoaderList.shift();//当完成下载后再从队列中删除
        	isNowLoading = false;
        }
        /**当加载错误进行尝试处理
        */
        private function ErrorHandler(e:IOErrorEvent):void{
        	isNowLoading = false;
        	if(tryErrorNowTime>tryErrorTime){
	        	trace("error:下载队列中有文件加载失败,并且超过尝试次数。已从队列中删除");
	        	this.dispatchEvent(new LoadLineEvent(LoadLineEvent.ONLOADLINECOMPLETE,myLoaderList[0],myLoader,false));
	        	tryErrorNowTime=0;
	        	//当完成下载后再从队列中删除
	        	myLoaderList.shift();
        	}else{
        		tryErrorNowTime++;
        	}
        }		
	}
}
package {
	
	/******************************************************************************
	 *
	 * 解析WebServices服务,整理kita32(www.roading.net)的AS3 WebService
	 * http://www.SnowManBlog.com
	 * By SnowMan
	 *
	 ******************************************************************************/
	import flash.net.*;
	import flash.events.*;
	
	public class WebServices extends EventDispatcher{
		private var wsUrl:String;
		private var xmlns:String;
		private var methods:Object;
		
		public function WebServices(url:String){
			wsUrl = url;
			methods = {};
			analyseService();
		}
		
		public function load(methodName:String, ...args):void{
			if(methods[methodName] != null){
				var ws = new loadWSMethod();
				ws.addEventListener("callComplete", callCompleteHandler);
				ws.addEventListener("callError", callErrorHandler);
				ws.load(wsUrl, xmlns, methods[methodName], methodName, args);
			}else{
				dispatchEvent(new eventer("wsCallError", {target:this, info:"WebServices.call.withoutMethodName"}));
			}
		}
		
		private function callCompleteHandler(e:eventer):void{
			dispatchEvent(new eventer("wsCallComplete", {target:this, methodName:e.eventInfo.m, data:e.eventInfo.d}));
		}
		
		private function callErrorHandler(e:eventer):void{
			dispatchEvent(new eventer("wsCallError", {target:this, info:"WebServices.call.Error"}));
		}
		
		private function analyseService():void{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = wsUrl + "?wsdl";
			urlRequest.method = URLRequestMethod.POST;
			urlLoader.addEventListener("complete", completeHandler);
			urlLoader.addEventListener("ioError", ioerrorHandler);
			urlLoader.load(urlRequest);
		}
		
		private function completeHandler(e:Event):void{
			var tmpXML:XML, wsdl:Namespace, s:Namespace, i:uint, j:uint, item:String, elementXML, itemLen;
			
			tmpXML = XML(e.target.data);
			wsdl = tmpXML.namespace();
			for (i = 0; i < tmpXML.namespaceDeclarations().length; i++) {
				s = tmpXML.namespaceDeclarations()[i];
				var prefix:String = s.prefix;
				if (prefix == "s") break;
			}
			elementXML = tmpXML.wsdl::["types"].s::["schema"];
			xmlns = elementXML.@targetNamespace;
			for (i =0; i<elementXML.s::element.length(); i+=2) {
				item = elementXML.s::element[i].@name;
				methods[item] = new Array();
				itemLen = elementXML.s::element[i].s::complexType.s::sequence.s::element.length();
				for (j =0; j<itemLen; j++)
					methods[item].push(elementXML.s::element[i].s::complexType.s::sequence.s::element[j].@name);
			}
			dispatchEvent(new eventer("wsAnalyseComplete", {target:this, methods:methods}));
		}
		
		private function ioerrorHandler(e:Event):void{
			dispatchEvent(new eventer("wsAnalyseError", {target:this, info:"WebServices.analyse.Error"}));
		}
	}
}



/******************************************************************************
 *
 * 调用WebServices方法
 *
 ******************************************************************************/
import flash.events.*;
import flash.net.*;

class loadWSMethod extends EventDispatcher{
	
	private var soap:Namespace = new Namespace("http://schemas.xmlsoap.org/soap/envelope/");
	private var soapXML:XML = <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
								xmlns:xsd="http://www.w3.org/2001/XMLSchema"
								xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body/></soap:Envelope>;
	private var urlLoader:URLLoader;
	private var urlRequest:URLRequest;
	private var targetMethodName:String;
	
	public function loadWSMethod(){
		urlLoader = new URLLoader();
		urlRequest = new URLRequest();
		urlLoader.addEventListener("complete", completeHandler);
		urlLoader.addEventListener("ioError", ioerrorHandler);
	}
	
	public function load(wsUrl, xmlns, labels, methodName, args):void{
		targetMethodName = methodName;
   		var methodXML:XML = XML("<" + methodName + " xmlns=\"" + xmlns + "\"/>");
		for (var i=0; i<args.length; i++)
           	methodXML.appendChild( new XML("<" + labels[i] +">" + args[i] + "</" + labels[i] + ">") );
        var tempXML:XML = soapXML;
       	tempXML.soap::["Body"].appendChild(methodXML);
        if(xmlns.lastIndexOf("/") == xmlns.length - 1) xmlns = xmlns.substr(0, xmlns.length - 1);
        urlRequest.url = wsUrl + "?op=" + methodName;            
        urlRequest.method = URLRequestMethod.POST;
        urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml;charset=utf-8"));        
        urlRequest.requestHeaders.push(new URLRequestHeader("SOAPAction", xmlns + "/" + methodName));
        urlRequest.data = tempXML;
        urlLoader.load(urlRequest);
	}
	
	private function completeHandler(e:Event):void{
		dispatchEvent(new eventer("callComplete", {m:targetMethodName, d:e.target.data}));
	}
	
	private function ioerrorHandler(e:Event):void{
		dispatchEvent(new eventer("callError", {e:e}));
	}
}




/******************************************************************************
 *
 * 事件扩展,附加传递参数eventInfo
 *
 ******************************************************************************/
class eventer extends Event {
	private var info:Object;

	public function eventer(type:String, info:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		this.info = info;
	}
	public function get eventInfo():Object {
		return this.info;
	}
	public override function toString():String {
		return formatToString("Event:", "type", "bubbles", "cancelable", "eventInfo");
	}
}
 
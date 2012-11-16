package HttpService
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import spark.components.Application;

	public class HttpServiceManager
	{
		
		private var mJsonResults:Object;
		private var mHttpServiceManager:HTTPService;
		public static var HTTP_URL:String;
		private var mCallBack:Function;
		
		public function HttpServiceManager(data:String, callback:Function)
		{
//			initialiseHttpServiceManager(data, callback);
			mCallBack = callback;
			mHttpServiceManager = new HTTPService();
//			mHttpServiceManager.url = "http://192.168.0.102:8080/webtool-0.1.0/json";//HTTP_URL;
			mHttpServiceManager.url = "http://java-popov.rhcloud.com/webtool-0.1.0/json";
			mHttpServiceManager.method= "POST";
			mHttpServiceManager.contentType = "application/json";
			mHttpServiceManager.showBusyCursor = true;
			mHttpServiceManager.addEventListener(FaultEvent.FAULT, faultHandler);
			mHttpServiceManager.addEventListener(ResultEvent.RESULT, checkResult);
			mHttpServiceManager.send(data);
		}
				
		/*protected function initialiseHttpServiceManager(method:String, callbackFunc:Function):void
		{
			mHttpServiceManager = new HTTPService();
			mHttpServiceManager.url = "http://192.168.0.102:8080/webtool-0.1.0/json";//HTTP_URL;
			mHttpServiceManager.method= "POST";
			mHttpServiceManager.contentType = "application/json";
			mHttpServiceManager.showBusyCursor = true;
			mHttpServiceManager.addEventListener(FaultEvent.FAULT, faultHandler);
			mHttpServiceManager.addEventListener(ResultEvent.RESULT, checkResult);
			mHttpServiceManager.send(method);
		}*/
		
		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(event.fault.faultString, "Error", Alert.OK);
		}
		
		private function checkResult(event:ResultEvent):void
		{
			mJsonResults = JSON.parse(event.result as String);
			if(mCallBack != null)
			{
				if(mJsonResults.error)
				{
					mCallBack(mJsonResults.error);
				}
				else
				{
					mCallBack(mJsonResults.result);	
				}
				
			}
		}
	}
}
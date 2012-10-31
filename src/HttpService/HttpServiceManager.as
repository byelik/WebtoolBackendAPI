package HttpService
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import spark.components.Application;

	public class HttpServiceManager
	{
		
		private static var mJsonResults:Object;
		public static var httpService:HTTPService;
		public static var HTTP_URL:String;
		
		public function HttpServiceManager()
		{
			initialiseHttpServiceManager();
//			stage.addEventListener(Event.ENTER_FRAME, checkResult);
		}
				
		protected function initialiseHttpServiceManager():void
		{
			httpService = new HTTPService();
			httpService.url = HTTP_URL;
			httpService.method= "POST";
			httpService.contentType = "application/json";
//			httpService.send('{"jsonrpc": "2.0", "method" : "general.extractFactsFromXGML","params":[], "id":7}');
			httpService.addEventListener(ResultEvent.RESULT, checkResult);
			
		}
		
		private function checkRes(event:Event):void
		{
			trace("dfdhf");
		}
		
		
		public static function sendRequest(params:String):void
		{
			trace("kgf");
			httpService.send(params);
			
		}
		
		private function isResult(event:ResultEvent):void
		{
			
		}
		
		private function checkResult(event:ResultEvent):void
		{
			mJsonResults = JSON.parse(event.result as String);		
			trace(mJsonResults);
			//return mJsonResults;
		}
		
		public static function getResult():Object
		{
			return mJsonResults;
		}
	}
}
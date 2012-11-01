package HostComponents.TabBarHostComponent
{
	
	import Data.DataModel;
	
	import HttpService.HttpServiceManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.IndexChangedEvent;
	import mx.rpc.events.ResultEvent;
	
	import spark.components.TabBar;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	
	
	public class TabBarHostComponent extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var mTabBar:TabBar;
		
		public function TabBarHostComponent()
		{
			super();	
		}
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			switch(partName)
			{
				case "mTabBar":
					mTabBar.addEventListener(IndexChangeEvent.CHANGE, selectTabHandker);
				break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
			switch(partName)
			{
				case "mTabBar":
					mTabBar.removeEventListener(IndexChangeEvent.CHANGE, selectTabHandker);
					break;
			}
		}
		
		private function selectTabHandker(event:IndexChangeEvent):void
		{
			switch(event.newIndex)
			{
				case 0:
					trace("Locations");
				break;
				case 1:
//					DataModel.getSingleton().mHttpServiceManager.sendRequest('{"jsonrpc": "2.0", "method" : "general.extractFactsFromXGML","params":[], "id":7}');
//					trace(DataModel.getSingleton().mHttpServiceManager);
					HttpServiceManager.sendRequest('{"jsonrpc": "2.0", "method" : "general.extractFactsFromXGML","params":[], "id":7}');
					//HttpServiceManager.getResult();
					HttpServiceManager.httpService.addEventListener(ResultEvent.RESULT, getRes);
					trace("Facts");
				break;
				case 2:
					trace("Beats");
				break;
				case 3:
					trace("XGML");
				break;
			}
		}
		
		private function getRes(event:ResultEvent):void
		{
			var tmp:Object;
			tmp = JSON.parse(event.result as String);
			trace(tmp);
		}
		
	}
}
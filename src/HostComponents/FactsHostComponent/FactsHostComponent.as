package HostComponents.FactsHostComponent
{
	

	
	import Data.Facts.FactsData;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.DropDownList;
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	
	
	public class FactsHostComponent extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var characterList:DropDownList;
		
		[SkinPart(required="true")]
		public var mAgentsList:List;
		
		
		[Bindable]
		public var tmpData:ArrayCollection = new ArrayCollection(['geka', 'gang', 'g','côte','b','coté',
																			'xyz', 'f', 'e', 'D', 'ABC','Öhlund',
																			'Oehland','Zorn','Aaron','Ohlin','Aaron']);
		
		
		
		private var dataSortField:SortField;
		private var dataSort:Sort;
		
		
		public function FactsHostComponent()
		{
			super();
			dataSortField = new SortField();
			
			dataSort = new Sort();
			sortCharacterList();		
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
				case "characterList":
					characterList.addEventListener(Event.CHANGE, selectCharacterhandler);
					break;
				case "mAgentsList":
					mAgentsList.addEventListener(MouseEvent.CLICK, addFactToAgent);
				break;
				default:
					break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
			switch(partName)
			{
				case "characterList":
					characterList.removeEventListener(Event.CHANGE, selectCharacterhandler);
					break;
				case "mAgentsList":
					mAgentsList.removeEventListener(MouseEvent.CLICK, addFactToAgent);
					break;
				default:
					break;
			}
		}
		
		private function sortCharacterList():void
		{
			dataSort.fields = [dataSortField];
			tmpData.sort = dataSort;
			tmpData.refresh();
		}
		
		private function selectCharacterhandler(event:IndexChangeEvent):void
		{
			trace(event);
			var mFacts:FactsData = new FactsData();
		}
		
		private function addFactToAgent(event:MouseEvent):void
		{
			//select fact and send to server data...
			trace(mAgentsList.selectedItem.label);
		}
		
	}
}
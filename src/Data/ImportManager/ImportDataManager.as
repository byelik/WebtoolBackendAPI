package Data.ImportManager
{
	import Data.DataModel;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;

	public class ImportDataManager
	{
		private var importerFileFilter:FileFilter;
		private var importerFileReference:FileReference;
		private var fileLoader:Loader;
		private var xmlData:XML;
		private var alertHandler:Alert;
		
		public function ImportDataManager()
		{
			importerFileFilter = new FileFilter("XML", "*.xml");
			importerFileReference = new FileReference();
			fileLoader = new Loader();			
		}
		
		public function importData():void
		{
			importerFileReference.browse([importerFileFilter]);
			importerFileReference.addEventListener(Event.SELECT, selectFile);
			importerFileReference.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		
		private function selectFile(event:Event):void
		{
			importerFileReference.addEventListener(Event.COMPLETE, loadFile);
			importerFileReference.load();
		}
		[Bindable]
		public var tmp:ArrayCollection = new ArrayCollection();
		private function loadFile(event:Event):void
		{
			var factsXML:XML;
			xmlData = XML(importerFileReference.data);
			for each(var fact:XML in xmlData.facts)
			{
				factsXML = fact;	
			}
			for each(var factId:XML in factsXML.fact)
			{
				var factObject:Object = {};
				factObject["id"] = int(factId.@id);
				factObject["description"] = String(factId.description[0]);
				for each(var own:XML in factId.owners.owner)
				{
					trace(own);
					factObject["owners"] = own;
				}
				
				tmp.addItem(factObject);
			}
			
			DataModel.getSingleton().parseFactsData(tmp);
		}
		
		private function errorHandler(event:IOErrorEvent):void
		{
			trace("Error:" + event);
			ShowAlertWnd(event);
		}
		
		private function ShowAlertWnd(errorEvent:IOErrorEvent):void
		{
			alertHandler = Alert.show("Error while loading: "  + errorEvent, "Error",	Alert.OK);
		}
	}
}
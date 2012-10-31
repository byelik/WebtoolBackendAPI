package Data.ImportManager
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
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
		
		private function loadFile(event:Event):void
		{
			xmlData = XML(importerFileReference.data);
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
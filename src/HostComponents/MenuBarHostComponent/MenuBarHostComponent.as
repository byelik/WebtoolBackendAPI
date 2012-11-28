package HostComponents.MenuBarHostComponent
{
	

	import Data.ExportManager.ExportDataManager;
	import Data.ImportManager.ImportDataManager;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.MenuBar;
	import mx.events.MenuEvent;
	import mx.formatters.DateFormatter;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.formatters.DateTimeFormatter;
	
	
	
	public class MenuBarHostComponent extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var mMenuBar:MenuBar;
				
		private var mImportDataManger:ImportDataManager 
		
		
		
		public function MenuBarHostComponent()
		{
			super();
			
			mImportDataManger = new ImportDataManager();
			
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
				case "mMenuBar":
					mMenuBar.addEventListener(MenuEvent.ITEM_CLICK, menuBarAction);
				break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
			switch(partName)
			{
				case "mMenuBar":
					mMenuBar.removeEventListener(MenuEvent.ITEM_CLICK, menuBarAction);
				break;
			}
		}
		
		private function menuBarAction(event:MenuEvent):void
		{		
			switch(event.label)
			{
				case "Экспорт":
					 trace("Экспорт");
					 var mExportDataManager:ExportDataManager;
					 mExportDataManager = new ExportDataManager();
					 mExportDataManager.exportData();
				break;
				case "Импорт":
					trace("Импорт");
					mImportDataManger.importData();
				break;
			}
		}
		
		
		
	}
}
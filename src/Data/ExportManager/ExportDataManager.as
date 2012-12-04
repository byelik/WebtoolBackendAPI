package Data.ExportManager
{
	import Data.ImportManager.ImportDataManager;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import flash.display.Loader;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public class ExportDataManager
	{
		private var currentDate:Date;
		
		private var exportFileFilter:FileFilter;
		private var exportFileReference:FileReference;
		
		private var currentYear:uint;
		private var currentMonth:uint;
		private var currentDay:uint;
		private var currentHour:uint;
		private var currentMinutes:uint;
		private var mFileName:String;
		
		private var mTestXML:XML = <foo id="22"><bar>44</bar>text</foo>;
		
//		private var mImportManager:ImportDataManager = new ImportDataManager();
		private var mImportManager:ImportDataManager;
		private var mZipExporter:FZip;
		private var mByteArrayData:ByteArray;
		public function ExportDataManager()
		{
			mByteArrayData = new ByteArray();
			
			mImportManager = new ImportDataManager();
			mZipExporter = new FZip(); //mImportManager.getZipExporter();
			currentDate = new Date();
			exportFileFilter = new FileFilter("XML", "*.zip");
			exportFileReference = new FileReference();
			
			currentYear = currentDate.getFullYear();
			currentMonth = currentDate.getMonth();
			currentDay = currentDate.getDate();
			currentHour = currentDate.getHours();
			currentMinutes = currentDate.getMinutes();
			
			setFileName(currentYear + "-" + currentMonth + "-" + currentDay + "_" + currentHour + "-" + currentMinutes + ".zip");
			
			mByteArrayData.writeObject(mTestXML);
//			mZipExporter.addFile(getFileName(), mByteArrayData);
		}
		
		public function setFileName(value:String):void
		{
			mFileName = value;
		}
		
		public function getFileName():String
		{
			return mFileName;
		}
		
		
		
		public function exportData():void
		{
			var tmpByteArray:ByteArray = new ByteArray();
			mByteArrayData.writeUTFBytes(mTestXML.toString());
			mZipExporter.addFile("Scenary_2.xml", mByteArrayData);
			mZipExporter.serialize(tmpByteArray);
			exportFileReference.save(tmpByteArray, getFileName());
		}
	}
}
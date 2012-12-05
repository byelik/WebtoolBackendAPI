package Data.ExportManager
{
	import Data.DataModel;
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
		
		private var mTestXML:XML =<recipe name="хлеб" preptime="5" cooktime="180">
								  <title>Простой хлеб</title>
								  <composition>
								    <ingredient amount="3" unit="стакан">Мука</ingredient>
								    <ingredient amount="0.25" unit="грамм">Дрожжи</ingredient>
								    <ingredient amount="1.5" unit="стакан">Тёплая вода</ingredient>
								    <ingredient amount="1" unit="чайная ложка">Соль</ingredient>
								  </composition>
								  <instructions>
								    <step>Смешать все ингредиенты и тщательно замесить.</step>
								    <step>Закрыть тканью и оставить на один час в тёплом помещении.</step>
								    <!-- <step>Почитать вчерашнюю газету.</step> - это сомнительный шаг... -->
								    <step>Замесить ещё раз, положить на противень и поставить в духовку.</step>
								  </instructions>
								</recipe>

		
//		private var mImportManager:ImportDataManager = new ImportDataManager();
		private var mImportManager:ImportDataManager;
		private var mZipExporter:FZip;
		private var mByteArrayData:ByteArray;
		public function ExportDataManager()
		{
			mByteArrayData = new ByteArray();
			
			mImportManager = new ImportDataManager();
			mZipExporter = DataModel.getSingleton().mFZipObject;//new FZip(); //mImportManager.getZipExporter();
			currentDate = new Date();
			exportFileFilter = new FileFilter("XML", "*.zip");
			exportFileReference = new FileReference();
			
			currentYear = currentDate.getFullYear();
			currentMonth = currentDate.getMonth();
			currentDay = currentDate.getDate();
			currentHour = currentDate.getHours();
			currentMinutes = currentDate.getMinutes();
			
			setFileName(currentYear + "-" + currentMonth + "-" + currentDay + "_" + currentHour + "-" + currentMinutes + ".zip");
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
//			var tmp:FZip = DataModel.getSingleton().mFZipObject;
			var tmpByteArray:ByteArray = new ByteArray();
			mByteArrayData.writeUTFBytes(mTestXML.toString());
			mByteArrayData.position = 0;
			mZipExporter.addFile("Scenary.xml", mByteArrayData);
			mZipExporter.serialize(tmpByteArray);
			exportFileReference.save(tmpByteArray, getFileName());
		}
	}
}
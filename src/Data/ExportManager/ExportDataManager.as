package Data.ExportManager
{
	import flash.display.Loader;
	import flash.net.FileFilter;
	import flash.net.FileReference;

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
		public function ExportDataManager()
		{
			currentDate = new Date();
			exportFileFilter = new FileFilter("XML", "*.xml");
			exportFileReference = new FileReference();
			
			currentYear = currentDate.getFullYear();
			currentMonth = currentDate.getMonth();
			currentDay = currentDate.getDay();
			currentHour = currentDate.getHours();
			currentMinutes = currentDate.getMinutes();
			
			mFileName = "" + currentYear + "-" + currentMonth + "-" + currentDay + "-" + currentHour + "-" + currentMinutes + ".xml";
		}
		
		public function exportData():void
		{
			exportFileReference.save("Test", mFileName);
		}
	}
}
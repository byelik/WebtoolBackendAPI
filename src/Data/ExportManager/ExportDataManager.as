package Data.Exportmanager
{
	import flash.display.Loader;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	public class ExportDataManager
	{
		private var fileName:Date;
		
		private var exportFileFilter:FileFilter;
		private var exportFileReference:FileReference;
		
		public function ExportDataManager()
		{
			fileName = new Date();
			exportFileFilter = new FileFilter("XML", "*.xml");
			exportFileReference = new FileReference();
		}
		
		public function exportData():void
		{
			exportFileReference.save("Test", "test.xml");
		}
	}
}
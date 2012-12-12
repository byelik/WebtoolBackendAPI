package Data.XGML
{
	import mx.collections.ArrayCollection;

	public class XgmslData
	{
		private var mFileName:String;
		private var mFilesWithThemes:XML;
		
		public function XgmslData(data:Object = null)
		{
			parse(data);
		}
		
		public function get filesWithThemes():XML
		{
			return mFilesWithThemes;
		}

		public function set filesWithThemes(value:XML):void
		{
			mFilesWithThemes = value;
		}

		public function get filename():String
		{
			return mFileName;
		}

		public function set filename(value:String):void
		{
			mFileName = value;
		}

		public static function getNewInstance():XgmslData
		{
			return new XgmslData();
		}
		
		public function parse(data:Object):void
		{
			if(!data)
			{
				mFileName = "";
				mFilesWithThemes = null;
			}
			else
			{
				mFileName = String(data.filename);
				mFilesWithThemes = (data.file as XML);
			}
		}
	}
}
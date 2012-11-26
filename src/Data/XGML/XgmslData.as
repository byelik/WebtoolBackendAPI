package Data.XGML
{
	import mx.collections.ArrayCollection;

	public class XgmslData
	{
		private var mId:int;
		private var mClassName:String;
		private var mFileName:String;
		private var mContent:XML;
		
		public function XgmslData(data:Object = null)
		{
			parse(data);
		}
		
		public function get id():int
		{
			return mId;
		}

		public function set id(value:int):void
		{
			mId = value;
		}

		public function get className():String
		{
			return mClassName;
		}

		public function set className(value:String):void
		{
			mClassName = value;
		}

		public function get filename():String
		{
			return mFileName;
		}

		public function set filename(value:String):void
		{
			mFileName = value;
		}

		public function get content():XML
		{
			return mContent;
		}

		public function set content(value:XML):void
		{
			mContent = value;
		}

		public static function getNewInstance():XgmslData
		{
			return new XgmslData();
		}
		
		public function parse(data:Object):void
		{
			if(!data)
			{
				mId = 0;
				mClassName = "";
				mFileName = "";
				mContent = null;
			}
			else
			{
				mId = int(data.id);
				mClassName = String(data.className);
				mFileName = String(data.filename);
				mContent = XML(data.content);
			}
		}
	}
}
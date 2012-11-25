package Data.XGML
{
	import mx.collections.ArrayCollection;

	public class XgmslData
	{
		private var mId:int;
		private var mDescription:String;
		private var mOwners:ArrayCollection;
		private var mXgmlId:String;
		
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

		public function get description():String
		{
			return mDescription;
		}

		public function set description(value:String):void
		{
			mDescription = value;
		}

		public function get owners():ArrayCollection
		{
			return mOwners;
		}

		public function set owners(value:ArrayCollection):void
		{
			mOwners = value;
		}

		public function get xgmlId():String
		{
			return mXgmlId;
		}

		public function set xgmlId(value:String):void
		{
			mXgmlId = value;
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
				mDescription = "";
				mOwners = null;
				mXgmlId = "";
			}
			else
			{
				mId = int(data.id);
				mDescription = String(data.description);
				mOwners = (data.owners);
				mXgmlId = "";
			}
		}
	}
}
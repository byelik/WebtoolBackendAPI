package Data.Locations
{
	public class LocationsData
	{
		private var mId:int;
		private var mName:String;
		private var mDescription:String;
		private var mAdjacents:Array;
		
		public function LocationsData(data:Object = null)
		{
			parse(data);
		}

		public function get adjacents():Array
		{
			return mAdjacents;
		}

		public function set adjacents(value:Array):void
		{
			mAdjacents = value;
		}

		public function get description():String
		{
			return mDescription;
		}

		public function set description(value:String):void
		{
			mDescription = value;
		}

		public function get name():String
		{
			return mName;
		}

		public function set name(value:String):void
		{
			mName = value;
		}

		public function get id():int
		{
			return mId;
		}

		public function set id(value:int):void
		{
			mId = value;
		}

		public static function getNewInstance():LocationsData
		{
			return new LocationsData();
		}
		
		public function parse(data:Object):void
		{
			if(!data)
			{
				mId = 0;
				mName = "";
				mDescription = "";
				mAdjacents = null;	
			}
			else
			{
				mId = int(data.id);
				mName = String(data.name);
				mDescription = String(data.description);
				mAdjacents = (data.adjacents) as Array;
			}
		}
	}
}
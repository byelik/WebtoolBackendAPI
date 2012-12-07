package Data.Locations
{
	public class LocationsData
	{
		private var mId:String;
		private var mItems:Array;
		private var mAdjacents:Array;
		
		public function LocationsData(data:Object = null)
		{
			parse(data);
		}

		public static function getNewInstance():LocationsData
		{
			return new LocationsData();
		}
		
		public function get items():Array
		{
			return mItems;
		}

		public function set items(value:Array):void
		{
			mItems = value;
		}

		public function get adjacents():Array
		{
			return mAdjacents;
		}

		public function set adjacents(value:Array):void
		{
			mAdjacents = value;
		}

		public function get id():String
		{
			return mId;
		}

		public function set id(value:String):void
		{
			mId = value;
		}

		public function parse(data:Object):void
		{
			if(!data)
			{
				mId = "";
				mItems = null;
				mAdjacents = null;	
			}
			else
			{
				mId = String(data.id);
				mItems = (data.items) as Array;
				mAdjacents = (data.adjacents) as Array;
			}
		}
	}
}
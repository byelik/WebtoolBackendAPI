package Data.Locations
{
	import mx.collections.ArrayCollection;

	public class LocationsData
	{
		private var mId:String;
		private var mItems:ArrayCollection;
		private var mAdjacents:Array;
		
		public function LocationsData(data:Object = null)
		{
			parse(data);
		}

		public static function getNewInstance():LocationsData
		{
			return new LocationsData();
		}
		
		public function get items():ArrayCollection
		{
			return mItems;
		}

		public function set items(value:ArrayCollection):void
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
				mItems = new ArrayCollection((data.items) as Array);
				mAdjacents = (data.adjacents) as Array;
			}
		}
	}
}
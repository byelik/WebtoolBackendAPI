package Data.Facts
{
	public class FactsData
	{
		private var mId:int;
		private var mDescription:String;
		private var mOwners:Array;
		private var mXgml:String;
		
		public function FactsData(data:Object = null)
		{
			parse(data);
		}
		public static function getNewInstance():FactsData
		{
			return new FactsData();
		}
		
		public function get xgml():String
		{
			return mXgml;
		}
		
		public function set xgml(value:String):void
		{
			mXgml = value;
		}
		
		public function get owners():Array
		{
			return mOwners;
		}
		
		public function set owners(value:Array):void
		{
			mOwners = value;
		}
		
		public function get description():String
		{
			return mDescription;
		}
		
		public function set description(value:String):void
		{
			mDescription = value;
		}
		
		public function get id():int
		{
			return mId;
		}
		
		public function set id(value:int):void
		{
			mId = value;
		}
		
		public function parse(data:Object):void
		{
			if(!data)
			{
				id = 0;
				mDescription = "";
				mOwners = null;
				mXgml = "";
			}
			else
			{
				id = int(data.id);
				mDescription = String(data.description);
				mOwners = (data.owners) as Array;
				mXgml = String(data.xgmlId);
			}
			
		}
	}
}
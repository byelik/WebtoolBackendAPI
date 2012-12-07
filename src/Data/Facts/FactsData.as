package Data.Facts
{
	public class FactsData
	{
		private var mId:int;
		private var mDescription:String;
		
		public function FactsData(data:Object = null)
		{
			parse(data);
		}
		public static function getNewInstance():FactsData
		{
			return new FactsData();
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
			}
			else
			{
				id = int(data.id);
				mDescription = String(data.description);
			}
		}
	}
}
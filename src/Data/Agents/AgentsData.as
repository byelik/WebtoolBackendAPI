package Data.Agents
{
	public class AgentsData
	{
		private var mId:String;
		private var mLocation:String;
		private var mNerve:int;
		private var mAffinity:int;
		private var mFacts:Array;
		private var mItems:Array;
		
		public function AgentsData(data:Object = null)
		{
			parse(data);
		}
		
		public function get items():Array
		{
			return mItems;
		}

		public function set items(value:Array):void
		{
			mItems = value;
		}

		public function get facts():Array
		{
			return mFacts;
		}

		public function set facts(value:Array):void
		{
			mFacts = value;
		}

		public function get location():String
		{
			return mLocation;
		}

		public function set location(value:String):void
		{
			mLocation = value;
		}

		public static function getNewInstance():AgentsData
		{
			return new AgentsData();
		}
		
		public function get affinity():int
		{
			return mAffinity;
		}
		
		public function set affinity(value:int):void
		{
			mAffinity = value;
		}
		
		public function get nerve():int
		{
			return mNerve;
		}
		
		public function set nerve(value:int):void
		{
			mNerve = value;
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
				mLocation = "";
				mNerve = 0;
				mAffinity = 0;
				mFacts = null;
				mItems = null;
			}
			else
			{
				mId = String(data.id);
				mLocation = String(data.location);
				mNerve = int(data.nerve);
				mAffinity = int(data.affinity);
				mFacts = (data.facts) as Array;
				mItems = (data.items) as Array;
			}
		}
	}
}
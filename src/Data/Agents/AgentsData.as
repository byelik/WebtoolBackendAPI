package Data.Agents
{
	public class AgentsData
	{
		private var mId:int;
		private var mName:String;
		private var mDescription:String;
		private var mNerve:int;
		private var mAffinity:int;
		private var mLocationId:int;
		
		public function AgentsData(data:Object = null)
		{
			parse(data);
		}
		
		public function get locationId():int
		{
			return mLocationId;
		}
		
		public function set locationId(value:int):void
		{
			mLocationId = value;
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
		
		public static function getNewInstance():AgentsData
		{
			return new AgentsData();
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
				mId = 0;
				mName = "";
				mDescription = "";
				mNerve = 0;
				mAffinity = 0;
				mLocationId = 0;
			}
			else
			{
				mId = int(data.id);
				mName = String(data.name);
				mDescription = String(data.description);
				mNerve = int(data.nerve);
				mAffinity = int(data.affinity);
				mLocationId = int(data.locationId);
			}
		}
	}
}
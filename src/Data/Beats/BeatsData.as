package Data.Beats
{
	import mx.collections.ArrayCollection;
	
	public class BeatsData
	{
		private var mActivities:ArrayCollection;
		private var mAgent:String;
		private var mDescription:String;
		private var mExclusiveBeatPriority:int;
		private var mId:int;
		private var mLocationId:int;
		private var mType:String;
		private var mXgmlTheme:String;
		private var mPreconditions:String;
		private var mRadius:String = "30";
		private var mBeatsCompleted:ArrayCollection;		
		
		public function BeatsData(data:Object = null)
		{
			parse(data); 
		}
		
		public function get beatsCompleted():ArrayCollection
		{
			return mBeatsCompleted;
		}

		public function set beatsCompleted(value:ArrayCollection):void
		{
			mBeatsCompleted = value;
		}

		public static function getNewInstance():BeatsData
		{
			return new BeatsData();
		}
		
		public function get xgmlTheme():String
		{
			return mXgmlTheme;
		}
		
		public function set xgmlTheme(value:String):void
		{
			mXgmlTheme = value;
		}
		
		public function get type():String
		{
			return mType;
		}
		
		public function set type(value:String):void
		{
			mType = value;
		}
		
		public function get preConditions():String
		{
			return mPreconditions;
		}
		
		public function set preConditions(value:String):void
		{
			mPreconditions = value;
		}
		
		public function get locationId():int
		{
			return mLocationId;
		}
		
		public function set locationId(value:int):void
		{
			mLocationId = value;
		}
		
		public function get id():int
		{
			return mId;
		}
		
		public function set id(value:int):void
		{
			mId = value;
		}
		
		public function get exclusiveBeatPriority():int
		{
			return mExclusiveBeatPriority;
		}
		
		public function set exclusiveBeatPriority(value:int):void
		{
			mExclusiveBeatPriority = value;
		}
		
		public function get description():String
		{
			return mDescription;
		}
		
		public function set description(value:String):void
		{
			mDescription = value;
		}
		
		public function get agent():String
		{
			return mAgent;
		}
		
		public function set agent(value:String):void
		{
			mAgent = value;
		}
		
		public function get activities():ArrayCollection
		{
			return mActivities;
		}
		
		public function set activities(value:ArrayCollection):void
		{
			mActivities = value;
		}
		
		public function parse(data:Object):void
		{
			if(!data)
			{
				mActivities = null;
				mAgent = "";
				mDescription = "";
				mExclusiveBeatPriority = 0;
				mId = 0;
				mLocationId = 0;
				mPreconditions = null;
				mType = "";
				mXgmlTheme = "";
				mBeatsCompleted = null;
			}
			else
			{
				mActivities = new ArrayCollection((data.activities) as Array);
				mAgent = String(data.agent);
				mDescription = String(data.description);
				mExclusiveBeatPriority = int(data.exclusiveBeatPriority);
				mId = int(data.id);
				mLocationId = int(data.locationId);
				mType = String(data.type);
				mXgmlTheme = String(data.xgmlTheme);
				mPreconditions = String(data.preConditions);
				mBeatsCompleted = new ArrayCollection((data.beatsCompleted) as Array);
				
			}
		}
	}
}
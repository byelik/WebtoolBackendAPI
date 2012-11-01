package Data.Facts
{
	import mx.rpc.http.HTTPService;

	public class FactsData
	{
		private var mId:int;
		private var mOwners:Array;
		private var mRequirements:Array;
		private var mXgml:String;
		
		public function FactsData()
		{
			
		}

		public function get id():int
		{
			return mId;
		}

		public function set id(value:int):void
		{
			mId = value;
		}
		
		public function get owners():Array
		{
			return mOwners;
		}
		
		public function set owners(value:Array):void
		{
			mOwners = value;
		}
		public function get xgml():String
		{
			return mXgml;
		}
		
		public function set xgml(value:String):void
		{
			mXgml = value;
		}
		
		public function get requirements():Array
		{
			return mRequirements;
		}
		
		public function set requirements(value:Array):void
		{
			mRequirements = value;
		}
	}
}
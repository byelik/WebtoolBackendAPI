package Data
{
	import HttpService.HttpServiceManager;

	public class DataModel
	{
		private static var msSingleton:DataModel;
		
//		public var mHttpServiceManager:HttpServiceManager;
		
		private function DataModel()
		{
//			mHttpServiceManager = new HttpServiceManager();
		}
		
		public static function getSingleton():DataModel
		{
			if(!msSingleton)
			{
				msSingleton = new DataModel();
			}
			return msSingleton;
		}
	}
}
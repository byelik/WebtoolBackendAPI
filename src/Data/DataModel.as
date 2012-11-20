package Data
{
	import Data.Agents.AgentsData;
	import Data.Beats.BeatsData;
	import Data.Facts.FactsData;
	import Data.Locations.LocationsData;
	
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;
	import spark.collections.SortField;


	public class DataModel
	{
		private static var msSingleton:DataModel;
		
		[Bindable]
		public var mFactsList:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var mBeatsList:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var mAgentsList:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var mLocationsList:ArrayCollection = new ArrayCollection();
		
		public function DataModel()
		{
			
		}
		
		public static function getSingleton():DataModel
		{
			if(!msSingleton)
			{
				msSingleton = new DataModel();
			}
			return msSingleton;
		}
		
		public function parseFactsData(data:Object):void
		{
			mFactsList.disableAutoUpdate();
			var facts:FactsData;
			if(mFactsList)
			{
				mFactsList.removeAll();
			}
			for each(var item:Object in data)
			{
				facts = FactsData.getNewInstance();
				facts.parse(item);
				mFactsList.addItem(facts);
			}
			mFactsList.enableAutoUpdate();
		}
		
		public function parseBeatsData(data:Object):void
		{
			mBeatsList.disableAutoUpdate();
			var beats:BeatsData;
			if(mBeatsList)
			{
				mBeatsList.removeAll();
			}
			for each(var item:Object in data)
			{
				beats = BeatsData.getNewInstance();
				beats.parse(item);
				mBeatsList.addItem(beats);
			}
			mBeatsList.enableAutoUpdate();
		}
		
		public function parseAgentsData(data:Object):void
		{
			mAgentsList.disableAutoUpdate();
			var agents:AgentsData;
			if(mAgentsList)
			{
				mAgentsList.removeAll();
			}
			for each(var item:Object in data)
			{
				agents = AgentsData.getNewInstance();
				agents.parse(item);
				mAgentsList.addItem(agents);
			}
			mAgentsList.enableAutoUpdate();
		}
		
		public function parseLocationsData(data:Object):void
		{
			mLocationsList.disableAutoUpdate();
			var locations:LocationsData;
			if(mLocationsList)
			{
				mLocationsList.removeAll();
			}
			for each(var item:Object in data)
			{
				locations = LocationsData.getNewInstance();
				locations.parse(item);
				mLocationsList.addItem(locations);
			}
			mLocationsList.enableAutoUpdate();
		}
	}
}
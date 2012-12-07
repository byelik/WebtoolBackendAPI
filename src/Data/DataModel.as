package Data
{
	import Data.Agents.AgentsData;
	import Data.Beats.BeatsData;
	import Data.Facts.FactsData;
	import Data.Locations.LocationsData;
	import Data.Tree.TreeData;
	import Data.XGML.XgmslData;
	
	import deng.fzip.FZip;
	
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
		
		[Bindable]
		public var mBubbleBeatData:ArrayCollection = new ArrayCollection([{beatPosX:1, beatPosY:1, beatRadius:40,
																	beatId:1, beatDescription:"desc", beatType:"normal", beatCompleted:""}]);
		
		[Bindable]
		public var mXgmlsData:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var mAgentXgml:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var mItemsData:ArrayCollection = new ArrayCollection([{type:"Cufflink", owner:"Melany", count:1},
																	{type:"FlashLight", owner:"Bathroom", count:2},
																	{type:"Revolver", owner:"Henry", count:3},
																	{type:"Rope", owner:"Philipp", count:4}]);
		[Bindable]
		public var mTypes:ArrayCollection = new ArrayCollection([{type:"Cufflink"}, 
																{type:"FlashLight"}, 
																{type:"Revolver"},
																{type:"Rope"}]);
		
		[Bindable]
		public var mFactsStatusList:ArrayCollection = new ArrayCollection(["not confirmed", 
																		   "true",
																		   "false"]);
		
		[Bindable]
		public var mTreeData:XML = new XML();
		
		[Bindable]
		public var mFZipObject:FZip = new FZip();
		
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
			parseOriginalBeatData();
			mBeatsList.enableAutoUpdate();
		}
		
		public function parseAgentsData(data:Object):void
		{
			
			var agents:AgentsData;
			if(mAgentsList)
			{
//				mAgentsList.removeAll();
				mAgentsList.disableAutoUpdate();
//				mAgentsList.refresh();
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
			
			var locations:LocationsData;
			if(mLocationsList)
			{
				
				mLocationsList.removeAll();
				mLocationsList.disableAutoUpdate();
				mLocationsList.refresh();
			}
			for each(var item:Object in data)
			{
				locations = LocationsData.getNewInstance();
				locations.parse(item);
				mLocationsList.addItem(locations);
			}
			mLocationsList.enableAutoUpdate();
		}
		public static const millisecondsPerDay:int = 1000 * 60 * 60 * 24;
		private function parseOriginalBeatData():void
		{
			if(mBubbleBeatData)
			{
				mBubbleBeatData.removeAll();	
			}
			for each(var originalBeatData:Object in mBeatsList)
			{
				var tmp:Object={beatPosX:new Date(new Date().time + millisecondsPerDay * 10), beatPosY:1, beatRadius:40};
				
				tmp["beatId"] = originalBeatData.id;
				tmp["beatDescription"] = originalBeatData.description;
				for each(var beatPrecondition:Object in originalBeatData.preconditions)
				{
					tmp["beatsCompleted"] = beatPrecondition.beatsCompleted;
					tmp["affinityMax"] = beatPrecondition.affinityMax;
					tmp["affinityMin"] = beatPrecondition.affinityMin;
					tmp["beatPreconditionsDescription"] = beatPrecondition.description;
					tmp["factsAvailableToAgent"] = beatPrecondition.factsAvailableToAgent;
					tmp["factsAvailableToUser"] = beatPrecondition.factsAvailableToUser;
					tmp["nerveMax"] = beatPrecondition.nerveMax;
					tmp["nerveMin"] = beatPrecondition.nerveMin;
					tmp["subjects"] = beatPrecondition.subjects;
				}
				tmp["activities"] = originalBeatData.activities;
				tmp["agentId"] = originalBeatData.agentId;
				tmp["exclusiveBeatPriority"] = originalBeatData.exclusiveBeatPriority;
				tmp["id"] = originalBeatData.id;
				tmp["locationId"] = originalBeatData.locationId;
				tmp["type"] = originalBeatData.type;
				tmp["xgmlTheme"] = originalBeatData.xgmlTheme;
//				tmp["preconditions"] = originalBeatData.preConditions;
//				var x:Date = new Date()
//				var y:Date = new Date(new Date().time + 10 * 10);
//				tmp["beatPosX"] = Math.random() - 0.001;
//				tmp["beatPosY"] = Math.random() - 0.0001;
				mBubbleBeatData.addItem(tmp);
			}
			
		}
		
		public function parseXgmlsData(data:Object):void
		{
			mXgmlsData.disableAutoUpdate();
			var xgmls:XgmslData;
			if(mXgmlsData)
			{
				mXgmlsData.removeAll();
			}
			for each(var item:Object in data)
			{
				xgmls = XgmslData.getNewInstance();
				xgmls.parse(item);
				mXgmlsData.addItem(xgmls);
			}
			mXgmlsData.enableAutoUpdate();
		}
		
		/*public function parseTreeData(data:Object):void
		{
			var treeData:TreeData;
			if(mTreeData)
			{
				mTreeData.removeAll();
			}
			for each(var item:Object in data)
			{

				treeData = TreeData.getNewInstance();
				treeData.parse(data);
				mTreeData.addItem(treeData);	
			}
		}*/
	}
}
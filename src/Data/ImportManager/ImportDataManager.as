package Data.ImportManager
{
	import Data.DataModel;
	import Data.ExportManager.ExportDataManager;
	
	import HostComponents.FactsHostComponent.FactsHostComponent;
	
	import Skins.FactsSkin.FactsComponent;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.utils.UIDUtil;

	public class ImportDataManager
	{
		private var importerFileFilter:FileFilter;
		private var importerFileReference:FileReference;
		private var fileLoader:Loader;
		private var mXmlData:XML;
		
		//xgml
		private var mXgmlThemeData:XML;
		private var mXgmlFiles:FZipFile;
		
		private var alertHandler:Alert;
		
		[Bindable]
		private var mFacts:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var mBeats:ArrayCollection = new ArrayCollection();
		
//		[Bindable]
//		private var mLocations:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var mAgents:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var mDescriptor:ArrayCollection = new ArrayCollection();
		
//		[Bindable]
//		private var mXgmls:ArrayCollection = new ArrayCollection();
		
		public var mZipLoader:FZip;
		private var mZipFile:FZipFile;
		
		[Bindable]
		private var mAgentsNamesList:ArrayCollection = new ArrayCollection();
		
//		private var mTreeObject:XML;
		
		public function ImportDataManager()
		{
			importerFileFilter = new FileFilter("zip", "*.zip");
			importerFileReference = new FileReference();
			fileLoader = new Loader();
			
			mZipLoader = new FZip();
			mZipFile = new FZipFile();
			
			mXgmlFiles = new FZipFile();
		}
		
		public function importData():void
		{
			importerFileReference.browse([importerFileFilter]);
			importerFileReference.addEventListener(Event.SELECT, selectFile);
			importerFileReference.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		
		private function selectFile(event:Event):void
		{
			importerFileReference.addEventListener(Event.COMPLETE, loadFile);
			importerFileReference.load();
		}
		
		private function loadFile(event:Event):void
		{
			//clear character facts and items list...
			if(DataModel.getSingleton().mItemsData)
			{
				DataModel.getSingleton().mItemsData.removeAll();
				DataModel.getSingleton().mItemsData.refresh();
			}
			if(DataModel.getSingleton().mCharacterFacts)
			{
				DataModel.getSingleton().mCharacterFacts.removeAll();
				DataModel.getSingleton().mCharacterFacts.refresh();
			}
			
			var factsXML:XML;
			var beatsXML:XML;
			var locationsXml:XML;
			var agentsXml:XML;
			var descriptorXml:XML;
			var itemsXml:XML;
			var xgmlsXml:XML;
			
			var xgmlThemeXML:XML;
			
			var treeData:Object;
			mZipLoader.loadBytes(importerFileReference.data);
			DataModel.getSingleton().mFZipObject.loadBytes(importerFileReference.data);
//			DataModel.getSingleton().mFZipObject = mZipLoader;
			
			
			mZipFile = mZipLoader.getFileByName("TreeData.xml");
			if(mZipFile)
			{
//				var treeXML:XML = new XML(mZipFile.content);
//				
//				for each(var group:XML in treeXML.children())
//				{
//					for each(var label:XML in group.children())
//					{
//						trace("Group:" + group.children().@label);
//						trace("Label" + label.children().@label + label.children().@description + label.children().@id + label.children().@x + label.children().@y);	
//					}
//					
//				}
				DataModel.getSingleton().mTreeData = new XML(mZipFile.content);
			}	
			
			mZipFile = mZipLoader.getFileByName("Scenary.xml");

			if(mZipFile)
			{
				mXmlData = XML(mZipFile.content);
			}
			//parse facts
			if(mFacts)
			{
				mFacts.removeAll();
			}
			if(mXmlData)
			{
				for each(var fact:XML in mXmlData.facts)
				{
					factsXML = fact;	
				}
				for each(var factId:XML in factsXML.fact)
				{
					var factObject:Object = {};				
					factObject["id"] = int(factId.@id);
					factObject["description"] = String(factId.children()[0]);
					mFacts.addItem(factObject);
				}
				DataModel.getSingleton().parseFactsData(mFacts);
				
				//parse beats data from XML
				if(mBeats)
				{
					mBeats.removeAll();
				}
				for each(var beats:XML in mXmlData.beats)
				{
					beatsXML = beats;
				}
				for each(var beat:XML in beatsXML.beat)
				{
					var beatsObject:Object = {"activities":[], "preConditions":[], "beatsCompleted":[]};	
					for each(var beatActivity:XML in beat.activities.children())
					{
						beatsObject["activities"].push(beatActivity.children()[0].toString());		
					}
					
					beatsObject["agent"] = String(beat.agent);
					beatsObject["description"] = String(beat.description);
					beatsObject["exclusiveBeatPriority"] = int(beat.exclusiveBeatPriority);
					beatsObject["id"] = int(beat.@id);
					for each(var beatCompleted:XML in beat.completedBeats.children())
					{
						beatsObject["beatsCompleted"].push(int(beatCompleted.children()[0]));
					}
	
					beatsObject["locationId"] = int(beat.locationId);
	//				beatsObject["preConditions"] = (beat.preConditions) as Array;
					beatsObject["type"] = String(beat.type);
					beatsObject["xgmlTheme"] = String(beat.xgmlTheme);
					beatsObject["preConditions"] = String(beat.preCondition);
					mBeats.addItem(beatsObject);
				}
				DataModel.getSingleton().parseBeatsData(mBeats);
				
				//parse locations
				var mLocations:ArrayCollection = new ArrayCollection();
				if(mLocations)
				{
					mLocations.removeAll();
				}
				for each(var locations:XML in mXmlData.locations)
				{
					locationsXml = locations;	
				}
				for each(var location:XML in locationsXml.location)
				{
					var locationObject:Object = {"adjacents":[], "items":[]};				
					locationObject["id"] = String(location.@id);
					for each(var adjacent:XML in location.adjacents.children())
					{
						locationObject["adjacents"].push(String(adjacent.children()[0]));
					}
					for each(var item:XML in location.items.children())
					{
						var locationItemsObject:Object = new Object();
						locationItemsObject["type"] = (String(item.children()[0]));
						locationItemsObject["count"] = (int(item.children()[1]));
						
						locationObject["items"].push(locationItemsObject);
					}
					mLocations.addItem(locationObject);
				}
				DataModel.getSingleton().parseLocationsData(mLocations);
				
				//parse agents
				if(mAgents)
				{
					mAgents.removeAll();
				}
				if(mAgentsNamesList)
				{
					mAgentsNamesList.removeAll();
				}
				for each(var agents:XML in mXmlData.agents)
				{
					agentsXml = agents;	
				}
				for each(var agent:XML in agentsXml.agent)
				{
					var agentObject:Object = {"facts":[], "items":[]};				
					agentObject["id"] = String(agent.@id);
					
					
					mAgentsNamesList.addItem(agentObject.id);
					
					agentObject["location"] = String(agent.location);
					agentObject["nerve"] = int(agent.nerve);
					agentObject["affinity"] = int(agent.affinity);
					for each(var fact:XML in agent.facts.children())
					{
						var agentFactsObject:Object = new Object();						
						agentFactsObject["id"] = fact.@id.toString();
						agentFactsObject["status"] = fact.@status.toString();
						
						agentObject["facts"].push(agentFactsObject);
					}
					for each(var item:XML in agent.items.children())
					{
						var agentItemsObject:Object = new Object();
						agentItemsObject["type"] = (String(item.children()[0]));
						agentItemsObject["count"] = (int(item.children()[1]));
						
						agentObject["items"].push(agentItemsObject);
					}
					mAgents.addItem(agentObject);
				}
				DataModel.getSingleton().parseAgentsData(mAgents);
				
				if(mDescriptor)
				{
					mDescriptor.removeAll();
				}
				for each(var descriptor:XML in mXmlData.descriptor)
				{
					var descriptorObject:Object = {};				
					descriptorObject["id"] = int(descriptor.@id);
					descriptorObject["scenarioId"] = String(descriptor.scenarioId);
					mDescriptor.addItem(descriptorObject);
				}
				parseAgnetsFiles(mAgentsNamesList);
			}
					
			ExportDataManager.deleteFiles(mZipLoader, "Scenary.xml", "TreeData.xml");
			
		}
		
		private function parseAgnetsFiles(agentsNames:ArrayCollection):void
		{		
			parseThemesFiles(agentsNames);
		}
		
		private function parseThemesFiles(themesFileName:ArrayCollection):void
		{
			if(DataModel.getSingleton().mAgentThemesList)
			{
				DataModel.getSingleton().mAgentThemesList.removeAll();
			}
			var agentXgmlFile:XML;
			var themesFilesList:ArrayCollection = new ArrayCollection();
			var themesList:ArrayCollection = new ArrayCollection();
			var xgmlThemesFile:XML;
			for(var i:int = 0; i < themesFileName.length; i++)
			{
				mXgmlFiles = mZipLoader.getFileByName(themesFileName[i] + ".xgml");
				if(mXgmlFiles)
				{
					agentXgmlFile = new XML(mXgmlFiles.content);
					for each(var fileThemeInAgentFile:XML in agentXgmlFile.children())
					{
//						trace(fileThemeInAgentFile.@file.toString());
						mXgmlFiles = mZipLoader.getFileByName(fileThemeInAgentFile.@file.toString());
						if(mXgmlFiles)
						{
							xgmlThemesFile = new XML(mXgmlFiles.content);
							for each(var themes:XML in xgmlThemesFile.children())
							{					
								themesList.addItem(themes.@name.toString());
							}
						}
					}
					
					var str:String = themesList.toString();
					var theme:Array = str.split(",");
					DataModel.getSingleton().mAgentThemesList.addItem({agentName:themesFileName[i], themes:theme});
				}
			}
//			var tmp:ArrayCollection = DataModel.getSingleton().mAgentThemesList;
		}
				
		private function errorHandler(event:IOErrorEvent):void
		{
			trace("Error:" + event);
			ShowAlertWnd(event);
		}
		
		private function ShowAlertWnd(errorEvent:IOErrorEvent):void
		{
			alertHandler = Alert.show("Error while loading: "  + errorEvent, "Error",	Alert.OK);
		}
		
		public function setZipExporter(value:FZip):void
		{
			mZipLoader = value;
		}
		
		public function getZipExporter():FZip
		{
			return mZipLoader;
		}
	}
}
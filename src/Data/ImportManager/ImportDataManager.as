package Data.ImportManager
{
	import Data.DataModel;
	import Data.ExportManager.ExportDataManager;
	
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
		private var xmlData:XML;
		private var alertHandler:Alert;
		
		[Bindable]
		private var mFacts:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var mBeats:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var mLocations:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var mAgents:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var mDescriptor:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var mItems:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var mXgmls:ArrayCollection = new ArrayCollection();
		
		public var mZipLoader:FZip;
		private var mZipFile:FZipFile;

//		private var mTreeObject:XML;
		
		public function ImportDataManager()
		{
			importerFileFilter = new FileFilter("zip", "*.zip");
			importerFileReference = new FileReference();
			fileLoader = new Loader();
			
			mZipLoader = new FZip();
			mZipFile = new FZipFile();

				
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
			var factsXML:XML;
			var beatsXML:XML;
			var locationsXml:XML;
			var agentsXml:XML;
			var descriptorXml:XML;
			var itemsXml:XML;
			var xgmlsXml:XML;
			
			var xgmlTheme:XML;
			
			var treeData:Object;
			
			mZipLoader.loadBytes(importerFileReference.data);
//			setZipExporter(mZipLoader);
			DataModel.getSingleton().mFZipObject = mZipLoader;
			mZipFile = mZipLoader.getFileByName("Scenary.xml");
			
			//TreeData.json
			
			if(mZipFile)
			{
				xmlData = XML(mZipFile.content);
			}
			//parse facts
			if(mFacts)
			{
				mFacts.removeAll();
			}
			if(xmlData)
			{
				for each(var fact:XML in xmlData.facts)
				{
					factsXML = fact;	
				}
				for each(var factId:XML in factsXML.fact)
				{
					var factObject:Object = {};				
					factObject["id"] = int(factId.@id);
					factObject["description"] = String(factId.children()[0]);
//					factObject["xgmlId"] = String(factId.xgmlId);
					/*for each(var own:XML in factId.owners.children())
					{
						factObject["owners"].push(int(own.children()[0]));
					}*/
					mFacts.addItem(factObject);
				}
				DataModel.getSingleton().parseFactsData(mFacts);
				
				//parse beats data from XML
				if(mBeats)
				{
					mBeats.removeAll();
				}
				for each(var beats:XML in xmlData.beats)
				{
					beatsXML = beats;
				}
				for each(var beat:XML in beatsXML.beat)
				{
					var beatsObject:Object = {"activities":[], "preConditions":[]};	
					for each(var beatActivity:XML in beat.activities.children())
					{
						beatsObject["activities"].push(beatActivity.children()[0].toString());		
					}
					
					beatsObject["agentId"] = int(beat.agentId);
					beatsObject["description"] = String(beat.description);
					beatsObject["exclusiveBeatPriority"] = int(beat.exclusiveBeatPriority);
					beatsObject["id"] = int(beat.@id);
					beatsObject["locationId"] = int(beat.locationId);
	//				beatsObject["preConditions"] = (beat.preConditions) as Array;
					beatsObject["type"] = String(beat.type);
					beatsObject["xgmlTheme"] = String(beat.xgmlTheme);
					for each(var beatPrecondition:XML in beat.preConditions.children())
					{
						var preconditionChildren:XMLList = beatPrecondition.children();
						var preconditionObj:Object = new Object();
						preconditionObj["description"] = preconditionChildren[0].toString();
						preconditionObj["factsAvailableToUser"] = new Array();
						for each(var userFact:XML in preconditionChildren[1].children())
						{
							preconditionObj["factsAvailableToUser"].push(int(userFact.children()[0]));
						}
						preconditionObj["factsAvailableToAgent"] = new Array();
						for each(var agentFact:XML in preconditionChildren[2].children())
						{
							preconditionObj["factsAvailableToAgent"].push(int(agentFact.children()[0]));
						}
						preconditionObj["beatsCompleted"] = new Array();
						for each(var beatCompleted:XML in preconditionChildren[3].children())
						{
							preconditionObj["beatsCompleted"].push(int(beatCompleted.children()[0]));
						}
						preconditionObj["affinityMin"] = preconditionChildren[4].toString();
						preconditionObj["affinityMax"] = preconditionChildren[5].toString();
						preconditionObj["nerveMax"] = preconditionChildren[6].toString();
						preconditionObj["nerveMin"] = preconditionChildren[6].toString();				
						preconditionObj["subjects"] = new Array();
						for each(var subject:XML in preconditionChildren[7].children())
						{
							preconditionObj["subjects"].push(int(subject.children()[0]));
						}
						
						beatsObject["preConditions"].push(preconditionObj);
					}
					mBeats.addItem(beatsObject);
				}
				DataModel.getSingleton().parseBeatsData(mBeats);
				
				//parse locations
				if(mLocations)
				{
					mLocations.removeAll();
				}
				for each(var locations:XML in xmlData.locations)
				{
					locationsXml = locations;	
				}
				for each(var location:XML in locationsXml.location)
				{
					var locationObject:Object = {"adjacents":[]};				
					locationObject["id"] = int(location.@id);
					locationObject["name"] = String(location.name);
					locationObject["description"] = String(location.description[0]);
					
					for each(var adjacent:XML in location.adjacents.children())
					{
						locationObject["adjacents"].push(int(adjacent.children()[0]));
					}
					mLocations.addItem(locationObject);
				}
				DataModel.getSingleton().parseLocationsData(mLocations);
				
				//parse agents
				if(mAgents)
				{
					mAgents.removeAll();
				}
				for each(var agents:XML in xmlData.agents)
				{
					agentsXml = agents;	
				}
				for each(var agent:XML in agentsXml.agent)
				{
					var agentObject:Object = {"facts":[]};				
					var facts
					agentObject["id"] = String(agent.@id);
					agentObject["location"] = String(agent.location);
					agentObject["nerve"] = int(agent.nerve);
					agentObject["affinity"] = int(agent.affinity);
					for each(var fact:XML in agent.children())
					{
						var factChildren:XMLList = fact.children();
						var factObj:Object = new Object();
						factObj["fact"] = new Array();
//						for each(var fact:XML in factChildren[1].children())
//						{
//							factObj["fact"].push(int(fact.children()[0]));
//						}
					}

					
					mAgents.addItem(agentObject);
				}
				DataModel.getSingleton().parseAgentsData(mAgents);
				
				if(mDescriptor)
				{
					mDescriptor.removeAll();
				}
				/*for each(var s:XML in xmlData.agents)
				{
					agentsXml = agents;	
				}*/
				for each(var descriptor:XML in xmlData.descriptor)
				{
					var descriptorObject:Object = {};				
					descriptorObject["id"] = int(descriptor.@id);
					descriptorObject["scenarioId"] = String(descriptor.scenarioId);
					mDescriptor.addItem(descriptorObject);
				}
	//			DataModel.getSingleton().parseAgentsData(mAgents);
				
				//parse agents
				if(mXgmls)
				{
					mXgmls.removeAll();
				}
				for each(var xgmls:XML in xmlData.xgml)
				{
					xgmlsXml = xgmls;	
				}
				if(xgmlsXml)
				{
					for each(var xgml:XML in xgmlsXml.xgml)
					{
						var xgmlObject:Object = {};				
						xgmlObject["id"] = int(xgml.@id);
						xgmlObject["className"] = String(xgml.className);
						xgmlObject["filename"] = String(xgml.filename);
						xgmlObject["content"] = xgml.content;
						mXgmls.addItem(xgmlObject);
					}
					DataModel.getSingleton().parseXgmlsData(mXgmls);
				}
			}
			mZipFile = mZipLoader.getFileByName("TreeData.xml");
			if(mZipFile)
			{
//				treeData= mZipFile.getContentAsString(mZipFile.content);
//				mTreeObject = JSON.parse(treeData as String);
				DataModel.getSingleton().mTreeData = new XML(mZipFile.content);
			}
			
			for(var i:int; i < mZipLoader.getFileCount(); i++)
			{
				if(mZipLoader.getFileAt(i).filename == "Scenary.xml")
				{
					mZipLoader.removeFileAt(i);
				}
				if(mZipLoader.getFileAt(i).filename == "TreeData.xml")
				{
					mZipLoader.removeFileAt(i);
				}
				
			}
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
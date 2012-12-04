package Data.ImportManager
{
	import Data.DataModel;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

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
		
		private var mZipLoader:FZip;
		private var mZipFile:FZipFile;

		private var mTreeObject:Object;
		
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
			mZipFile = mZipLoader.getFileByName("Scenary_2.xml");
			xmlData = XML(mZipFile.content);//XML(importerFileReference.data);

			//TreeData.json
			mZipFile = mZipLoader.getFileByName("TreeData.json");
			treeData = mZipFile.getContentAsString(mZipFile.content);
			mTreeObject = JSON.parse(treeData as String);
//			DataModel.getSingleton().parseTreeData(mTreeObject);

			//read xgml from file...
//			mZipFile = mZipLoader.getFileByName("2_Eddy_Interrogation.xgml");
//			xgmlTheme = new XML(mZipFile.content);
//			for each(var importTheme in xgmlTheme.children())
//			{
////				trace(importTheme.@file);
//				trace(importTheme.children()[0].@name);
//			}
			
//			xmlData = XML(importerFileReference.data);
			//parse facts
			if(mFacts)
			{
				mFacts.removeAll();
			}
			for each(var fact:XML in xmlData.facts)
			{
				factsXML = fact;	
			}
			for each(var factId:XML in factsXML.fact)
			{
				var factObject:Object = {"owners":[]};				
				factObject["id"] = int(factId.@id);
				factObject["description"] = String(factId.description);
				factObject["xgmlId"] = String(factId.xgmlId);
				for each(var own:XML in factId.owners.children())
				{
					factObject["owners"].push(int(own.children()[0]));
				}
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
				
				for each(var adjacent:XML in factId.owners.children())
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
				var agentObject:Object = {};				
				agentObject["id"] = int(agent.@id);
				agentObject["name"] = String(agent.name);
				agentObject["description"] = String(agent.description);
				agentObject["nerve"] = int(agent.nerve);
				agentObject["affinity"] = int(agent.affinity);
				agentObject["locationId"] = int(agent.locationId);
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
			
			//parse items
			if(mItems)
			{
				mItems.removeAll();
			}
			for each(var items:XML in xmlData.items)
			{
				itemsXml = items;	
			}
			if(itemsXml)
			{
				for each(var item:XML in itemsXml.item)
				{
					var itemObject:Object = {"maps":[]};				
					itemObject["itemType"] = String(item.itemType);
					for each(var itemMap:XML in item.maps.children())
					{
						var mapChildren:XMLList = itemMap.children();
						var mapObj:Object = new Object();
						mapObj["placeType"] = mapChildren[0].toString();
						mapObj["placeId"] = mapChildren[1].toString();
						mapObj["count"] = mapChildren[2].toString();
						itemObject["maps"].push(mapObj);
					}
					mItems.addItem(itemObject);
				}
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
		
		private function errorHandler(event:IOErrorEvent):void
		{
			trace("Error:" + event);
			ShowAlertWnd(event);
		}
		
		private function ShowAlertWnd(errorEvent:IOErrorEvent):void
		{
			alertHandler = Alert.show("Error while loading: "  + errorEvent, "Error",	Alert.OK);
		}
	}
}
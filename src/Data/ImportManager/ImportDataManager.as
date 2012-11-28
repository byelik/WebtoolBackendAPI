package Data.ImportManager
{
	import Data.DataModel;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;

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
		
		public function ImportDataManager()
		{
			importerFileFilter = new FileFilter("XML", "*.xml");
			importerFileReference = new FileReference();
			fileLoader = new Loader();			
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
			
			
			xmlData = XML(importerFileReference.data);
			for each(var fact:XML in xmlData.facts)
			{
				factsXML = fact;	
			}
			for each(var factId:XML in factsXML.fact)
			{
				var factObject:Object = {};
				
				
//				trace(factId.@id);
				factObject["id"] = int(factId.@id);
				factObject["description"] = String(factId.description[0]);
				
				for each(var own:XML in factId.owners.owner)
				{
//					trace(own);
					factObject["owners"] = own;
				}
				mFacts.addItem(factObject);
			}
			DataModel.getSingleton().parseFactsData(mFacts);
			
			//parse beats data from XML
			for each(var beats:XML in xmlData.beats)
			{
				beatsXML = beats;
			}
			for each(var beat:XML in beatsXML.beat)
			{
				trace(beat.@id);
				var beatsObject:Object = {};
				beatsObject["activities"] = (beat.activities) as Array;
				beatsObject["agentId"] = int(beat.agentId);
				beatsObject["description"] = String(beat.description);
				beatsObject["exclusiveBeatPriority"] = int(beat.exclusiveBeatPriority);
				beatsObject["id"] = int(beat.@id);
				beatsObject["locationId"] = int(beat.locationId);
				beatsObject["preConditions"] = (beat.preConditions) as Array;
				beatsObject["type"] = String(beat.type);
				beatsObject["xgmlTheme"] = String(beat.xgmlTheme);
				for each(var beatPreconditions:XML in beat.preConditions)
				{
					trace(beatPreconditions.preConditions);
//					beatsObject["affinityMax"] = int(beatPreconditions.affinityMax);
//					beatsObject["affinityMin"] = int(beatsObject.affinityMin);
					beatsObject["preConditions"] = beatPreconditions;
					
				}
				mBeats.addItem(beatsObject);
			}
//			for each(var beats:XML in beatsXML.beats)
//			{
				
				
				
				
//				beatsObject["id"] = int(factId.@id);
//				factObject["description"] = String(factId.description[0]);
				/*for each(var own:XML in factId.owners.owner)
				{
					trace(own);
					factObject["owners"] = own;
				}*/
//				mFacts.addItem(factObject);
//			}
			DataModel.getSingleton().parseBeatsData(mBeats);
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
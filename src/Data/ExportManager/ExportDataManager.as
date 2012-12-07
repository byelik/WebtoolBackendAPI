package Data.ExportManager
{
	import Data.DataModel;
	import Data.ImportManager.ImportDataManager;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import flash.display.Loader;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import mx.collections.ArrayCollection;
	import mx.core.MXMLObjectAdapter;

	public class ExportDataManager
	{
		private var currentDate:Date;
		
		private var exportFileFilter:FileFilter;
		private var exportFileReference:FileReference;
		
		private var currentYear:uint;
		private var currentMonth:uint;
		private var currentDay:uint;
		private var currentHour:uint;
		private var currentMinutes:uint;
		private var mFileName:String;
		
		private var mXmlData:XML; 
		private var mTreeXml:XML;

		private var mImportManager:ImportDataManager;
		private var mZipExporter:FZip;
		private var mByteArrayData:ByteArray;
		public function ExportDataManager()
		{
			mXmlData = new XML();
			mTreeXml = new XML();
			mByteArrayData = new ByteArray();
			
			mImportManager = new ImportDataManager();
			mZipExporter = DataModel.getSingleton().mFZipObject;
			currentDate = new Date();
			exportFileFilter = new FileFilter("XML", "*.zip");
			exportFileReference = new FileReference();
			
			currentYear = currentDate.getFullYear();
			currentMonth = currentDate.getMonth();
			currentDay = currentDate.getDate();
			currentHour = currentDate.getHours();
			currentMinutes = currentDate.getMinutes();
			
			setFileName(currentYear + "-" + currentMonth + "-" + currentDay + "_" + currentHour + "-" + currentMinutes + ".zip");
		}
		
		public function setFileName(value:String):void
		{
			mFileName = value;
		}
		
		public function getFileName():String
		{
			return mFileName;
		}
		//FIX ME delete Scenary.xml && TreeData.xml when complete and when cancel...
		
		
		public function exportData():void
		{
			prepareXmlData();
//			var tmp:FZip = DataModel.getSingleton().mFZipObject;
			var tmpByteArray:ByteArray = new ByteArray();
			mByteArrayData.writeUTFBytes(mXmlData.toString());
			mByteArrayData.position = 0;
			mZipExporter.addFile("Scenary.xml", mByteArrayData);
			mByteArrayData.clear();
			mByteArrayData.writeUTFBytes(mTreeXml.toString());
			mZipExporter.addFile("TreeData.xml", mByteArrayData);
			mZipExporter.serialize(tmpByteArray);
			exportFileReference.save(tmpByteArray, getFileName());
		}
		
		private function prepareXmlData():void
		{
			var agentsData:ArrayCollection = DataModel.getSingleton().mAgentsList;
			var locationsData:ArrayCollection = DataModel.getSingleton().mLocationsList;
			var factsData:ArrayCollection = DataModel.getSingleton().mFactsList;
			var beatsData:ArrayCollection = DataModel.getSingleton().mBubbleBeatData;
			
			mTreeXml = DataModel.getSingleton().mTreeData;
			mXmlData =<data>
							<agents>
							</agents>
							<locations>
							</locations>
							<hints>
							</hints>
							<facts>
							</facts>
							<beats>
							</beats>
					   </data>;
			
			 //Agents
			for(var i:int = 0; i < agentsData.length; i++)
			{
				var agentNode:XML = new XML();
				agentNode = <agent id={agentsData[i].id}>
								<name>{agentsData[i].name}</name>
								<description>{agentsData[i].description}</description>
								<nerve>{agentsData[i].nerve}</nerve>
								<affinity>{agentsData[i].affinity}</affinity>
							</agent>
				mXmlData.agents.appendChild(agentNode);
//				mXmlData.agents.agent.@id = tmp[i].id;
			}
			
			//Locations
			for(var i:int = 0; i < locationsData.length; i++)
			{
				var locationNode:XML = new XML();
				var locationsAdjacents:XML = new XML();
				locationNode = <location id={locationsData[i].id}>
								<name>{locationsData[i].name}</name>
								<description>{locationsData[i].description}</description>
							   </location>
				locationsAdjacents = <adjacents/>;
				for(var k:int = 0; k < locationsData[i].adjacents.length;k++)
				{
					var adjacent:XML = new XML();
					adjacent = <adjacent>{locationsData[i].adjacents[k]}</adjacent>
					locationsAdjacents.appendChild(adjacent);
				}
				locationNode.appendChild(locationsAdjacents);
				mXmlData.locations.appendChild(locationNode);
			}
			
			//Facts
			for(var i:int = 0; i < factsData.length; i++)
			{
				
			}
			
			
			//Beats
			for(var i:int = 0; i < beatsData.length; i++)
			{
				var beatsNode:XML = new XML();
				beatsNode = <beat id = {beatsData[i].id}>
							<description>{beatsData[i].description}</description>
							<agent>{beatsData[i].agent}</agent>
							<type>{beatsData[i].type}</type>
							</beat>
			}
			
		}
	}
}
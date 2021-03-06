package Data.ExportManager
{
	import Data.DataModel;
	import Data.ImportManager.ImportDataManager;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.xml.XMLNode;
	
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

//		private var mImportManager:ImportDataManager;
		private var mZipExporter:FZip;
		
		public function ExportDataManager()
		{
			mXmlData = new XML();
			mTreeXml = new XML();
			
//			mImportManager = new ImportDataManager();
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
		
		public function exportData():void
		{
			var mByteArrayData:ByteArray = new ByteArray();
			var tmpByteArray:ByteArray = new ByteArray();
			deleteFiles(mZipExporter, "Scenary.xml");
			prepareXmlData();
			
			mByteArrayData.writeUTFBytes(mXmlData.toString());
			mZipExporter.addFile("Scenary.xml", mByteArrayData,true);
			mByteArrayData.clear();
			
			mByteArrayData.writeUTFBytes(mTreeXml.toString());
			deleteFiles(mZipExporter, "TreeData.xml");
			mZipExporter.addFile("TreeData.xml", mByteArrayData,true);
			mZipExporter.serialize(tmpByteArray);
			exportFileReference.addEventListener(Event.CANCEL, cancelSaving);
			
			exportFileReference.save(tmpByteArray, getFileName());
		}
		
		private function cancelSaving(event:Event):void
		{
			deleteFiles(mZipExporter, "Scenary.xml", "TreeData.xml");
		}
		
		private function prepareXmlData():void
		{
			for(var i:int = 0; i < DataModel.getSingleton().mAgentsList.length; i++)
			{
				DataModel.getSingleton().mAgentsList[i].items.removeAll();
				for(var k:int = 0; k < DataModel.getSingleton().mItemsData.length; k++)
				{
					if(DataModel.getSingleton().mAgentsList[i].id == DataModel.getSingleton().mItemsData[k].owner)
					{
						DataModel.getSingleton().mAgentsList[i].items.addItem({type:DataModel.getSingleton().mItemsData[k].type, count:DataModel.getSingleton().mItemsData[k].count});
					}
				}
			}
			
			for(var i:int = 0; i < DataModel.getSingleton().mLocationsList.length; i++)
			{
				DataModel.getSingleton().mLocationsList[i].items.removeAll();
				for(var k:int = 0; k < DataModel.getSingleton().mItemsData.length; k++)
				{
					if(DataModel.getSingleton().mLocationsList[i].id == DataModel.getSingleton().mItemsData[k].owner)
					{
						DataModel.getSingleton().mLocationsList[i].items.addItem({type:DataModel.getSingleton().mItemsData[k].type, count:DataModel.getSingleton().mItemsData[k].count});
					}
				}
			}
			
			
			var agentsData:ArrayCollection = DataModel.getSingleton().mAgentsList;
			var locationsData:ArrayCollection = DataModel.getSingleton().mLocationsList;
			var factsData:ArrayCollection = DataModel.getSingleton().mFactsList;
			var beatsData:ArrayCollection = DataModel.getSingleton().mBubbleBeatData;
			
//			mTreeXml = DataModel.getSingleton().mTreeData;
			
			/*mTreeXml = <node label="Folders">
							  <node label="ODN">
							         <node label="Group 1">
							                 <node label="beat 1" description="test description" id="4" x="Sun Dec 23 12:31:53 GMT+0200 2012" y="50"/>
							         </node>
							         <node label="Group 2">
							                 <node label="beat 2" description="test description" id="46" x="Thu Jan 3 19:19:30 GMT+0200 2013" y="70"/>
							         </node>
							         <node label="Group 1">
							                 <node label="beat 3" description="test description" id="5" x="Thu Dec 20 20:48:17 GMT+0200 2012" y="60"/>
							         </node>
							  </node>
							</node>
			*/
				mTreeXml = new XML();
				var odnNode:XML = new XML();
				odnNode = <node label="ODN">
					  </node>
				mTreeXml = <node label="Folders">
						  </node>
				for(var i:int = 0; i < beatsData.length; i++)
				{
					var groupNode:XML = new XML();
					groupNode = <node label="Group">
								</node>
					var node:XML = new XML();	
					node = <node label={"beat: " + beatsData[i].id}></node>
					node.@id = beatsData[i].id;
					node.@x = beatsData[i].beatPosX;
					node.@y = beatsData[i].beatPosY;
					groupNode.appendChild(node);
					odnNode.appendChild(groupNode);	
				}
				
				mTreeXml.appendChild(odnNode);
				
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
				var agentFacts:XML = new XML();
				var agentItems:XML = new XML();
				agentNode = <agent id={agentsData[i].id}>
								<location>{agentsData[i].location}</location>
								<nerve>{agentsData[i].nerve}</nerve>
								<affinity>{agentsData[i].affinity}</affinity>
							</agent>
				agentFacts = <facts/>
				agentItems = <items/>
				for(var k:int = 0; k < agentsData[i].facts.length;k++)
				{
					var fact:XML = new XML();
					fact = <fact id ={agentsData[i].facts[k].id} status={agentsData[i].facts[k].status}></fact>
					agentFacts.appendChild(fact);
				}
				agentNode.appendChild(agentFacts);	
				for(var k:int = 0; k < agentsData[i].items.length;k++)
				{
					var item:XML = new XML();
					item = <item> 
							<type>{agentsData[i].items[k].type}</type>
							<count>{agentsData[i].items[k].count}</count>
						  </item>
					agentItems.appendChild(item);
				}
				agentNode.appendChild(agentItems);
				
				mXmlData.agents.appendChild(agentNode);
//				mXmlData.agents.agent.@id = tmp[i].id;
			}
			
			//Locations
			for(var i:int = 0; i < locationsData.length; i++)
			{
				var locationNode:XML = new XML();
				var locationsAdjacents:XML = new XML();
				var locationItems:XML = new XML();
				locationNode = <location id={locationsData[i].id}>
							   </location>
				locationsAdjacents = <adjacents/>;
				for(var k:int = 0; k < locationsData[i].adjacents.length;k++)
				{
					var adjacent:XML = new XML();
					adjacent = <adjacent>{locationsData[i].adjacents[k]}</adjacent>
					locationsAdjacents.appendChild(adjacent);
				}
				locationNode.appendChild(locationsAdjacents);
				
				locationItems = <items/>
				for(var k:int = 0; k < locationsData[i].items.length;k++)
				{
					var item:XML = new XML();
					item = <item> 
							<type>{locationsData[i].items[k].type}</type>
							<count>{locationsData[i].items[k].count}</count>
						  </item>
					locationItems.appendChild(item);
				}
				locationNode.appendChild(locationItems);
				
				mXmlData.locations.appendChild(locationNode);
			}
			
			//Facts
			for(var i:int = 0; i < factsData.length; i++)
			{
				var factsNode:XML = new XML();
				factsNode = <fact id ={factsData[i].id}>
							{factsData[i].description}
							</fact>
				mXmlData.facts.appendChild(factsNode);
			}
			
			
			//Beats
			for(var i:int = 0; i < beatsData.length; i++)
			{
				var beatsNode:XML = new XML();
				var beatsThemes:XML = new XML();
				var completedBeats:XML = new XML();
				var preCondition:XML = new XML();
				var beatsActivities:XML = new XML();
				beatsNode = <beat id = {beatsData[i].id}>
							<description>{beatsData[i].description}</description>
							<agent>{beatsData[i].agent}</agent>
							<type>{beatsData[i].type}</type>
							<exclusiveBeatPriority>{beatsData[i].exclusiveBeatPriority}</exclusiveBeatPriority>
							</beat>
				beatsThemes = <themes/>
				completedBeats = <completedBeats/>
				preCondition = <preCondition/>
				beatsActivities = <activities/>	
				//for(var k:int = 0; k < beatsData[i].xgmlTheme.length;k++)
				//{
					var theme:XML = new XML();
					theme = <theme>{beatsData[i].xgmlTheme}</theme>
					beatsThemes.appendChild(theme);
				//}
				beatsNode.appendChild(beatsThemes);	
				
				for(var k:int = 0; k < beatsData[i].beatsCompleted.length;k++)
				{
					var beatCompleted:XML = new XML();
					beatCompleted = <beat>{beatsData[i].beatsCompleted[k]}</beat>
					completedBeats.appendChild(beatCompleted);
				}
				beatsNode.appendChild(completedBeats);
				
				for(var k:int = 0; k < beatsData[i].preConditions.length; k++)
				{
					preCondition = <preCondition>
								   {beatsData[i].preConditions}
								   </preCondition>
				}
				beatsNode.appendChild(preCondition);
				
				
				for(var k:int = 0; k < beatsData[i].activities.length;k++)
				{
					var activity:XML = new XML();
					activity = <activity>{beatsData[i].activities[k]}</activity>
					beatsActivities.appendChild(activity);
				}
				beatsNode.appendChild(beatsActivities);
				
				mXmlData.beats.appendChild(beatsNode);
			}
			
		}
		
		public static function deleteFiles(fZip:FZip, scenaryFileName:String = null, treeDataFileName:String = null):void
		{
			for(var i:int; i < fZip.getFileCount(); i++)
			{
				if((fZip.getFileAt(i).filename == treeDataFileName) ||(fZip.getFileAt(i).filename == scenaryFileName))
				{
					fZip.removeFileAt(i);
				}
			}
		}
	}
}
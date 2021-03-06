package HostComponents.BeatsHostComponent
{
	
	import Constants.Const;
	
	import Data.DataModel;
	
	import Manager.EventManager;
	
	import Skins.BeatsSkin.SearchComponent;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.charts.BubbleChart;
	import mx.charts.events.ChartItemEvent;
	import mx.charts.series.BubbleSeries;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.events.CloseEvent;
	import mx.events.EffectEvent;
	import mx.managers.IFocusManagerComponent;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.BorderContainer;
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.effects.Resize;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	
	
	public class BeatsHostComponent extends SkinnableComponent
	{
		/*[SkinPart(required="true")]
		public var mAgentList:DropDownList;*/
		
		[SkinPart(required="true")]
		public var mBeatsTree:Tree;
		
		[SkinPart(required="true")]
		public var mBeatDescriptionField:TextArea;
		
		[SkinPart(required="true")]
		public var mChooseAgentList:DropDownList;
		
		[SkinPart(required="true")]
		public var mBeatTheme:DropDownList;
		
		/*[SkinPart(required="true")]
		public var mLocationList:DropDownList;*/
		
		[SkinPart(required="true")]
		public var mTypeList:DropDownList;
		
		[SkinPart(required="true")]
		public var mPriorityField:TextInput;
		
		[SkinPart(required="true")]
		public var mActivitiesList:TextArea;
		
		/*[SkinPart(required="true")]
		public var mPreconditionsDescriptionField:TextArea;*/
		
//		[SkinPart(required="true")]
//		public var mFactsKnownToUser:DataGrid;
		
//		[SkinPart(required="true")]
//		public var mFactsKnownToAgent:DataGrid;
		
		[SkinPart(required="true")]
		public var mBeatsCompletedField:TextInput;
		
		/*[SkinPart(required="true")]
		public var mAffinityMinField:TextInput;*/
		
		/*[SkinPart(required="true")]
		public var mAffinityMaxField:TextInput;*/
		
		/*[SkinPart(required="true")]
		public var mNerveMinField:TextInput;*/
		
		/*[SkinPart(required="true")]
		public var mNerveMaxField:TextInput;*/
		
		[SkinPart(required="true")]
		public var mSave:Button;
		
		[SkinPart(required="true")]
		public var mDelete:Button;
		
		[SkinPart(required="true")]
		public var mTreeStateBtn:ToggleButton;
		
		[SkinPart(required="true")]
		public var mTreeBorderContainer:BorderContainer;
		
		[SkinPart(required="true")]
		public var showBeatsTree:Resize;
		
		[SkinPart(required="true")]
		public var hideBeatsTree:Resize;
		
		[SkinPart(required="false")]
		public var mSearchField:SearchComponent;
		
		[SkinPart(required="true")]
		public var mRefreshSearch:Button;
		
		[SkinPart(required="true")]
		public var mBeatChart:BubbleChart;
		
		[SkinPart(required="true")]
		public var mBeatSeries:BubbleSeries;
		
		[SkinPart(required="true")]
		public var mAddBeat:Button;
		
		[SkinPart(required="true")]
		public var mBubbleCanvas:Canvas;
		
		[SkinPart]
		public var mPreconditionsFunction:TextArea;
		
		private var mComponent:IFocusManagerComponent;
		private var firstTextElement:String;
		
		[Bindable]
		public var beatTypeList:ArrayCollection; 
		
		[Bindable]
		public var mBeatVariables:ArrayCollection;
		
		private var dataSortField:SortField;
		private var dataSort:Sort;
		

		
		public var treeContextMenu:ContextMenu;
		
		private var groupId:int;
		
		[Bindable]
		public var mFacts:ArrayCollection;
		
		
		[Bindable]
		public var mBeatsData:ArrayCollection;
		
		[Bindable]
		public var mBeatRadius:String = "30";
		
		[Bindable]
		public var mBeatsListData:ArrayCollection = DataModel.getSingleton().mBeatsList;
		
		[Bindable]
		public var mSelectedUsersFacts:Vector.<Object> = new Vector.<Object>;
		
		[Bindable]
		private var mSelectedAgentFacts:Vector.<Object> = new Vector.<Object>;
		
		private var mSelectedBeatOnGraph:Object;
		
		private var mSelectedBeatsId:ArrayCollection;
		
		[Bindable]
		public var mBeatContextMenu:ContextMenu;
		
		[Bindable]
		public var mAgentThemes:ArrayCollection = new ArrayCollection();
		
		private var mBeatConnection:Canvas;
		
		[Bindable]
		public var mBeatBuffer:ArrayCollection;
		
		public function BeatsHostComponent()
		{
			super();
			mBeatBuffer = new ArrayCollection();
			mBeatConnection = new Canvas();
			mSelectedBeatsId = new ArrayCollection();
			mBeatsData = DataModel.getSingleton().mBeatsList;
			
			beatTypeList = new ArrayCollection(["exclusive", "normal", "repeated"]);
			mBeatVariables = new ArrayCollection();
			dataSortField = new SortField();
			
			dataSort = new Sort();
			sortBeatTypeList();
			
			treeContextMenu = new ContextMenu();
			treeContextMenu.hideBuiltInItems();
			
			
			
			var addGroupMenuItem:ContextMenuItem = new ContextMenuItem("Add Group");
			treeContextMenu.customItems.push(addGroupMenuItem);
			addGroupMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addGroupMenuEvent);
			
			var cutMenuItem:ContextMenuItem = new ContextMenuItem("Cut item");
			treeContextMenu.customItems.push(cutMenuItem);
			cutMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cutMenuEvent);
			
			var copyMenuItem:ContextMenuItem = new ContextMenuItem("Copy item");
			treeContextMenu.customItems.push(copyMenuItem);
			copyMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, copyMenuEvent);
			
			var deleteMenuItem:ContextMenuItem = new ContextMenuItem("Delete item");
			deleteMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteMenuEvent);
			
			var pasteMenuItem:ContextMenuItem = new ContextMenuItem("Paste item");
			pasteMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, pasteMenuEvent);
			
			var renameMenuItem:ContextMenuItem = new ContextMenuItem("Rename item");
			renameMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, renameMenuEvent);
			
			treeContextMenu.customItems.push(addGroupMenuItem);
			treeContextMenu.customItems.push(cutMenuItem);
			treeContextMenu.customItems.push(copyMenuItem);
			treeContextMenu.customItems.push(deleteMenuItem);
			treeContextMenu.customItems.push(pasteMenuItem);
			treeContextMenu.customItems.push(renameMenuItem);
			
//			treeContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, getSelectedElement);
			
			var addBeatContextMenuItem:ContextMenuItem = new ContextMenuItem("Add Beat");
			addBeatContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addBeatContextMenuHandler);
			
			var cutBeatContextMenuItem:ContextMenuItem = new ContextMenuItem("Cut Beat");
			cutBeatContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cutBeatContextMenuHandler);
			
			var copyBeatContextMenuItem:ContextMenuItem = new ContextMenuItem("Copy Beat");
			copyBeatContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, copyBeatContextMenuHandler);
			
			var deleteBeatContextMenuItem:ContextMenuItem = new ContextMenuItem("Delete Beat");
			deleteBeatContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteBeatContextMenuHandler);
			
			var pasteBeatContextMenuItem:ContextMenuItem = new ContextMenuItem("Paste Beat");
			pasteBeatContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, pasteBeatContextMenuHandler);
			
			var renameBeatContextMenuItem:ContextMenuItem = new ContextMenuItem("Rename Beat");
			renameBeatContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, renameBeatContextMenuHandler);
			
			
			
			mBeatContextMenu = new ContextMenu();
			mBeatContextMenu.hideBuiltInItems();
			mBeatContextMenu.customItems.push(addBeatContextMenuItem);
			mBeatContextMenu.customItems.push(cutBeatContextMenuItem);
			mBeatContextMenu.customItems.push(copyBeatContextMenuItem);
			mBeatContextMenu.customItems.push(deleteBeatContextMenuItem);
			mBeatContextMenu.customItems.push(pasteBeatContextMenuItem);
			mBeatContextMenu.customItems.push(renameBeatContextMenuItem);
			
			
			mFacts = DataModel.getSingleton().mFactsList;
			EventManager.getSingleton().addEventListener(EventManager.STOP_DRAG_BEAT, drawBeatConnection);
		}
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			switch(partName)
			{
				/*case "mAgentList":
					mAgentList.addEventListener(Event.CHANGE, selectAgent);
				break;*/
				case "mChooseAgentList":
					mChooseAgentList.addEventListener(Event.CHANGE, chooseAgent);
				break;
				/*case "mLocationList":
					mLocationList.addEventListener(Event.CHANGE, selectLocation);
				break;*/
				case "mTypeList":
					mTypeList.addEventListener(Event.CHANGE, selectType);
				break;
				case "mSave":
					mSave.addEventListener(MouseEvent.CLICK, saveData);
				break;
				case "mDelete":
					mDelete.addEventListener(MouseEvent.CLICK, deleteBeat);
				break;
				case "mTreeStateBtn":
					mTreeStateBtn.addEventListener(MouseEvent.CLICK, treeStateEvent);
				break;
				case "showBeatsTree":
					showBeatsTree.addEventListener(EffectEvent.EFFECT_END, showBeatsTreeEvent);
				break;
				case "hideBeatsTree":
					hideBeatsTree.addEventListener(EffectEvent.EFFECT_START, hideBeatsTreeEvent);
				break;
				case "mSearchField":
					mSearchField.mSearchInputField.addEventListener(TextOperationEvent.CHANGE, seacrhEvent);
				break;
				case "mRefreshSearch":
					mRefreshSearch.addEventListener(MouseEvent.CLICK, refreshSearch);
				break;
				case "mAddBeat":
					mAddBeat.addEventListener(MouseEvent.CLICK, addBeat);
				break;
				case "mBeatChart":
					mBeatChart.addEventListener(ChartItemEvent.ITEM_CLICK, selectBeatOnGraph);
				break;
				case "mBeatsCompletedField":
					mBeatsCompletedField.addEventListener(TextOperationEvent.CHANGE, setCompletedBeats);
				break;
				case "mBeatDescriptionField":
					mBeatDescriptionField.addEventListener(TextOperationEvent.CHANGE, setBeatDescription);
				break;
				case "mPriorityField":
					mPriorityField.addEventListener(TextOperationEvent.CHANGE, checkPriorityValue);
				break;
				case "mBeatTheme":
					mBeatTheme.addEventListener(Event.CHANGE, selectBeatTheme);
				break;
				case "mActivitiesList":
					mActivitiesList.addEventListener(TextOperationEvent.CHANGE, setBeatActivities);
				break;
				case "mPreconditionsFunction":
					mPreconditionsFunction.addEventListener(TextOperationEvent.CHANGE, setBeatPrecondition);
				break;
				default:
					//default
				break;
			}
		}		
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
			switch(partName)
			{
				case "mChooseAgentList":
					mChooseAgentList.removeEventListener(Event.CHANGE, chooseAgent);
				break;
				case "mTypeList":
					mTypeList.removeEventListener(Event.CHANGE, selectType);
				break;
				case "mSave":
					mSave.removeEventListener(MouseEvent.CLICK, saveData);
				break;
				case "mDelete":
					mDelete.removeEventListener(MouseEvent.CLICK, deleteBeat);
				break;
				case "mTreeStateBtn":
					mTreeStateBtn.removeEventListener(MouseEvent.CLICK, treeStateEvent);
				break;
				case "showBeatsTree":
					showBeatsTree.removeEventListener(EffectEvent.EFFECT_END, showBeatsTreeEvent);
				break;
				case "hideBeatsTree":
					hideBeatsTree.removeEventListener(EffectEvent.EFFECT_START, hideBeatsTreeEvent);
				break;
				case "mSearchField":
					mSearchField.mSearchInputField.removeEventListener(TextOperationEvent.CHANGE, seacrhEvent);
				break;
				case "mRefreshSearch":
					mRefreshSearch.removeEventListener(MouseEvent.CLICK, refreshSearch);
				break;
				case "mAddBeat":
					mAddBeat.addEventListener(MouseEvent.CLICK, addBeat);
				break;
				case "mBeatChart":
					mBeatChart.removeEventListener(ChartItemEvent.ITEM_CLICK, selectBeatOnGraph);
				break;
				case "mBeatsCompletedField":
					mBeatsCompletedField.removeEventListener(TextOperationEvent.CHANGE, setCompletedBeats);
				break;
				case "mBeatDescriptionField":
					mBeatDescriptionField.removeEventListener(TextOperationEvent.CHANGE, setBeatDescription);
				break;
				case "mPriorityField":
					mPriorityField.removeEventListener(TextOperationEvent.CHANGE, checkPriorityValue);
				break;
				case "mBeatTheme":
					mBeatTheme.removeEventListener(Event.CHANGE, selectBeatTheme);
				break;
				case "mActivitiesList":
					mActivitiesList.removeEventListener(TextOperationEvent.CHANGE, setBeatActivities);
				break;
				case "mPreconditionsFunction":
					mPreconditionsFunction.removeEventListener(TextOperationEvent.CHANGE, setBeatPrecondition);
				break;
				default:
					//default
				break;
			}
		}
		
		private function chooseAgent(event:IndexChangeEvent):void
		{
			if(mSelectedBeatOnGraph)
			{
				if(DataModel.getSingleton().mThemesList)
				{
					DataModel.getSingleton().mThemesList.removeAll();	
				}
				for(var i:int = 0; i < DataModel.getSingleton().mBubbleBeatData.length; i++)
				{
					if(mSelectedBeatOnGraph.id == DataModel.getSingleton().mBubbleBeatData[i].id)
					{
						DataModel.getSingleton().mBubbleBeatData[i].agent = mChooseAgentList.selectedItem.id;
						for(var j:int = 0; j < DataModel.getSingleton().mAgentThemesList.length; j++)
						{
							if(DataModel.getSingleton().mBubbleBeatData[i].agent == DataModel.getSingleton().mAgentThemesList[j].agentName)
							{
								DataModel.getSingleton().mThemesList.addAll(new ArrayCollection(DataModel.getSingleton().mAgentThemesList[j].themes));
//								DataModel.getSingleton().mThemesList.addItem(DataModel.getSingleton().mAgentThemesList[j].themes);
								break;
							}
						}
					}
				}
			}
//			var tmp:ArrayCollection = DataModel.getSingleton().mThemesList; 
		}
			
		private function selectType(event:IndexChangeEvent):void
		{
			if(mSelectedBeatOnGraph)
			{
				for(var i:int = 0; i < DataModel.getSingleton().mBubbleBeatData.length; i++)
				{
					if(mSelectedBeatOnGraph.id == DataModel.getSingleton().mBubbleBeatData[i].id)
					{
						DataModel.getSingleton().mBubbleBeatData[i].type = mTypeList.selectedItem;
					}
				}
			}
		}
		
		private var isPriorityOk:Boolean;
		private var isMinAffinityOk:Boolean;
		private var isMaxAffinityOk:Boolean;
		private var isMinNerveOk:Boolean;
		private var isMaxNerveOk:Boolean;
		
		private function saveData(event:MouseEvent):void
		{
			trace(mSelectedBeatOnGraph.activties);
			//save data...
//			checkPriorityValue();
			
//			var selectedUserFacts:ArrayCollection = new ArrayCollection();
//			var selectedAgentFacts:ArrayCollection = new ArrayCollection(); 
				
			//disable server
//			new HttpServiceManager('{"method":"beats.updateBeat","params":[{"id":"'+mBeatsTree.selectedItem.id+'","description":"'+mBeatDescriptionField.text+'","agentId":"'+mBeatsTree.selectedItem.agentId+'","locationId":"'+mLocationList.selectedItem.id+'","type":"'+mTypeList.selectedItem+'","xgmlTheme":"'+mBeatTheme.selectedItem.xgmlTheme+'","activities":["Find(steve)","StartDialog(steve, Lets flirt with me!)","CompleteBeat(Jessica_flirt)"],"exclusiveBeatPriority":"'+mPriorityField.text+'"}],"jsonrpc":"2.0","id":21}', updateBeatResult);
//			new HttpServiceManager('{"method":"beats.updateBeatPrecondition","params":["'+mBeatsTree.selectedItem.id+'",{"description":"","factsAvailableToUser":['+selectedUserFacts+'],"factsAvailableToAgent":['+selectedAgentFacts+'],"beatsCompleted":['+mBeatsCompletedField.text+'],"affinityMin":"'+mAffinityMinField.text+'","affinityMax":"'+mAffinityMaxField.text+'","nerveMin":"'+mNerveMinField.text+'","nerveMax":"'+mNerveMaxField.text+'"}],"jsonrpc":"2.0","id":24}', updateBeatPreconditions);
		}
		
		private function updateBeatResult(result:Object):void
		{
			if(result == null)
			{
				//good
			}
			else
			{
				//error
			}
		}
		
		private function updateBeatPreconditions(result:Object):void
		{
			if(result == null)
			{
				//good
			}
			else
			{
				//error
			}
				
		}
		
		//FIX ME call if beat(s) is was selected...
		private function deleteBeat(event:MouseEvent):void
		{
			deleteBeatWindow();
		}
		
		private function deleteBeatWindow():void
		{
			Alert.yesLabel = "Да";
			Alert.noLabel = "Нет";
			Alert.show("Вы действительно хотите удалить выбранные биты?", "Удаление бита", Alert.YES | Alert.NO, this, deleteBeatHandler);
		}
		
		private function deleteBeatHandler(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				if(mSelectedBeatsId == mSelectedBeatOnGraph.id)
				{
					if(mBeatChart.selectedChartItem)
					{
						DataModel.getSingleton().mBubbleBeatData.removeItemAt(mBeatChart.selectedChartItem.index);
						DataModel.getSingleton().mBubbleBeatData.enableAutoUpdate();
						DataModel.getSingleton().mBubbleBeatData.refresh();
					}
				}	
			}
		}
		
		private function treeStateEvent(event:MouseEvent):void
		{
			if(mTreeStateBtn.selected)
			{
				hideBeatsTree.end(); hideBeatsTree.play();
			}
			else
			{
				showBeatsTree.end(); showBeatsTree.play();
			}
				
		}
		
		private function showBeatsTreeEvent(event:EffectEvent):void
		{
			mBeatsTree.visible = true;
			mBeatsTree.includeInLayout = true;
		}
		
		private function hideBeatsTreeEvent(event:EffectEvent):void
		{
			mBeatsTree.visible = false;
			mBeatsTree.includeInLayout = false;
		}
		
		/**/
		
		/*private function expandParents(xmlNode:XML):void
		{
			while (xmlNode.parent() != null)
			{  
				xmlNode = xmlNode.parent();
				mBeatsTree.expandItem(xmlNode,true, false);
			}
		}//expandParents
		
		//uses e4x to find a node, then calls expand parents to make it visible,
		//then selects it      
		private function findNodeById(sId:String):void
		{
			var xmllistDescendants:XMLList  = DataModel.getSingleton().mTreeData.descendants().(@label == sId);
			expandParents(xmllistDescendants[0]);
			mBeatsTree.selectedItem = xmllistDescendants[0];
		}*/
		
		[Bindable]
		private var searchResult:*;
		private var searchResultIndex:uint = 0;

		private function findByName(value:String):void
		{
			var searchStr:String = mSearchField.mSearchInputField.text;
			mBeatsTree.expandChildrenOf(DataModel.getSingleton().mTreeData[0], false);
			searchResult = DataModel.getSingleton().mTreeData.node.(@label.toLowerCase().search(searchStr.toLowerCase()) > -1);
			searchResultIndex = 0;
			if (searchResult[searchResultIndex] != null)
			{
				expandNode(searchResult[searchResultIndex]);
			}
			else
			{
				Alert.show("Ошибка в запросе", "Ошибка", Alert.OK);
			}
		}
		private function expandNode(xmlNode:XML):void
		{
			while (xmlNode.parent() != null) {
				xmlNode = xmlNode.parent();
				mBeatsTree.expandItem(xmlNode, true, false);
				mBeatsTree.selectedItem = searchResult[searchResultIndex];
			}
		}
		
		
		
		
		/**/
		
		
		
		
		
		
		private function seacrhEvent(event:TextOperationEvent):void
		{
			findByName(mSearchField.mSearchInputField.text);
			/*for(var i:int = 0; i < beatTypeList.length; i++)
			{
				if(mSearchField.mSearchInputField.text == beatTypeList[i].substr(0,3))
				{
					trace("search is work");
					if(mSearchField.mSearchMatch.length <=7)
					{
						mSearchField.mSearchMatch.addItem(mSearchField.mSearchInputField.text);
					}
				}
				if(mSearchField.mSearchInputField.text.length == 0)
				{
					mSearchField.mSearchMatch.removeAll();
				}
			}*/
		}
		
		private function refreshSearch(event:MouseEvent):void
		{
			
//			findNodeById(mSearchField.mSearchInputField.text);
			
			//refresh search...
			//close search tree... and show beats tree
			mSearchField.mSearchInputField.text = "";
			if(mSearchField)
			{
				mSearchField.mSearchMatch.removeAll();
			}
//			open all nodes...
//			mBeatsTree.openItems = DataModel.getSingleton().mTreeData..node;
			
//			close all nodes...
//			mBeatsTree.openItems = [];
		}
		
		/*private function getSelectedElement(event:ContextMenuEvent):void
		{
			trace("Event: " + event);
			mBeatsTree.selectedIndex = tmp;
			
		}*/
		/*private var tmp:int;
		private function rollOverTreeItem(event:ListEvent):void
		{
			tmp = mBeatsTree.dataProvider.getItemIndex(event.itemRenderer.data);

//			trace(mBeatsTree.selectedIndex);
//			var renderer:IListItemRenderer = mBeatsTree.indexToItemRenderer(event.rowIndex);
//			trace(renderer);
		}*/
		
		/*private function treeItemClick(event:ListEvent):void
		{
			trace(event);
		}*/
		
		private function addBeat(event:MouseEvent):void
		{
			addBeatHandler();
		}
		
		//FIX ME change creation of object...
		private function addBeatHandler():void
		{
//			new HttpServiceManager('{"method":"beats.addBeat","params":[{}],"jsonrpc":"2.0","id":7}', addBeatResult);
			var beatIdList:Array = new Array();
			var beatId:int = 1;
			if(DataModel.getSingleton().mBubbleBeatData.length > 1)
			{
				for(var i:int = 0; i < DataModel.getSingleton().mBubbleBeatData.length; i++)
				{
					beatIdList.push(DataModel.getSingleton().mBubbleBeatData[i].id);
				}
				
				beatIdList.sort(Array.NUMERIC);
				beatId += beatIdList[beatIdList.length - 1];
				trace(beatId);
				//			mBeatsData.addItem(result);
				
				var tmp:Object={beatPosX:new Date(new Date().time + Const.millisecondsPerDay * Math.random()*40), beatPosY:20, beatRadius:40};
				
				tmp["beatId"] = beatId;
				tmp["description"] = "";
				tmp["beatsCompleted"] = "";
				tmp["preConditions"] = "";
				tmp["activities"] = "";
				tmp["agent"] = "";
				tmp["exclusiveBeatPriority"] = "";
				tmp["id"] = beatId;
				tmp["locationId"] = "";
				tmp["type"] = "normal";
				tmp["xgmlTheme"] = "";
				tmp["beatPosY"] = Math.random() * 50;
				
				DataModel.getSingleton().mBubbleBeatData.addItem(tmp);
				var tp:ArrayCollection = DataModel.getSingleton().mBubbleBeatData;
				focusManager.setFocus(mBeatDescriptionField);
			}
		}
		
		private function selectBeatOnGraph(event:ChartItemEvent):void
		{
			event.stopImmediatePropagation();
			mSelectedBeatOnGraph = event.hitData.item;
			if(mSelectedBeatsId)
			{
				mSelectedBeatsId.removeAll();
			}
			for(var i:int = 0; i < event.currentTarget.selectedChartItems.length; i ++)
			{
				mSelectedBeatsId.addItem(event.currentTarget.selectedChartItems[i].item.beatId);
			}
			
			if(mSelectedBeatOnGraph)
			{
				mBeatDescriptionField.text = mSelectedBeatOnGraph.description;
				mPriorityField.text = mSelectedBeatOnGraph.exclusiveBeatPriority;
				mTypeList.selectedItem = mSelectedBeatOnGraph.type;
				mActivitiesList.text = mSelectedBeatOnGraph.activities;
				mBeatsCompletedField.text = mSelectedBeatOnGraph.beatsCompleted;
				mBeatTheme.selectedItem = mSelectedBeatOnGraph.xgmlTheme;
				mPreconditionsFunction.text = mSelectedBeatOnGraph.preConditions;
				/*for(var i:int = 0; i < mBeatsListData.length; i ++)
				{
					if(mSelectedBeatOnGraph.xgmlTheme == mBeatsListData[i].xgmlTheme)
					{
						mBeatTheme.selectedItem = mBeatsListData[i];
					}
				}*/
				if(DataModel.getSingleton().mThemesList)
				{
					DataModel.getSingleton().mThemesList.removeAll();	
				}
				for(var i:int = 0; i < DataModel.getSingleton().mBubbleBeatData.length; i++)
				{
					if(mSelectedBeatOnGraph.id == DataModel.getSingleton().mBubbleBeatData[i].id)
					{
						for(var j:int = 0; j < DataModel.getSingleton().mAgentThemesList.length; j++)
						{
							if(DataModel.getSingleton().mBubbleBeatData[i].agent == DataModel.getSingleton().mAgentThemesList[j].agentName)
							{
								DataModel.getSingleton().mThemesList.addAll(new ArrayCollection(DataModel.getSingleton().mAgentThemesList[j].themes));
//								DataModel.getSingleton().mThemesList.addItem(DataModel.getSingleton().mAgentThemesList[j].themes);
								break;
							}
						}
					}
				}
				
				
				
				
				
				
				
				
				var agentsData:ArrayCollection = DataModel.getSingleton().mAgentsList;
				for(var j:int = 0; j < agentsData.length; j ++)
				{
					if(mSelectedBeatOnGraph.agent == agentsData[j].id)
					{
						mChooseAgentList.selectedIndex = j;
						break;
					}
					else
					{
						mChooseAgentList.selectedIndex = -1;
					}
				}
			}
		}
		
		
		private function setCompletedBeats(event:TextOperationEvent):void
		{
			if(mSelectedBeatOnGraph)
			{
				var str:String = mBeatsCompletedField.text.toString();
				var tmpArr:Array = str.split(",");
				mSelectedBeatOnGraph.beatsCompleted = tmpArr;
			}
		}
		//FIX ME: refresh text via input...
		private function setBeatDescription(event:TextOperationEvent):void
		{
			if(mSelectedBeatOnGraph)
			{
				for(var i:int = 0; i < DataModel.getSingleton().mBubbleBeatData.length; i++)
				{
					if(mSelectedBeatOnGraph.id == DataModel.getSingleton().mBubbleBeatData[i].id)
					{
						DataModel.getSingleton().mBubbleBeatData[i].description = mBeatDescriptionField.text;
						mSelectedBeatOnGraph.description = DataModel.getSingleton().mBubbleBeatData[i].description;						
					}
				}
				 
			}
		}
		
		
		private function addGroupMenuEvent(event:ContextMenuEvent):void
		{
			groupId++;
			var treeGroupNode:XML = new XML();
			treeGroupNode = <node label="Group:">{"Group: " + groupId}</node>;
			if(mBeatsTree.selectedItem != null)
			{
				mBeatsTree.selectedItem.appendChild(treeGroupNode);
			}
		}
		
		private function cutMenuEvent(event:ContextMenuEvent):void
		{
			trace("cut event");
			if(mBeatsTree.selectedItems)
			{
				mBeatsTreeItemsBuffer = mBeatsTree.selectedItem;
				var deleteNode:XML = mBeatsTree.selectedItem as XML;
				mBeatsTree.selectedItem = deleteNode.parent();
				delete mBeatsTree.selectedItem.node[deleteNode.childIndex()];
			}
		}
		var mBeatsTreeItemsBuffer:*;
		private function copyMenuEvent(event:ContextMenuEvent):void
		{
			
			if(mBeatsTree.selectedItems)
			{
				mBeatsTreeItemsBuffer = new XML(mBeatsTree.selectedItem.toString());
			}
		}
		
		private function deleteMenuEvent(event:ContextMenuEvent):void
		{
			Alert.yesLabel = "Да";
			Alert.noLabel = "Нет";
			Alert.show("Вы действительно хотите удалить выбранные уровни?", "Внимание", Alert.YES | Alert.NO, null, deleteBeatLevelHandler);
		}
		
		private function deleteBeatLevelHandler(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				
				var deleteNode:XML = mBeatsTree.selectedItem as XML;
				var children:XMLList = XMLList(deleteNode.parent()).children();
				for (var i:Number=0; i < children.length(); i++) 
				{
					delete children[i];

				}
			}
		}
		
		private function pasteMenuEvent(event:ContextMenuEvent):void
		{
//			var treeGroupNode:XML = new XML();
//			treeGroupNode = <node label="Group:">{"Group: " + groupId}</node>;
			if(mBeatsTree.selectedItem != null)
			{
				mBeatsTree.selectedItem.appendChild(mBeatsTreeItemsBuffer);
			}
		}
		
		private function renameMenuEvent(event:ContextMenuEvent):void
		{
			trace("rename event" + mBeatsTree.selectedItem);
			mBeatsTree.editable = true;
			mBeatsTree.editedItemPosition = {columnIndex:0, rowIndex:mBeatsTree.selectedIndex};
		}
		
		//TODO: if beat.type == exclusive do not enter excluSiveBeatPriority 
		private function checkPriorityValue(event:TextOperationEvent):void
		{
			firstTextElement = mPriorityField.text.substring(0,1);
			if(mSelectedBeatOnGraph)
			{
				if(!checkValue(firstTextElement, mPriorityField))
				
				{
					Alert.show(Const.ERROR_INPUT_PROIRITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
					mComponent = mPriorityField;
				}
				else
				{
					for(var i:int = 0; i < DataModel.getSingleton().mBubbleBeatData.length; i++)
					{
						if(mSelectedBeatOnGraph.id == DataModel.getSingleton().mBubbleBeatData[i].id)
						{
							DataModel.getSingleton().mBubbleBeatData[i].exclusiveBeatPriority = mPriorityField.text;
						}
					}
				}
			}
		}		
		
		private function selectBeatTheme(event:IndexChangeEvent):void
		{
			if(mSelectedBeatOnGraph)
			{
				mSelectedBeatOnGraph.xgmlTheme = mBeatTheme.selectedItem;
			}
		}
		
		private function setBeatActivities(event:TextOperationEvent):void
		{
			if(mSelectedBeatOnGraph)
			{
				var str:String = mActivitiesList.text.toString();
				var tmpArr:Array = str.split(",");
				mSelectedBeatOnGraph.activities = tmpArr;	
			}
			
		}
		
		private function setBeatPrecondition(event:TextOperationEvent):void
		{
			if(mSelectedBeatOnGraph)
			{
				mSelectedBeatOnGraph.preConditions = mPreconditionsFunction.text;
			}
		}
		
		private function checkValue(str:String, txtField:TextInput):Boolean
		{
			if(parseInt(str) == 0 && txtField.text.length > 1 || parseInt(txtField.text) > Const.MAX_VALUE || txtField.text == Const.EMPTY_STRING)	
			{
				return false;
			}
			return true;
		}
		
		private function alertHandler(event:CloseEvent):void
		{
			if(event.detail == Alert.OK)
			{
				focusManager.setFocus(mComponent);
			}
		}
		
		private function sortBeatTypeList():void
		{
			
			dataSort.fields = [dataSortField];
			
			beatTypeList.sort = dataSort;
			beatTypeList.refresh();
		}
				
		public function drawBeatConnection(event:Event):void
		{
//			var beatContainer:UIComponent = new UIComponent();
			
			mBeatConnection.graphics.clear();
			var  beatLine:Sprite = new Sprite();
			beatLine.mouseEnabled = false;
			beatLine.mouseChildren = false;
			mBeatConnection.mouseEnabled = false;
			mBeatConnection.mouseChildren = false;
			beatLine.graphics.clear();
			mBeatConnection.graphics.lineStyle(1, 0x000000,1);
			if(mBeatSeries)
			{
				for(var i:int = 0; i < mBeatSeries.items.length; i++)
				{
					if(mBeatSeries.items[i].item.beatsCompleted)
					{
						for(var k:int = 0; k < mBeatSeries.items[i].item.beatsCompleted.length; k++)
						{
							for(var j:int = 0; j < mBeatSeries.items.length; j++)
							{
								//FIX ME when set beatsCompleted...
								if(mBeatSeries.items[j].item.id == mBeatSeries.items[i].item.
									beatsCompleted[k] )
								{
									var y:Number = mBeatSeries.items[i].y - mBeatSeries.items[j].y;
									var x = mBeatSeries.items[i].x - mBeatSeries.items[j].x;
									
									var tan = y/x;
									var angle:Number = Math.atan(-tan);
									angle = x < 0 ? angle + Math.PI : angle; 
									
									var dx:Number = 15*Math.cos(angle);
									var dy:Number = 15*Math.sin(angle);
									
									mBeatConnection.graphics.moveTo(mBeatSeries.items[j].x+dx, mBeatSeries.items[j].y-dy);
									mBeatConnection.graphics.lineTo(mBeatSeries.items[i].x - dx, mBeatSeries.items[i].y + dy);
									
									
									//arrows
									var arrowSize:Number = 15;
									var xTo:Number = mBeatSeries.items[i].x;
									var yTo:Number = mBeatSeries.items[i].y;
									
									mBeatConnection.graphics.beginFill(0x000000);
									mBeatConnection.graphics.moveTo(xTo - dx, yTo + dy);
									
									var bX:Number = xTo - arrowSize * Math.sin(Math.PI/3 - angle);
									var bY:Number = yTo + arrowSize * Math.cos(Math.PI/3 - angle);
									
									mBeatConnection.graphics.lineTo(bX - dx, bY + dy);
									
									var cX:Number=bX-arrowSize*Math.cos(Math.PI/2 - angle);
									var cY:Number=bY-arrowSize*Math.sin(Math.PI/2 - angle);
									
									mBeatConnection.graphics.lineTo(cX - dx, cY + dy);
									mBeatConnection.graphics.lineTo(xTo - dx, yTo + dy);
								}
							}
						}
					}
				}
				mBeatSeries.addChild(mBeatConnection);
			}
		}
		
		private function addBeatContextMenuHandler(evt:ContextMenuEvent):void 
		{
			addBeatHandler();
		}
		
		private function cutBeatContextMenuHandler(event:ContextMenuEvent):void
		{
			if(mSelectedBeatOnGraph)
			{
				if(mBeatBuffer)
				{
					mBeatBuffer.removeAll();
				}
				mBeatBuffer.addItem(mSelectedBeatOnGraph);
				if(mBeatChart.selectedChartItem)
				{
					DataModel.getSingleton().mBubbleBeatData.removeItemAt(mBeatChart.selectedChartItem.index);
				}
			}
		}
		
		private function copyBeatContextMenuHandler(event:ContextMenuEvent):void
		{
			if(mSelectedBeatOnGraph)
			{
				if(mBeatBuffer)
				{
					mBeatBuffer.removeAll();
				}
				mBeatBuffer.addItem(mSelectedBeatOnGraph);
			}
		}
		
		private function deleteBeatContextMenuHandler(event:ContextMenuEvent):void
		{
			deleteBeatWindow();
		}
		
		private function pasteBeatContextMenuHandler(event:ContextMenuEvent):void
		{
			var tmp:ArrayCollection = DataModel.getSingleton().mBubbleBeatData; 
			if(mBeatBuffer)
			{
				tmp.disableAutoUpdate();
				for(var i:int; i < mBeatBuffer.length; i++)
				{
					tmp.addItem(mBeatBuffer[i]);
					tmp.enableAutoUpdate();
					tmp.refresh();
				}
			}
		}
		
		private function renameBeatContextMenuHandler(event:ContextMenuEvent):void
		{
			
		}
	}
}
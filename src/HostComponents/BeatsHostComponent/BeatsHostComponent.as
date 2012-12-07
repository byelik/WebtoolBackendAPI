package HostComponents.BeatsHostComponent
{
	
	import Constants.Const;
	
	import Data.DataModel;
	
	import HttpService.HttpServiceManager;
	
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
		
		[SkinPart(required="true")]
		public var mLocationList:DropDownList;
		
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
		
		[SkinPart(required="true")]
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
		
		private var mComponent:IFocusManagerComponent;
		private var firstTextElement:String;
		
		[Bindable]
		public var beatTypeList:ArrayCollection; 
		
		[Bindable]
		public var mBeatVariables:ArrayCollection;
		
		private var dataSortField:SortField;
		private var dataSort:Sort;
		
//		private var addGroupMenuItem:ContextMenuItem;
//		private var cutMenuItem:ContextMenuItem;
//		private var copyMenuItem:ContextMenuItem;
//		private var deleteMenuItem:ContextMenuItem;
//		private var pasteMenuItem:ContextMenuItem;
//		private var renameMenuItem:ContextMenuItem;
		
		//[Bindable]
		public var treeContextMenu:ContextMenu;
		
		//[Bindable]
		
		
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
				case "mLocationList":
					mLocationList.addEventListener(Event.CHANGE, selectLocation);
				break;
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
				/*case "mBeatsTree":
					mBeatsTree.addEventListener(ListEvent.ITEM_ROLL_OVER, rollOverTreeItem);
				break;*/
				/*case "mBeatsTree":
					mBeatsTree.addEventListener(ListEvent.ITEM_CLICK, treeItemClick);
				break;*/
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
				/*case "mAgentList":
					mAgentList.removeEventListener(Event.CHANGE, selectAgent);
					break;*/
				case "mChooseAgentList":
					mChooseAgentList.removeEventListener(Event.CHANGE, chooseAgent);
				break;
				case "mLocationList":
					mLocationList.removeEventListener(Event.CHANGE, selectLocation);
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
				/*case "mBeatsTree":
					mBeatsTree.removeEventListener(ListEvent.ITEM_ROLL_OVER, rollOverTreeItem);
				break;*/
				/*case "mBeatsTree":
					mBeatsTree.removeEventListener(ListEvent.ITEM_CLICK, treeItemClick);
				break;*/
				default:
					//default
				break;
			}
		}
		
		/*private function selectAgent(event:IndexChangeEvent):void
		{
			//select agent...
		}*/
		
		private function chooseAgent(event:IndexChangeEvent):void
		{
			//choose agentt...
		}
		
		private function selectLocation(event:IndexChangeEvent):void
		{
			//select location...
		}
		
		private function selectType(event:IndexChangeEvent):void
		{
			//select type...
		}
		
		private var isPriorityOk:Boolean;
		private var isMinAffinityOk:Boolean;
		private var isMaxAffinityOk:Boolean;
		private var isMinNerveOk:Boolean;
		private var isMaxNerveOk:Boolean;
		
		private function saveData(event:MouseEvent):void
		{
			//save data...
			checkPriorityValue();
			
			//depricated
//			checkMinAffinityValue();
//			checkMaxAffinityValue();
//			checkMinNerveValue();
//			checkMaxNerveValue();
			

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
				new HttpServiceManager('{"method":"beats.removeBeat","params":["'+mSelectedBeatsId+'"],"jsonrpc":"2.0","id":45}', deleteBeatResult);
			}
			else
			{
				//close window...
			}
		}
		
		private function deleteBeatResult(result:Object):void
		{
			mBeatsListData.disableAutoUpdate();
			if(result == null)
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
		
		private function seacrhEvent(event:TextOperationEvent):void
		{
			for(var i:int = 0; i < beatTypeList.length; i++)
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
			}
		}
		
		private function refreshSearch(event:MouseEvent):void
		{
			//refresh search...
			//close search tree... and show beats tree
			mSearchField.mSearchInputField.text = "";
			if(mSearchField)
			{
				mSearchField.mSearchMatch.removeAll();
			}
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
				DataModel.getSingleton().mBubbleBeatData.addItem(beatId);
				var tmp:ArrayCollection = DataModel.getSingleton().mBubbleBeatData
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
//			trace(mSelectedBeatsId);
			//mSelectedBeatsId.addItem(mSelectedBeatOnGraph.beatId);
			
			if(mSelectedBeatOnGraph)
			{
				mBeatDescriptionField.text = mSelectedBeatOnGraph.beatDescription;
				mPriorityField.text = mSelectedBeatOnGraph.exclusiveBeatPriority;
				mTypeList.selectedItem = mSelectedBeatOnGraph.type;
//				mActivitiesList.dataProvider = mSelectedBeatOnGraph.activities;
				mActivitiesList.text = mSelectedBeatOnGraph.activities;
				
				
				//depricated
//				mAffinityMinField.text = mSelectedBeatOnGraph.affinityMin;
//				mAffinityMaxField.text = mSelectedBeatOnGraph.affinityMax;
//				mNerveMinField.text = mSelectedBeatOnGraph.nerveMin;
//				mNerveMaxField.text = mSelectedBeatOnGraph.nerveMax;
//				mBeatsCompletedField.text = mSelectedBeatOnGraph.beatsCompleted;
				
				//mBeatTheme.selectedItem = selectedBeatOnGraph.xgmlTheme;
				for(var i:int = 0; i < mBeatsListData.length; i ++)
				{
					if(mSelectedBeatOnGraph.xgmlTheme == mBeatsListData[i].xgmlTheme)
					{
						mBeatTheme.selectedItem = mBeatsListData[i];
					}
				}
				
				for(var k:int = 0; k < DataModel.getSingleton().mLocationsList.length; k++)
				{
					if(mSelectedBeatOnGraph.locationId == DataModel.getSingleton().mLocationsList[k].id)
					{
						mLocationList.selectedItem = DataModel.getSingleton().mLocationsList[k];
					}
					
				}
				
				var mAgentsData:ArrayCollection = DataModel.getSingleton().mAgentsList;
				for(var j:int = 0; j <  mAgentsData.length; j ++)
				{
					if(mSelectedBeatOnGraph.agentId == mAgentsData[j].id)
					{
						mChooseAgentList.selectedItem = mAgentsData[j];
						new HttpServiceManager('{"method":"general.getXGMLThemesForAgent","params":["'+mChooseAgentList.selectedItem.name+'"],"jsonrpc":"2.0","id":8}', getXgmlThemesForAgentResult);
					}
				}
			}
		}
		
		
		private function getXgmlThemesForAgentResult(result:Object):void
		{
			if(result.code)
			{
				Alert.show("Ошибка при загрузке списка тем для агента", "Внимание", Alert.OK);
			}
			else
			{
				if(mAgentThemes)
				{
					mAgentThemes.removeAll();
				}
				var str:String = result.toString();
				var themes:Array = str.split(",");
				for(var i:int = 0; i < themes.length; i++)
				{
					mAgentThemes.addItem(themes[i]);	
				}
				
				mBeatTheme.dataProvider = mAgentThemes;
				for(var j:int; j < mAgentThemes.length; j++)
				{
					if(mAgentThemes[j] == mSelectedBeatOnGraph.xgmlTheme)
					{
						mBeatTheme.selectedItem = mAgentThemes[j];
					}
				
				}
			}
		}
		
		private function addBeatResult(result:Object):void
		{
			if(result.code)
			{
				Alert.show("Error", "Error", Alert.OK);
			}
			else
			{
//				good	
				mBeatsData.addItem(result);
				focusManager.setFocus(mBeatDescriptionField);
			}
		}
		var groupId:int;
		private function addGroupMenuEvent(event:ContextMenuEvent):void
		{
			
			groupId++;
			var treeGroupNode:XML = new XML();
			treeGroupNode = <node>{"Group: " + groupId}</node>;
			DataModel.getSingleton().mTreeData.children()[0].appendChild(treeGroupNode);
		}
		
		private function cutMenuEvent(event:ContextMenuEvent):void
		{
			trace("cut event");
		}
		
		private function copyMenuEvent(event:ContextMenuEvent):void
		{
			trace("copy event");
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
				var node:XML = XML(mBeatsTree.selectedItem);
				if( node == null ) return;
				if( node.localName() != "node" ) return;
				
				var children:XMLList = XMLList(node.parent()).children();
				for(var i:Number=0; i < children.length(); i++) {
					if( children[i].@label == node.@label ) {
						delete children[i];
					}
				}
			}
		}
		
		private function deleteBeatLevelResult(result:Object):void
		{
			//result...
		}
		
		
		private function pasteMenuEvent(event:ContextMenuEvent):void
		{
			trace("paste event");
		}
		
		private function renameMenuEvent(event:ContextMenuEvent):void
		{
			trace("rename event" + mBeatsTree.selectedItem);
			mBeatsTree.editable = true;
			mBeatsTree.editedItemPosition = {columnIndex:0, rowIndex:mBeatsTree.selectedIndex};
		}
		
		
		
		
		
		private function checkPriorityValue():void
		{
			firstTextElement = mPriorityField.text.substring(0,1);
			if(!checkValue(firstTextElement, mPriorityField))
			{
				Alert.show(Const.ERROR_INPUT_PROIRITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mPriorityField;
				isPriorityOk = false;
			}
		}
		
		//depricated
		/*private function checkMinAffinityValue():void
		{
			firstTextElement = mAffinityMinField.text.substring(0,1);
			if(!checkValue(firstTextElement, mAffinityMinField))
			{
				Alert.show(Const.ERROR_INPUT_AFFINITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mAffinityMinField;
				isMinAffinityOk = false;
			}
		}*/
		
		//depricated
		/*private function checkMaxAffinityValue():void
		{
			firstTextElement = mAffinityMaxField.text.substring(0,1);
			if(!checkValue(firstTextElement, mAffinityMaxField))
			{
				Alert.show(Const.ERROR_INPUT_AFFINITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mAffinityMaxField;
				isMaxAffinityOk = false;
			}
		}*/
		
		//depricated
		/*private function checkMinNerveValue():void
		{
			firstTextElement = mNerveMinField.text.substring(0,1);
			if(!checkValue(firstTextElement, mNerveMinField))
			{
				Alert.show(Const.ERROR_INPUT_NERVE_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mNerveMinField;
				isMinNerveOk = false;
			}	
		}*/

		//depricated
		/*private function checkMaxNerveValue():void
		{
			firstTextElement = mNerveMaxField.text.substring(0,1);
			if(!checkValue(firstTextElement, mNerveMaxField))
			{
				Alert.show(Const.ERROR_INPUT_NERVE_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mNerveMaxField;
				isMaxNerveOk = false;
			}
		}*/
		
		
		private function checkValue(str:String, txtField:TextInput):Boolean
		{
			if(parseInt(str) == 0 && txtField.text.length > 1 || parseInt(txtField.text) > Const.MAX_VALUE || txtField.text == Const.EMPTY_STRING)	
			{
				return false;
			}
			isPriorityOk = true;
			isMinAffinityOk = true;
			isMaxAffinityOk = true;
			isMinNerveOk = true;
			isMaxNerveOk = true;
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
		
		/*private var beatType:String = "normal";
		private function getBeatType():String
		{
			//for each(var type:String in beatTypeList)
			//{
			//	if(beatType == type)
			//	{
			//		return beatType;
			//	}
			//}
			for(var i:int = 0; i < beatTypeList.length; i++)
			{
				if(mBeatsTree.selectedItem.type == beatTypeList[i])
				{
					mTypeList.selectedItem = beatTypeList[i];
				}
			}
			return null;
		}*/
		
		public function drawBeatConnection(event:Event):void
		{
//			var beatContainer:UIComponent = new UIComponent();
			mBeatConnection.graphics.clear();
			var  beatLine:Sprite = new Sprite();
			
			
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
								if(mBeatSeries.items[j].item.beatId == mBeatSeries.items[i].item.beatsCompleted[k] )
								{
									mBeatConnection.graphics.moveTo(mBeatSeries.items[j].x, mBeatSeries.items[j].y);
									mBeatConnection.graphics.lineTo(mBeatSeries.items[i].x, mBeatSeries.items[i].y);
									
									var y:Number = mBeatSeries.items[i].y - mBeatSeries.items[j].y;
									var x = mBeatSeries.items[i].x - mBeatSeries.items[j].x;
									
									var tan = y/x;
									
									//arrows
									var arrowSize:Number = 15;
									var xTo:Number = mBeatSeries.items[i].x;
									var yTo:Number = mBeatSeries.items[i].y;
									var angle:Number = Math.atan(-tan);
									mBeatConnection.graphics.beginFill(0x000000);
									mBeatConnection.graphics.moveTo(xTo, yTo);
									
									var bX:Number = xTo - arrowSize * Math.sin(Math.PI/3 - angle);
									var bY:Number = yTo + arrowSize * Math.cos(Math.PI/3 - angle);
									
									mBeatConnection.graphics.lineTo(bX, bY);
									
									var cX:Number=bX-arrowSize*Math.cos(Math.PI/2 - angle);
									var cY:Number=bY-arrowSize*Math.sin(Math.PI/2 - angle);
									
									mBeatConnection.graphics.lineTo(cX, cY);
									mBeatConnection.graphics.lineTo(xTo, yTo);
								}
							}
						}
					}
				}
				mBeatSeries.addChild(mBeatConnection);
			}
//			beatLine.graphics.endFill();
			
		}
		
		private function addBeatContextMenuHandler(evt:ContextMenuEvent):void 
		{
			addBeatHandler();
		}
		
		private function cutBeatContextMenuHandler(event:ContextMenuEvent):void
		{
//			drawBeatConnection();
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
//					mBeatsData.addItem(mBeatBuffer[i]);
//					mBeatsData.enableAutoUpdate();
//					mBeatsData.refresh();
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
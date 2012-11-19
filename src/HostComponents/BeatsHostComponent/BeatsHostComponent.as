package HostComponents.BeatsHostComponent
{
	
	import Constants.Const;
	
	import Data.DataModel;
	
	import HttpService.HttpServiceManager;
	
	import Manager.AlertManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.events.CloseEvent;
	import mx.events.EffectEvent;
	import mx.events.ListEvent;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerComponent;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.BorderContainer;
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.DropDownList;
	import spark.components.List;
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
		public var mActivitiesList:List;
		
		/*[SkinPart(required="true")]
		public var mPreconditionsDescriptionField:TextArea;*/
		
		[SkinPart(required="true")]
		public var mFactsKnownToUser:DataGrid;
		
		[SkinPart(required="true")]
		public var mFactsKnownToAgent:DataGrid;
		
		[SkinPart(required="true")]
		public var mBeatsCompletedField:TextInput;
		
		[SkinPart(required="true")]
		public var mAffinityMinField:TextInput;
		
		[SkinPart(required="true")]
		public var mAffinityMaxField:TextInput;
		
		[SkinPart(required="true")]
		public var mNerveMinField:TextInput;
		
		[SkinPart(required="true")]
		public var mNerveMaxField:TextInput;
		
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
		public var mSearchField:TextInput;
		
		[SkinPart(required="true")]
		public var mRefreshSearch:Button;
		
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
		
		[Bindable]
		public var treeContextMenu:ContextMenu;
		
		[Bindable]
		public var mUserFacts:ArrayCollection;
		
		[Bindable]
		public var mselectedUserFacts:Vector.<Object>;
		
		public function BeatsHostComponent()
		{
			super();
			beatTypeList = new ArrayCollection(["exclusive", "normal", "repeated"]);
			mBeatVariables = new ArrayCollection();
			dataSortField = new SortField();
			
			dataSort = new Sort();
			sortBeatTypeList();
			
			treeContextMenu = new ContextMenu();
			treeContextMenu.hideBuiltInItems();
			
			var addGroupMenuItem:ContextMenuItem = new ContextMenuItem("Add Group");
			addGroupMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, addGroupMenuEvent);
			
			var cutMenuItem:ContextMenuItem = new ContextMenuItem("Cut");
			cutMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cutMenuEvent);
			
			var copyMenuItem:ContextMenuItem = new ContextMenuItem("Copy");
			copyMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, copyMenuEvent);
			
			var deleteMenuItem:ContextMenuItem = new ContextMenuItem("Delete");
			deleteMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteMenuEvent);
			
			var pasteMenuItem:ContextMenuItem = new ContextMenuItem("Paste");
			pasteMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, pasteMenuEvent);
			
			var renameMenuItem:ContextMenuItem = new ContextMenuItem("Rename");
			renameMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, renameMenuEvent);
			
			
//			treeContextMenu.customItems = [addGroupMenuItem, cutMenuItem,
//											copyMenuItem, deleteMenuItem,
//											pasteMenuItem, renameMenuItem];
			
			treeContextMenu.customItems.push(addGroupMenuItem);
			treeContextMenu.customItems.push(cutMenuItem);
			treeContextMenu.customItems.push(copyMenuItem);
			treeContextMenu.customItems.push(deleteMenuItem);
			treeContextMenu.customItems.push(pasteMenuItem);
			treeContextMenu.customItems.push(renameMenuItem);
//			treeContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, getSelectedElement);
			
//			mSave.contextMenu = treeContextMenu;
//			var tmp:ArrayCollection = DataModel.getSingleton().mBeatsList; 
//			trace(tmp);
			
			mUserFacts = DataModel.getSingleton().mFactsList;
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
					mSearchField.addEventListener(TextOperationEvent.CHANGE, seacrhEvent);
				break;
				case "mRefreshSearch":
					mRefreshSearch.addEventListener(MouseEvent.CLICK, refreshSearch);
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
					mSearchField.removeEventListener(TextOperationEvent.CHANGE, seacrhEvent);
				break;
				case "mRefreshSearch":
					mRefreshSearch.removeEventListener(MouseEvent.CLICK, refreshSearch);
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
		
		private function saveData(event:MouseEvent):void
		{
			//save data...
//			checkPriorityValue();
//			checkMinAffinityValue();
//			checkMaxAffinityValue();
//			checkMinNerveValue();
//			checkMaxNerveValue();text = "88,44"
			var selectedUserFacts:ArrayCollection = new ArrayCollection();
			if(mFactsKnownToUser.selectedItems)
			{
				for(var jj:int = 0; jj < mFactsKnownToUser.selectedItems.length; jj++)
				{
					selectedUserFacts.addItem(mFactsKnownToUser.selectedItems[jj].id);
				}
			}
//			trace(selectedUserFacts);
			new HttpServiceManager('{"method":"beats.updateBeat","params":[{"id":"'+mBeatsTree.selectedItem.id+'","description":"'+mBeatDescriptionField.text+'","agentId":"'+mBeatsTree.selectedItem.agentId+'","locationId":"'+mLocationList.selectedItem.id+'","type":"'+mTypeList.selectedItem+'","xgmlTheme":"'+mBeatTheme.selectedItem.xgmlTheme+'","activities":["Find(steve)","StartDialog(steve, Lets flirt with me!)","CompleteBeat(Jessica_flirt)"],"exclusiveBeatPriority":"'+mPriorityField.text+'"}],"jsonrpc":"2.0","id":21}', updateBeatResult);
			new HttpServiceManager('{"method":"beats.updateBeatPrecondition","params":["'+mBeatsTree.selectedItem.id+'",{"description":"","factsAvailableToUser":['+selectedUserFacts+'],"factsAvailableToAgent":[],"beatsCompleted":['+mBeatsCompletedField.text+'],"affinityMin":"'+mAffinityMinField.text+'","affinityMax":"'+mAffinityMaxField.text+'","nerveMin":"'+mNerveMinField.text+'","nerveMax":"'+mNerveMaxField.text+'"}],"jsonrpc":"2.0","id":24}', updateBeatPreconditions);
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
			//delete beat...
			if(mFactsKnownToUser.selectedItems)
			{
				for(var i:int = 0; i <mFactsKnownToUser.selectedItems.length; i ++)
				{
					trace(mFactsKnownToUser.selectedItems[i].id );	
				}
			}
		}
		
		private function treeStateEvent(event:MouseEvent):void
		{
			if(mTreeStateBtn.selected)
			{
//				mBeatsTree.includeInLayout = false;
//				mBeatsTree.visible = false;
//				currentState = currentState == 'hideBeatsTree' ? '' : 'hideBeatsTree';
//				mTreeBorderContainer.width = mTreeStateBtn.width;
				hideBeatsTree.end(); hideBeatsTree.play();
			}
			else
			{
//				mBeatsTree.includeInLayout = true;
//				mBeatsTree.visible = true;
//				mTreeBorderContainer.width = 200;
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
				if(mSearchField.text == beatTypeList[i].substr(0,3))
				{
					trace("search is work");
				}
			}
		}
		
		private function refreshSearch(event:MouseEvent):void
		{
			//refresh search...
			//close search tree... and show beats tree
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
		
		private function addGroupMenuEvent(event:ContextMenuEvent):void
		{
			trace("add group event");
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
			trace("delete event");
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
			if(checkValue(firstTextElement, mPriorityField))
			{
				Alert.show(Const.ERROR_INPUT_PROIRITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mPriorityField;
			}
		}
		
		private function checkMinAffinityValue():void
		{
			firstTextElement = mAffinityMinField.text.substring(0,1);
			if(checkValue(firstTextElement, mAffinityMinField))
			{
				Alert.show(Const.ERROR_INPUT_AFFINITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mAffinityMinField;
			}
		}
		
		private function checkMaxAffinityValue():void
		{
			firstTextElement = mAffinityMaxField.text.substring(0,1);
			if(checkValue(firstTextElement, mAffinityMaxField))
			{
				Alert.show(Const.ERROR_INPUT_AFFINITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mAffinityMaxField;
			}
		}
		
		private function checkMinNerveValue():void
		{
			firstTextElement = mNerveMinField.text.substring(0,1);
			if(checkValue(firstTextElement, mNerveMinField))
			{
				Alert.show(Const.ERROR_INPUT_NERVE_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mNerveMinField;
			}	
		}

		private function checkMaxNerveValue():void
		{
			firstTextElement = mNerveMaxField.text.substring(0,1);
			if(checkValue(firstTextElement, mNerveMaxField))
			{
				Alert.show(Const.ERROR_INPUT_NERVE_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mNerveMaxField;
			}
		}
		
		private function checkValue(str:String, txtField:TextInput):Boolean
		{
			if(parseInt(str) == 0 && txtField.text.length > 1 || parseInt(txtField.text) > Const.MAX_VALUE || txtField.text == Const.EMPTY_STRING)	
			{
				return true;
			}
			return false;
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
//			dataSort.fields = [new SortField("data", true, true)];
//			dataSort.reverse();
			
			beatTypeList.sort = dataSort;
			beatTypeList.refresh();
		}
		
		private var beatType:String = "normal";
		private function getBeatType():String
		{
			/*for each(var type:String in beatTypeList)
			{
				if(beatType == type)
				{
					return beatType;
				}
			}*/
			for(var i:int = 0; i < beatTypeList.length; i++)
			{
				if(mBeatsTree.selectedItem.type == beatTypeList[i])
				{
					mTypeList.selectedItem = beatTypeList[i];
				}
			}
			return null;
		}
	}
}
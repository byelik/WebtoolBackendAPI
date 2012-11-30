package HostComponents.FactsHostComponent
{
	

	
	import Constants.Const;
	
	import Data.DataModel;
	import Data.Facts.FactsData;
	
	import HttpService.HttpServiceManager;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.managers.IFocusManagerComponent;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.DropDownList;
	import spark.components.List;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.GridItemEditorEvent;
	import spark.events.GridSelectionEvent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	
	
	public class FactsHostComponent extends SkinnableComponent
	{
		[SkinPart(required="false")]
		public var mCharacterList:DropDownList;
		
		[SkinPart(required="true")]
		public var mAffinity:TextInput;
		
		[SkinPart(required="true")]
		public var mNerve:TextInput;
		
		[SkinPart(required="true")]
		public var mAddVariable:Button;
		
		[SkinPart(required="true")]
		public var mDeleteVariable:Button;
		
		[SkinPart(required="true")]
		public var mVariableList:DataGrid;
		
		[SkinPart(required="true")]
		public var mCharacterFactsList:DataGrid;
		
		[SkinPart(required="true")]
		public var mAddFactOwner:Button;
		
		[SkinPart(required="true")]
		public var mDeleteFactOwner:Button;
		
		[SkinPart(required="true")]
		public var mLocationList:DropDownList;
		
		[SkinPart(required="true")]
		public var mAddFact:Button;
		
		[SkinPart(required="true")]
		public var mDeleteFact:Button;
		
		
		[SkinPart(required="true")]
		public var mFactsList:DataGrid;
		
		[SkinPart(required="true")]
		public var mItemsGrid:DataGrid;
		
		[SkinPart(required="true")]
		public var mAddItem:Button;
		
		[SkinPart(required="true")]
		public var mDeleteItem:Button;
		
		[Bindable]
		public var mAgents:ArrayCollection;
		
		[Bindable]
		public var mLocations:ArrayCollection;
		
		[Bindable]
		public var mSystemFacts:ArrayCollection;
		
		
		private var selectedAgents:Vector.<Object>;
		private var firstTextElement:String;
		private var mComponent:IFocusManagerComponent;
		
		[Bindable]
		public var tmpData:ArrayCollection = new ArrayCollection([{id:'geka', desc:10}, {id:'gang', desc:9}, 'g','côte','b','coté',
																'xyz', 'f', 'e', 'D', 'ABC','Öhlund',
																'Oehland','Zorn','Aaron','Ohlin',{id:'Aaron', desc:1}]);
//		[Bindable]
//		public var mSystemFactsList:ArrayCollection = new ArrayCollection();

		[Bindable]
		public var mCharacterFactItems:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var mVariableItems:ArrayCollection = new ArrayCollection();
				
		private var dataSortField:SortField;
		private var dataSort:Sort;
		
		private var mSelectedSystemFacts:ArrayCollection;
		private var mSelectedCharacterFacts:ArrayCollection;
		private var mSelectedCharacterFactsItemIndex:Vector.<Object>;

		private var indexNewElement:int 
		
		private var mSelectedCharacterIndex:int;
		private var mSelectedLocationIndex:int;
		
		public function FactsHostComponent()
		{
			super();
			
			mAgents = DataModel.getSingleton().mAgentsList;
			mLocations = DataModel.getSingleton().mLocationsList;
			mSystemFacts = DataModel.getSingleton().mFactsList;
			
			dataSortField = new SortField();
			dataSort = new Sort();
			sortData();
			mSelectedSystemFacts = new ArrayCollection();
			mSelectedCharacterFacts = new ArrayCollection();
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
				case "mCharacterList":
					mCharacterList.addEventListener(Event.CHANGE, selectCharacter);
				break;
				case "mAffinity":
					mAffinity.addEventListener(TextOperationEvent.CHANGE, inputAffinityValue);
				break;
				case "mNerve":
					mNerve.addEventListener(TextOperationEvent.CHANGE, inputNerveValue);
				break;
				case "mAddVariable":
					mAddVariable.addEventListener(MouseEvent.CLICK, addVariable);
				break;
				case "mDeleteVariable":
					mDeleteVariable.addEventListener(MouseEvent.CLICK, deleteVariable);
				break;
				case "mVariableList":
					mVariableList.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, finishEdirVariableDescription);
				break
				/*case "mCharacterFactsList":
					mCharacterFactsList.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, selectCharacterFact);
				break;*/
				case "mAddFactOwner":
					mAddFactOwner.addEventListener(MouseEvent.CLICK, addFactOwner);
				break
				case "mDeleteFactOwner":
					mDeleteFactOwner.addEventListener(MouseEvent.CLICK, deleteFactOwner);
				break;
				case "mLocationList":
					mLocationList.addEventListener(Event.CHANGE, selectLocation);
				break;
				case "mAddFact":
					mAddFact.addEventListener(MouseEvent.CLICK, addFact);
				break;
				case "mDeleteFact":
					mDeleteFact.addEventListener(MouseEvent.CLICK, deleteFact);
				break;
				case "mFactsList":
					mFactsList.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, finishEditSystemFactDescription);
				break;
				case "mAddItem":
					mAddItem.addEventListener(MouseEvent.CLICK, addItem);
				break;
				case "mDeleteItem":
					mDeleteItem.addEventListener(MouseEvent.CLICK, deleteItem);
				break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
			switch(partName)
			{
				case "mCharacterList":
					mCharacterList.removeEventListener(Event.CHANGE, selectCharacter);
				break;
				case "mAffinity":
					mAffinity.removeEventListener(TextOperationEvent.CHANGE, inputAffinityValue);
					break;
				case "mNerve":
					mNerve.removeEventListener(TextOperationEvent.CHANGE, inputNerveValue);
					break;
				case "mAddVariable":
					mAddVariable.removeEventListener(MouseEvent.CLICK, addVariable);
					break;
				case "mDeleteVariable":
					mDeleteVariable.removeEventListener(MouseEvent.CLICK, deleteVariable);
					break;
				case "mVariableList":
					mVariableList.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, finishEdirVariableDescription);
					break
				/*case "mCharacterFactsList":
					mCharacterFactsList.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, selectCharacterFact);
				break;*/
				case "mAddFactOwner":
					mAddFactOwner.removeEventListener(MouseEvent.CLICK, addFactOwner);
					break
				case "mDeleteFactOwner":
					mDeleteFactOwner.removeEventListener(MouseEvent.CLICK, deleteFactOwner);
					break;
				case "mLocationList":
					mLocationList.removeEventListener(Event.CHANGE, selectLocation);
					break;
				case "mAddFact":
					mAddFact.removeEventListener(MouseEvent.CLICK, addFact);
					break;
				case "mDeleteFact":
					mDeleteFact.removeEventListener(MouseEvent.CLICK, deleteFact);
					break;
				case "mFactsList":
					mFactsList.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, finishEditSystemFactDescription);
				break;
				case "mAddItem":
					mAddItem.addEventListener(MouseEvent.CLICK, addItem);
					break;
				case "mDeleteItem":
					mDeleteItem.addEventListener(MouseEvent.CLICK, deleteItem);
				break;
			}
		}
		
		
		private function sortData():void
		{		
			var sortFactsField:SortField = new SortField();
			var sortFacts:Sort = new Sort();
			sortFactsField.name = "id";
			sortFacts.fields = [sortFactsField];
			

			
			dataSortField.name = "name";
//			dataSortField.numeric = true;
			dataSort.fields = [dataSortField, new SortField("id",true, true)];
			
			if(mAgents)
			{
				mAgents.sort = dataSort;
				mAgents.refresh();
			}
			if(mLocations)
			{
				mLocations.sort = dataSort;
				mLocations.refresh();	
			}
			if(mSystemFacts)
			{
				mSystemFacts.sort = sortFacts;
				mSystemFacts.refresh();
			}
		}
		
		/**
		 * Select character...
		 */
		private function selectCharacter(event:IndexChangeEvent):void
		{	
			getCharacterData();
		}
		
		public function getCharacterData():void
		{
			mSelectedCharacterIndex = mCharacterList.selectedIndex;
			
			new HttpServiceManager('{"method":"locations.getLocations","params":[],"jsonrpc":"2.0","id":0}', parseLocationsData);
			new HttpServiceManager('{"method":"facts.getFacts","params":[], "jsonrpc": "2.0", "id":7}', parseFactsData);
			new HttpServiceManager('{"method":"agents.getAgents","params":[],"jsonrpc":"2.0","id":0}', parseAgentsData);
			
			//			new HttpServiceManager('{"method":"general.getFactDetails","params":["'+event.target.selectedItem.id+'"],"jsonrpc":"2.0","id":0}', factDetailResult);
			mAffinity.text = mCharacterList.selectedItem.affinity;
			mNerve.text = mCharacterList.selectedItem.nerve;
			for(var i:int = 0; i < mLocations.length; i++)
			{
				if(mCharacterList.selectedItem.locationId == mLocations[i].id)
				{
					mLocationList.selectedItem = mLocations[i];
					mSelectedLocationIndex = i;
				}
				
			}
			
			if(mCharacterFactItems)
			{
				mCharacterFactItems.removeAll();
			}
			for(var j:int = 0; j < mSystemFacts.length; j++)
			{	
				var factsOwner:Object = mSystemFacts[j]; 
				if(!factsOwner.owners)
				{
					continue;
				}
				for(var k:int = 0; k < factsOwner.owners.length; k ++)
				{
					if(factsOwner.owners[k] == mCharacterList.selectedItem.id)
					{
						mCharacterFactItems.addItem(factsOwner);
					}	
				}
			}	
		}
		
		private function parseLocationsData(data:Object):void
		{
			DataModel.getSingleton().parseLocationsData(data);
			mCharacterList.selectedIndex = mSelectedCharacterIndex;
			mLocationList.selectedIndex = mSelectedLocationIndex;
		}
		
		private function parseFactsData(data:Object):void
		{
			DataModel.getSingleton().parseFactsData(data);
			mCharacterList.selectedIndex = mSelectedCharacterIndex;
			mLocationList.selectedIndex = mSelectedLocationIndex;
		}
		
		
		private function parseAgentsData(data:Object):void
		{
			DataModel.getSingleton().parseAgentsData(data);
			mCharacterList.selectedIndex = mSelectedCharacterIndex;
			mLocationList.selectedIndex = mSelectedLocationIndex;
		}
		
		private function factDetailResult(result:Object):void
		{
			trace(result);
		}
			
		
		private function inputAffinityValue(event:TextOperationEvent):void
		{
//			trace(mAffinity.text);
			firstTextElement = mAffinity.text.substring(0,1);
			if(checkValue(firstTextElement, mAffinity))
			{
				Alert.show(Const.ERROR_INPUT_AFFINITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mAffinity;
			}
		}
		
		private function inputNerveValue(event:TextOperationEvent):void
		{
			firstTextElement = mNerve.text.substring(0,1);
			if(checkValue(firstTextElement, mNerve))
			{
				Alert.show(Const.ERROR_INPUT_NERVE_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mNerve;
			}	
		}
		
		private function addVariable(event:MouseEvent):void
		{
			//add variable and refresh all data
			
			mVariableItems.addItem({id:"New Variable", description: ""}); 
			mSystemFacts.addEventListener(CollectionEvent.COLLECTION_CHANGE, getIndex);
		}
		
		private function addVariableResult(result:Object):void
		{
			if(result == null)
			{
				//good
				mVariableList.startItemEditorSession(indexNewElement, 1)
			}
			else
			{
				//error...
			}
		}
			
		
		private function deleteVariable(event:MouseEvent):void
		{
			//delete variable and refresh all data
			if(mVariableList.selectedItems)
			{
				Alert.yesLabel = "Да";
				Alert.noLabel = "Нет";
				Alert.show(Const.WARNING_DELETE_VARIABLE, Const.TITLE_DELETE_VARIABLE, Alert.YES | Alert.NO, this, deleteVariableHandler);
			}
		}
		
		private function finishEdirVariableDescription(event:GridItemEditorEvent):void
		{
			var variableDescription:String = mVariableItems.getItemAt(event.rowIndex).description; 
			//edit variable ENTER(save data and refresh all list)
		}
		
		private function editVariableResult(result:Object):void
		{
			if(result == null)
			{
				//good
			}
			else
			{
				//error...
			}
		}
		
		
		/*private function selectCharacterFact(event:GridItemEditorEvent):void
		{
			trace(mCharacterFactsList.selectedIndex);	
		}*/
		
		
		private function addFactOwner(event:MouseEvent):void
		{
			if(mFactsList.selectedItems)
			{
				mAddFactOwner.enabled = false;
//				var selectedObjects:Vector.<Object> = mFactsList.selectedItems;
				new HttpServiceManager('{"method":"facts.addFactOwner","params":["'+mFactsList.selectedItem.id+'","'+mCharacterList.selectedItem.id+'"],"jsonrpc":"2.0","id":9}', addFactOwnerResult);
			}
		}
			
		private function addFactOwnerResult(result:Object):void
		{
			if(result != null)
			{
				//error
			}
			else
			{
				mCharacterFactItems.addItem(mFactsList.selectedItem);
			}
			
		}
		
		
		
		
		 
		private function deleteFactOwner(event:MouseEvent):void
		{
			var indx:Vector.<Object> = mCharacterFactsList.selectedItems;
			if(mSelectedCharacterFactsItemIndex)
			{
				mSelectedCharacterFactsItemIndex = null;
			}
			mSelectedCharacterFactsItemIndex = mCharacterFactsList.selectedItems;
			
			if(mSelectedCharacterFacts)
			{
				mSelectedCharacterFacts.removeAll();
			}
				
			if(mCharacterFactsList.selectedItems)
			{
				for(var i:int = 0; i < indx.length; i++)
				{
					mSelectedCharacterFacts.addItem(indx[i].id);
				}
				new HttpServiceManager('{"method":"facts.removeFactOwner","params":["'+mSelectedCharacterFacts+'","'+mCharacterList.selectedItem.id+'"], "jsonrpc": "2.0", "id":7}', deleteFactOwnerResult);
				mDeleteFactOwner.enabled = false;
			}
		}
		
		private function deleteFactOwnerResult(result:Object):void
		{
			if(result !=null)
			{
				//error
				Alert.show("Не удалось удалить факт персонажа", "Ошибка", Alert.OK);
			}
			else
			{
				for(var i:int = 0; i < mSelectedCharacterFactsItemIndex.length; i++)
				{
					mCharacterFactItems.removeItemAt(mCharacterFactsList.selectedIndex);
				}
//				mCharacterFactItems.removeItemAt(mSelectedCharacterFactsItemIndex);
//				mCharacterFactItems.removeItemAt(mCharacterFactsList.selectedIndex);
			}
		}
		
		private function selectLocation(event:IndexChangeEvent):void
		{
			//select location
			new HttpServiceManager('{"method":"agents.setAgentLocation","params":["'+mCharacterList.selectedItem.id+'","'+event.target.selectedItem.id+'"], "jsonrpc": "2.0", "id":7}', setAgentLocation);
			
		}

		private function setAgentLocation(result:Object):void
		{
			trace("Result set Location: " + result);
			if(result == null)
			{
				//good
			}
		}
		
		private function addFact(event:MouseEvent):void
		{
//			focusManager.setFocus(mFactsDescriptionArea);
//			mFactsDescriptionArea.text = "New Fact";
//			mSystemFactsList.addItem({id:"1", description:"New Fact"});
			new HttpServiceManager('{"method":"facts.addFact","params":[{"description":"New Fact"}],"jsonrpc":"2.0","id":9}', addFactResult);
			mSystemFacts.addEventListener(CollectionEvent.COLLECTION_CHANGE, getIndex);
		}
		
		private function addFactResult(result:Object):void
		{
			if(result)
			{
				mSystemFacts.addItem(result);
				mFactsList.startItemEditorSession(indexNewElement, 1)
			}

		}
		
		private function deleteFact(event:MouseEvent):void
		{	
			var selectedObjects:Vector.<Object> = mFactsList.selectedItems;
			if(mSelectedSystemFacts)
			{
				mSelectedSystemFacts.removeAll();
			}
			
			for(var i:int = 0; i < selectedObjects.length; i++)
			{
				mSelectedSystemFacts.addItem(selectedObjects[i].id);
			}						
			Alert.yesLabel = "Да";
			Alert.noLabel = "Нет";
			Alert.show(Const.WARRNING_DELETE_FACT, Const.TITLE_DELETE_FACT, Alert.YES | Alert.NO, this, deleteFactHandler);
		}
		
		private function deleteFactHandler(event:CloseEvent):void
		{			
			if(event.detail == Alert.YES)
			{
				trace("delete selected fact(s)");
				if(mFactsList.selectedItems)
				{
					new HttpServiceManager('{"method":"facts.removeFact","params":["'+mSelectedSystemFacts+'"],"jsonrpc":"2.0","id":0}', deleteFactResult);
//					new HttpServiceManager('{"method":"facts.removeFact","params":["258","265"],"jsonrpc":"2.0","id":0}', deleteSystemFactResult);
//					mSystemFactsList.removeItemAt(mFactsList.selectedIndex);
					mDeleteFact.enabled = false;
					mAddFactOwner.enabled = false;
				}
			}
			else
			{
				trace("just close wnd ");
			}
				
		}
		
		private function deleteFactResult(result:Object):void
		{
			trace(result);
			if(result)
			{
//				Alert.show("Code: " + result.code + "\n\Message: " + result.message, "Error", Alert.OK);
				Alert.show("Ошибка при удалении", "Ошибка", Alert.OK);
			}
			if(result == null)
			{
				new HttpServiceManager('{"method":"facts.getFacts","params":[], "jsonrpc": "2.0", "id":7}', DataModel.getSingleton().parseFactsData);
			}
		}
		
		private function finishEditSystemFactDescription(event:GridItemEditorEvent):void
		{
			var factId:int = mSystemFacts.getItemAt(event.rowIndex).id;
			var xgmlId:String = mSystemFacts.getItemAt(event.rowIndex).xgml;
			var factDescription:String = mSystemFacts.getItemAt(event.rowIndex).description;
			new HttpServiceManager('{"method":"facts.updateFactDetails","params":['+factId+', "'+xgmlId+'", "'+factDescription+'"], "jsonrpc": "2.0", "id":7}', editFactDescriptionResult);
		}
		
		private function editFactDescriptionResult(result:Object):void
		{
			if(result == null)
			{
				//good
			}
			{
				//error
			}
		}
		
		////////////////////////addItem//////////////////////////////////
		private function addItem(event:MouseEvent):void
		{
			
		}
		
		private function addItemResult(result:Object):void
		{
			
		}
		////////////////////////addItem//////////////////////////////////
		
		
		
		////////////////////////deleteItem//////////////////////////////////
		private function deleteItem(event:MouseEvent):void
		{
			deleteItemAlertWnd();
		}
		
		private function deleteItemAlertWnd():void
		{
			Alert.yesLabel = "Да";
			Alert.noLabel = "Нет";
			Alert.show("Вы действительно хотите удалить выбранные обьекты?", "Внимание", Alert.YES | Alert.NO, null, deleteItemHandler);	
		}
		
		private function deleteItemHandler(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				// send to the server selected items, after response we delete selected items
			}
		}
		
		private function deleteItemResult(result:Object):void
		{
			
		}
		////////////////////////deleteItem//////////////////////////////////
		
		
		private function deleteVariableHandler(event:CloseEvent):void
		{
			//			trace(event.detail);
			//			var tmp:Vector.<Object>;
			
			if(event.detail == Alert.YES)
			{
				trace("delete selected variables(s)");
				
				mVariableItems.removeItemAt(mVariableList.selectedIndex);
				mDeleteVariable.enabled = false;
			}
			else
			{
				trace("close wnd");
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
		
		private function getIndex(event:CollectionEvent):void
		{
			indexNewElement = event.location;
		}
	}
}
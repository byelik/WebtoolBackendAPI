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
		public var mVariableItems:ArrayCollection = new ArrayCollection();
				
		private var dataSortField:SortField;
		private var dataSort:Sort;
		
		private var mSelectedSystemFacts:ArrayCollection;
		private var mSelectedCharacterFacts:ArrayCollection;
		private var mSelectedCharacterFactsItemIndex:Vector.<Object>;

		private var indexNewElement:int 
		
		private var mSelectedCharacterIndex:int;
//		private var mSelectedLocationIndex:int;
		
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
				case "mCharacterFactsList":
					mCharacterFactsList.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, finishEditCharacterFact);
				break;
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
				case "mCharacterFactsList":
					mCharacterFactsList.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, finishEditCharacterFact);
				break;
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
			if(DataModel.getSingleton().mLocationsList)
			{
				DataModel.getSingleton().mLocationsList.sort = dataSort;
				DataModel.getSingleton().mLocationsList.refresh();	
			}
			if(DataModel.getSingleton().mFactsList)
			{
				DataModel.getSingleton().mFactsList.sort = sortFacts;
				DataModel.getSingleton().mFactsList.refresh();
			}
		}
		
		/**
		 * Select character...
		 */
		private function selectCharacter(event:IndexChangeEvent):void
		{	
			getCharacterData();
		}
		
		[Bindable]
		public var tmp:ArrayCollection = new ArrayCollection();
		public function getCharacterData():void
		{
			if(DataModel.getSingleton().mCharacterFacts)
			{
				DataModel.getSingleton().mCharacterFacts.removeAll();
				DataModel.getSingleton().mCharacterFacts.refresh();
			}
			var characterFact:ArrayCollection = new ArrayCollection();
			if(characterFact)
			{
				characterFact.removeAll();
				characterFact.refresh();
				characterFact.addItem(mCharacterList.selectedItem.facts);
			}
			for(var i:int = 0; i < characterFact.length; i++)
			{
				for(var j:int = 0; j < characterFact[i].length; j++)
				{
					DataModel.getSingleton().mCharacterFacts.addItem(characterFact[i][j]);	
				}	
			} 
			
			mAffinity.text = mCharacterList.selectedItem.affinity;
			mNerve.text = mCharacterList.selectedItem.nerve;
			for(var i:int = 0; i < DataModel.getSingleton().mLocationsList.length; i++)
			{
				if(mCharacterList.selectedItem.location == DataModel.getSingleton().mLocationsList[i].id)
				{					
					mLocationList.selectedIndex = i;
				}
				
			}
			
			/*if(mCharacterFactItems)
			{
				mCharacterFactItems.removeAll();
			}
			for(var j:int = 0; j < DataModel.getSingleton().mFactsList.length; j++)
			{	
				var factsOwner:Object = DataModel.getSingleton().mFactsList[j]; 
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
			}*/	
		}
		
		/*private function parseLocationsData(data:Object):void
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
		}*/
		
		private function factDetailResult(result:Object):void
		{
			trace(result);
		}
			
		
		private function inputAffinityValue(event:TextOperationEvent):void
		{
//			trace(mAffinity.text);
			firstTextElement = mAffinity.text.substring(0,1);
			if(!checkValue(firstTextElement, mAffinity))
			{
				Alert.show(Const.ERROR_INPUT_AFFINITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mAffinity;
			}
			else
			{
				mCharacterList.selectedItem.affinity = mAffinity.text; 
			}
		}
		
		private function inputNerveValue(event:TextOperationEvent):void
		{
			firstTextElement = mNerve.text.substring(0,1);
			if(!checkValue(firstTextElement, mNerve))
			{
				Alert.show(Const.ERROR_INPUT_NERVE_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mNerve;
			}
			else
			{
				mCharacterList.selectedItem.nerve = mNerve.text;
			}
		}
		
		private function addVariable(event:MouseEvent):void
		{
			//add variable and refresh all data
			
			mVariableItems.addItem({id:"New Variable", description: ""}); 
//			mSystemFacts.addEventListener(CollectionEvent.COLLECTION_CHANGE, getIndex);
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
		
		
		private function finishEditCharacterFact(event:GridItemEditorEvent):void
		{
			//	
		}
		
		private function editCharacterFactResult(result:Object):void
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
		
		private function addFactOwner(event:MouseEvent):void
		{
			var factObj:Object;
			if(mFactsList.selectedItems)
			{
				
				for(var i:int = 0; i < mFactsList.selectedItems.length; i++)
				{
					factObj = (mFactsList.selectedItems);	
				}
				for(var j:int = 0; j < factObj.length; j++)
				{
					for(var k:int = 0; k < DataModel.getSingleton().mAgentsList.length; k++)
					{
						if(mCharacterList.selectedItem.id == DataModel.getSingleton().mAgentsList[k].id)
						{
							DataModel.getSingleton().mAgentsList[k].facts.addItem({id:factObj[j].id, status:"true", description:factObj[j].description});
							DataModel.getSingleton().mCharacterFacts.addItem({id:factObj[j].id, status:"true", description:factObj[j].description});
						}
					}					
				}
			}
			mAddFactOwner.enabled = false;
		}
			
		private function deleteFactOwner(event:MouseEvent):void
		{
			var indx:Vector.<Object> = mCharacterFactsList.selectedItems;
			if(indx)
			{
				for(var i:int = 0; i < indx.length; i++)
				{
					DataModel.getSingleton().mCharacterFacts.removeItemAt(mCharacterFactsList.selectedIndex);
					for(var k:int = 0; k < DataModel.getSingleton().mAgentsList.length; k++)
					{
						if(mCharacterList.selectedItem.id == DataModel.getSingleton().mAgentsList[k].id)
						{
							DataModel.getSingleton().mAgentsList[k].facts.removeItemAt(k);
						}
					}
				}
				var tmp:ArrayCollection = DataModel.getSingleton().mAgentsList;
			}
		}
				
		private function selectLocation(event:IndexChangeEvent):void
		{
			for(var i:int = 0; i < DataModel.getSingleton().mAgentsList.length; i++)
			{
				DataModel.getSingleton().mAgentsList[i].location = mLocationList.selectedItem.id;	
			}			
		}

		private function addFact(event:MouseEvent):void
		{
			var randomFactId:Number = Math.ceil(Math.random()*3000); 
			var factObj:Object = ({id: "fact_"+randomFactId, description:"New Fact"});
			DataModel.getSingleton().mFactsList.addEventListener(CollectionEvent.COLLECTION_CHANGE, getIndex);
			DataModel.getSingleton().mFactsList.addItem(factObj);
			var tmp:ArrayCollection = DataModel.getSingleton().mFactsList; 
			mFactsList.startItemEditorSession(indexNewElement, 1)
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
				mSelectedSystemFacts.addItem(selectedObjects[i]);
			}						
			Alert.yesLabel = "Да";
			Alert.noLabel = "Нет";
			Alert.show(Const.WARRNING_DELETE_FACT, Const.TITLE_DELETE_FACT, Alert.YES | Alert.NO, this, deleteFactHandler);
		}
		
		private function deleteFactHandler(event:CloseEvent):void
		{			
			if(event.detail == Alert.YES)
			{
				if(mFactsList.selectedItems)
				{
					for(var i:int = 0; i < mSelectedSystemFacts.length; i++)
					{
						DataModel.getSingleton().mFactsList.removeItemAt(mFactsList.selectedIndex);
						mDeleteFact.enabled = false;
						mAddFactOwner.enabled = false;
					}
				}
			}
			else
			{
				trace("just close wnd ");
			}
				
		}
		
		private function finishEditSystemFactDescription(event:GridItemEditorEvent):void
		{
//			var factId:int = DataModel.getSingleton().mFactsList.getItemAt(event.rowIndex).id;
//			var xgmlId:String = DataModel.getSingleton().mFactsList.getItemAt(event.rowIndex).xgml;
			var factDescription:String = DataModel.getSingleton().mFactsList.getItemAt(event.rowIndex).description;
//			new HttpServiceManager('{"method":"facts.updateFactDetails","params":['+factId+', "'+xgmlId+'", "'+factDescription+'"], "jsonrpc": "2.0", "id":7}', editFactDescriptionResult);
		}
		
		////////////////////////addItem//////////////////////////////////
		private function addItem(event:MouseEvent):void
		{
			var itemOwner:String = "input Owner";
			var itemType:String = "input Type";
			//DataModel.getSingleton().mAgentsList[0].id
			/*for(var i:int = 0; i < DataModel.getSingleton().mAgentsList.length; i++)
			{
				if(DataModel.getSingleton().mAgentsList[i].items != null)
				{
					itemType = DataModel.getSingleton().mAgentsList[i].items[0].type;
				}
				else
				{
					itemType = "test";
				}
			}*/
			DataModel.getSingleton().mItemsData.addItem({owner:itemOwner, 
															type:itemType, 
															count:1});
//			var items:ArrayCollection = DataModel.getSingleton().mItemsData;
//			var agent:ArrayCollection = DataModel.getSingleton().mAgentsList;
//			var locationItems:ArrayCollection = DataModel.getSingleton().mLocationsList;
//			trace(tmp);
		}
		
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
				var index:Vector.<Object> = mItemsGrid.selectedItems;
				var itm:ArrayCollection = DataModel.getSingleton().mAgentsList;
				if(index)
				{
					for(var i:int = 0; i < index.length; i++)
					{
						for(var k:int = 0; k < DataModel.getSingleton().mAgentsList.length; k++)
						{
							for(var j:int = 0; j < DataModel.getSingleton().mAgentsList[k].items.length; j++)
							{
								if(mItemsGrid.selectedItem.owner == DataModel.getSingleton().mAgentsList[k].id)
								{
									DataModel.getSingleton().mAgentsList[k].items.removeItemAt(j);
								}
//								
							}
							
						}
						DataModel.getSingleton().mItemsData.removeItemAt(mItemsGrid.selectedIndex);
					}
					
				}
			}
			var tmp:ArrayCollection = DataModel.getSingleton().mAgentsList;
		}
		
		private function editItemsResult(result:Object):void
		{
			if(result == null)
			{
				//good
			}
			{
				//error
			}
		}
		
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
				trace("false");
				return false;
			}
			trace("true");
			return true;
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
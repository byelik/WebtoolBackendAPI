package HostComponents.FactsHostComponent
{
	

	
	import Constants.Const;
	
	import Data.Facts.FactsData;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
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
	import spark.events.IndexChangeEvent;
	
	
	
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
		
		
		
		
		private var selectedAgents:Vector.<Object>;
		private var firstTextElement:String;
		private var mComponent:IFocusManagerComponent;
		
		[Bindable]
		public var tmpData:ArrayCollection = new ArrayCollection(['geka', 'gang', 'g','côte','b','coté',
																'xyz', 'f', 'e', 'D', 'ABC','Öhlund',
																'Oehland','Zorn','Aaron','Ohlin','Aaron']);
		[Bindable]
		public var mFactsListData:ArrayCollection = new ArrayCollection([{label:"Electronics", data:1, desc: "hello"}, 
																		{label:"Home Good", data:2, desc: "hellocvcvd"},
																		{label:"Home Gods", data:5, desc: "helldfdfffdfo"},
																		{label:"Goods", data:3, desc: "hellodsfdfdfdfgfgfg"},
																		{label:"oe Gds", data:6, desc: "hellogdsdgerffbhfbv"},
																		{label:"Ho Goo", data:4, desc: "hellofkgjfdkgghgfh"},
																		{label:"Hoe Gs", data:7, desc: "hellfhjnfgiubo"},
																		{label:"Hom Goo", data:9, desc: "hellognbv"},
																		{label:"H ds", data:8, desc: "hellfjbfvbo"},
																		{label:"e ds", data:10, desc: "hellgvfgfo"},
																		{label:"o G", data:12, desc: "hellfbgjbgo"},
																		{label:"e s", data:11, desc: "hellbjfbfo"},
																		{label:"Hmjje Gfgfgoods", data:13, desc: "hellobfiofbfbhngnglngngnghnlgng;n,glmngl;ng"},
																		{label:"Home Gdfgdfg", data:15, desc: "hellohiofnfb rigjuriotrhgright g"},
																		{label:"Home Goods", data:14, desc: "hellnbkg;ngklno"},
																		{label:"Home Goods", data:16, desc: "hellobgknfbkfnbkb"},
																		{label:"Toys", data:17, desc: "hellogbklgnbgbngbngkbgbkmgbklggkbmgklbmgklbmgklbmgkbmgbmkgeokfeoire okb"},
																		{label:"arni", data:13, desc: "BYELIk"} ]);
		
		
		
		private var dataSortField:SortField;
		private var dataSort:Sort;
		
		
		public function FactsHostComponent()
		{
			super();
			dataSortField = new SortField();
			
			dataSort = new Sort();
			sortCharacterList();		
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
					mAffinity.addEventListener(TextEvent.TEXT_INPUT, inputAffinityValue);
				break;
				case "mNerve":
					mNerve.addEventListener(TextEvent.TEXT_INPUT, inputNerveValue);
				break;
				case "mAddVariable":
					mAddVariable.addEventListener(MouseEvent.CLICK, addVariable);
				break;
				case "mDeleteVariable":
					mDeleteVariable.addEventListener(MouseEvent.CLICK, deleteVariable);
				break;
				case "mVariableList":
					mVariableList.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, selectVariable);
				break
				case "mCharacterFactsList":
					mCharacterFactsList.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, selectCharacterFact);
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
					mFactsList.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, selectFact);
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
					mAffinity.addEventListener(Event.CHANGE, inputAffinityValue);
					break;
				case "mNerve":
					mNerve.removeEventListener(Event.CHANGE, inputNerveValue);
					break;
				case "mAddVariable":
					mAddVariable.removeEventListener(MouseEvent.CLICK, addVariable);
					break;
				case "mDeleteVariable":
					mDeleteVariable.removeEventListener(MouseEvent.CLICK, deleteVariable);
					break;
				case "mVariableList":
					mVariableList.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, selectVariable);
					break
				case "mCharacterFactsList":
					mCharacterFactsList.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, selectCharacterFact);
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
					mFactsList.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, selectFact);
				break;
			}
		}
		
		private function sortCharacterList():void
		{
			dataSortField.numeric = true;
			
//			dataSort.fields = [dataSortField];
			dataSort.fields = [new SortField("data", true, true)];
			dataSort.reverse();
//			tmpData.sort = dataSort;
//			tmpData.refresh();
			mFactsListData.sort = dataSort;
			mFactsListData.refresh();
		}
		
		private function selectCharacter(event:IndexChangeEvent):void
		{
			trace(event.target.selectedItem.data);
//			mFactsList.selectedItem = event.target.selectedItem;
//			mAgentsList.selectedItems = mFactsList.selectedItems;
			//var mFacts:FactsData = new FactsData();
		}
		
		private function inputAffinityValue(event:TextEvent):void
		{
			trace(mAffinity.text);
			firstTextElement = mAffinity.text.substring(0,1);
			if(checkValue(firstTextElement, mAffinity))
			{
				Alert.show(Const.ERROR_INPUT_AFFINITY_VALUE, Const.TITLE_ERROR_WINDOW, Alert.OK, null, alertHandler);
				mComponent = mAffinity;
			}
		}
		
		private function inputNerveValue(event:TextEvent):void
		{
			
		}
		
		private function addVariable(event:MouseEvent):void
		{
			//add variable and refresh all data
		}
		
		private function deleteVariable(event:MouseEvent):void
		{
			//delete variable and refresh all data
		}
		
		private function selectVariable(event:GridItemEditorEvent):void
		{
			//edit variable ENTER(save data and refresh all list)
			trace("*");
		}
		
		/*private function editFact(event:GridItemEditorEvent):void
		{
			//save data in the system and refresh in all lists 
		}*/
		
		private function selectCharacterFact(event:GridItemEditorEvent):void
		{
			trace("character fact");
		}
		
		
		private function addFactOwner(event:MouseEvent):void
		{
			/*selectedAgents = mAgentsList.selectedItems;
			for(var i:int = 0; i < selectedAgents.length; i++)
			{
				//				trace(selectedAgents[i].data);
			}*/
			//			{"method":"facts.addFactOwner","params":[256,180],"jsonrpc":"2.0","id":38}
			
		}
			
		
		
		
		
		private function deleteFactOwner(event:MouseEvent):void
		{
			//{"method":"facts.removeFactOwner","params":[256,181],"jsonrpc":"2.0","id":39}
			/*selectedAgents = mAgentsList.selectedItems;
			for(var i:int = 0; i < selectedAgents.length; i++)
			{
				trace(selectedAgents[i].data);
			}*/
		}
		
		private function selectLocation(event:IndexChangeEvent):void
		{
			//select location
			trace(event.target.selectedItem.label);
		}

		private function addFact(event:MouseEvent):void
		{
//			{"method":"facts.addFact","params":[{}],"jsonrpc":"2.0","id":43}
//			focusManager.setFocus(mFactsDescriptionArea);
//			mFactsDescriptionArea.text = "New Fact";
		}
		
		private function deleteFact(event:MouseEvent):void
		{
			for(var i:int = 0; i < mFactsList.selectedItems.length; i++)
			{
				trace(i);
			}
			
			Alert.yesLabel = "Да";
			Alert.noLabel = "Нет";
			Alert.show(Const.WARRNING_DELETE_FACT, Const.TITLE_DELETE_FACT, Alert.YES | Alert.NO, this, deleteFactHandler);
		}
		
		private function selectFact(event:GridItemEditorEvent):void
		{
			//refresh all data
		}
		
		private function deleteFactHandler(event:CloseEvent):void
		{
//			trace(event.detail);
//			var tmp:Vector.<Object>;
			
			if(event.detail == Alert.YES)
			{
				trace("delete selected fact(s)");
				
				mFactsListData.removeItemAt(mFactsList.selectedIndex);	
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
	}
}
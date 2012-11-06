package HostComponents.FactsHostComponent
{
	

	
	import Constants.Const;
	
	import Data.Facts.FactsData;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.DropDownList;
	import spark.components.List;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.GridItemEditorEvent;
	import spark.events.IndexChangeEvent;
	
	
	
	public class FactsHostComponent extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var characterList:DropDownList;
		
		[SkinPart(required="true")]
		public var mAgentsList:List;
		
		[SkinPart]
		public var mFactsList:DataGrid;
		
		[SkinPart(required="true")]
		public var mAddFactOwner:Button;
		
		[SkinPart(required="true")]
		public var mRemoveFactOwner:Button;
		
		[SkinPart(required="true")]
		public var mAddFact:Button;
		
		[SkinPart(required="true")]
		public var mFactsDescriptionArea:TextArea;
		
		[SkinPart(required="true")]
		public var mDeleteFact:Button;
		
		private var selectedAgents:Vector.<Object>;
		
		
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
				case "characterList":
					characterList.addEventListener(Event.CHANGE, selectCharacterhandler);
					break;
				case "mAgentsList":
					mAgentsList.addEventListener(Event.CHANGE, addFactToAgent);
				break;
				case "mFactsList":
					mFactsList.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, editFact);
				break;
				case "mAddFactOwner":
					mAddFactOwner.addEventListener(MouseEvent.CLICK, addFactOwner);
				break;
				case "mRemoveFactOwner":
					mRemoveFactOwner.addEventListener(MouseEvent.CLICK, removeFactOwner);
				break;
				case "mAddFact":
					mAddFact.addEventListener(MouseEvent.CLICK, addFact);
				break;
				case "mDeleteFact":
					mDeleteFact.addEventListener(MouseEvent.CLICK, deleteFact);
				break;
				default:
					break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
			switch(partName)
			{
				case "characterList":
					characterList.removeEventListener(Event.CHANGE, selectCharacterhandler);
					break;
				case "mAgentsList":
					mAgentsList.removeEventListener(Event.CHANGE, addFactToAgent);
					break;
				case "mFactsList":
					mFactsList.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, editFact);
					break;
				case "mAddFactOwner":
					mAddFactOwner.removeEventListener(MouseEvent.CLICK, addFactOwner);
					break;
				case "mRemoveFactOwner":
					mRemoveFactOwner.removeEventListener(MouseEvent.CLICK, removeFactOwner);
					break;
				case "mAddFact":
					mAddFact.removeEventListener(MouseEvent.CLICK, addFact);
					break;
				case "mDeleteFact":
					mDeleteFact.removeEventListener(MouseEvent.CLICK, deleteFact);
					break
				default:
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
		
		private function selectCharacterhandler(event:IndexChangeEvent):void
		{
			mFactsList.selectedItem = event.target.selectedItem;
			mAgentsList.selectedItems = mFactsList.selectedItems;
			//var mFacts:FactsData = new FactsData();
		}
		
		
		
		private function addFactToAgent(event:IndexChangeEvent):void
		{
			//select fact and send to server data...
//			trace(t);
		}
		
		
		private function editFact(event:GridItemEditorEvent):void
		{
			//save data in the system and refresh in all lists 
		}
		
		private function addFactOwner(event:MouseEvent):void
		{
			selectedAgents = mAgentsList.selectedItems;
			for(var i:int = 0; i < selectedAgents.length; i++)
			{
//				trace(selectedAgents[i].data);
			}
//			{"method":"facts.addFactOwner","params":[256,180],"jsonrpc":"2.0","id":38}
			
		}
		
		private function removeFactOwner(event:MouseEvent):void
		{
			//{"method":"facts.removeFactOwner","params":[256,181],"jsonrpc":"2.0","id":39}
			selectedAgents = mAgentsList.selectedItems;
			for(var i:int = 0; i < selectedAgents.length; i++)
			{
				trace(selectedAgents[i].data);
			}
		}
		
		private function addFact(event:MouseEvent):void
		{
//			{"method":"facts.addFact","params":[{}],"jsonrpc":"2.0","id":43}
			focusManager.setFocus(mFactsDescriptionArea);
			mFactsDescriptionArea.text = "New Fact";
		}
		
		private function deleteFact(event:MouseEvent):void
		{
			Alert.yesLabel = "Да";
			Alert.noLabel = "Нет";
			Alert.show(Const.WARRNING_DELETE_FACT, Const.TITLE_DELETE_FACT, Alert.YES | Alert.NO, this, deleteFactHandler);
		}
		
		private function deleteFactHandler(event:CloseEvent):void
		{
			trace(event.detail);
			if(event.detail == Alert.YES)
			{
				trace("delete selected fact(s)");
			}
			else
			{
				trace("close wnd");
			}
				
		}
	}
}
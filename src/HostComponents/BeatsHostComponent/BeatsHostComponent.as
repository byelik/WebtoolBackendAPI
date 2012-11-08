package HostComponents.BeatsHostComponent
{
	
	import Constants.Const;
	
	import Manager.AlertManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerComponent;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	
	
	public class BeatsHostComponent extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var mAgentList:DropDownList;
		
		[SkinPart(required="true")]
		public var mBeatDescriptionField:TextArea;
		
		[SkinPart(required="true")]
		public var mChooseAgentList:DropDownList;
		
		[SkinPart(required="true")]
		public var mXgmlField:TextInput;
		
		[SkinPart(required="true")]
		public var mLocationList:DropDownList;
		
		[SkinPart(required="true")]
		public var mTypeList:DropDownList;
		
		[SkinPart(required="true")]
		public var mPriorityField:TextInput;
		
		[SkinPart(required="true")]
		public var mActivitiesField:TextArea;
		
		[SkinPart(required="true")]
		public var mPreconditionsDescriptionField:TextArea;
		
		[SkinPart(required="true")]
		public var mFactsKnownToUser:TextArea;
		
		[SkinPart(required="true")]
		public var mFactsKnownToAgent:TextArea;
		
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
		
		private var mComponent:IFocusManagerComponent;
		private var firstTextElement:String;
		
		[Bindable]
		public var beatTypeList:ArrayCollection; 
		
		private var dataSortField:SortField;
		private var dataSort:Sort;
		
		public function BeatsHostComponent()
		{
			super();
			beatTypeList = new ArrayCollection(["exclusive", "normal", "repeated"]);
			
			dataSortField = new SortField();
			
			dataSort = new Sort();
			sortBeatTypeList();
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
				case "mAgentList":
					mAgentList.addEventListener(Event.CHANGE, selectAgent);
				break;
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
				case "mAgentList":
					mAgentList.removeEventListener(Event.CHANGE, selectAgent);
					break;
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
				default:
					//default
					break;
			}
		}
		
		private function selectAgent(event:IndexChangeEvent):void
		{
			//select agent...
		}
		
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
			checkPriorityValue();
			checkMinAffinityValue();
			checkMaxAffinityValue();
			checkMinNerveValue();
			checkMaxNerveValue();
		}
		
		private function deleteBeat(event:MouseEvent):void
		{
			//delete beat...
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
		
	}
}
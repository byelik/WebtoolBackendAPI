package HostComponents.BeatsHostComponent
{
	
	import Constants.Const;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
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
		
		
		public function BeatsHostComponent()
		{
			super();
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
		}
		
		private function deleteBeat(event:MouseEvent):void
		{
			//delete beat...
		}
		
		private function checkPriorityValue():void
		{
			if(parseInt(mPriorityField.text) < 0 || parseInt(mPriorityField.text) > Const.MAX_VALUE || mPriorityField.text == Const.EMPTY_STRING)
			{
				showAlertWindow("Неверное значение приоритета. Допустимые значения от 0 до 100", "Ошибка", Const.ONE_BUTTON, null, setFocusField);
				
			}
		}
		
		private function checkAffinityValue():void
		{
			
		}
		
		private function checkNerve():void
		{
			
		}
		
		private function showAlertWindow(descriptionError:String, title:String, buttonCount:uint, parent:Sprite, functionName:Function):void
		{
			Alert.show(descriptionError, title, buttonCount, null, functionName);
		}
		
		private function setFocusField(event:CloseEvent):void
		{
			if(event.detail == Alert.OK)
			{
				focusManager.setFocus(mPriorityField);
			}
		}
		
	}
}
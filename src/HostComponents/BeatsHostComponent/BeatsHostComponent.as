package HostComponents.BeatsHostComponent
{
	
	import flash.events.Event;
	import flash.events.TextEvent;
	
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
		
	}
}
package HostComponents.LocationsHostComponent
{
	
	
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import spark.components.DropDownList;
	import spark.components.List;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	
	
	public class LocationsHostComponent extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var mLocationsList:DropDownList;
		
		[SkinPart(required="true")]
		public var mLocationNameField:TextInput;
		
		[SkinPart(required="true")]
		public var mLocationDescriptionField:TextInput;
		
		[SkinPart(required="true")]
		public var mAgentsList:List;
		
		
		public function LocationsHostComponent()
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
				case "mLocationsList":
					mLocationsList.addEventListener(Event.CHANGE, selectLocation);
				break;
				case "mLocationNameField":
					mLocationNameField.addEventListener(TextEvent.TEXT_INPUT, inputLocationName);
				break;
				case "mLocationDescriptionField":
					mLocationDescriptionField.addEventListener(TextOperationEvent.CHANGE, inputLocationDescription);
				break;
				case "mAgentsList":
					mAgentsList.addEventListener(Event.CHANGE, selectAgent);
				break;
				default:
					trace("default");
				break;	
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
			switch(partName)
			{
				case "mLocationsList":
					mLocationsList.removeEventListener(Event.CHANGE, selectLocation);
				break;
				case "mLocationNameField":
					mLocationNameField.removeEventListener(TextEvent.TEXT_INPUT, inputLocationName);
				break;
				case "mLocationDescriptionField":
					mLocationDescriptionField.removeEventListener(TextOperationEvent.CHANGE, inputLocationDescription);
				break;
				case "mAgentsList":					
					mAgentsList.removeEventListener(Event.CHANGE, selectAgent);
				break;
				default:
					trace("default");
				break;	
			}
		}
		
		private function selectLocation(event:IndexChangeEvent):void
		{
			//select location in drop list...
		}
		
		private function inputLocationName(event:Event):void
		{
			//input location name and send to the server...
		}
		
		private function inputLocationDescription(event:TextOperationEvent):void
		{
			//input location description and send to the server...
		}
		
		private function selectAgent(event:IndexChangeEvent):void
		{
			//select agent in the list and send to the server...
		}
		
	}
}
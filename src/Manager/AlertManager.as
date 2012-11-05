package Manager
{
	import flash.display.Sprite;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	
	import spark.components.supportClasses.SkinnableComponent;

	public class AlertManager extends SkinnableComponent
	{
		private static var mComponent:Object;
		
		
		public function AlertManager()
		{
		}
		
		public static function showAlertWindow(descriptionError:String, title:String, buttonCount:uint, parent:Sprite, functionName:Function):void
		{
			Alert.show(descriptionError, title, buttonCount, parent, functionName);
		}
		
		public static function alertHandler(event:CloseEvent):void
		{
			
			if (event.detail == Alert.OK)
			{
				trace("ok");
			}
			else if(event.detail == Alert.NO)
			{
				trace("no");
			}
			else if(event.detail == Alert.YES)
			{
				trace("yes");	
			}	
			else if(event.detail == Alert.NO)
			{
				trace("no");
			}
		}
		
		public static function setComponent(obj:Object):void
		{
			mComponent = obj;
		}
	}
}
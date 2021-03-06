package Render.BeatRender
{
	
	import Constants.Const;
	
	import Data.DataModel;
	
	import HostComponents.FactsHostComponent.FactsHostComponent;
	
	import Manager.EventManager;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.charts.ChartItem;
	import mx.charts.DateTimeAxis;
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.CartesianTransform;
	import mx.charts.chartClasses.GraphicsUtilities;
	import mx.charts.series.BubbleSeries;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.graphics.SolidColor;
	import mx.skins.ProgrammaticSkin;
	import mx.utils.ColorUtil;
	
	public class BeatsRender extends UIComponent
		implements IDataRenderer
	{

		private static var rcFill:Rectangle = new Rectangle();
		private var _data:Object;
		
		[Bindable]
		private var mBeatColor:uint;
		
		private var mWhiteBeat:uint = 0xFFFFFF;
		private var mOrangeBeat:uint = 0xFFA500;
		private var mGreenBeat:uint = 0x008000;
				
		private var stageX:Number;
		private var stageY:Number;
		private var dataX:Number;
		private var dataY:Number;
		
		private var hAxis:DateTimeAxis;
		private var vAxis:LinearAxis;
		
		private var hMin:Number;
		private var hMax:Number;
		private var vMin:Number;
		private var vMax:Number;
		
		private var mBeatIdLabel:TextField;
		private var mBeatDescriptionLabel:TextField;
		
		[Bindable]
		private var mBeatStrokeColor:uint;
		
		private var beatDataProvider:BubbleSeries;
		private var mLabelTextFormatter:TextFormat;
		public function BeatsRender() 
		{
			super();
			
			
			mBeatStrokeColor = 0x000000;
			
			mBeatIdLabel = new TextField();

			mBeatIdLabel.mouseEnabled = false;
			mBeatIdLabel.x = 4; 
			mBeatIdLabel.y = 6;
			mBeatIdLabel.autoSize = TextFieldAutoSize.LEFT;
			
			mLabelTextFormatter = new TextFormat();
			mLabelTextFormatter.color = 0x000000;
			mLabelTextFormatter.font = "Verdana";
			mLabelTextFormatter.bold = true;
			mLabelTextFormatter.size = 12;
			
//			mBeatIdLabel.defaultTextFormat = labelTextFormatter;
			mBeatIdLabel.setTextFormat(mLabelTextFormatter);
			mBeatIdLabel.defaultTextFormat = mLabelTextFormatter;
			addChild(mBeatIdLabel);
			
			mBeatDescriptionLabel = new TextField();
// 			descriptionLabel.height;
			mBeatDescriptionLabel.autoSize = TextFieldAutoSize.LEFT;
			mBeatDescriptionLabel.x = 30;
			mBeatDescriptionLabel.y = 6;
			mBeatDescriptionLabel.setTextFormat(mLabelTextFormatter);
			addChild(mBeatDescriptionLabel);
			
			addEventListener(MouseEvent.MOUSE_DOWN, startMoving);
			
			addEventListener(FlexEvent.DATA_CHANGE, dataExist);
			
			addEventListener(FlexEvent.UPDATE_COMPLETE, refreshStage);
			
			EventManager.getSingleton().addEventListener(EventManager.CHANGE_BEATS_LABELS, changeBeatsLabels);
		}
		
		private function refreshStage(event:FlexEvent):void
		{						
//			mBeatIdLabel.x = (this.width / 2);
//			mBeatIdLabel.y = (this.height / 2);
			EventManager.getSingleton().fireEvent(EventManager.STOP_DRAG_BEAT);	
		}
		private function changeBeatsLabels(event:Event):void
		{
			var tmp = parent as BubbleSeries;
			if(tmp)
			{
//				if(tmp.minRadius < 100)
//				{
//					mLabelTextFormatter.size =-2;
//					mBeatIdLabel.setTextFormat(mLabelTextFormatter);
//					mBeatDescriptionLabel.setTextFormat(mLabelTextFormatter);
					if(tmp.minRadius == -10)
					{
						mBeatIdLabel.visible = false;
						mBeatDescriptionLabel.visible = false;
					}
//				}
				if(tmp.minRadius > -10)
				{
					mBeatIdLabel.visible = true;
					mBeatDescriptionLabel.visible = true;
					mLabelTextFormatter.size +=2;
					mBeatIdLabel.setTextFormat(mLabelTextFormatter);
					mBeatDescriptionLabel.setTextFormat(mLabelTextFormatter);
					mBeatIdLabel.x = tmp.minRadius / 2;
					mBeatIdLabel.y = tmp.minRadius / 2;
					mBeatDescriptionLabel.x = (tmp.minRadius / 2) + 40;
					mBeatDescriptionLabel.y = tmp.minRadius / 2;
				}
			}	
		}
		
		private function startMoving(event:MouseEvent):void
		{
			hAxis = DateTimeAxis(BubbleSeries(parent).getAxis(CartesianTransform.HORIZONTAL_AXIS));
			vAxis = LinearAxis(BubbleSeries(parent).getAxis(CartesianTransform.VERTICAL_AXIS));
			hMin = hAxis.minimum.time;
			hMax = hAxis.maximum.time;
			vMin = vAxis.minimum;
			vMax = vAxis.maximum;
			
			stageX = event.stageX;
			stageY = event.stageY;
			
			dataX = _data.item.beatPosX
			dataY = _data.item.beatPosY;
			
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, moving, true);
			systemManager.addEventListener(MouseEvent.MOUSE_UP, stopMoving, true);
		}
		
		private function moving(event:MouseEvent):void
		{	
			var posX:Number = dataX + (event.stageX - stageX) * (hMax - hMin) / parent.width;
			if (posX >= hMin && posX <= hMax)
			{
				_data.item.beatPosX = new Date(posX);
				
				/*for each(var treeXML:Object in DataModel.getSingleton().mTreeData)
				{
					for each(var group:XML in treeXML.children())
					{
						for each(var label:XML in group.children())
						{
							if(tmp.id == label.children().@id)
							{
								tmp["beatPosX"] = new Date(String(label.children().@x));
								tmp["beatPosY"] = int(label.children().@y);	
							}
							
						}
						
					}
					
				}*/
				
				
				
				
				//for(var i:int = 0; i < beatDataProvider.selectedItems.length; i++)
				//{
				//	_data.item[i].beatPosX = new Date(posX);
				//}
//				_data.item.beatPosX = new Date(posX);
			}
			
			var posY:Number = Math.round(dataY + (stageY - event.stageY) * 100 / parent.height);
			if (posY >= vMin && posY <= vMax)
			{
				_data.item.beatPosY = posY;
			}
		}

		private function stopMoving(event:MouseEvent):void
		{
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, moving, true);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, stopMoving, true);
			
			beatDataProvider = parent as BubbleSeries;
			beatDataProvider.dataProvider.refresh();
		}
		
		[Inspectable(environment="none")]
		[Bindable("dataChange")]
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if (_data == value)
				return;
			
			_data = value;
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		private function dataExist(event:FlexEvent):void
		{
			mBeatIdLabel.text = _data.item.id;
			if(_data.item.description != " ")
			{
				mBeatDescriptionLabel.text = _data.item.description;
			}
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var fill:IFill;
			var state:String = "";
			
			switch(data.item.type)
			{
				case "normal":
					mBeatColor = mWhiteBeat;
					break;
				case "exclusive":
					mBeatColor = mOrangeBeat;
					break;
				case "repeated":
					mBeatColor = mGreenBeat;	
					break;
				default:
					//
					break;
				
			}
			
			if (_data is ChartItem && _data.hasOwnProperty('fill'))
			{
				fill = new SolidColor(mBeatColor);
				state = _data.currentState;
			}
			else
				fill = GraphicsUtilities.fillFromStyle(getStyle('fill'));
			
			
			var color:uint;
			var adjustedRadius:Number = 0;
			
			switch (state)
			{
				case ChartItem.FOCUSED:
				case ChartItem.ROLLOVER:
					if (styleManager.isValidStyleValue(getStyle('itemRollOverColor')))
					{
						color = getStyle('itemRollOverColor');
					}
					else
					{
						mBeatStrokeColor = 0x0000FF;
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-20);
					}
					fill = new SolidColor(color);
					adjustedRadius = getStyle('adjustedRadius');
					if (!adjustedRadius)
					{
						adjustedRadius = 0;
					}
					break;
				case ChartItem.NONE:
					mBeatStrokeColor = 0x000000;
					break;
				case ChartItem.DISABLED:
					if (styleManager.isValidStyleValue(getStyle('itemDisabledColor')))
					{
						color = getStyle('itemDisabledColor');
					}
					else
					{
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),20);
					}
					fill = new SolidColor(GraphicsUtilities.colorFromFill(color));
					break;
				case ChartItem.FOCUSEDSELECTED:
				case ChartItem.SELECTED:
					if (styleManager.isValidStyleValue(getStyle('itemSelectionColor')))
					{
						color = getStyle('itemSelectionColor');
					}
					else
					{
						mBeatStrokeColor = 0x0000FF;
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-30);
					}
					fill = new SolidColor(color);
					adjustedRadius = getStyle('adjustedRadius');
					if (!adjustedRadius)
						adjustedRadius = 0;
					break;
			}
			
			var stroke:IStroke = getStyle("stroke");
			
			var w:Number = stroke ? stroke.weight / 2 : 0;
			
			rcFill.right = unscaledWidth;
			rcFill.bottom = unscaledHeight;
			
			var g:Graphics = graphics;
			g.clear();		
			if (stroke)
			{
				stroke.apply(g,null,null);
			}
			if (fill)
				fill.begin(g, rcFill, null);
			g.lineStyle(3, mBeatStrokeColor);
			g.drawEllipse(w - adjustedRadius,w - adjustedRadius,unscaledWidth - 2 * w + adjustedRadius * 2, unscaledHeight - 2 * w + adjustedRadius * 2);
			
			if (fill)
				fill.end(g);
		}
	}
}

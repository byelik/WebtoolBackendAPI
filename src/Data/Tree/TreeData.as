package Data.Tree
{
	public class TreeData
	{
		private var mTreeFolder:Array;
		
		public function TreeData(data:Object = null)
		{
			parse(data);
		}
		
		public function get treeFolder():Array
		{
			return mTreeFolder;
		}

		public function set treeFolder(value:Array):void
		{
			mTreeFolder = value;
		}

		public static function getNewInstance():TreeData
		{
			return new TreeData();
		}
		
		
		public function parse(data:Object):void
		{
			if(!data)
			{
				mTreeFolder = null;
			}
			else
			{
				mTreeFolder = (data.ODN) as Array;
			}
		}
	}
}
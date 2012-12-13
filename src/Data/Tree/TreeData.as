package Data.Tree
{
	import mx.collections.ArrayCollection;

	public class TreeData
	{
		private var mTreeFolder:Object;
		
		public function TreeData(data:Object = null)
		{
			parse(data);
		}
		
		public function get treeFolder():Object
		{
			return mTreeFolder;
		}

		public function set treeFolder(value:Object):void
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
				mTreeFolder = (data) as Object;
			}
		}
		
	}
}
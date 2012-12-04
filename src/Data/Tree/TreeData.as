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
		
		/*public function toJson():String
		 {
			  res="{ name:\""+name+"\" data:[ ";
			  for each(var i:Person in children)
			  {
				  res+=i.toJson()+",";
			  }
			  res=res.substr(res.length-1);
			  res+="]}";
		 }*/
		/*public class Person
		{
				
				public var name:String;
				public var children:ArrayCollection;
				
				public function Person(_name:String, _children:ArrayCollection = null)
				{
					this.name = _name;
					if(_children != null)
					{
						this.children = _children;
					}//end Person constructor
				
				}//end Person class
			
		}//end package declaration*/
		
	}
}
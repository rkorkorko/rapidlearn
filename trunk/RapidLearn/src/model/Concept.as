package model
{
	import mx.collections.ArrayCollection;
	
	public class Concept
	{		
		private var name: String;
		private var x:int;
		private var y:int;
				
		//initialize all variables
		public function Concept(x:int, y:int)
		{
			this.x = x;
			this.y = y;
			this.name = "Add Name"; 
		}
		
		public function setName(name:String):void {
			this.name = name;
		}
		
		public function getX():int{
			return x;
		}
		
		public function getY():int{
			return y;
		}
		 
	}
}
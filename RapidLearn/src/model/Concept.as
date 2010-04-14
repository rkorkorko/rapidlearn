package model
{
	import mx.collections.ArrayCollection;
	
	public class Concept
	{		
		private var name: String;
		private var x:Number;
		private var y:Number;
				
		//initialize all variables
		public function Concept(x:Number, y:Number)
		{
			this.x = x;
			this.y = y;
			this.name = "Add Name"; 
		}
		
		public function setName(name:String):void {
			this.name = name;
		}
		
		public function getX():Number{
			return x;
		}
		
		public function getY():Number{
			return y;
		}
		 
	}
}
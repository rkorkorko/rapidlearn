package model
{
	import mx.collections.ArrayCollection;
	
	public class Concept
	{		
		private var name: String;
				
		//initialize all variables
		public function Concept()
		{
			this.name="test"; 
		}
		
		public function setName(name:String):void {
			this.name = name;
		}
		
		public function getName():String{
			return this.name;
		}
	}
}
package model
{
	import mx.collections.ArrayCollection;
	
	public class Problem
	{
		private var name:String;
		private var text:String;
		private var choice1:String;
		private var choice2:String;
		private var choice3:String;
		private var choice4:String;
		private var choice5:String;
		private var numChoices:int; 
		private var correctChoice:int;
		private var concepts:ArrayCollection;
		
		public function Problem(name:String,text:String,choice1:String,choice2:String,choice3:String,choice4:String,choice5:String,numChoices:int,correctChoice:int)
		{
			this.name = name;
			this.text = text;
			this.choice1 = choice1;
			this.choice2 = choice2;
			this.choice3 = choice3;
			this.choice4 = choice4;
			this.choice5 = choice5;
			this.numChoices = numChoices;
			this.correctChoice = correctChoice;
			this.concepts = new ArrayCollection();
		}
		
		public function getName():String {
			return this.name;
			
		}
		
		public function getText():String {
			return this.text;
		}
		
		public function getChoice1():String {
			return this.choice1;
		}
		
		public function getChoice2():String {
			return this.choice2;
		}
		
		public function getChoice3():String {
			return this.choice3;
		}
		
		public function getChoice4():String {
			return this.choice4;
		}
		
		public function getChoice5():String {
			return this.choice5;
		}
		
		public function getNumChoices():int {
			return this.numChoices;
		}
		
		public function getCorrectChoice():int {
			return this.correctChoice;
		}
		
		public function getConcepts():ArrayCollection {
			return this.concepts;
		}
		
		public function addConcept(c:Concept):void {
			if(c != null && !this.concepts.contains(c)) {
				this.concepts.addItem(c);
			}
		}
		
		public function removeConcept(c:Concept):void {
			// NEED TO IMPLEMENT LATER
		}
		

	}
}
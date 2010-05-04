package model
{
	import model.Concept;
	
	public class ConceptRelation
	{
		private var previous:Concept;
		private var next:Concept;
		
		public function ConceptRelation(previous:Concept, next:Concept)
		{
			this.previous = previous;
			this.next = next;	
		}
		
		public function getPrevious():Concept {
			return this.previous;
		}
		
		public function getNext():Concept {
			return this.next;
		}
		

	}
}
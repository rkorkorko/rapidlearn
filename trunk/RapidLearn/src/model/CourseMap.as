package model
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class CourseMap extends EventDispatcher
	{		
		private var concepts:ArrayCollection;
		private var relations:ArrayCollection;
		
		private var xyToConcept:Dictionary;
		
		public function CourseMap()
		{
			concepts = new ArrayCollection();
			relations = new ArrayCollection();
			xyToConcept = new Dictionary();
		}
		
		public function getConcepts():ArrayCollection {
			return this.concepts;
		}
		
		public function getRelations():ArrayCollection {
			return this.relations;
		}

		/**add concept**/ 
		public function addConcept(c:Concept):void{			
			this.concepts.addItem(c);
			
			var l:ArrayCollection = new ArrayCollection();
			l.addItem(c.getX());
			l.addItem(c.getY());
			xyToConcept[l] = c;	
		}
				 
		/**add relation**/
		public function addRelation(r:ConceptRelation):void{
			this.relations.addItem(r);			
		}	
			 
		public function getConcept(x:Number, y:Number):Concept{
			var l:ArrayCollection = new ArrayCollection();
			l.addItem(x);
			l.addItem(y);
			return xyToConcept[l];		
		}
				
	}
}
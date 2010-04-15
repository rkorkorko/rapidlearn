package model
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class CourseMap extends EventDispatcher
	{		
		private var concepts:ArrayCollection;
		private var relations:ArrayCollection;
		private var problems:ArrayCollection;
		
		private var xyToConcept:Dictionary;
		
		public function CourseMap()
		{
			concepts = new ArrayCollection();
			relations = new ArrayCollection();
			problems = new ArrayCollection();
			xyToConcept = new Dictionary();
		}
		
		public function getConcepts():ArrayCollection {
			return this.concepts;
		}
		
		public function getRelations():ArrayCollection {
			return this.relations;
		}
		
		public function getProblems():ArrayCollection {
			return this.problems;
		}

		/**add concept**/ 
		public function addConcept(c:Concept):void{			
			this.concepts.addItem(c);		
		}
				 
		/**add relation**/
		public function addRelation(r:ConceptRelation):void{
			this.relations.addItem(r);			
		}	
		
		/**add problem**/
		public function addProblem(p:Problem):void{
			this.problems.addItem(p);
		}
	
				
	}
}
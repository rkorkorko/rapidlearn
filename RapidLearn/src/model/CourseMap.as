package model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	public class CourseMap extends EventDispatcher
	{
		private var selectedConcept: Concept;
		private var previousSelectedConcept: Concept;
		
		private var concepts:ArrayCollection;
		private var relations:ArrayCollection;
		
		
		public function CourseMap()
		{
			selectedConcept = null;
			previousSelectedConcept = null;
			concepts = new ArrayCollection();
			relations = new ArrayCollection();
		}
		
		public function getConcepts():ArrayCollection {
			return this.concepts;
		}
		
		public function getRelations():ArrayCollection {
			return this.relations;
		}


		/**
		 * Returns the concept that is currently selected, or null if no concept is
		 * selected.
		 */
		public function getSelectedConcept():Concept {
			return this.selectedConcept;
		}
		
		/**
		 * Returns the concept that was previously selected, or null if no concept is
		 * selected.
		 */
		public function getPreviousSelectedConcept():Concept {
			return this.previousSelectedConcept;
		}
		
		/**add concept**/
		
		public function addConcept(event:MouseEvent):void{
			var c: Concept = new Concept(event.localX, event.localY);
			this.concepts.addItem(c);	
		}
		
		/**
		 * Adds the passed concept object to the list of prerequisites for the selected concept.  
		 */
		public function addConceptAsPrerequisite(event:MouseEvent):void {
			if(this.selectedConcept != null) {
				var cPrev:Concept = new Concept(event.localX,event.localY);
				var crPrev:ConceptRelation = new ConceptRelation(cPrev,this.selectedConcept);
				this.concepts.addItem(cPrev);
				this.relations.addItem(crPrev);
				dispatchEvent(new Event("prereqAdded"));
			}
			
		}
		
		/**
		 * Adds the passed concept object to the list of next concepts for the selected concept. 
		 */
		public function addConceptAsNext(event:MouseEvent):void {
			if(this.selectedConcept != null) {
				var cNext:Concept = new Concept(event.localX,event.localY);
				var crNext:ConceptRelation = new ConceptRelation(this.selectedConcept,cNext);
				this.concepts.addItem(cNext);
				this.relations.addItem(crNext);
				dispatchEvent(new Event("nextAdded"));
			}
		}
		

	}
}
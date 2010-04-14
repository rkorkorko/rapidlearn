package model
{
	import flash.events.EventDispatcher;
	
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
		
		
		/**
		 * Adds the passed concept object to the list of prerequisites for the selected concept.  
		 * It first checks if the concept is already in the list.  If not, then it is added to 
		 * the list.
		 */
		public function addConceptAsPrerequisite():void {
			if(this.selectedConcept != null) {
				// DO THIS LATER
			}
			
		}
		
		/**
		 * Adds the passed concept object to the list of next concepts for the selected concept.  
		 * It first checks if the concept is already in the list.  If not, then it is added to 
		 * the list.
		 */
		public function addConceptAsNext():void {
			
		}

	}
}
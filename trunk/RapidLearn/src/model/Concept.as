package model
{
	import mx.collections.ArrayCollection;
	
	public class Concept
	{		
		private var prereqs: ArrayCollection;
		private var nextConcepts: ArrayCollection;
		private var name: String;
				
		//initialize all variables
		public function Concept(name:String)
		{
			
		}
		
		//get prereqs
		private function getPrereqs():ArrayCollection{
			return prereqs;
		}
		//getconcepts
		private function getNextConcepts():ArrayCollection{
			return nextConcepts; 
		}
		//add prereq
		private function addPrereq(){
			
			//fire event listener to update view. 
		}
		
		//remove nextConcept		
		private function removeConcept(concept:Concept){
			
			//fire event listener to update view. 
		}
		//remove prereq
		private function removePrereq(concept:Concept){
			
			//fire event listener to update view. 
		}
		
		//add nextConcept		
		private function addNextConcept(){
			
			//fire event listener to update view. 
		}
	
		//set resources.
		private function addResource (resource: Resource){
			
			//only update model.
		} 
	}
}
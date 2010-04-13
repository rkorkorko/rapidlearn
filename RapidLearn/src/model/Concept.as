package model
{
	import mx.collections.ArrayCollection;
	
	public class Concept
	{		
		private var prereqs: ArrayCollection;
		private var nextConcept: ArrayCollection;
		private var name: String;
				
		//initialize all variables
		public function Concept(name:String)
		{
			
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
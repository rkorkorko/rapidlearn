package model
{
	import flash.events.EventDispatcher;
	import model.Concept;
	
	public class CourseMap extends EventDispatcher
	{
		private var selectedConcept: Concept;
		
		
		public function CourseMap()
		{
		}

		public function getSelectedConcept:Concept {
			return this.selectedConcept;
		}

	}
}
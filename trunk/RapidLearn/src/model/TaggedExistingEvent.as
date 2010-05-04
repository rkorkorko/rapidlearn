package model
{
	import flash.events.Event;
	
	public class TaggedExistingEvent extends Event
	{
		private var problem:Problem;
		
		public function TaggedExistingEvent(type:String, problem:Problem)
		{
			super(type);
			this.problem = problem;
		}
		
		public function getProblem():Problem {
			return this.problem;
		}

	}
}

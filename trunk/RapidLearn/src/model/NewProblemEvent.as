package model
{
	import flash.events.Event;

	public class NewProblemEvent extends Event
	{
		private var problem:Problem;
		
		public function NewProblemEvent(type:String, problem:Problem)
		{
			super(type);
			this.problem = problem;
		}
		
		public function getProblem():Problem {
			return this.problem;
		}
		
		
		
	}
}
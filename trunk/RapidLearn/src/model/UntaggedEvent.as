package model
{
	import flash.events.Event;

	public class UntaggedEvent extends Event
	{
		private var numUntagged:int;
		
		public function UntaggedEvent(type:String, numUntagged:int)
		{
			super(type);
			this.numUntagged = numUntagged;
		}
		
		public function getNumUntagged():int {
			return this.numUntagged;
		}
		
	}
}
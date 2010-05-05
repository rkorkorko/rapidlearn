package model
{
	import flash.events.Event;

	public class RelationEvent extends Event
	{
		private var start:Concept;
		private var end:Concept;
		
		public function RelationEvent(type:String, start:Concept, end:Concept)
		{
			super(type);
			this.start = start;
			this.end = end;
		}
		
		public function getStart():Concept {
			return this.start;
		}
		
		public function getEnd():Concept {
			return this.end;
		}
		
	}
}
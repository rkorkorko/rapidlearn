package drawing
{
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import drawing.Box;
	import drawing.Line;
	
	public class CourseMapView
	{
		private var boxes:ArrayCollection = new ArrayCollection();
    	private var lines:ArrayCollection = new ArrayCollection();
    	private var designArea:Canvas;
    	private var isDrawEnable:Boolean = false;
    	private var isDrawing:Boolean = false;
    	private var templateLine:Line;
    	private var selectedBox:Box;
		
		
		public function CourseMapView()
		{
			createTemplateLine();
		}
		
			// create guide line for first time drawing
	    public function createTemplateLine():void{
	      templateLine = new Line();
	      templateLine.name="templateLine";
	      templateLine.visible = false;
	    }
	    
		public function setIsDrawEnable(value:Boolean):void{
	      this.isDrawEnable = value;
	    }
	    public function getIsDrawEnable():Boolean{
	      return this.isDrawEnable;
	    }
	    public function getBoxList():ArrayCollection{
	      return boxes;
	    }
	    public function getLineList():ArrayCollection{
	      return lines;
	    }
	    
	    

	}
}
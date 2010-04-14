package DrawingClasses
{
  import flash.events.MouseEvent;
  
  import model.Concept;
  
  import mx.collections.ArrayCollection;
  import mx.controls.Image;
  import mx.controls.Text;
  public class Box extends Image
  {
    private var designer:Designer = new Designer();
//  this line refrence arrays for drawing this box lines especialy when box moving
    private var fromLines:ArrayCollection = new ArrayCollection();
    private var toLines:ArrayCollection = new ArrayCollection();
    private var isSelected:Boolean;
    private var priorSelected:Boolean; //temp variable for select/deselect
	private var dragged:Boolean; // temp var for select/deselect
	private var startX;
	private var startY;
	private var endX;
	private var endY;
	public var text:Text;
	
	private var concept:Concept;
	
	private var isMouseDown:Boolean=false;
    [Bindable]
    [Embed(source="/assets/box.png")] 
    public var boxPicture:Class; 
    
    [Bindable]
    [Embed(source="/assets/box_selected.png")] 
    public var boxSelectedPicture:Class; 
    
    public function Box(d:Designer){
      this.source =boxPicture;   
      this.isSelected = false;
      this.priorSelected=false;
      this.dragged=false;
      this.concept = new Concept();
      text = new Text();
      text.text = "foo";
      this.designer=d;
    }
    
    public function getConcept():Concept{
    	return this.concept;
    }
    
    public function setConceptName(name:String):void{
    	this.concept.setName(name);
    }
    
    public function addFromLine(fromLine:Line):void{
      this.fromLines.addItem(fromLine);
    }
    public function addToLine(toLine:Line):void{
      this.toLines.addItem(toLine);
    }
    public function getFromLines():ArrayCollection{
      return this.fromLines;
    }
    public function getToLines():ArrayCollection{
      return this.toLines;
    }
    public function getWidth():int{
      return this.width;
    }
    public function getHeight():int{
      return this.height;
    }
    public function getX():int{
      return this.x;
    }
    public function getY():int{
      return this.y;
    }
    public function setDesigner(value:Designer):void{
      this.designer = value;
    }

    
    // when box create from Image Class adding this events for listening mouse movement 
    public function create(x:int,y:int,id:String):void{
      this.x = x;
      this.y = y;
      this.text.x=x;
      this.text.y=y;
      this.id = id;
      this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
      this.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
      this.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
    }
/*       this.text.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownText);
      this.text.addEventListener(MouseEvent.MOUSE_UP,mouseUpText);
    }
    private function mouseDownText(event:MouseEvent):void{
    	if(!designer.getIsDrawEnable()){
    		this.text.startDrag();
    	}
    }
    private function mouseUpText(event:MouseEvent):void{
    	if(!designer.getIsDrawEnable()){
    		this.text.stopDrag();
    	}
    } */
    
    // mouse down event define start drawing line or draging box 
    //if line button click before, it sets mouse coordinate as firt points of line
    //if line button dosen't click it sets dragable of box
    private function mouseDown(event:MouseEvent):void{
    	this.isMouseDown=true;
      if (!designer.getIsDrawEnable()){
         this.startDrag();
         
      }
      else{
        designer.prepareDrawing(); 
        designer.setCurrentFromBox(this);
      }
      this.priorSelected=this.isSelected;
      trace('mouse down');
      trace('prior');
      trace(this.priorSelected);      
      this.startX=event.stageX;;
      this.startY=event.stageY;
    }

    //mouse move events works when box draging 
    //if this box has line this methods draws it
    private function mouseMove(event:MouseEvent):void{
    	trace('mouse move');
    	if(this.isMouseDown){
    		this.text.x=this.x+this.width/2-this.text.width/2;
      	this.text.y=this.y+this.height/2-this.text.height/2;
      	designer.getDesignArea().removeChild(this.text);
      	designer.getDesignArea().addChildAt(this.text,1);
    	}
      if (fromLines.length>0){
        drawFromLines();
        
      }
      if (toLines.length>0){
        drawToLines();  
      }
           
    }
    // this medthods draw "from direction" lines with updated coordinate 
    public function drawFromLines():void{
      for (var i:int=0;i<fromLines.length;i++){
        Line(fromLines[i]).draw();
      }
    }
    // this medthods draw "to direction" lines with updated coordinate 
    public function drawToLines():void{
      for (var i:int=0;i<toLines.length;i++){
        Line(toLines[i]).draw();
      }
    }
    
    //mouse up events define stop box dragging or finish drawing line
    //if finish drawing line it sets mouse coordinate as last points of line  
    //if stop draging it sets stop drag 
    private function mouseUp(event:MouseEvent):void{
    	trace('mouseup');
      if (!designer.getIsDrawEnable()){
      	
        this.stopDrag();
      }
      else{  
        designer.setCurrentToBox(this);
        designer.addLine();
      }     
      this.endX=event.stageX;
      this.endY=event.stageY;
      trace(this.startX);
      trace(this.startY);
      trace(this.endX);
      trace(this.endY);
      this.dragged=(!((this.startX==this.endX)&&(this.startY==this.endY)));
      trace('dragged');
      trace(this.dragged);
      if(this.dragged){
      	this.isSelected=true;
      	this.priorSelected=true;
      	this.dragged=false;
      	this.source=boxSelectedPicture;
		if((designer.currentSelectedBox!=null)&&(designer.currentSelectedBox!=this)){
      		designer.currentSelectedBox.source=boxPicture;
      	}
      	designer.currentSelectedBox=this;
      	trace('selected');
      }else{
      	this.isSelected=!this.priorSelected;
      	this.priorSelected=this.isSelected;
      	if(!this.isSelected){
      		this.source=boxPicture;trace('deselected');
      		designer.currentSelectedBox=null;
      	}else{
      		this.source=boxSelectedPicture;trace('selected');
      		if((designer.currentSelectedBox!=null)&&(designer.currentSelectedBox!=this)){
      			designer.currentSelectedBox.source=boxPicture;
      			designer.currentSelectedBox.isSelected=false;
      		}
      		designer.currentSelectedBox=this;
      		this.source=boxSelectedPicture;
      	}
      	

      }
      this.text.x=this.x+this.width/2-this.text.width/2;
      	this.text.y=this.y+this.height/2-this.text.height/2;
      	designer.getDesignArea().removeChild(this.text);
      	designer.getDesignArea().addChild(this.text);
      	this.isMouseDown=false;
      	designer.redrawAllTexts();   
    }
    public function redrawText():void{
    	this.text.x=this.x+this.width/2-this.text.width/2;
      	this.text.y=this.y+this.height/2-this.text.height/2;
      	designer.getDesignArea().removeChild(this.text);
      	designer.getDesignArea().addChild(this.text);
    }
  }
}
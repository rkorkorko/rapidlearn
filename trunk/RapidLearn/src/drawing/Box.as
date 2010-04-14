package drawing
{
  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import mx.collections.ArrayCollection;
  import mx.controls.Image;  
  public class Box extends Image
  {
    private var designer:Designer;
//  this line refrence arrays for drawing this box lines especialy when box moving
    private var fromLines:ArrayCollection = new ArrayCollection();
    private var toLines:ArrayCollection = new ArrayCollection();

    [Bindable]
    [Embed(source="/Images/box.png")] 
    public var boxPicture:Class; 
    
    public function Box(){
      this.source =boxPicture;   
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
      this.id = id;
      this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
      this.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
      this.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
    }
    
    // mouse down event define start drawing line or draging box 
    //if line button click before, it sets mouse coordinate as firt points of line
    //if line button dosen't click it sets dragable of box
    private function mouseDown(event:MouseEvent):void{
      if (!designer.getIsDrawEnable()){
        this.startDrag();  
      }
      else{
        designer.prepareDrawing(); 
        designer.setCurrentFromBox(this);
      }      
    }
    //mouse move events works when box draging 
    //if this box has line this methods draws it
    private function mouseMove(event:MouseEvent):void{
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
      if (!designer.getIsDrawEnable()){
        this.stopDrag();
      }
      else{  
        designer.setCurrentToBox(this);
        designer.addLine();
      }      
    }
  }
}
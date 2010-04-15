package DrawingClasses
{
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import model.Concept;
  import model.ConceptRelation;
  import model.CourseMap;
  
  import mx.collections.ArrayCollection;
  import mx.containers.Canvas;
  import mx.controls.Button;
  import mx.managers.PopUpManager;
  
  import ui.NameDialog;
  public class Designer
  {
    private var boxes:ArrayCollection = new ArrayCollection();
    private var lines:ArrayCollection = new ArrayCollection();
    private var designArea:Canvas;
    private var lineButton:Button;
    private var isDrawEnable:Boolean = false;
    private var isDrawing:Boolean = false;
    private var templateLine:Line;
    private var currentFromBox:Box;
    private var currentToBox:Box;
    public var currentSelectedBox:Box;
    private var courseMap:CourseMap;
    private var flexDrawing:FlexDrawing;
    
    [Bindable]
    [Embed(source="/assets/arrow_black.png")] 
    public var lineOffPicture:Class; 
	
    // designer is a manager class. 
    public function Designer(fd:FlexDrawing){ 
    	this.flexDrawing = fd;
      createTemplateLine();   
      courseMap = new CourseMap();
      addEventListener("addCName", setConceptName);
    }
    
    public function getDesignArea():Canvas{
    	return this.designArea;
    }

    public function setLineButton(value:Button):void{
      this.lineButton = value;      
    }
    // create guide line for first time drawing
    public function createTemplateLine():void{
      templateLine = new Line();
      templateLine.name="templateLine";
      templateLine.visible = false;
    }
    // reset all design area and design item array
    public function reset():void{
      boxes.removeAll();
      lines.removeAll();
      designArea.removeAllChildren();
      lineButton.setStyle("icon", lineOffPicture);
      createTemplateLine();
      designArea.addChild(templateLine);
    }
    public function setIsDrawEnable(value:Boolean):void{
      this.isDrawEnable = value;
    }
    public function getIsDrawEnable():Boolean{
      return this.isDrawEnable;
    }
    public function setCurrentFromBox(value:Box):void{
      this.currentFromBox = value;      
    }
    public function setCurrentToBox(value:Box):void{
      this.currentToBox = value;  
    }
    public function getBoxList():ArrayCollection{
      return boxes;
    }
    public function getLineList():ArrayCollection{
      return lines;
    }
    private function getId(type:String):String{
      var idString:String  = type + Math.round(Math.random()*10000).toString();
      return idString;
    }
    
    // set design area and adding desing area events.    
    public function setDesignArea(value:Canvas):void{
      this.designArea = value;
      designArea.addChild(templateLine);      
      designArea.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
      designArea.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
    }
		// this method checks mouse up event on the box or not .
		// if not cancel drawing. 
		// if there is no excpation add lines
		public function mouseUp(event:MouseEvent):void{
      if (isDrawEnable){
        try{
          if (Box(event.currentTarget)!= null){
            addLine();
          }                  
        }
        catch(e:Error){
            cancelDrawing();          
        }        
      }      
    }
    //when mouse move on the design area drawing template line if isDrawing true
    public function mouseMove(event:MouseEvent):void{
      if (isDrawing){
        drawLine();  
      }
    }
    // create box 
    private var newBox:Box;
    private var win:NameDialog;
    public function addBox(x:int, y:int):void{
      newBox = new Box(this);
      var id:String = getId("Box");
      newBox.setDesigner(this);
      newBox.create(x,y,id);
      boxes.addItem(newBox);     
      
      win=PopUpManager.createPopUp(this.flexDrawing,NameDialog,true) as NameDialog;
      win.addEventListener("addCName", setConceptName);
	  PopUpManager.centerPopUp(win);
      designArea.addChild(newBox);      
    } 
    
    public function setConceptName(event:Event):void{
    	trace("name:", win.getName());
    	var name:String = win.getName();
    	newBox.setConceptName(name);
    	newBox.text.text=name;
    	designArea.addChild(newBox);
    	newBox.text.x=newBox.getX()+newBox.getWidth()/3;
    	newBox.text.y=newBox.getY()+newBox.getHeight()/3;
      	designArea.addChild(newBox.text);    	
	    courseMap.addConcept(newBox.getConcept());
	    trace("concept", newBox.getConcept().getName(), "added to CourseMap");
    } 
    
    // this method works when mouse down on the box 
    // it sets first point coordinae of template line
    public function prepareDrawing():void{    
      if (isDrawEnable){
        templateLine.graphics.clear();
        templateLine.setX1(designArea.mouseX);
        templateLine.setY1(designArea.mouseY);
        templateLine.visible = true;
        isDrawing = true;      
      }  
    }
    // this methods set second coordinate of template line and draw
    public function drawLine():void{   
      if (isDrawing){
        templateLine.setX2(designArea.mouseX);
        templateLine.setY2(designArea.mouseY);
        templateLine.draw();
      }
    }
    
    // this methods create new line and add line to box and designer
    public function addLine():void{ 
      if (isDrawing){
        var newLine:Line = new Line();
        newLine.setId(getId("Line"));
        newLine.setFromBox(currentFromBox);
        newLine.setToBox(currentToBox);
        newLine.draw();        
        currentFromBox.addFromLine(newLine);
        currentToBox.addToLine(newLine);          
        lines.addItem(newLine);
        designArea.addChild(newLine);
        cancelDrawing();
        
        //update model
        var fromConcept:Concept = currentFromBox.getConcept();
        var toConcept:Concept = currentToBox.getConcept();
        courseMap.addRelation(new ConceptRelation(fromConcept, toConcept)); 
        trace("relation from", fromConcept.getName(), "to", toConcept.getName());  
         
      }
      else{
        cancelDrawing();
      }
    }
    // this methods cancel drawing
    public function cancelDrawing():void{
      templateLine.visible = false;
      isDrawEnable = false;
      isDrawing = false;
      lineButton.setStyle("icon", lineOffPicture);
    }
    public function redrawAllTexts():void{
    	for(var i=0;i<boxes.length;i++){
    		boxes[i].redrawText();
    	}
    }
    public function fixAllMouseDowns():void{
    	for(var i=0;i<boxes.length;i++){
    		boxes[i].fixMouseDown();
    	}
    }
  }
}
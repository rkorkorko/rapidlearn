package DrawingClasses
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  
  import model.Concept;
  import model.ConceptRelation;
  import model.CourseMap;
  
  import mx.collections.ArrayCollection;
  import mx.containers.Canvas;
  import mx.controls.Button;
  import mx.managers.PopUpManager;
  
  import ui.NameDialog;
  public class Designer extends EventDispatcher
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
    private var flexDrawing:RapidLearn;
    
    [Bindable]
    [Embed(source="/assets/arrow_black.png")] 
    public var lineOffPicture:Class; 
	
    // designer is a manager class. 
    public function Designer(fd:RapidLearn){ 
    	this.flexDrawing = fd;
      createTemplateLine();   
      courseMap = new CourseMap();
      addEventListener("addCName", setConceptName);
      
    }
    

    
    public function getDesignArea():Canvas{
    	return this.designArea;
    }
    
    public function getCourseMap():CourseMap {
    	return this.courseMap;
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
    
    //forward event when selection changed
    private function selectionChangedHandler(event:Event):void {
    	dispatchEvent(new Event("selectionChanged"));
    }
    
    // create box 
    private var newBox:Box;
    private var win:NameDialog;
    private var enterKey:Boolean = false;
    public function addBox(x:int, y:int):void{
      newBox = new Box(this);
      var id:String = getId("Box");
      newBox.setDesigner(this);
      newBox.create(x,y,id);
      newBox.addEventListener("selectionChanged",selectionChangedHandler);
      boxes.addItem(newBox);     
      
      win=PopUpManager.createPopUp(this.flexDrawing,NameDialog,true) as NameDialog;
      enterKey =true;
      win.addEventListener(KeyboardEvent.KEY_DOWN, enterKeyListener);
      win.addEventListener("addCName", setConceptName);
	  PopUpManager.centerPopUp(win);
      designArea.addChild(newBox);      
    } 
    
    public function enterKeyListener(event: KeyboardEvent):void{
    	trace("enter in keyboard listner");
    	if (event.charCode==13 && enterKey==true){
    		//win.handleNameDialogClick();
    		trace("fired keyboard listner");
    	}
    } 
    
    public function setConceptName(event:Event):void{
    	trace("name:", win.getName());
    	var name:String = win.getName();
    	newBox.setConceptName(name);
    	newBox.text.text=name;
    	designArea.addChild(newBox);
    	
    	
      	designArea.addChild(newBox.text);
      	newBox.text.x = newBox.x+newBox.width/2-newBox.text.text.length*4;
    	newBox.text.y = newBox.y+newBox.height/2-9;
    	//trace("redraw");
   //   	newBox.addMouseUpEventListenerToText();
      	   	
	    courseMap.addConcept(newBox.getConcept());
	    trace("concept", newBox.getConcept().getName(), "added to CourseMap");
	    enterKey=false;trace(newBox.text.height);
    	trace(newBox.text.width);
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
    
    public function whitespaceClickHandler(){
    	trace("whitespace click");
     	var x:int = flexDrawing.designArea.mouseX;
    	var y:int = flexDrawing.designArea.mouseY;
		//check if box on location
		var onBox:Boolean;
		for(var i=0;i<boxes.length;i++){
    		var a:int = boxes[i].getX();
    		var b:int = boxes[i].getY();
    		var c:int = boxes[i].getX()+boxes[i].getWidth();
    		var d:int = boxes[i].getY()+boxes[i].getHeight();
    		trace(x);
    		trace(y);
    		trace(a);
    		trace(b);
    		trace(c);
    		trace(d);
    		if((x>=a) && (x<=c) && (y>=b) && (y<=d)){
    			return;
    		}
    	}
    	//if we get here then we know no boxes clicked. deselect all boxes
    	for(var i=0;i<boxes.length;i++){
    		currentSelectedBox.source=currentSelectedBox.boxPicture;
    		currentSelectedBox = null;
    	} 
    }
  }
}
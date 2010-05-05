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
    
    public function deleteSelectedLines(){
    	var count:int =0;
    	var linesToRemove:ArrayCollection = new ArrayCollection();
    	for(var i=0;i<lines.length;i++){
    		if(lines[i].isSelect){
    			trace("selected line found");
    			this.courseMap.getRelations().removeItemAt(getConceptRelationIndexFromLine(lines[i]));
    			designArea.removeChild(lines[i]);
    			linesToRemove.addItem(lines[i]);
    		}
    	}
    	count = linesToRemove.length;
    	for(var j=0;j<linesToRemove.length;j++){
    		lines.removeItemAt(lines.getItemIndex(linesToRemove[j]));
    	}
    	if(count==1){
    		flexDrawing.statusNotification.text="1 relation successfully deleted";
    	}if(count>1){
    		flexDrawing.statusNotification.text=count + " relations successfully deleted";
    	}
    }
    
    public function getConceptRelationIndexFromLine(line:Line):int{
    	for(var i =0;i<courseMap.getRelations();i++){
    		if(courseMap.getRelations()[i].getPrevious() == line.fromBox.concept && courseMap.getRelations()[i].getNext() == line.toBox.concept){
    			return i;
    		}
    	}
    	return null;
    }
    
    public function deleteSelectedBoxes():void{
    	if(currentSelectedBox!=null){
    		trace(currentSelectedBox.text.text);
    		//update status bar
    		flexDrawing.statusNotification.text = currentSelectedBox.text.text + " is deleted";
    		
    		var concept:Concept = Concept(this.courseMap.getConcepts().getItemAt(getConceptIndexFromBox(currentSelectedBox)));
    		var cnametodisplay:String = concept.getName();
    		trace(cnametodisplay);
    		for(var k:int = 0;k<courseMap.getProblems().length;k++){
    			if(courseMap.getProblems()[k].getConcepts().contains(concept)){
    				trace(courseMap.getProblems()[k].getConcepts());
    				courseMap.getProblems()[k].getConcepts().removeItemAt(courseMap.getProblems()[k].getConcepts().getIndexOf(concept));
    				trace(courseMap.getProblems()[k].getConcepts());
    			}
    			
    		}
    		
    		this.courseMap.getConcepts().removeItemAt(getConceptIndexFromBox(currentSelectedBox));
    		designArea.removeChild(currentSelectedBox);
    		designArea.removeChild(currentSelectedBox.text);
    		boxes.removeItemAt(boxes.getItemIndex(currentSelectedBox));
    		
    		//need to remove all arrows into and out of this box
    		var linesToRemove:ArrayCollection = new ArrayCollection();
    		for(var i=0;i<lines.length;i++){
    			if(lines[i].fromBox == currentSelectedBox || lines[i].toBox == currentSelectedBox){
    				this.courseMap.getRelations().removeItemAt(getConceptRelationIndexFromLine(lines[i]));
    				designArea.removeChild(lines[i]);
    				linesToRemove.addItem(lines[i]);
    			}
    			
    		}
    		    	for(var j=0;j<linesToRemove.length;j++){
    		lines.removeItemAt(lines.getItemIndex(linesToRemove[j]));
    		
    	}
    		
    		
    		currentSelectedBox=null;
    		
    		
    	}  	
    	 
    }
    
    public function getConceptIndexFromBox(box:Box):int{
    	for(var i=0;i<courseMap.getConcepts();i++){
    		if(courseMap.getConcepts()[i] == box.concept){
    			return i;
    		}
    	}
    	return null;
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
      courseMap.clear();      
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
      designArea.addEventListener(KeyboardEvent.KEY_DOWN, enterKeyListener);
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
  	  designArea.addChild(newBox);      
      
      win=PopUpManager.createPopUp(this.flexDrawing,NameDialog,true) as NameDialog;
      enterKey =true;
      win.init(courseMap);
      win.addEventListener(KeyboardEvent.KEY_DOWN, enterKeyListener);
      win.addEventListener("addCName", setConceptName);
      win.addEventListener("invalidCName",removeInvalidConceptBox);
	  PopUpManager.centerPopUp(win);     
    } 
    
    public function enterKeyListener(event: KeyboardEvent):void{
    	trace("enter in keyboard listner");
    	if (event.charCode==13 && enterKey==true){
    		win.handleNameDialogClick();
    		trace("fired keyboard listner");
    	}
    } 
    
    
    public function removeInvalidConceptBox(event:Event):void {
    	if(newBox != null) {
    		trace("Removing invalid concept box");
    		boxes.removeItemAt(boxes.length-1);
    		designArea.removeChild(newBox);
    		newBox = null;
    	}
    }
    
    
    public function setConceptName(event:Event):void{
    	trace("name:", win.getName());
    	
    	 
    	
    	var name:String = win.getName();
    	
    	newBox.setConceptName(name);
    	
    	newBox.text.text=name;
    	
    	
    	
      	designArea.addChild(newBox.text);
      	newBox.text.x = newBox.x+newBox.width/2-newBox.text.text.length*4;
    	newBox.text.y = newBox.y+newBox.height/2-9;
    	//trace("redraw");
   		//newBox.addMouseUpEventListenerToText();
      	   	
	    courseMap.addConcept(newBox.getConcept());
	    trace("concept", newBox.getConcept().getName(), "added to CourseMap");
	    enterKey=false;trace(newBox.text.height);
    	trace(newBox.text.width);
    	
    	//updating status bar
    	flexDrawing.statusNotification.text = "Concept Added: " + name;
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
        newLine.addEventListener("lineSelected",lineSelectedHandler);
        newLine.addEventListener("lineDeselected",lineDeselectedHandler);
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
        
        //update status bar
        flexDrawing.statusNotification.text = currentFromBox.name + " is a prerequisite to " + currentToBox.name;
         
      }
      else{
        cancelDrawing(); 
      }
    }  
 
 	public function lineSelectedHandler(event:Event):void {
 		dispatchEvent(new Event("lineSelected"));
 	}
 	
 	public function lineDeselectedHandler(event:Event):void {
 		dispatchEvent(new Event("lineDeselected"));
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

    		if((x>=a) && (x<=c) && (y>=b) && (y<=d)){
    			return;
    		}
    	}
    	//if we get here then we know no boxes clicked. deselect all boxes
			if(currentSelectedBox!=null){
    			currentSelectedBox.source=currentSelectedBox.boxPicture;
    			currentSelectedBox = null;
    			dispatchEvent(new Event("selectionChanged"));
   			}
    	
    }
  }
}
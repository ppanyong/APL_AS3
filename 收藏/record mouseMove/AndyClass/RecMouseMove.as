/*
* @class        utils.ageyev.RecMouseMove
* @description  Class for record mouse movement and reproduction written down.
* @usage        import utils.ageyev.RecMouseMove;
*               var recorder:RecMouseMove = new RecMouseMove();
*               recorder.record(83, 40);
*               this.createTextField("my_txt", 101, 10, 10, 300, 100);
*               my_txt.text = "Wait, recording mouse movement..."; 
*               this.onEnterFrame = function(){
*                       if(!recorder.isActive()){
*                               trace(recorder.getCoord());
*                               var mc = this.createEmptyMovieClip("myMouse", 100);
*                               mc.beginFill(0xFF0000);
*                               mc.moveTo(0, 0);
*                               mc.lineTo(30, 0);
*                               mc.lineTo(0, 30);
*                               mc.lineTo(0, 0);
*                               mc.endFill();
*                               my_txt.text = "Replaying...";
*                               recorder.play(mc, 83);
*                               this.onEnterFrame = null;
*                       }
*               }
* @author:      Igor Ageyev (igor@ageyev.ru)
* @version:     1.2.0
*/

class AndyClass.RecMouseMove{
	
	// info of mouse position
	private var X:Array = [];
	private var Y:Array = [];
	
	private var act:Boolean; // whether there is a recording or playing
	
	private var i:Number; // index of arrays
	private var freq:Number; // frequency of record
	private var ID:Number; // for setInterval
	private var step:Number; // amount of step of recording
	
	var mc:MovieClip; // MovieClip for playing
	
	/* Begins recording mouse movement
	*  @param	fre		frequency of record (?ptional, 50 by default)
	*  @param	amount	Duration of record (?ptional, false by default)
	*/
	public function record(fre:Number, amount:Number):Void{
		clearInterval(ID);
		act = true;
		step = amount ? amount : false;
		freq = fre ? fre : 50;
		i = 0;

		ID = setInterval(this, "recording", freq);
	}
	
	/* Records mouse movement
	*  @param	obj		instance of class
	*/
	private function recording():Void{
		// now recording...
		X[i] = Math.round(_xmouse);
		Y[i] = Math.round(_ymouse);
		
		i++;
		if(i > step && step <> false){
			this.stop();
		}
	}
	
	// Stops recording
	public function stop():Void{
		act = false;
		clearInterval(ID);
	}
	
	/*
	* Signals about, whether there is a recording or playing
	* @return	Boolean value (false or true)
	*/
	public function isActive():Boolean{
		return act;
	}
	
	/*
	* Gives out the information mouse movement
	* @return	xml object with information of coordinates
	*/
	public function getCoord():XML{
		// create an XML document
		var coord:XML = new XML();
		
		// create two XML nodes
		var element1:XMLNode = coord.createElement("x");
		var element2:XMLNode = coord.createElement("y");
		coord.appendChild(element1);
		coord.appendChild(element2);
		
		// create two XML text nodes
		var textNode1:XMLNode = coord.createTextNode(X.toString());
		var textNode2:XMLNode = coord.createTextNode(Y.toString());
		element1.appendChild(textNode1);
		element2.appendChild(textNode2);

		return (coord);
		
	}
	
	/*
	* Receives the information mouse movement
	* @param 	coord   xml object with information of coordinates
	*/
	public function setCoord(coord:XML):Void{
		var aNode:XMLNode = coord.firstChild;
		X = aNode.firstChild.nodeValue.split(",");
		aNode = aNode.nextSibling;
		Y = aNode.firstChild.nodeValue.split(",");

	}
	
	/*
	* Begins playing mouse movement
	* @param 	target	movie clip
	* @param 	fre		frequency of record (?ptional, 50 by default)
	*/
	public function play(target:MovieClip, fre:Number):Void{
		clearInterval(ID);
		mc = target;
		freq = fre ? fre : 50;
		i = 0;
		ID = setInterval(this, "playing", freq);
		act = true;
	}
	
	/* Playing
	*  @param obj	instance of class
	*/
	private function playing():Void{
		mc._x = X[i];
		mc._y = Y[i];

		i++;
		if(i==X.length){
			this.stop();
		}
	}
	
}	// 	=====	end RecMouseMove class	
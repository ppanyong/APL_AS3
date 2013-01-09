package  
{
	import com.formatlos.as3.lib.text.highlight.style.IHighlightStyle;
	import com.formatlos.as3.lib.text.highlight.style.SimpleHighlightStyle;
	import com.formatlos.as3.lib.text.highlight.TextHighlighter;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Martin Raedlinger (mr@formatlos.de)
	 */
	 
	[SWF(width="558", height="100", frameRate="25", backgroundColor="#CCCCCC")]
	public class TextHighlighterExample extends Sprite
	{	
		public function TextHighlighterExample()
		{
			// stage settings
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.BEST;
			
			
			// highlight container
			var highlight : Sprite = new Sprite();
			addChild(highlight);
			
			// create textfield
			var textFormat : TextFormat = new TextFormat("Arial", 12, 0x000000);
			textFormat.leading = 4;
			
			var textField : TextField = new TextField();
			addChild(textField);
			
			textField.autoSize = TextFieldAutoSize.NONE;
			textField.mouseWheelEnabled = false;
			textField.width = stage.stageWidth;
			textField.height = stage.stageHeight;
			textField.wordWrap = true;
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
			textField.multiline = true;
			
			// add text
			textField.text = "Far far away, behind the word mountains, " +
			"far from the countries Vokalia and Consonantia, there live the blind texts. " +
			"Separated they live in Bookmarksgrove right at the coast of the Semantics, " +
			"a large language ocean. A small river named Duden flows by their place and " +
			"supplies it with the necessary regelialia. It is a paradisematic country, " +
			"in which roasted parts of sentences fly into your mouth. Even the all-powerful " +
			"Pointing has no control about the blind texts it is an almost unorthographic ...";
			
			
			// highlight style
			var style : IHighlightStyle = new SimpleHighlightStyle(0x00ff00, 0.5);
			
			// highlighter
			var textHighlighter : TextHighlighter = new TextHighlighter(textField, highlight, style);
			textHighlighter.highlight(/far/gi);
			textHighlighter.highlight("Duden", false);
			
		}
	}
}

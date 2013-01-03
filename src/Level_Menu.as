package    {
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	
	public class Level_Menu extends Level{
		
		[Embed(source="../data/menu-background.png")] private var ImgBackground:Class;
		
		public var startButton:FlxButtonPlus;
		public var cursor:AnimatedCursor;
		
		public var title:FlxText;
		public var titleSub:FlxText;
		public var prototype:FlxText;
		
		public var startGame:Boolean = false;

		public const TEXT_COLOR:uint = 0x4ECDC4;
		public const ALT_TEXT_COLOR:uint = 0xC7F464;
		
		public function Level_Menu( group:FlxGroup ) {

			super();
			
			levelSizeX = 160;
			levelSizeY = 240;
			
			createForegroundAndBackground();
			
			// Add cursor
			cursor = new AnimatedCursor();
			PlayState.groupForeground.add(cursor);
			
		}
		
		override public function nextLevel():Boolean
		{
			if( startGame )
			{
				return true;
			}
			return false;
		}
		
		public function createForegroundAndBackground():void {
			
			// Background
			var backgroundSprite:FlxSprite;
			backgroundSprite = new FlxSprite(0,0);
			backgroundSprite.loadGraphic(ImgBackground, true, true, 160, 240);	
			PlayState.groupBackground.add(backgroundSprite);
			
			// Title
			title = new FlxText(0, 32, FlxG.width, "Slide");
			title.setFormat(null,32,TEXT_COLOR,"center");
			PlayState.groupForeground.add(title);
			
			titleSub = new FlxText(0, 72, FlxG.width, "Trivia");
			titleSub.setFormat(null,32,ALT_TEXT_COLOR,"center");
			PlayState.groupForeground.add(titleSub);
			
			prototype = new FlxText(0, 224, FlxG.width, "Scopely Prototype");
			prototype.setFormat(null,8,0xfffef0,"center");
			PlayState.groupForeground.add(prototype);
			
			// Create start buttons
			var buttonSize:int = 64;
			startButton = new FlxButtonPlus(FlxG.width/2 - buttonSize/2, FlxG.height/2 + 34, start, [], "START", buttonSize);
			startButton.updateInactiveButtonColors([ 0xff0b486b, 0xff3b8686, 0xff79bd9a ]);
			startButton.updateActiveButtonColors([ 0xff10F064, 0xffC7F464, 0xffC7F464 ]);
			startButton.visible = true;
			PlayState.groupForeground.add(startButton);
		}
		
		public function start():void {
			startGame = true;
		}
		
		override public function update():void
		{			
			super.update();
		}	
	}
}

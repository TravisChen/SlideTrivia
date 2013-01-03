package
{
	import flash.events.*;
	import flash.net.*;
	
	import org.flixel.*;
	
	public class PlayState extends BasePlayState
	{
		public static var _currLevel:Level;
		public static var _intro:Boolean = false;
		
		public static var groupBackground:FlxGroup;
		public static var groupTilemap:FlxGroup;
		public static var groupEnemy:FlxGroup;
		public static var groupCollects:FlxGroup;
		public static var groupPlayer:FlxGroup;
		public static var groupForeground:FlxGroup;
		
		public static var questions:Array = [];
		public static var currQuestion:int = 0;
		public static var myLoader;
		
		function PlayState():void
		{
			super();

			groupBackground = new FlxGroup;
			groupTilemap = new FlxGroup;
			groupEnemy = new FlxGroup;
			groupPlayer = new FlxGroup;
			groupCollects = new FlxGroup;
			groupForeground = new FlxGroup;
			
			var myRequest:URLRequest = new URLRequest("questions.csv");
			myLoader = new URLLoader();			
			myLoader.addEventListener(Event.COMPLETE, onload);
			myLoader.load(myRequest);

			this.add(groupBackground);
			this.add(groupTilemap);
			this.add(groupEnemy);
			this.add(groupPlayer);
			this.add(groupCollects);
			this.add(groupForeground);
		}
		
		private function onload( Event ):void
		{
			questions = myLoader.data.split(/\r\n|\n|\r/);
			for (var i:int=0; i<questions.length; i++){
				questions[i] = questions[i].split(",");
			}
			
			// Create the level
			var currLevelClass:Class;
			if( !_intro )
			{
				currLevelClass = Level_Menu;
				_currLevel = new currLevelClass( groupBackground );
			}
			else
			{
				if( currQuestion < questions.length )
				{
					currLevelClass = Level_Main;
					_currLevel = new currLevelClass( groupBackground, questions[currQuestion][0], questions[currQuestion][1], questions[currQuestion][2], questions[currQuestion][3] );
				}
				else
				{
					currLevelClass = Level_Menu;
					_currLevel = new currLevelClass( groupBackground );					
				}
				
				currQuestion++;
			}
		}
		
		override public function update():void
		{						
			// Update level
			if( _currLevel )
			{
				_currLevel.update();
				
				// Next level
				if( _currLevel.nextLevel() )
				{
					nextLevel();				
				}
			}
			
			super.update();
		}
		
		public function nextLevel():void
		{
			_intro = true;
			FlxG.switchState(new PlayState());
		}
		
		override public function create():void
		{
		}

		override public function destroy():void
		{
			// Update level
			_currLevel.destroy();
			
			super.destroy();
		}
	}
}
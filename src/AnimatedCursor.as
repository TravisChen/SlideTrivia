package
{
	import org.flixel.*;
	
	public class AnimatedCursor extends FlxSprite
	{
		[Embed(source="../data/game-cursor.png")] private var imgGameCursor:Class;
		
		public function AnimatedCursor()
		{
			super();
			loadGraphic(imgGameCursor, true, true, 12, 12);
			addAnimation("normal", [0,1,2,1], 5);
			
			scale.x = 3;
			scale.y = 3;
			
			offset.x = -10;
		}
		
		override public function update():void
		{
			super.update();
			
			play("normal");
			
			x = FlxG.mouse.x;
			y = FlxG.mouse.y;
		}
	}
}
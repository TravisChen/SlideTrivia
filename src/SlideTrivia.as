package
{
	import org.flixel.*; 
	[SWF(width="480", height="720", backgroundColor="#556270")] 
	
	public class SlideTrivia extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		
		public function SlideTrivia()
		{
			super(160,240,PlayState,3);
		}
	}
}
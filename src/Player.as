package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="data/player.png")] private var ImgPlayer:Class;
		[Embed(source="data/enemy.png")] private var ImgEnemy:Class;
		
		public var running:Boolean = false;
		public var dead:Boolean = false;
		public var win:Boolean = false;
		public var lose:Boolean = false;
		
		public function Player(X:int,Y:int,enemy:Boolean)
		{
			super(X,Y);
			
			if( enemy )
				loadGraphic(ImgEnemy,true,true,32,40);
			else
				loadGraphic(ImgPlayer,true,true,32,40);
			
			// Bounding box tweaks
			width = 32;
			height = 40;
			offset.x = 16;
			offset.y = 16;
			
			this.scale = new FlxPoint( 1, 1 );
			
			addAnimation("win", [0,4], 6 );
			addAnimation("lose", [13], 6);
			addAnimation("dead", [18,19,18], 6);
			addAnimation("idle", [0,11,12,11], 6);
			addAnimation("run", [0,1,2,3], 12);
		}
		
		override public function update():void
		{
			if( dead )
			{
				play("dead");
			}
			else if ( win )
			{
				play("win");
			}
			else if ( lose )
			{
				play("lose");
			}
			else
			{
				if( running )
					play("run");
				else
					play("idle");
			}
			
			super.update();
		}
	}
}
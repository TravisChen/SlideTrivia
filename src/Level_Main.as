package    {
		
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	
	public class Level_Main extends Level{
	
		[Embed(source="../data/game-background.png")] private var ImgBackground:Class
		[Embed(source="../data/game-answer-background.png")] private var ImgAnswerBackground:Class
		[Embed(source="../data/game-answer-bar.png")] private var ImgAnswerBar:Class
		
		[Embed(source = "../sound/song.mp3")] private var SndSong:Class;
		[Embed(source = "../sound/done.mp3")] private var SndDone:Class;
		[Embed(source = "../sound/winner.mp3")] private var SndWin:Class;
		[Embed(source = "../sound/lose.mp3")] private var SndLose:Class;
		[Embed(source = "../sound/bust.mp3")] private var SndBust:Class;
		
		// Inputs
		private var _question:String;
		private var _questionMin:int;
		private var _questionMax:int;
		private var _questionAnswer:int;
		
		// Timer
		public var startTime:Number;
		public var endTime:Number;
		private var timerText:FlxText;
		private var questionText:FlxText;
		private var answerText:FlxText;
		private var correctAnswerText:FlxText;
		private var playerAnswerText:FlxText;
		private var enemyAnswerText:FlxText;
		private var winnerText:FlxText;
		
		// Buzz in
		private var nextButton:FlxButtonPlus;
		private var playerBuzzedIn:Boolean = false;
		private var cursor:AnimatedCursor;
		
		private var sliderBar:FlxButtonPlus;
		private var slider:FlxButtonPlus;
		
		private var isSliding:Boolean = false;
		private var mouseDown:Boolean = false;
		private var overSlider:Boolean = false;
		private var showResults:Boolean = false;
		private var playerDone:Boolean = false;
		private var enemyDone:Boolean = false;
		private var pressedNext:Boolean = false;
		private var firstUpdate:Boolean = true;
		private var winSound:Boolean = false;
		private var playerBust:Boolean = false;
		private var enemyBust:Boolean = false;
		
		private var sliderBarSize:Number = 0.0;
		private var sliderBarOffset:Number = 0.0;
		private var sliderWidth:Number = 0.0;
		
		// Consts
		public const MAX_TIME:uint = 8;
		public const TEXT_COLOR:uint = 0x4ECDC4;
		public const ALT_TEXT_COLOR:uint = 0xC7F464;
		public const PLAYER_1_COLOR:uint = 0x5a94ff;
		public const PLAYER_2_COLOR:uint = 0xf76347;
		
		// Question
		private var currGuess:int;
		private var lastGuess:int = currGuess;
		private var enemyGuess:int = 0;

		// Backgrounds
		private var backgroundSprite:FlxSprite;
		private var answerBackgroundSprite:FlxSprite;
		private var answerBarSprite:FlxSprite;
		
		public function Level_Main( group:FlxGroup, question:String, questionMin:int, questionMax:int, questionAnswer:int ) {
			
			_question = question;
			_questionMin = questionMin;
			_questionMax = questionMax;
			_questionAnswer = questionAnswer;
			
			currGuess = questionMin;
			
			levelSizeX = 160;
			levelSizeY = 240;
			
			timer = MAX_TIME;
			endTime = 1.0;
			
			// Create player
			player = new Player(FlxG.height*1/4,166, false);
			PlayState.groupPlayer.add(player);
			
			enemy = new Player(-32,158, true);
			PlayState.groupEnemy.add(enemy);
			
			// Simulate other player guess
			enemyGuess = Math.floor(Math.random() * (questionMax - questionMin )) + questionMin;
			
			createHUD();
			
			// Add cursor
			cursor = new AnimatedCursor();
			PlayState.groupForeground.add(cursor);
			
			super();
		}
		
		public function createHUD():void {

			// Create background
			backgroundSprite = new FlxSprite(0,0);
			backgroundSprite.loadGraphic(ImgBackground, true, true, 160, 240);	
			PlayState.groupBackground.add(backgroundSprite);
			
			answerBackgroundSprite = new FlxSprite(0,0);
			answerBackgroundSprite.loadGraphic(ImgAnswerBackground, true, true, 160, 240);	
			PlayState.groupBackground.add(answerBackgroundSprite);
			
			answerBarSprite = new FlxSprite(-32,133);
			answerBarSprite.loadGraphic(ImgAnswerBar, true, true, 3, 59);	
			PlayState.groupBackground.add(answerBarSprite);
			
			// Timer
			timerText = new FlxText(0, 2, FlxG.width, "0:00");
			timerText.setFormat(null,16,TEXT_COLOR,"center");
			PlayState.groupBackground.add(timerText);
			
			// Question Text
			questionText = new FlxText(4, 34, FlxG.width - 8, _question);
			questionText.setFormat(null,8,ALT_TEXT_COLOR,"left");
			PlayState.groupBackground.add(questionText);
			
			// Answer Text
			answerText = new FlxText(0, 88, FlxG.width, "100");
			answerText.setFormat(null,32,ALT_TEXT_COLOR,"center");
			PlayState.groupBackground.add(answerText);
			
			// Correct Answer Text
			correctAnswerText = new FlxText(-1000, 92, FlxG.width, "100");
			correctAnswerText.setFormat(null,32,0xfffef0,"right");
			PlayState.groupBackground.add(correctAnswerText);
			correctAnswerText.visible = false;
			
			// Player Answer Text
			playerAnswerText = new FlxText(-1000, 192, FlxG.width, "100");
			playerAnswerText.setFormat(null,16,PLAYER_1_COLOR,"center");
			PlayState.groupBackground.add(playerAnswerText);
			playerAnswerText.visible = false;
			
			enemyAnswerText = new FlxText(-1000, 210, FlxG.width, "100");
			enemyAnswerText.setFormat(null,16,PLAYER_2_COLOR,"center");
			PlayState.groupBackground.add(enemyAnswerText);
			enemyAnswerText.visible = false;
			
			// Winner text
			winnerText = new FlxText(0, 240, FlxG.width*2/3, "You Win!");
			winnerText.setFormat(null,16,0xfffef0,"center");
			PlayState.groupBackground.add(winnerText);
			
			// Slider bar
			sliderBarSize = FlxG.width - 8;
			sliderBarOffset = 4;
			sliderWidth = 16;
			sliderBar = new FlxButtonPlus(sliderBarOffset, 210, null, [], "", sliderBarSize, 14);
			sliderBar.updateInactiveButtonColors([ 0xff4ECDC4, 0xff4ECDC4, 0xff4ECDC4 ]);
			sliderBar.updateActiveButtonColors([ 0xff4ECDC4, 0xff4ECDC4, 0xff4ECDC4 ]);
			sliderBar.visible = true;
			PlayState.groupForeground.add(sliderBar);
			
			// Slider
			slider = new FlxButtonPlus(4, 202, null, [], "", sliderWidth, 32);
			slider.setMouseOverCallback(sliderOver,[]);
			slider.setMouseOutCallback(sliderOut,[]);
			slider.updateInactiveButtonColors([ 0xff4ECDC4, 0xff4ECDC4, 0xff4ECDC4 ]);
			slider.updateActiveButtonColors([ 0xffC7F464, 0xffC7F464, 0xffC7F464 ]);
			slider.visible = true;
			PlayState.groupForeground.add(slider);
			
			// Create start buttons
			nextButton = new FlxButtonPlus(116, 206, next, [], "NEXT", 40);
			nextButton.updateInactiveButtonColors([ 0xff0b486b, 0xff3b8686, 0xff79bd9a ]);
			nextButton.updateActiveButtonColors([ 0xff10F064, 0xffC7F464, 0xffC7F464 ]);
			nextButton.visible = false;
			PlayState.groupForeground.add(nextButton);
		}
		
		public function next():void {
			pressedNext = true;
		}
		
		public function sliderOver():void {
			overSlider = true;
		}
		
		public function sliderOut():void {
			overSlider = false;
		}
		
		public function buzzIn():void {
			playerBuzzedIn = true;
		}
		
		private function setupResults():void {
			
			if( !showResults )
			{
				player.x = -32;
				enemy.x = -32;
				answerBarSprite.x = -32;
				
				player.running = true;
				player.facing = 0;
				enemy.running = true;
				enemy.facing = 0;
				
				sliderBar.visible = false;
				slider.visible = false;
				cursor.visible = false;
				answerText.visible = false;
				answerBackgroundSprite.visible = false;
				correctAnswerText.visible = true;
				playerAnswerText.visible = true;
				enemyAnswerText.visible = true;
				showResults = true;
				timerText.text = "RESULT";
				
				FlxG.play(SndDone);
			}
		}
		
		private function updateTimer():void
		{
			// Timer
			var minutes:uint = timer/60;
			var seconds:uint = timer - minutes*60;
			timer -= FlxG.elapsed;
			
			// Check round end
			if( timer <= 0 )
			{
				setupResults();
				return;
			}
			
			// Update timer text
			if( seconds < 10 )
				timerText.text = "" + minutes + ":0" + seconds;
			else
				timerText.text = "" + minutes + ":" + seconds;
		}
		
		public function updateSlider():void
		{	
			if( showResults )
				return;
			
			player.x = slider.x + sliderWidth / 2;
			
			if( isSliding && FlxG.mouse.pressed() )
			{
				player.running = true;
				slider.x = cursor.x;
				
				currGuess = getGuessFromX( slider.x );
				
				if( lastGuess > currGuess )
					player.facing = 1;
				else if ( lastGuess < currGuess )
					player.facing = 0;
			}
			else
			{
				player.running = false;
				player.facing = 0;
				
				if( overSlider && FlxG.mouse.pressed() )
				{
					isSliding = true;
				}
			}
			
			if( slider.x <= sliderBarOffset )
			{
				slider.x = sliderBarOffset;
				currGuess = _questionMin;
			}
			
			if( slider.x >= sliderBarSize - sliderWidth/2 - sliderBarOffset )
			{
				slider.x = sliderBarSize - sliderWidth/2 - sliderBarOffset;
				currGuess = _questionMax;
			}
			
			lastGuess = currGuess;
		}
		
		public function getGuessFromX( x:Number ):int
		{
			var guess:int  = 0;
			var percentage:Number = ( ( x + sliderBarOffset ) / ( sliderBarSize ) );
			guess = (int) ( _questionMin + ( (_questionMax - _questionMin ) * percentage ) );
			
			return guess;
		}
		
		public function getTargetX( guess:int ):Number
		{
			var targetX:Number = 0;
			var guessPercent:Number = ( ( guess - _questionMin ) / (_questionMax - _questionMin ) );
			targetX = ( ( sliderBarSize * guessPercent ) + sliderBarOffset );
			
			return targetX;
		}	
		
		public function updateWinnerResults():void
		{
			if( playerDone && enemyDone )
			{
				endTime -= FlxG.elapsed;
				if( endTime <= 0 )
				{
					playerAnswerText.alpha -= 0.05;
					enemyAnswerText.alpha -= 0.05;	
					
					winnerText.y -= 1.5;
					if( winnerText.y <= 204 )
					{
						nextButton.visible = true;
						cursor.visible = true;
						winnerText.y = 204;
					}
		
					if( currGuess == enemyGuess || ( currGuess > _questionAnswer && enemyGuess > _questionAnswer )  )
					{
						winnerText.text = "Draw";
						
						if( !winSound )
						{
							FlxG.play(SndLose);
							winSound = true;
						}
					}
					else if( ( currGuess > enemyGuess && currGuess <= _questionAnswer ) || ( currGuess < enemyGuess && enemyGuess > _questionAnswer ) )
					{
						winnerText.text = "Blue Wins!";
						player.win = true;
						enemy.lose = true;
						winnerText.color = PLAYER_1_COLOR;
						
						if( !winSound )
						{
							FlxG.play(SndWin);
							winSound = true;
						}
					}
					else if( ( enemyGuess > currGuess && enemyGuess <= _questionAnswer ) || ( enemyGuess < currGuess && currGuess > _questionAnswer ) )
					{
						winnerText.text = "Red Wins.";
						enemy.win = true;
						player.lose = true;
						winnerText.color = PLAYER_2_COLOR;
						
						if( !winSound )
						{
							FlxG.play(SndLose);
							winSound = true;
						}
					}
						
				}
			}
		}
		
		public function updateResults():void
		{
			var answerTarget:Number = getTargetX( _questionAnswer );
			var playerTarget:Number = getTargetX( currGuess );
			var enemyTarget:Number = getTargetX( enemyGuess );
			
			if( answerBarSprite.x >= answerTarget )
			{
				answerBarSprite.x = answerTarget;
				correctAnswerText.text = "" + _questionAnswer + "";
			}
			else
			{
				answerBarSprite.x += 1.5;
				correctAnswerText.x = answerBarSprite.x - 143;
				correctAnswerText.text = "" + getGuessFromX(answerBarSprite.x) + "";
			}
			

			
			if( player.x >= playerTarget )
			{
				player.x = playerTarget;
				player.running = false;
				playerDone = true;
				
				if( currGuess == _questionAnswer )
				{
					player.win = true;					
				}
				else if( currGuess > _questionAnswer )
				{
					player.dead = true;
				}
				
				if( currGuess > _questionAnswer )
				{
					playerAnswerText.text = "BUST";
					if( !playerBust )
					{
						playerBust = true;
						FlxG.play(SndBust);
					}
				}
				else
					playerAnswerText.text = "" + currGuess + "";
			}
			else
			{
				player.x += 1.2;
				
				playerAnswerText.x = player.x - FlxG.width/2;
				if( getGuessFromX(player.x) > _questionAnswer )
					playerAnswerText.text = "BUST";
				else
					playerAnswerText.text = "" + getGuessFromX(player.x) + "";
			}
			

			
			if( enemy.x >= enemyTarget )
			{
				enemy.x = enemyTarget;
				enemy.running = false;
				enemyDone = true;
				
				if( enemyGuess == _questionAnswer )
				{
					enemy.win = true;					
				}
				else if( enemyGuess > _questionAnswer )
				{
					enemy.dead = true;
				}
				
				if( enemyGuess > _questionAnswer )
				{
					enemyAnswerText.text = "BUST";
					if( !enemyBust )
					{
						enemyBust = true;
						FlxG.play(SndBust);
					}
				}
				else
					enemyAnswerText.text = "" + enemyGuess + "";
			}
			else
			{
				enemy.x += 1.0;
				
				enemyAnswerText.x = enemy.x - FlxG.width/2;
				if( getGuessFromX(enemy.x) > _questionAnswer )
					enemyAnswerText.text = "BUST";
				else
					enemyAnswerText.text = "" + getGuessFromX(enemy.x) + "";
			}
		}
		
		override public function update():void
		{	
			if( firstUpdate )
			{
				firstUpdate = false;
				FlxG.play(SndSong);
			}
			
			if( showResults )
			{
				updateResults();	
				updateWinnerResults();
			}
			
			// Update answer text
			answerText.text = "" + currGuess + "";
			
			// Slider
			updateSlider();
			
			// Timer
			updateTimer();
			
			super.update();
		}
		
		override public function nextLevel():Boolean
		{
			if( pressedNext )
			{
				return true;
			}
			return false;
		}
	}
}

package { 
	import flash.display.*;
	import flash.ui.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.media.SoundChannel;

Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;   

	
    public class Game extends MovieClip
    { 
		//common
		public var timer:Timer = new Timer(24);
		public var life:Number;
		public var score:int;
		public var levelcount:int;
		public var bosshp:int;
		public var rnd1:int;
		public var rnd2:int;
		public var rnd3:int;
		public var i:int;
		public var ii:int
		public var framesElapsed:Number;
		public var p1speedX, p1speedY:Number;
		public var shotimer:int;
		
		
		//assets
		public var gametitle:Title;
		public var buttonmove:ButtonMove;
		public var buttonspaceshooter:ButtonSpaceShooter;
		public var buttonspacesnake:ButtonSpaceSnake;
		public var lifebox:LifeBox;
		public var scorebox:ScoreBox;
		public var hero:Hero;
		public var enemy1:Enemy1;
		public var boss1:Boss1;
		public var star:Star;
		public var bullet:Bullet;
		public var heart:Heart;
		public var mcFood:Food;
		public var gameovermessage:GameOverMessage;
		
		//variables
		public var Left:Boolean;
		public var Right:Boolean;
		public var Up:Boolean;
		public var Down:Boolean;
		public var Space:Boolean;
		public var readyToMove:Boolean;
		public var End:Boolean;
		public var Bosslevel:Boolean;

		
		//arrays
		public var BulletArray:Array;
		public var EnemyArray:Array;
		public var BossArray:Array;
		public var HeartArray:Array;
		public var StarArray:Array;
		public var snakes:Array;
		
		//sounds
		public var myChannel:SoundChannel = new SoundChannel();
		public var menusound:MenuSound = new MenuSound();
		public var startsound:StartSound = new StartSound();
		public var spacegamesound:SpaceGameSound = new SpaceGameSound();
		public var shootsound:ShootSound = new ShootSound();
		public var explosionsound:ExplosionSound = new ExplosionSound();
		public var snakeimpactsound:SnakeImpactSound = new SnakeImpactSound();
		public var snakemovesound:SnakeMoveSound = new SnakeMoveSound();
		public var losesound:LoseSound = new LoseSound();
		public var bossexplosionsound:BossexplosionSound = new BossexplosionSound();
		
        public function Game()
		{ 
            timer.addEventListener(TimerEvent.TIMER,onTimer);
			StartScreen();					
        }// game
		
		public function StartScreen()
		{
			myChannel.stop();
			myChannel = menusound.play();
			
			gametitle=new Title;addChild(gametitle);
			gametitle.x=400;gametitle.y=100;
			
			buttonspaceshooter=new ButtonSpaceShooter;addChild(buttonspaceshooter);
			buttonspaceshooter.x=207;buttonspaceshooter.y=327;
			
			buttonspacesnake=new ButtonSpaceSnake;addChild(buttonspacesnake);
			buttonspacesnake.x=607;buttonspacesnake.y=327;
			
	buttonspaceshooter.addEventListener(MouseEvent.CLICK,buttonstartfunction);
		function buttonstartfunction(eventObject:MouseEvent)
		{
			removeChild(buttonspaceshooter);
			removeChild(buttonspacesnake);
			removeChild(gametitle);
			startsound.play();
			myChannel.stop();
			SpaceGame();
		}//buttonspaceshooter
		
	buttonspacesnake.addEventListener(MouseEvent.CLICK,buttonstartfunctionb);
		function buttonstartfunctionb(eventObject:MouseEvent)
		{
			removeChild(buttonspaceshooter);
			removeChild(buttonspacesnake);
			removeChild(gametitle);
			myChannel.stop();
			startsound.play();
			SpaceSnake();
		}//buttonspacesnake
			
	}//sscreen
	
	
//#############!!	GAME START	!!######################
	
	public function SpaceGame(){
		
		buttonmove=new ButtonMove;addChild(buttonmove);
		buttonmove.x=400;buttonmove.y=300;
			
		myChannel = spacegamesound.play();
		hero=new Hero;addChild(hero);
		hero.x=400;hero.y=550;
		hero.dead=false;
		score=0;
		scorebox=new ScoreBox;addChild(scorebox);
		scorebox.x=125;scorebox.y=12;
		lifebox=new LifeBox;addChild(lifebox);
		lifebox.x=25;lifebox.y=12;
		life = 1;
		levelcount = 0;
		bosshp=4;
		shotimer=0;
		Bosslevel=false;
		Space=false;
		
	//	buttonmoveright.addEventListener (TouchEvent.PROXIMITY_ROLL_OVER, touchRollOver);
	//	buttonmoveright.addEventListener (TouchEvent.PROXIMITY_ROLL_OUT, touchRollOut);
		
		stage.addEventListener(TouchEvent.TOUCH_MOVE, OnTouchMove);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
		stage.addEventListener(KeyboardEvent.KEY_UP, KeyUpHandler);
	
		BulletArray= new Array;
		EnemyArray= new Array;
		BossArray= new Array;
		HeartArray= new Array;
		StarArray= new Array;


		timer.start();
		stage.focus = this;
	}//setupSpaceGame
	
	
	function OnTouchMove (e:TouchEvent):void{
		buttonmove.x = e.stageX;
	}
	
	
	
	
/*	public	function touchRollOver(e:TouchEvent):void{
			Right=true;
	}
	
	public	function touchRollOut(e:TouchEvent):void{
			Right=false;
	}*/
	
	public function KeyDownHandler(e:KeyboardEvent){
		if(e.keyCode==39){Right=true;}
		if(e.keyCode==37){Left=true;}
		if(e.keyCode==38){Up=true;}
		if(e.keyCode==40){Down=true;}
	}//keydown
		
	public function KeyUpHandler(e:KeyboardEvent){
		if(e.keyCode==39){Right=false;}
		if(e.keyCode==37){Left=false;}
		if(e.keyCode==38){Up=false;}
		if(e.keyCode==40){Down=false;}
		if(e.keyCode==32){Space=true;}
	}//keyup

///////***************SPACE SHOOTER BOOT*************//////////////////////
		
		public function onTimer(evt:TimerEvent):void{
			IntroduceStars();
			IntroduceHearts();
			IntroduceEnemies();
			IntroduceBoss();
			ProcessUserInput();
			Shoot();
//			ShootMobile();
//			UserInputMobile();
			MoveObjects();
			CollisionDetection();
			RemoveDeadObjects();
			UpdateDisplay();
			CheckForGameOver();
		}//GAMELOOP
			
///////**********************************************//////////////////////
		
		public function IntroduceStars(){
			rnd1=Math.random()*20;
			if(rnd1==1){
				star=new Star;addChild(star);
				star.x=Math.random()*800;star.y=-30;
				StarArray.push(star);
			}//if
		}//create stars
		
		public function IntroduceEnemies(){
			if(Bosslevel==false){			
				rnd2=Math.random()*40;
					if(rnd2==1){
					enemy1=new Enemy1;addChild(enemy1);
					enemy1.scaleY = 0.2; enemy1.scaleX = 0.2;
					enemy1.x=Math.random()*800;enemy1.y=-30;
					EnemyArray.push(enemy1);
				}//ifplace
			}//ifboss
		}//intro enemies
		
		public function IntroduceBoss(){
		if(levelcount>19){
			levelcount=0;
				boss1=new Boss1;addChild(boss1);
				boss1.scaleY = 1; boss1.scaleX = 1;
				boss1.x=Math.random()*800;boss1.y=-30;
				BossArray.push(boss1);
			}//if
		}//intro boss
		
		public function IntroduceHearts(){
			if(life<3){
				rnd3=Math.random()*1000;
				if(rnd3==1){
					heart=new Heart;addChild(heart);
					heart.scaleY = 0.1; heart.scaleX = 0.1;
					heart.x=Math.random()*800;heart.y=30;
					HeartArray.push(heart);
				}//if
			}
		}//intro hearts
		
		public function ProcessUserInput(){ 
			if(Right && hero.x<780){hero.x+=10;}
			if(Left && hero.x>20){hero.x-=10;}
			if(Space){Space==true};
		}//Process User Input
		
		public function UserInputMobile(){ 
			if(buttonmove.x>hero.x && hero.x<780){hero.x+=10;hero.gotoAndStop(3);}
			if(buttonmove.x<hero.x && hero.x>20){hero.x-=10;hero.gotoAndStop(2);}
			if((hero.x+5)>=buttonmove.x && (hero.x-5)<=buttonmove.x){hero.gotoAndStop(1);}
		}//Process User Input on Mobile
			
		
		public function Shoot(){
			if(Space==true){
			shootsound.play();
			bullet= new Bullet;addChild(bullet);
			bullet.x=hero.x;bullet.y=hero.y;
			bullet.dead=false;
			BulletArray.push(bullet);}
			Space=false;
		}//shoot
		
		public function ShootMobile(){
			if(shotimer>=20){shotimer=0;Shoot();}
			shotimer+=1;
			trace(shotimer);
		}
	
		public function MoveObjects(){
			for(i=0;i<StarArray.length;i++){StarArray[i].action();}
			for(i=0;i<HeartArray.length;i++){HeartArray[i].action();}
			for(i=0;i<EnemyArray.length;i++){EnemyArray[i].action();}
			for(i=0;i<BossArray.length;i++){BossArray[i].action();}
			for each (var obj:Object in BulletArray){obj.y-=10;}
		}//move objects
			
		public function CollisionDetection(){
			for(i=0;i<EnemyArray.length;i++){
				if(EnemyArray[i].hitTestObject(hero.HitZone)){EnemyArray[i].dead=true;life-=1;if(life==0){hero.dead=true;}}			
				for(ii=0;ii<BulletArray.length;ii++){
					if(EnemyArray[i].hitTestObject(BulletArray[ii])){explosionsound.play();EnemyArray[i].dead=true;BulletArray[ii].dead=true;score+=1;levelcount+=1;if(levelcount>19){Bosslevel=true}}
				}
			}//i, ii enemy
			for(i=0;i<BossArray.length;i++){
				if(BossArray[i].hitTestObject(hero.HitZone)){BossArray[i].dead=true;life-=1;if(life==0){hero.dead=true;}}			
				for(ii=0;ii<BulletArray.length;ii++){
					if(BossArray[i].hitTestObject(BulletArray[ii])){snakeimpactsound.play();BulletArray[ii].dead=true;bosshp-=1;if(bosshp<0){bossexplosionsound.play();BossArray[i].dead=true;Bosslevel=false;bosshp=4;score+=1000;}}
				}
			}//i, ii boss
			for(i=0;i<HeartArray.length;i++){
				if(HeartArray[i].hitTestObject(hero.HitZone)){startsound.play();life+=1;HeartArray[i].dead=true;}			
			}//i, ii heart
		};//CollisionDetection
		
		public function RemoveDeadObjects(){
			for(i=0;i<BulletArray.length;i++){
				if(BulletArray[i].dead || BulletArray[i].y<0){removeChild(BulletArray[i]);BulletArray[i]=null;BulletArray.splice(i,1);}
				}//remove bullet
				
			for(i=0;i<EnemyArray.length;i++){
				if(EnemyArray[i].dead){removeChild(EnemyArray[i]);EnemyArray[i]=null;EnemyArray.splice(i,1);}
				}//remove Enemy
				
			for(i=0;i<BossArray.length;i++){
				if(BossArray[i].dead){removeChild(BossArray[i]);BossArray[i]=null;BossArray.splice(i,1);}
				}//remove Enemy
				
			for(i=0;i<StarArray.length;i++){
				if(StarArray[i].dead){removeChild(StarArray[i]);StarArray[i]=null;StarArray.splice(i,1);}
				}//remove Star
				
			for(i=0;i<HeartArray.length;i++){
				if(HeartArray[i].dead){removeChild(HeartArray[i]);HeartArray[i]=null;HeartArray.splice(i,1);}
				}//remove Heart
				
			};//remove dead objects
			
		public function UpdateDisplay(){
			scorebox.scoretext.text="Score: "+score.toString();
			lifebox.scoretext.text="Life: "+life.toString();
			};//update display
			
		public function CheckForGameOver(){
			if(hero.dead){
				myChannel.stop();
				timer.stop();
				myChannel = losesound.play();
				gameovermessage=new GameOverMessage;
				addChild(gameovermessage);
				gameovermessage.x=370;
				gameovermessage.y=200;
				gameovermessage.addEventListener(MouseEvent.CLICK,gameoverfunction);
				function gameoverfunction(eventObject:MouseEvent){
				RemoveAllObjects();
				StartScreen();
				}//go function
			}//if hero is dead			
		};//gameover
		
		public function RemoveAllObjects(){
			for(i=0;i<BulletArray.length;i++){removeChild(BulletArray[i]);BulletArray[i]=null;}
			for(i=0;i<EnemyArray.length;i++){removeChild(EnemyArray[i]);EnemyArray[i]=null;}
			for(i=0;i<BossArray.length;i++){removeChild(BossArray[i]);BossArray[i]=null;}
			for(i=0;i<StarArray.length;i++){removeChild(StarArray[i]);StarArray[i]=null;}
			for(i=0;i<HeartArray.length;i++){removeChild(HeartArray[i]);HeartArray[i]=null;}
			BulletArray=[];EnemyArray=[];StarArray=[];HeartArray=[];
			removeChild(hero);removeChild(gameovermessage);removeChild(scorebox);removeChild(lifebox);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, KeyUpHandler);
		}//remove all objects
		
		
//####################!!	SNAKE GAME	BOOT!!######################
		
	public function SpaceSnake(){
		
		End=false;
		score=0;
		scorebox=new ScoreBox;addChild(scorebox);
		scorebox.x=125;scorebox.y=12;
		lifebox=new LifeBox;addChild(lifebox);
		lifebox.x=25;lifebox.y=12;
		life = 3;
		framesElapsed = 0;
		p1speedX = 1; //snakek starts moving right
		p1speedY = 0;
		readyToMove = false;
		snakes = new Array();
		
		//Create 1st body part of snake and push it into the array
		var snakeHead = new SnakePart();
		snakeHead.x = 400;
		snakeHead.y = 300;
		snakes.push(snakeHead);
		addChild(snakeHead);
		
		addEventListener(Event.ENTER_FRAME,update);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
		stage.addEventListener(KeyboardEvent.KEY_UP, KeyUpHandler);
		
		stage.focus = this;
			
	}//setupSnakeGame
		
		public function update(evt:Event)
		{
			handleUserInput();
			handleGameLogic();
			UpdateDisplay();
			
			if (End){endSnakeGame();}
		}
	
		public function handleUserInput()
		{			
			//if player wants to move left but snake is not
			//already moving right
			if (Left && (p1speedX != 1)) 
			{p1speedX = -1;p1speedY = 0;}
			//if player wants to move right but snake is not
			//already moving left
			else if (Right && (p1speedX != -1 ))
			{p1speedX = 1;p1speedY = 0;}
			//if player wants to move up but snake is not
			//already moving down
			else if (Up && (p1speedY != 1))
			{p1speedY = -1;p1speedX = 0;}
			else if (Down && (p1speedY != -1))
			{p1speedY = 1;p1speedX = 0;}
			
			if (Space)
			readyToMove = true;
		}
		
		public function handleGameLogic()
		{
			if (!readyToMove)
				return;
			
			framesElapsed++;
			
			//Update the new position of the snake's head
			if (framesElapsed % 2 == 0)
			{
				//Update motion of the snake's body
				for (var i = snakes.length - 1; i >= 1; i--)
				{
					snakes[i].x = snakes[i-1].x;
					snakes[i].y = snakes[i-1].y;
				}
			
				if (p1speedX > 0)
				{snakes[0].x += 20;}
				else if (p1speedX < 0)
				{snakes[0].x -= 20;}
				else if (p1speedY > 0)
				{snakes[0].y += 20;}
				else if (p1speedY < 0)
				{snakes[0].y -= 20;}
				
				//Check for collisions between the snake and its own body
				for (i = snakes.length - 1; i >= 1; i--)
				{
					if ((snakes[0].x == snakes[i].x) &&
						(snakes[0].y == snakes[i].y))
					{
						collided();
						break;
					}
				}
			}
			
			//Check for collisions between the snake and the walls
			if (snakes[0].y < 0)
			{collided();}
			else if (snakes[0].x > 800)
			{collided();}
			else if (snakes[0].x < 0)
			{collided();}
			else if (snakes[0].y > 600)
			{collided();}
			
			//Add new food items
			if (mcFood == null)
			{
				//Create a new food item
				mcFood = new Food();
				mcFood.x = Math.random() * 700 + 50;
				mcFood.y = Math.random() * 500 + 50;
				addChild(mcFood);
			}
			
			//Check for collisions between food item and Snake
			if (mcFood != null)
			{
				if (snakes[0].hitTestObject(mcFood))
				{
					//Add score
					score += 10;
					snakemovesound.play();
					
					removeChild(mcFood);
					mcFood = null;
					
					//Add a body
					var newPart = new SnakePart();
					newPart.x = snakes[snakes.length-1].x;
					newPart.y = snakes[snakes.length-1].y;
					snakes.push(newPart);
					addChild(newPart);
				}
			}
		}

		private function endSnakeGame()
		{
			clearGame();
			removeEventListener(Event.ENTER_FRAME, update);
			myChannel = losesound.play();
			gameovermessage=new GameOverMessage;
			addChild(gameovermessage);
			gameovermessage.x=370;
			gameovermessage.y=200;
			gameovermessage.addEventListener(MouseEvent.CLICK,gameoverfunction);
			function gameoverfunction(eventObject:MouseEvent){
			removeChild(gameovermessage);removeChild(scorebox);removeChild(lifebox);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, KeyUpHandler);
			StartScreen();
			}
		}
		
		//Misc Functions
		public function resetGame()
		{
			//remove all food
			removeChild(mcFood);
			mcFood = null;
			
			//remove all of snake body except first
			for (var i = snakes.length - 1; i >= 1; i--)
			{
				removeChild(snakes[i]);
				snakes.splice(i,1);
			}
			
			//Center the snake's head
			snakes[0].x = 400;snakes[0].y = 300;
			readyToMove = false;
		}
		
		public function clearGame()
		{
			//remove all food
			if (mcFood != null)
			{removeChild(mcFood);mcFood = null;}
			
			//remove all of snake body
			for (var i = snakes.length - 1; i >= 0; i--)
			{removeChild(snakes[i]);snakes.splice(i,1);}
		}
		
		public function collided()
		{
			snakeimpactsound.play();
			life -= 1;
			if (life > 0){resetGame();}else{End=true;}
		}
		
	}//end class	
		
}

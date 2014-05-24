package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author WORLDking
	 */
	public class Mainn extends Sprite 
	{
		public var money:int = 500;
		public var tMoney:TextField = new TextField();
		public var player:Player_mc = new Player_mc();
		public var speed:int = 10;
		public var bulletSpeed:int = 20;
		public var enemySpeed:int = 10;
		public var bulletMas:Array = new Array();
		public var tim:Timer = new Timer(250);
		public var mooveTimer:Timer = new Timer(100);
		public var enemyMas:Array = new Array();
		public var enemyMoover:Timer = new Timer(5);
		public var cleanTimer:Timer = new Timer(10000);
		public var score:TextField = new TextField();
		public var intScore:int=0;
		public var temp:Boolean = true;
		public function Mainn():void 
		{
			addChild(score);
			player.x = 160;
			player.y = stage.stageHeight - player.height;
			addChild(player);
			//stage.addEventListener(Event.ENTER_FRAME, moover);
		 	tim.start();
			cleanTimer.start();
			enemyMoover.start();
			mooveTimer.start();
			cleanTimer.addEventListener(TimerEvent.TIMER, clean);
			mooveTimer.addEventListener(TimerEvent.TIMER, tryToMoove);
			enemyMoover.addEventListener(TimerEvent.TIMER, mooveEnemy);
			tim.addEventListener(TimerEvent.TIMER, tryToShout);
			//makeEnemyRow();
		}
		public function mooveEnemy(event:TimerEvent):void
		{
			for (var i:int = 0; i < enemyMas.length; i++)
			{
				enemyMas[i].y += enemySpeed;
				//trace(enemyMas[i].y);		
			}
			makeEnemyRow();
		}
		public function tryToMoove(event:TimerEvent):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyMoover);			
		}
		public function moover(event:Event):void
		{
			if (player.x < mouseX)
			{
				if(player.x+player.width+speed<stage.stageWidth)
				player.x+=speed;
			}
			else if (player.y > mouseY)
			{
				if(player.x-speed>0)
				player.x-=speed;
			}

		}
		public function keyMoover(event:KeyboardEvent):void
		{
			if (event.keyCode == 37)
			{
				if(player.x-speed>=-10)
				player.x -= speed;
			}
			else if (event.keyCode == 39)
			{
				if(player.x+player.width+speed<=stage.stageWidth+10)
				player.x += speed;
			}
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyMoover);		
		}
		public function tryToShout(event:TimerEvent):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, shout);
		}
		public function shout(event:KeyboardEvent):void
		{
			
			if (event.keyCode == Keyboard.ENTER)
			{
				var box:Box_mc = new Box_mc();
				if (intScore >= 100 && intScore<500)
				{
					box.x = player.x;
					box.y = player.y + box.height;
					bulletMas.push(box);
					addChild(bulletMas[bulletMas.length - 1]);	
					
					box = new Box_mc();
					box.x = player.x+2*box.width;
					box.y = player.y + box.height;
					bulletMas.push(box);
					addChild(bulletMas[bulletMas.length - 1]);	
				}
				else if (intScore >= 500)
				{
					box.x = player.x;
					box.y = player.y + box.height;
					bulletMas.push(box);
					addChild(bulletMas[bulletMas.length - 1]);	
					
					box = new Box_mc();
					box.x = player.x+2*box.width;
					box.y = player.y + box.height;
					bulletMas.push(box);
					addChild(bulletMas[bulletMas.length - 1]);
					
					box = new Box_mc();
					box.x = player.x + box.width;
					box.y = player.y + box.height;
					bulletMas.push(box);
					addChild(bulletMas[bulletMas.length - 1]);					
				}
				else
				{
					box.x = player.x + box.width;
					box.y = player.y + box.height;
					bulletMas.push(box);
					addChild(bulletMas[bulletMas.length - 1]);
				}
				if (intScore == 250 || intScore ==251)
				
				{
					var bonus:bonus_mc = new bonus_mc();
					bonus.x = 160;
					addChild(bonus);
					bonus.addEventListener(Event.ENTER_FRAME, mooveBonus);
				}
				addEventListener(Event.ENTER_FRAME, mooveBullets);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, shout);
			}
			
		}
		public function mooveBonus(event:Event):void
		{
			var bonus:bonus_mc = event.currentTarget as bonus_mc;
			catchBonus(bonus)
			bonus.y += 15;

		}
		public function catchBonus(bonus:bonus_mc):void
		{
			if (bonus.x - bonus.width<player.x && bonus.x>player.x && bonus.y-bonus.height<player.y && bonus.y>player.y)
			{
				mooveTimer = new Timer(50);
				mooveTimer.start();
				mooveTimer.addEventListener(TimerEvent.TIMER, tryToShout);
			}
		}
		public function mooveBullets(event:Event):void
		{
			for (var i:int = 0; i < bulletMas.length; i++)
			{
				bulletMas[i].y -= bulletSpeed;
				if(temp)
				{
					isKill(bulletMas[i], i);
				}
			}
		}
		public function isKill(box:Box_mc,k:int):Boolean
		{
			//for (var i:int = 0; i < enemyMas.length; i++)
			//{
				//if (box.x+box.width < enemyMas[i].x && box.x>=box.x && box.y+height<enemyMas[i].y && box.y>=enemyMas[i].y)
				//{
					//removeChild(enemyMas[i]);
					//enemyMas.splice(i);
				//}
			//}
			
			for (var i:int = 0; i < enemyMas.length; i++)
			{
				//trace((box.x + box.width < enemyMas[enemyMas.length - 1][i].x && box.x >= enemyMas[enemyMas.length - 1][i].x && box.y + box.height > enemyMas[enemyMas.length - 1][i].y && box.y <= enemyMas[enemyMas.length - 1][i].y));
				if (box.x-box.width <= enemyMas[i].x && box.x>=enemyMas[i].x && box.y-box.height<=enemyMas[i].y && box.y>=enemyMas[i].y)
				{
					//trace(" " );
					removeChild(enemyMas[i]);
					enemyMas.splice(i, 1);
					removeChild(bulletMas[k]);
					bulletMas.splice(k, 1);
					//trace(enemyMas[i].y);
					intScore++;
					showScore();
					trace(enemyMas[i].y);
					
					return true;
				}	
				if (enemyMas[i].y >= player.y)
					{
						trace("regsegserg");
						enemyMoover.stop();
						cleaner();
						removeEventListener(Event.ENTER_FRAME, mooveBullets);
						cleanTimer.removeEventListener(TimerEvent.TIMER, clean);
						mooveTimer.removeEventListener(TimerEvent.TIMER, tryToMoove);
						enemyMoover.removeEventListener(TimerEvent.TIMER, mooveEnemy);
						tim.removeEventListener(TimerEvent.TIMER, tryToShout);
						temp = false;
					}
				//trace(enemyMas[i].y);
				

				
			}
			return false;
		}
		public function showScore():void
		{
			
			var size:TextFormat = new TextFormat("Tekton Pro Ext", 20,0xFFFFFF);
			score.selectable = false;
			score.text = String(intScore);
			score.setTextFormat(size);
			stage.addChild(score);
		}
		public function cleaner():void
		{
			while (this.numChildren > 0) removeChildAt(0);
			var tf:TextFormat = new TextFormat("Brush Script Std", 14, 0x000000);
			var t:TextField = new TextField();
			t.width = stage.stageWidth;
			score.setTextFormat(tf);
			stage.addChild(score);
			stage.addChild(t);
			t.y = 100;
			t.height = 320;
			t.text = "\nЧто-бы начать заново \n \n нажмите ENTER";
			t.setTextFormat(tf);
			addEventListener(KeyboardEvent.KEY_DOWN, reNew);
		}
		public function clean(event:TimerEvent):void
		{
			for (var i:int = 0; i < bulletMas.length; i++)
			{
				if (bulletMas[i].x < 0) 
				{
					removeChild(bulletMas[i]);
					bulletMas.splice(i);
				}
			}

			
		}
		public function reNew(event:KeyboardEvent):void
		{
			trace("hjghhjg");
			if(event.keyCode==Keyboard.ENTER)
			{
				enemyMas = new Array();
				bulletMas = new Array();
				intScore = 0;
				Main(true);
			}
			
		}
		public function makeEnemyRow():void
		{
			var box:Box_mc;
			//var tMas:Array = new Array();
			for (var i:int = 0; i < 32; i++)
			{
				//if (int(Math.random() * 2) == 1)
				//{
					box = new Box_mc();
					box.x = i * 10;
					enemyMas.push(box);
					addChild(enemyMas[enemyMas.length - 1]);
				//}
			}
			//enemyMas.push(tMas);
		}
		
	}
	
}
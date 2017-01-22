package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.ui.*;
	import flash.geom.*;
	
	/**
	 * ...
	 * @author Yoon
	 */
	public class Enemy extends Sprite
	{
		public var frameno:uint = 0;
		public var xvel:int = 0;
		public var yvel:int = 0;
		public var xaccel:int = 2;
		public var yaccel:int = 2;
		public var max_xvel:uint = 12;
		public var xresistance_airborne:int = 1;
		public var xresistance_ground:int = 4;
		public var gravity:int = 1;
		public var yvel_loss_when_landing:int = 4*gravity;
		public var blu_hitbox:Rectangle;
		public var red_hitbox:Rectangle;
		public var axis:Point;
		
		public var life:int = 1;
		public var max_invulnerability_time:int = 20;
		public var invulnerability_time:int = max_invulnerability_time;
		
		public var facing_right:Boolean = false;
		
		public var type:int = 0;
		public static const TYPE_PIRATE_ROUGE:int = 0;
		public static const TYPE_PIRATE_BLEU:int = 1;
		public static const TYPE_CUISINIER:int = 2;
		public static const TYPE_PERROQUET:int = 3;
		public static const TYPE_COUTEAU:int = 4;
		
		
		[Embed (source = "../res/perroquet0.png")] private var Perroquet0:Class;
		private var spr_perroquet0:Bitmap = new Perroquet0();	
		[Embed (source = "../res/perroquet1.png")] private var Perroquet1:Class;
		private var spr_perroquet1:Bitmap = new Perroquet1();	
		[Embed (source = "../res/perroquet2.png")] private var Perroquet2:Class;
		private var spr_perroquet2:Bitmap = new Perroquet2();
		[Embed(source="../res/sound/Wilhelm_Scream.mp3")] private var perroquet_mort_snd:Class;
		private var snd_perroquet_mort:Sound = new perroquet_mort_snd;
		
		[Embed (source = "../res/cuisinier1.png")] private var cuisinier0:Class;
		private var spr_cuisinier0:Bitmap = new cuisinier0();	
		[Embed (source = "../res/cuisinier2.png")] private var cuisinier1:Class;
		private var spr_cuisinier1:Bitmap = new cuisinier1();	
		[Embed (source = "../res/cuisinier3.png")] private var cuisinier2:Class;
		private var spr_cuisinier2:Bitmap = new cuisinier2();
		[Embed (source = "../res/cuisinier_mort.png")] private var cuisinier_mort:Class;
		private var spr_cuisinier_mort:Bitmap = new cuisinier_mort();
		[Embed(source = "../res/sound/103533__tschapajew__pain-scream-serious-2.mp3")] private var cuisinier_mort_snd:Class;
		private var snd_cuisiner_mort:Sound = new cuisinier_mort_snd;
		
		[Embed (source = "../res/Pirate_rouge0.png")] private var Pirate_rouge0:Class;
		private var spr_Pirate_rouge0:Bitmap = new Pirate_rouge0();	
		[Embed (source = "../res/Pirate_rouge1.png")] private var Pirate_rouge1:Class;
		private var spr_Pirate_rouge1:Bitmap = new Pirate_rouge1();	
		[Embed (source = "../res/Pirate_rouge2.png")] private var Pirate_rouge2:Class;
		private var spr_Pirate_rouge2:Bitmap = new Pirate_rouge2();
		[Embed (source = "../res/Pirate_rouge3.png")] private var Pirate_rouge3:Class;
		private var spr_Pirate_rouge3:Bitmap = new Pirate_rouge3();
		[Embed (source = "../res/Pirate_rouge_mort.png")] private var Pirate_rouge_mort:Class;
		private var spr_Pirate_rouge_mort:Bitmap = new Pirate_rouge_mort();
		[Embed(source="../res/sound/44428__thecheeseman__hurt1.mp3")] private var Pirate_rouge_mort_snd:Class;
		private var snd_Pirate_rouge_mort:Sound = new Pirate_rouge_mort_snd;
		
		[Embed (source = "../res/Pirate_bleu0.png")] private var Pirate_bleu0:Class;
		private var spr_Pirate_bleu0:Bitmap = new Pirate_bleu0();	
		[Embed (source = "../res/Pirate_bleu1.png")] private var Pirate_bleu1:Class;
		private var spr_Pirate_bleu1:Bitmap = new Pirate_bleu1();	
		[Embed (source = "../res/Pirate_bleu2.png")] private var Pirate_bleu2:Class;
		private var spr_Pirate_bleu2:Bitmap = new Pirate_bleu2();
		[Embed (source = "../res/Pirate_bleu3.png")] private var Pirate_bleu3:Class;
		private var spr_Pirate_bleu3:Bitmap = new Pirate_bleu3();
		[Embed (source = "../res/Pirate_bleu4.png")] private var Pirate_bleu4:Class;
		private var spr_Pirate_bleu4:Bitmap = new Pirate_bleu4();
		[Embed (source = "../res/Pirate_bleu_mort.png")] private var Pirate_bleu_mort:Class;
		private var spr_Pirate_bleu_mort:Bitmap = new Pirate_bleu_mort();
		[Embed(source="../res/sound/76968__michel88__painh.mp3")] private var Pirate_bleu_mort_snd:Class;
		private var snd_Pirate_bleu_mort:Sound = new Pirate_bleu_mort_snd;
		
		[Embed (source = "../res/couteau0.png")] private var couteau0:Class;
		private var spr_couteau0:Bitmap = new couteau0();	
		[Embed (source = "../res/couteau1.png")] private var couteau1:Class;
		private var spr_couteau1:Bitmap = new couteau1();	
		[Embed (source = "../res/couteau2.png")] private var couteau2:Class;
		private var spr_couteau2:Bitmap = new couteau2();
		[Embed (source = "../res/couteau3.png")] private var couteau3:Class;
		private var spr_couteau3:Bitmap = new couteau3();
		
		
		
		private var current_sprite:Bitmap;
		
		public function Enemy(type_:int, ix:Number, iy:Number) 
		{
			this.type = type_;
			this.x = ix;
			this.y = iy;
			
			switch(type)
			{
				case TYPE_PIRATE_ROUGE:
					this.life = 1;
					this.blu_hitbox = new Rectangle(0, 0, 50, -80);
					this.red_hitbox = new Rectangle(0, 0, 70, -80);
					this.axis = new Point(16, 0);
					drawSprite(spr_Pirate_rouge0);
					break;
				case TYPE_PIRATE_BLEU:
					this.life = 1;
					this.blu_hitbox = new Rectangle(0, 0, 50, -80);
					this.red_hitbox = new Rectangle(0, 0, 70, -80);
					this.axis = new Point(16, 0);
					drawSprite(spr_Pirate_bleu0);
					break;
				case TYPE_CUISINIER:
					this.life = 1;
					this.y = 3;
					this.blu_hitbox = new Rectangle(0, 0, 30, -60);
					this.red_hitbox = new Rectangle(0, 0, 0, 0);
					this.axis = new Point(15, 0);
					drawSprite(spr_cuisinier0);
					break;
				case TYPE_PERROQUET:
					this.life = 1;
					this.blu_hitbox = new Rectangle(0, 0, 32, -30);
					this.red_hitbox = new Rectangle(0, 0, 32, -30);
					this.axis = new Point(16, 0);
					this.drawSprite(spr_perroquet0);
					break;
				case TYPE_COUTEAU:
					yvel = -Math.random() * 30.0;
					this.blu_hitbox = new Rectangle(0, 0, 35, -35);
					this.red_hitbox = new Rectangle(0, 0, 35, -35);
					this.axis = new Point(16, 0);
					this.drawSprite(spr_couteau0);
					break;
			}
			turnRight();
		}
		
		public function drawSprite(value:Bitmap = null):void
		{
			if (value == null)
				value = this.current_sprite;
			else
				this.current_sprite = value;
				
			this.graphics.clear();
			var matrix:Matrix = new Matrix();
			if (!facing_right)
				matrix.scale( -1, 1);
			matrix.translate(axis.x - (value.width / 2), 0);
			this.graphics.beginBitmapFill(value.bitmapData, matrix);
			this.graphics.drawRect(axis.x - (value.width / 2), 0, value.width, -value.height);
			this.graphics.endFill();
		}
		
		public function turnLeft():void 
		{
			if (facing_right)
			{
				facing_right = false; 
				this.drawSprite();
			}	
		}
		public function turnRight():void 
		{
			if (!facing_right)
			{
				facing_right = true; 
				this.drawSprite();
			}	
		}
		
		public function die(silently:Boolean = false):void 
		{
			life = 0;
			//TODO
			switch(type)
			{
				case TYPE_PIRATE_ROUGE:
					this.drawSprite(spr_Pirate_rouge_mort);
					if(!silently)
						snd_Pirate_rouge_mort.play();
					break;
				case TYPE_PIRATE_BLEU:
					this.drawSprite(spr_Pirate_bleu_mort);
					if(!silently)
						snd_Pirate_bleu_mort.play();
					break;
				case TYPE_CUISINIER:
					this.drawSprite(spr_cuisinier_mort);
					if(!silently)
						snd_cuisiner_mort.play();
					break;
				case TYPE_PERROQUET:
					this.drawSprite(spr_perroquet2);
					if (!silently)
						snd_perroquet_mort.play();
					break;
			}
		}
		
		public function update(bear_y:Number):void 
		{
			frameno++;
			if(life > 0)
				switch(type)
				{
					case TYPE_PIRATE_ROUGE:
						if (frameno % 3 == 0) {
							switch(current_sprite) {
								default: drawSprite(spr_Pirate_rouge0); break;
								case spr_Pirate_rouge0: drawSprite(spr_Pirate_rouge1);  break;
								case spr_Pirate_rouge1: drawSprite(spr_Pirate_rouge2);  break;
								case spr_Pirate_rouge2: drawSprite(spr_Pirate_rouge3);  break;
								case spr_Pirate_rouge3: drawSprite(spr_Pirate_rouge0);  break;
							}
						}
					
						if (this.x+parent.x < 200) {
								this.xvel++;
								turnLeft();
							}
						else if(this.x+parent.x <550) {
								this.xvel--;
								turnRight();
							}
						
						
						if (this.xvel > 8)
							this.xvel = 8;
						else if (this.xvel< -8)
							this.xvel = -8;
						
							
						if (frameno % 2 == 0)
						{
							if (this.y >= 0)
								this.yvel -= 4;
							else this.yvel++;
						}
						break;
					case TYPE_COUTEAU:
						yvel++;
						if (frameno % 2 == 0) {
							switch(current_sprite) {
								default: drawSprite(spr_couteau0); break;
								case spr_couteau0: drawSprite(spr_couteau1);  break;
								case spr_couteau1: drawSprite(spr_couteau2);  break;
								case spr_couteau2: drawSprite(spr_couteau3);  break;
								case spr_couteau3: drawSprite(spr_couteau0);  break;
							}
						}
						if(frameno==1) {
							if (parent.x+parent.parent.x < 200) {
									this.xvel = 20;
									turnLeft();
								}
							else {
									this.xvel = -20;
									turnRight();
								}
						}
						break;
					case TYPE_PIRATE_BLEU:
						if (frameno % 3 == 0) {
							switch(current_sprite) {
								default: drawSprite(spr_Pirate_bleu0); break;
								case spr_Pirate_bleu0: drawSprite(spr_Pirate_bleu1);  break;
								case spr_Pirate_bleu1: drawSprite(spr_Pirate_bleu2);  break;
								case spr_Pirate_bleu2: drawSprite(spr_Pirate_bleu3);  break;
								case spr_Pirate_bleu3: drawSprite(spr_Pirate_bleu4);  break;
								case spr_Pirate_bleu4: drawSprite(spr_Pirate_bleu0);  break;
							}
						}
					
						if (this.x+parent.x < 200) {
								this.xvel++;
								turnLeft();
							}
						else if(this.x+parent.x <550) {
								this.xvel--;
								turnRight();
							}
						
						
						if (this.xvel > 14)
							this.xvel = 14;
						else if (this.xvel< -14)
							this.xvel = -14;
						
							
						if (frameno % 2 == 0)
						{
							if (this.y >= 0)
								this.yvel -= 8;
							else this.yvel++;
						}
						break;
					case TYPE_CUISINIER:
						if (frameno % 7 == 0) {
							/*
							for (var i:int = 0 ; i < this.numChildren ; i++ )
								if (this.getChildAt(i).y > 100)
									this.removeChildAt(i);
									*/
							switch(current_sprite) {
								default: drawSprite(spr_Pirate_bleu0); break;
								case spr_cuisinier0: drawSprite(spr_cuisinier2);  
									//addChild(new Enemy(Enemy.TYPE_COUTEAU, 0, 0));  
									break;
								//case spr_cuisinier1: drawSprite(spr_cuisinier2);  break;
								case spr_cuisinier2: drawSprite(spr_cuisinier0);  break;
							}
						}
						if (this.x+parent.x < 200) {
								turnLeft();
							}
						else  {
								turnRight();
							}
						break;
					case TYPE_PERROQUET:
						if(frameno % 3 == 0) {
							if (current_sprite == spr_perroquet0)
								this.drawSprite(spr_perroquet1);
							else this.drawSprite(spr_perroquet0);
						}
						
						if (this.x+parent.x < 200) {
							this.xvel++;
							turnLeft();
						}
						else if(this.x+parent.x <550) {
							this.xvel--;
							turnRight();
						}
						
						
						if (this.xvel > 20)
							this.xvel = 20;
						else if (this.xvel< -20)
							this.xvel = -20;
						
							
						if (frameno % 2 == 0)
						{
							if (this.y > -100)
								this.yvel--;
							else this.yvel++;
						}
						
						break;
				}
			//end if(life > 0)
			
			if(life <= 0) {
				if (this.y < 0)
					yvel++;
				else {
					yvel = 0;
					switch(type)
					{
						default: this.y = 0;
						case TYPE_PIRATE_ROUGE:
							this.y = 6;
							break;
						case TYPE_PIRATE_BLEU:
							this.y = 6;
							break;
						case TYPE_CUISINIER:
							this.y = 6;
							break;
						case TYPE_PERROQUET:
							this.y = 1;
							break;
					}
				}
				xvel += (xvel > 0 ? -1 : (xvel < 0 ? 1 : 0));
			}
			
			this.x += xvel;
			this.y += yvel;
			
			
			//If invulnerable, let's blink
			if (life > 0 && invulnerability_time <= max_invulnerability_time)
			{
				if (invulnerability_time % 9 == 0)
					this.visible = false;
				else if (invulnerability_time % 9 == 4)
					this.visible = true;
			} else if (invulnerability_time == max_invulnerability_time+1)
				this.visible = true;
			
			invulnerability_time++;
			
		}
	}

}
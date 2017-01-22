package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.ui.*;
	/**
	 * ...
	 * @author Yoon
	 */
	public class Ship extends Sprite
	{
		
		public var ground_height:uint = 42;
		
		[Embed (source = "../res/ship.png")] private var ShipBG:Class;
		public var spr_ship:Bitmap = new ShipBG();	
		[Embed (source = "../res/table.png")] private var Table:Class;
		public var spr_table:Bitmap = new Table();
		
		
		public var enemies:Array;
		
		public function Ship() 
		{
			var matrix:Matrix = new Matrix();
			matrix.translate(0, ground_height);
			this.graphics.beginBitmapFill(spr_ship.bitmapData, matrix);
			this.graphics.drawRect(0, 42, spr_ship.width, -spr_ship.height);
			this.graphics.endFill();
			
			enemies = new Array(32);

			enemies[0] = new Enemy(Enemy.TYPE_PERROQUET, 3500, 0);
			this.addChild(enemies[0]);
			for (var i:int = 1 ; i < enemies.length ; i++ )
			{
				//switch(Math.random+1*3 as int)
				var rand:Number = Math.random();
				if (rand < 0.5)
					enemies[i] = new Enemy(Enemy.TYPE_PIRATE_ROUGE, 6000*(i+6)/(enemies.length+6), 0);
				else if (rand < 0.8)
					enemies[i] = new Enemy(Enemy.TYPE_PIRATE_BLEU, 6000*(i+6)/(enemies.length+6), 0);
				else
					enemies[i] = new Enemy(Enemy.TYPE_CUISINIER, 6000*(i+6)/(enemies.length+6), 0);
				this.addChild(enemies[i]);
			}
		}
		
		public function update(bear_y:Number):void 
		{
			for (var i:int = 0 ; i < enemies.length ; i++ )
				enemies[i].update(bear_y);
		}
	}

}
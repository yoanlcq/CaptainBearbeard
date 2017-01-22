package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.media.Sound;
    import flash.ui.*;
    import flash.geom.*;
    import flash.text.*;

    /**
     * ...
     * @author Yoon
     */
    public class BearBeard extends Sprite
    {
        
        private var i:int = 0;
        public var debug_stuff_displayed:Boolean = false;
        public var debuginfo:TextField = new TextField();
        
        public var ship:Ship;
        public var main:Main;
        
        public var frameno:uint = 0;
        public var bouncing:Boolean = false;
        public var falling_faster:Boolean = false;
        public var min_jump_charge:uint = 13;
        public var max_jump_charge:uint = 26;
        public var jump_charge:uint = min_jump_charge;
        public var xvel:int = 0;
        public var yvel:int = 0;
        public var xaccel:int = 2;
        public var yaccel:int = 2;
        public var max_xvel:uint = 12;
        public var bonus_xvel:int = 0;
        public var xresistance_airborne:int = 1;
        public var xresistance_ground:int = 4;
        public var gravity:int = 1;
        public var yvel_loss_when_landing:int = 4*gravity;
        public var blu_hitbox:Rectangle  = new Rectangle(0, 0, 40, -70);
        public var red_hitbox:Rectangle  = new Rectangle(0, 0, 40, -40);
        public var mine_hitbox:Rectangle = new Rectangle(0, 0, 40, -70);
        public var your_hitbox:Rectangle = new Rectangle(0, 0, 40, -40);
        public var axis:Point = new Point(20, 0);
        
        public var max_life:int = 6;
        public var life:int = max_life;
        public var dead_time:int = 0;
        public var max_dead_time:int = 42;
        public var max_invulnerability_time:int = 42;
        public var invulnerability_time:int = max_invulnerability_time;
        
        public var gameover:Boolean = false;
        public var won:Boolean = false;
        public var uppin:Boolean = false;

        public var facing_right:Boolean = true;
        
        public var animtime:int = 0;
        
        [Embed (source = "../res/bearbeard0.png")] private var Stand0:Class;
        private var spr_stand0:Bitmap = new Stand0();
        [Embed (source = "../res/bearbeard_walk0.png")] private var Walk0:Class;
        private var spr_walk0:Bitmap = new Walk0();
        [Embed (source = "../res/bearbeard_walk1.png")] private var Walk1:Class;
        private var spr_walk1:Bitmap = new Walk1();
        [Embed (source = "../res/bearbeard_walk2.png")] private var Walk2:Class;
        private var spr_walk2:Bitmap = new Walk2();
        [Embed (source = "../res/bearbeard_walk3.png")] private var Walk3:Class;
        private var spr_walk3:Bitmap = new Walk3();
        [Embed (source = "../res/bearbeard_jump.png")] private var Jump:Class;
        private var spr_jump:Bitmap = new Jump();
        [Embed (source = "../res/bearbeard_air0.png")] private var Air0:Class;
        private var spr_air0:Bitmap = new Air0();
        [Embed (source = "../res/bearbeard_air1.png")] private var Air1:Class;
        private var spr_air1:Bitmap = new Air1();
        [Embed (source = "../res/bearbeard_air2.png")] private var Air2:Class;
        private var spr_air2:Bitmap = new Air2();
        [Embed (source = "../res/bearbeard_air3.png")] private var Air3:Class;
        private var spr_air3:Bitmap = new Air3();
        [Embed (source = "../res/bearbeard_air4.png")] private var Air4:Class;
        private var spr_air4:Bitmap = new Air4();
        [Embed (source = "../res/bearbeard_dead.png")] private var Dead:Class;
        private var spr_dead:Bitmap = new Dead();
        [Embed (source = "../res/bearbeardfinal.png")] private var YouWon:Class;
        private var spr_win:Bitmap = new YouWon();

        
        private var current_sprite:Bitmap = spr_stand0;
        
        
        [Embed(source = "../res/sound/punch.mp3")] private var Punch:Class;
        private var snd_punch:Sound = new Punch();
        [Embed(source = "../res/sound/146726__fins__jumping.mp3")] private var JumpSnd:Class;
        private var snd_jump:Sound = new JumpSnd();
        [Embed(source="../res/sound/148076__corsica-s__foam-pluck-03.mp3")] private var Boing:Class;
        private var snd_boing:Sound = new Boing(); 
        [Embed(source = "../res/sound/213854__fantozzi__captain-sparrow.mp3")] private var WinSnd:Class;
        private var snd_win:Sound = new WinSnd();
        
        public function BearBeard(main_:Main, ship_:Ship) 
        {
            this.main = main_;
            this.ship = ship_;
            
            debuginfo.width = 400;
            debuginfo.height = 42;
            debuginfo.textColor = 0xffffff;
            debuginfo.wordWrap = true;
            debuginfo.background = true;
            debuginfo.backgroundColor = 0x0000ff;
            
            this.drawSprite(spr_stand0);
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
            
            //Display debug stuff again since it has been cleared.
            //Yes, it's ugly.
            if(this.debug_stuff_displayed)
                this.display_debug_stuff = true;
        }
        
        public function get display_debug_stuff():Boolean 
        {
            return debug_stuff_displayed;
        }
        public function set display_debug_stuff(value:Boolean):void
        {
            debug_stuff_displayed = value;
            if (debug_stuff_displayed)
            {
                this.addChild(debuginfo);
                
                this.graphics.lineStyle(1, 0x0000ff);
                this.graphics.beginFill(0, 0);
                this.graphics.drawRect(blu_hitbox.x, blu_hitbox.y, blu_hitbox.width, blu_hitbox.height);
                this.graphics.endFill();
                
                this.graphics.lineStyle(1, 0xff0000);
                this.graphics.beginFill(0, 0);
                this.graphics.drawRect(red_hitbox.x, red_hitbox.y, red_hitbox.width, red_hitbox.height);
                this.graphics.endFill();
                
                this.graphics.lineStyle(1, 0xffffff);
                this.graphics.beginFill(0xffffff, 1);
                this.graphics.drawRect(axis.x, axis.y, 1, -1);
                this.graphics.endFill();
            }
            else
            {
                this.removeChild(debuginfo);
                                
                this.graphics.clear();
                this.drawSprite(); 
            }
        }
        
        public function get x_by_axis():Number
        {
            return this.x + axis.x;
        }
        
        public function set x_by_axis(value:Number):void
        {
            this.x = value - axis.x;
        }
        
        public function get y_by_axis():Number
        {
            return this.y + axis.y;
        }
        
        public function set y_by_axis(value:Number):void
        {
            this.y = value - axis.y;
        }
        
        public function turnLeft():void 
        {
            if (!won && facing_right)
            {
                facing_right = false; 
                this.drawSprite();
            }	
        }
        public function turnRight():void 
        {
            if (!won && !facing_right)
            {
                facing_right = true; 
                this.drawSprite();
            }	
        }
        
        public function moveLeft():void 
        {
            turnLeft();
            if (!bouncing)
                xvel = -max_xvel;
            else 
            {
                xvel -= xaccel;
                if (y_by_axis >= 400 - 42)
                    bonus_xvel--;
                if (xvel < -max_xvel + bonus_xvel*max_xvel/4)
                    xvel = -max_xvel + bonus_xvel*max_xvel/4;
            }
        }
        
        public function moveRight():void 
        {
            turnRight();
            if (!bouncing)
                xvel = max_xvel;
            else 
            {
                xvel += xaccel;
                if (y_by_axis >= 400 - 42)
                    bonus_xvel++;
                    
                if (xvel > max_xvel + bonus_xvel*max_xvel/4)
                    xvel = max_xvel + bonus_xvel*max_xvel/4;
                
            }
        }
        
        public function chargeJump():void 
        {
            if (!won && !bouncing && frameno%2==0)
            {
                
                if (jump_charge < max_jump_charge)
                    jump_charge++;
                else
                    jump();
                    
                main.updateUi();
            }
        }
        
        public function jump():void
        {
            if (!bouncing && jump_charge>min_jump_charge)
            {
                //Let's go into space !
                snd_jump.play();
                yvel = -jump_charge;
                bouncing = true;
                jump_charge = min_jump_charge;
                uppin = true;
            }
        }
        
        public function fallFaster():void 
        {
            if (bouncing && yvel > 0)
            {
                falling_faster = true;
            }
        }
        
        public function land():void
        {
            snd_boing.play();
            this.y_by_axis = (stage.stageHeight - this.ship.ground_height);
            yvel = 0;
            bouncing = false;
            falling_faster = false;
            bonus_xvel = 0;
            main.updateUi();
        }
        
        public function die():void 
        {
            life = 0;
            this.visible = true;
            this.drawSprite(this.spr_dead);
        }
        
        public function update():void
        {
            frameno++;
            animtime++;
            
            if (!won && !bouncing && ship.x <= -6270 && ship.x >= -6321)
            {
                //We won !!
                main.snd_bg_channel.stop();
                for (var i:int = 0 ; i < ship.enemies.length ; i++ )
                    ship.enemies[i].die(true);
                won = true;
                visible = true;
                snd_win.play();
                drawSprite(spr_win);
            } else if(!won) {
            
                if(life <= 0) {
                    if (this.y < 400-42)
                        yvel++;
                    else {
                        yvel = 0;
                        this.y = 400 - 42;
                    }
                    xvel += (xvel > 0 ? -1 : (xvel < 0 ? 1 : 0));
                    if (yvel == 0)
                    {
                        dead_time++;
                        if (dead_time > max_dead_time)
                            gameover = true;
                    }
                }
                else {
                    //Change sprites
                    
                    //We're on the ground.
                    if (!bouncing) 
                    {
                        if (Math.abs(xvel) == max_xvel && animtime%1==0)
                        {
                            switch (this.current_sprite) 
                            {
                                default:
                                    drawSprite(spr_walk0);
                                    break;
                                case this.spr_walk0: drawSprite(spr_walk1); break;
                                case this.spr_walk1: drawSprite(spr_walk2); break;
                                case this.spr_walk2: drawSprite(spr_walk3); break;
                                case this.spr_walk3: drawSprite(spr_walk0); break;
                            }
                        } 
                        if(Math.abs(xvel) < max_xvel && this.current_sprite != this.spr_stand0) {
                            drawSprite(spr_stand0);
                        }
                    }
                    //We're bouncing
                    else
                    {
                        if (this.y >= 400 - 42) {
                            if(current_sprite != spr_air2)
                                drawSprite(spr_air2);
                        }
                        else 
                        {
                            if (yvel < -5) 
                            {
                                if (uppin && current_sprite != spr_jump)
                                    drawSprite(spr_jump);
                                else if (!uppin && current_sprite != spr_air3)
                                    drawSprite(spr_air3);
                            }
                            if (yvel >= -5 && yvel < 15 && current_sprite != spr_air4) {
                                drawSprite(spr_air4);
                                uppin = false;
                            }
                            if (yvel >= 15 && current_sprite != spr_air0)
                                drawSprite(spr_air0);
                        }
                    }
                }
                
                if(falling_faster)
                    yvel += 4;
                
                //Move it !
                
                this.ship.x -= xvel;
                this.y += yvel;
                
                if (this.ship.x > 0)
                    this.ship.x = 0;
                else if (this.ship.x < -(ship.spr_ship.width-600))
                    this.ship.x = -(ship.spr_ship.width-600);
                
                /* old code
                this.x += xvel;
                this.y += yvel;
                */
                
                //Apply horizontal air resistance
                if (frameno % 2 == 0)
                {
                    xvel += (xvel > 0 ? -xresistance_airborne : (xvel < 0 ? xresistance_airborne : 0));
                    //If on the ground, then slow down quickly.
                    if (!bouncing)
                        xvel /= 2;
                }
                
                //Apply gravity
                if (bouncing)
                {
                    //Are we airborne ?
                    if (this.y_by_axis < (stage.stageHeight - this.ship.ground_height))
                    {
                        yvel += gravity;
                    }
                    //We're on the ground (or mayber even under.)
                    else {
                        //Were we falling ?
                        if(falling_faster)
                            yvel = 0;
                        
                        if (yvel > 0)
                        {
                            this.y_by_axis = (stage.stageHeight - this.ship.ground_height);
                            yvel = -yvel + yvel_loss_when_landing;
                            if (yvel > 0)
                                yvel = 0;
                        }
                        //Are we done bouncing ?
                        if (yvel == 0)
                        {
                            land();
                        } else snd_boing.play();
                    }
                }
                this.ship.update( -(400 - ship.ground_height - this.y));
                
                if (life > 0)
                {
                    //If invulnerable, let's blink
                    if (invulnerability_time <= max_invulnerability_time)
                    {
                        if (invulnerability_time % 9 == 0)
                            this.visible = false;
                        else if (invulnerability_time % 9 == 4)
                            this.visible = true;
                    } else if (invulnerability_time == max_invulnerability_time+1)
                        this.visible = true;
                    
                    invulnerability_time++;
                    
                    //Check collisions
                    //debuginfo.text = "...";
                    
                    //If we're falling, we are the attacker.
                    if ( ((y!= 400-42 && (y > 400-42-20)) || yvel > 0) /*&& invulnerability_time > max_invulnerability_time*/)
                    {
                        this.mine_hitbox.x = red_hitbox.x;
                        this.mine_hitbox.y = red_hitbox.y + this.y - (400 - 42);
                        this.mine_hitbox.width = red_hitbox.width;
                        this.mine_hitbox.height = red_hitbox.height;
                        this.mine_hitbox.height *= -1;
                        
                        for (i = 0 ; i < ship.enemies.length ; i++ )
                        {
                            this.your_hitbox.x = ship.x - 200 + ship.enemies[i].x + ship.enemies[i].axis.x;
                            this.your_hitbox.y = ship.y -(400 - 42) + ship.enemies[i].y + ship.enemies[i].axis.y +red_hitbox.height;//- 2*ship.enemies[i].blu_hitbox.height;
                            this.your_hitbox.width = ship.enemies[i].blu_hitbox.width;
                            this.your_hitbox.height = ship.enemies[i].blu_hitbox.height;
                            this.your_hitbox.height *= -1;
                                
                            //if(i==0)
                            //trace(" (" + mine_hitbox.x + "," + mine_hitbox.y + "," + mine_hitbox.width + "," + mine_hitbox.height + ")"
                                // +" (" + your_hitbox.x + "," + your_hitbox.y + "," + your_hitbox.width + "," + your_hitbox.height + ")");
                            
                            if (mine_hitbox.intersects(your_hitbox) && ship.enemies[i].life>0) {
                                if (ship.enemies[i].invulnerability_time > ship.enemies[i].max_invulnerability_time)
                                {
                                    debuginfo.text = "we got him !";
                                    snd_punch.play();
                                    ship.enemies[i].life--;
                                    if (ship.enemies[i].life <= 0) {
                                        ship.enemies[i].yvel = yvel;
                                        ship.enemies[i].die();
                                        debuginfo.text = "He died !"+ship.enemies[i].x+", "+ship.enemies[i].y;
                                    }
                                    else
                                        ship.enemies[i].invulnerability_time = 0;
                                }
                            }
                        }
                    }
                    //Else, we're vulnerable.
                    else if(invulnerability_time > max_invulnerability_time)
                    {		
                        this.mine_hitbox.x = blu_hitbox.x;
                        this.mine_hitbox.y = blu_hitbox.y + this.y - (400 - 42);
                        this.mine_hitbox.width = blu_hitbox.width;
                        this.mine_hitbox.height = blu_hitbox.height;
                        this.mine_hitbox.height *= -1;
                        
                        for ( i = 0 ; i < ship.enemies.length ; i++ )
                        {
                            this.your_hitbox.x = ship.x - 200 + ship.enemies[i].x + ship.enemies[i].axis.x;
                            this.your_hitbox.y = ship.y -(400 - 42) + ship.enemies[i].y + ship.enemies[i].axis.y;//- 2*ship.enemies[i].blu_hitbox.height;
                            this.your_hitbox.width = ship.enemies[i].red_hitbox.width;
                            this.your_hitbox.height = ship.enemies[i].red_hitbox.height;
                            this.your_hitbox.height *= -1;
                                
                            /*
                            trace(" (" + mine_hitbox.x + "," + mine_hitbox.y + "," + mine_hitbox.width + "," + mine_hitbox.height + ")"
                                 +" (" + your_hitbox.x + "," + your_hitbox.y + "," + your_hitbox.width + "," + your_hitbox.height + ")");
                            */
                            if (mine_hitbox.intersects(your_hitbox) && ship.enemies[i].life>0) {
                                if (invulnerability_time > max_invulnerability_time && ship.enemies[i].invulnerability_time > ship.enemies[i].max_invulnerability_time)
                                {
                                    debuginfo.text = "we're hit !";
                                    this.life--;
                                    main.updateUi();
                                    if (this.life <= 0)
                                        die();
                                    this.invulnerability_time = 0;
                                }
                            }
                        }
                    }
                }
                else //life <= 0
                {
                    //TODO
                }
            }
        }
    }

}

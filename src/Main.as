package
{
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.text.*;
    import flash.ui.*;

    /**
     * ...
     * @author Yoon
     */
    [Frame(factoryClass="Preloader")]
    public class Main extends Sprite 
    {
        
        private var debug_stuff_displayed:Boolean = false;
        
        private var holding_left:Boolean = false;
        private var holding_right:Boolean = false;
        private var holding_up:Boolean = false;
        private var holding_down:Boolean = false;
        private var debuginfo:TextField = new TextField();
        
        private var ship:Ship = new Ship();
        private var bear:BearBeard;
        
        [Embed (source = "../res/ui.png")] private var Ui:Class;
        private var spr_ui:Bitmap = new Ui();
        
        //[Embed(source="../res/Music/Antti_Martikainen_-_Treasure_Cove.mp3")] private var BgMusic:Class;
        //public var snd_bg:Sound = new BgMusic();
        //public var snd_bg_channel:SoundChannel;
        
        public function Main() 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
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
                stage.addChild(debuginfo);
            }
            else
            {
                stage.removeChild(debuginfo);
            }
        }

        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            //Entry point
            stage.scaleMode = StageScaleMode.NO_SCALE;
            //snd_bg_channel = snd_bg.play();
            
            //Set up the scene
            
            ship.y = stage.stageHeight - ship.ground_height;
            stage.addChild(ship);
            
            stage.addChild(this);
            
            bear = new BearBeard(this, ship);
            restart();
            
            updateUi();
            
            debuginfo.width = stage.stageWidth/2;
            debuginfo.height = 80;
            debuginfo.textColor = 0xffffff;
            debuginfo.wordWrap = true;
            debuginfo.background = true;
            debuginfo.backgroundColor = 0xff0000;
                    
            //Get ready for user input
            
            stage.addEventListener(Event.ENTER_FRAME, update);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keydown);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyup);
        }
        
        
        
        public function updateUi():void 
        {
            this.graphics.clear();
            //dessiner rectangle
            this.graphics.beginFill(0xff0000);
            this.graphics.drawRect(106, 21, 130*bear.life/bear.max_life, 12);
            this.graphics.endFill();
            //dessiner rectangle
            this.graphics.beginFill(0x0000ff);
            this.graphics.drawRect(12, 356, 8, -264*2*(bear.jump_charge-bear.min_jump_charge)/bear.max_jump_charge);
            this.graphics.endFill();
            //dessiner ui
            this.graphics.beginBitmapFill(spr_ui.bitmapData);
            this.graphics.drawRect(0, 0, spr_ui.width, spr_ui.height);
            this.graphics.endFill();
        }
        
        
        private function restart():void 
        {
            bear.x_by_axis = 200;
            bear.y_by_axis = stage.stageHeight - ship.ground_height;
            stage.addChild(bear);
            updateUi();
        }
        
        private function update(e:Event):void 
        {
            if (bear.life <= 0)
            {
                //Baaaaw
                //TODO
                if(bear.gameover) {
                    debuginfo.text = "gameover";
                    stage.removeChild(bear);
                    bear = new BearBeard(this, ship);
                    restart();
                    ship.x = 0;
                }
            }
            else 
            {	
                if (holding_left) 
                {
                    bear.moveLeft();
                } 
                else if (holding_right)
                {
                    bear.moveRight();
                } 
                if (holding_up)
                {
                    bear.chargeJump();
                } else bear.jump();
				
                if (holding_down)
                {
                    bear.fallFaster();
                }
                debuginfo.text = "Captain is in " + (bear.ship.x) + ", " + bear.y_by_axis + "\n"
                        + "Jump charge : " + bear.jump_charge + "\n"
                        + "Life: " + bear.life;
            }
            //Apply changes
            
            bear.update();
        }
        
        private function keydown(e:KeyboardEvent):void
        {
            switch(e.keyCode) {
                case Keyboard.LEFT: 
                    holding_left  = true; 
                    holding_right = false;
                    break;
                case Keyboard.RIGHT: 
                    holding_right = true;
                    holding_left  = false;
                    break;
                case Keyboard.UP: 
                    holding_up    = true;
                    break;
                case Keyboard.DOWN: 
                    holding_down  = true;
                    break;	
                    
                case Keyboard.V:
                    bear.land();
                    break;
                case Keyboard.G:
                    this.display_debug_stuff = !this.display_debug_stuff;
                    bear.display_debug_stuff = !bear.display_debug_stuff;
                    break;
                case Keyboard.W:
                    bear.ship.x += 1000;
                    break;
                case Keyboard.X:
                    bear.ship.x -= 1000;
                    break;
            }
        }
        
        private function keyup(e:KeyboardEvent):void
        {
            switch(e.keyCode) {
                case Keyboard.LEFT: 
                    holding_left  = false; 
                    break;
                case Keyboard.RIGHT: 
                    holding_right = false;
                    break;
                case Keyboard.UP: 
                    holding_up    = false;
                    break;
                case Keyboard.DOWN: 
                    holding_down  = false;
                    break;
            }
        }
    }
}

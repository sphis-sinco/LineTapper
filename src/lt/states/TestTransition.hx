package lt.states;

import lt.objects.ui.Button;
import openfl.display.BitmapData;
import lt.objects.ui.Dialog;
import lt.objects.play.Tile;
import flixel.addons.transition.FlxTransitionSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;

class TestTransition extends State {
    var f:Tile;
    var spr:FlxSprite;
    override function create() {
        super.create();
        var wawa:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(10,10,FlxG.width,FlxG.height,true,0xFF353535,0xFF505050));
        wawa.scale.set(4,4);
        wawa.scrollFactor.set(0.2,0.2);
        wawa.alpha = 0.5;
        add(wawa);
        var f:Tile = new Tile(0,0,LEFT,0,Conductor.instance.step_ms*4);
        add(f);
        var x:Tile = new Tile(0,100,RIGHT,Conductor.instance.step_ms,Conductor.instance.step_ms*4);
        add(x);
        var a:Tile = new Tile(200,0,UP,Conductor.instance.step_ms*2,Conductor.instance.step_ms*4);
        add(a);
        var c:Tile = new Tile(200,300,DOWN,Conductor.instance.step_ms*3,Conductor.instance.step_ms*4);
        add(c);

        //ok
        add(new Button(500,450, "TOGGLE", 100, 20, true));
        add(new Button(500,500, "NORMAL", 100, 20, (val:Bool)->{
            trace(val);
        }));
    }

    var ue:Bool = false;
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.G)
            Dialog.show("Information", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", []);

        var moveSpeed:Float = elapsed*1000;
        if (FlxG.keys.pressed.A || FlxG.keys.pressed.D) 
            FlxG.camera.scroll.x -= FlxG.keys.pressed.A ? moveSpeed : -moveSpeed;
        if (FlxG.keys.pressed.W || FlxG.keys.pressed.S) 
            FlxG.camera.scroll.y -= FlxG.keys.pressed.W ? moveSpeed : -moveSpeed;

        if (FlxG.keys.pressed.Q || FlxG.keys.pressed.E) 
            FlxG.camera.zoom -= FlxG.keys.pressed.Q ? -(3*elapsed) : (3*elapsed);


        //work

        if (FlxG.keys.justPressed.SPACE) {
            trace("Wawa");
            Utils.switchState(new TestTransition(true,true), "Transition Test!");
        }
    }
}
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;

var opcionestxt:Array<String> = ['main', 'freeplay', 'credits', 'options'];
var opcionesSprite:Array<FlxSprite> = [];
var rendersSprite:Array<FlxSprite> = [];
var numb:Int = (FlxG.random.int(0,2));
var bg:FlxSprite;
var smoke:FlxSprite;
var bar:FlxSprite;
var culocam:FlxCamera;
var curSelected:Int = 0;

function create(){
	culocam = new FlxCamera();
    culocam.bgColor = 0x0;
	FlxG.cameras.add(culocam, false);

    add(bg = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/bg')));
    bg.screenCenter();
    bg.scale.set(0.7,0.7);
    bg.camera = culocam;

    add(smoke = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/smoke')));
    smoke.screenCenter();
    smoke.scale.set(0.7,0.7);
    smoke.camera = culocam;
    FlxTween.tween(smoke, {alpha: 0}, 2, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});

    add(bar = new FlxSprite(-130, -190).loadGraphic(Paths.image('menus/mainmenu/bar')));
    bar.scale.set(0.7,0.7);
    bar.camera = culocam;

	for(i => sprite in opcionestxt){
	var grr:FlxSprite = new FlxSprite(-250 + (i * 30), 50 + (i * 130));
    grr.frames = Paths.getFrames('menus/mainmenu/buttons/' + sprite);
    grr.animation.addByPrefix('idle', "idle", 24, false);
    grr.animation.addByPrefix('select', "encima", [0], 24, false);
    grr.animation.addByPrefix('selected', "selected", 24, false);
    grr.updateHitbox();
    grr.camera = culocam;
    grr.scale.set(0.35,0.35);
    grr.animation.play('idle');
	add(grr);
	opcionesSprite.push(grr);
	}

	for(sprite in ["bf", "gf", "tails"]){
	var grr:FlxSprite = new FlxSprite(1300, 20);
	grr.loadGraphic(Paths.image('menus/mainmenu/renders/' + sprite));
	grr.scrollFactor.set();
	grr.camera = culocam;
	add(grr);
	rendersSprite.push(grr);
	}
}

var seleccionado:Bool = false;
var val:Int = 0;
function update(){
    if (FlxG.keys.justPressed.THREE) FlxG.resetState();
    if (seleccionado) return;

    if(controls.DOWN_P) curSelected += 1;
    else if (controls.UP_P) curSelected -= 1;
    
    curSelected = FlxMath.wrap(curSelected, 0, opcionestxt.length - 1);

    for(i in 0...opcionestxt.length){
        if(i == curSelected && controls.ACCEPT){
            seleccionado = true;
            opcionesSprite[i].animation.play('selected');
            opcionesSprite[i].setPosition(opcionesSprite[i].x - 98, opcionesSprite[i].y - 33);

            new FlxTimer().start(0.8, function(tmr:FlxTimer) {
                confirmSelected(i);
            });
        } else {
            opcionesSprite[i].animation.play((i == curSelected) ? 'select' : 'idle'); 
        }
    }

	for (i in 0...rendersSprite.length) {
		if (i == numb) {
			if(val == 0){
		    FlxTween.tween(rendersSprite[i], {x: 600}, 1, { ease: FlxEase.smootherStepOut,
				 onComplete:function(){
				}});
			val++;
			}
			rendersSprite[i].alpha = 1;
			}else{
			rendersSprite[i].alpha = 0;	
			}
	}

	if (controls.SWITCHMOD) openSubState(new ModSwitchMenu());
	if (controls.DEV_ACCESS) openSubState(new EditorPicker());
}

function confirmSelected(selection:Int){
    switch(selection){
        case 0: FlxG.switchState(new ModState('main'));
        case 1: FlxG.switchState(new FreeplayState());
        case 2: FlxG.switchState(new CreditsMain());
        case 3: FlxG.switchState(new OptionsMenu());
    }
}
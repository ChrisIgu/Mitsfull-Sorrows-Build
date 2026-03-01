import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.backend.MusicBeatState;
import flixel.addons.display.FlxBackdrop;

var songs:Array<String> = ["Twisted"];
var backs:Array<FlxSprite> = [];
var botones:Array<FlxSprite> = [];
static var lastSelected:Int = 0;
var curSelected:Int = 0;
var cam1:FlxCamera;
function create(){
    cam1 = new FlxCamera();
    cam1.bgColor = 0x0;
    FlxG.cameras.add(cam1, false);

    var upBar:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/upBar"));
    add(upBar);

    insert(0, upBar = new FlxBackdrop(Paths.image('menus/freeplay/upBar'))).velocity.set(100,0);
    upBar.camera = cam1;

    insert(0, downBar = new FlxBackdrop(Paths.image('menus/freeplay/downBar'))).velocity.set(100,0);
    downBar.camera = cam1;

    insert(0, bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/freeplay/niebla1')));
    bg.camera = cam1;
    bg.color = 0xFB00FF;

    insert(0, bg2 = new FlxBackdrop(Paths.image('menus/freeplay/niebla2'))).velocity.set(300,0);
    bg2.camera = cam1;
    bg2.color = 0xFF00EE;

    insert(0, bg3 = new FlxBackdrop(Paths.image('menus/freeplay/niebla3'))).velocity.set(1100,0);
    bg3.camera = cam1;
    bg3.color = 0xFF00EE;

    insert(0, bg0 = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/freeplay/bg')));
    bg0.camera = cam1;

    add(imagesong = new FlxSprite(680, -140).loadGraphic(Paths.image('menus/freeplay/intruder')));
    imagesong.scale.set(0.72, 0.72);
    imagesong.camera = cam1;

    //BOTONES

    add(barra = new FlxSprite(-50, 250).loadGraphic(Paths.image('menus/freeplay/buttons/barra')));
    barra.scale.set(0.6, 0.6);
    barra.camera = cam1;

    add(ball = new FlxSprite(140, 307).loadGraphic(Paths.image('menus/freeplay/buttons/punto')));
    ball.scale.set(0.6, 0.6);
    ball.camera = cam1;

    add(pausa = new FlxSprite(80, 303).loadGraphic(Paths.image('menus/freeplay/buttons/pausa')));
    pausa.scale.set(0.6, 0.6);
    pausa.camera = cam1;
    botones.push(pausa);

    add(play = new FlxSprite(80, 303).loadGraphic(Paths.image('menus/freeplay/buttons/play')));
    play.scale.set(0.6, 0.6);
    play.camera = cam1;
    play.visible = false;
    botones.push(play);

    add(nameSong = new FlxSprite(150, 120).loadGraphic(Paths.image('menus/freeplay/' + songs[0])));
    nameSong.scale.set(0.7, 0.7);
    nameSong.camera = cam1;

    //quiero que el sprite back se repita 2 veces

    for(i in 0...2){
        add(spr = new FlxSprite(100 + (i * 370), 140).loadGraphic(Paths.image('menus/freeplay/buttons/back')));
        spr.scale.set(0.25, 0.25);
        spr.camera = cam1;
        backs.push(spr);

        add(spr1 = new FlxSprite(100 + (i * 370), 140).loadGraphic(Paths.image('menus/freeplay/buttons/back presionado')));
        spr1.scale.set(0.25, 0.25);
        spr1.camera = cam1;
        backs.push(spr1);
    }

    backs[2].flipX = true;
    backs[3].flipX = true;
    backs[1].alpha = 0;
    backs[3].alpha = 0;

	curSelected = lastSelected;
    FlxG.mouse.visible = true;
}

function sele() {
    var song = FreeplaySonglist.get().songs[curSelected];
    PlayState.loadSong(song.name, song.difficulties[0], false, false);
	FlxG.save.data.lastsong = song.name;
    FlxG.save.data.lastdificulted = song.difficulties[0];
    FlxG.switchState(new PlayState());
}

function playPreview(index:Int) {
    if (index < 0 || index >= songs.length) return;
    var songName = songs[index];
    FlxG.sound.playMusic(Paths.inst(songName), 1, true);
}

var lastPlayed:Int = -1;
var br:Int = 0;
var pausaoplay:Bool = false;
function update(){
    updateSpeed(FlxG.keys.pressed.FIVE ? 15 : 1);

    if (controls.BACK){
	    FlxG.switchState(new MainMenuState());
	}
	
    if (controls.ACCEPT) {
		if(br == 0){
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound("menu/confirm"), 0.5);
        new FlxTimer().start(1, _ -> sele());
		br++;		
		}
	}
    if (controls.LEFT) {curSelected -= 1; backs[1].alpha = 1;
    }else if (controls.RIGHT){ curSelected += 1; backs[3].alpha = 1;
        }else{ backs[1].alpha = backs[3].alpha = 0;
    }

    curSelected = FlxMath.wrap(curSelected, 0, songs.length - 1);

    if (curSelected != lastPlayed) {
        playPreview(curSelected);
        lastPlayed = curSelected;
    }

    if (FlxG.sound.music != null && FlxG.sound.music.playing) {  
        ball.x = FlxMath.lerp(140, 580, FlxG.sound.music.time / FlxG.sound.music.length);
    }

    if(FlxG.mouse.overlaps(botones[0], botones[1])){
        if(FlxG.mouse.justPressed){
            pausa.visible = !pausa.visible;
            play.visible = !play.visible;

            play.visible ? FlxG.sound.music.pause() : FlxG.sound.music.resume();
        }
    }
    
	var song = FreeplaySonglist.get().songs[curSelected];
    lastSelected = curSelected;

	if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;
}

function updateSpeed(speed:Float){
    FlxG.timeScale = FlxG.sound.music.pitch = speed;
}
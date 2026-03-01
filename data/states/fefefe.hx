import funkin.backend.ui.HealthIcon;
import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.MusicBeatState;
import funkin.savedata.FunkinSave;

var icon:HealthIcon = null;
var lastIcon:String = "";
var songIcons:Array<String> = ["midnightman", "akuma", "dp", "feli", "calibe"];
var songs:Array<String> = ["torturing silence", "akuma", "lost identity", "suffocation", "dev"];
var dif:Array<String> = ["hard", "normal"];
var saturation:CustomShader = new CustomShader("Saturation");
var back:FlxSprite = new FlxSprite(-30,520);
var enter:FlxSprite = new FlxSprite(1070,520);
var blank:FlxSprite = new FlxSprite();
var sprai:Array<FlxSprite> = [];
var disco:Array<FlxSprite> = [];
var obj:Array<FlxSprite> = [];
var dife:Array<FlxSprite> = [];
var curSelected:Int = 0;
var diff:Int = 0;
var culocam:FlxCamera;
var scoreText:FlxText;
static var lastSelected:Int = 0;

function create(){
    window.title = "Friday Night Forbidden - Freeplay";
    DiscordUtil.changePresenceSince("Freeplay", null);

	FlxG.camera.bgColor = FlxColor.BLACK;
	culocam = new FlxCamera();
    culocam.bgColor = 0x0;
	FlxG.cameras.add(culocam, false);

	if(!isMobile){
	culocam.addShader(saturation);
	saturation. AAA = 0.15;
    saturation. BBB = 0.07;
	}

	var estatic:FlxSprite = new FlxSprite();
	estatic.frames = Paths.getFrames('menu1/freeplay/estatic');
	estatic.animation.addByPrefix('idle', "estatic", 30);
	estatic.animation.play('idle');
	estatic.scrollFactor.set();
	estatic.camera = culocam;
	estatic.alpha = 0.5;
	add(estatic);

	er = new FlxSprite().loadGraphic(Paths.image('menu1/freeplay/freeplay_design'));
	er.scrollFactor.set();
	er.camera = culocam;
	add(er);

	enter.frames = Paths.getFrames('menu1/freeplay/ENTER');
	enter.animation.addByPrefix('idle', "ENTER1", 15, false);
	enter.animation.addByPrefix('toc', "ENTER", 15, false);
	enter.animation.play('idle');
	enter.scrollFactor.set();
    enter.scale.set(0.5, 0.5);
	enter.camera = culocam;
	add(enter);

	back.frames = Paths.getFrames('menu1/freeplay/ESC');
	back.animation.addByPrefix('idle', "ESC1", 15, false);
	back.animation.addByPrefix('toc', "ESC", 15, false);
	back.animation.play('idle');
	back.scrollFactor.set();
    back.scale.set(0.5, 0.5);
	back.camera = culocam;
	add(back);

	arrow = new FlxSprite(630,140).loadGraphic(Paths.image('menu1/freeplay/arrow'));
	arrow.scrollFactor.set();
	arrow.camera = culocam;
	add(arrow);

	arrow2 = new FlxSprite(630,490).loadGraphic(Paths.image('menu1/freeplay/arrow'));
	arrow2.scrollFactor.set();
	arrow2.camera = culocam;
    arrow2.flipY = true;
	add(arrow2);

	for(i => cucapelua in ["_torturing", "_akuma", "_Lost", "_Suffo", "_dev"]){
	var erwebomio:FlxSprite = new FlxSprite(500, 0 + (i * 360));
	erwebomio.loadGraphic(Paths.image('menu1/freeplay/' + cucapelua));
	erwebomio.camera = culocam;
	add(erwebomio);
	sprai.push(erwebomio);
	}

	for(cucapelua in songIcons){
	var erwebomio:FlxSprite = new FlxSprite(900, 204);
	erwebomio.loadGraphic(Paths.image('menu1/freeplay/disc_' + cucapelua));
	erwebomio.scale.set(0.9, 0.9);
	erwebomio.camera = culocam;
	erwebomio.scrollFactor.set();
	add(erwebomio);
	disco.push(erwebomio);
	}

	for(cucapelua in songs){
	var erwebomio:FlxSprite = new FlxSprite(5, 154);
	erwebomio.loadGraphic(Paths.image('menu1/freeplay/items/' + cucapelua + '1'));
	erwebomio.scale.set(0.3, 0.3);
	erwebomio.camera = culocam;
	erwebomio.scrollFactor.set();
	add(erwebomio);
	obj.push(erwebomio);
	}

	for(cucapelua in dif){
	var erwebomio:FlxSprite = new FlxSprite(100, 474);
	erwebomio.loadGraphic(Paths.image('menu1/freeplay/' + cucapelua));
	erwebomio.scale.set(0.8, 0.8);
	erwebomio.camera = culocam;
	erwebomio.scrollFactor.set();
	add(erwebomio);
	dife.push(erwebomio);
	}

	subject = new FlxText(150, 60, 0, "SUBJECT", 24);
	subject.setFormat(Paths.font("PhantoMuff.ttf"), 20, 0xFFFFFFFF, "center");
	subject.scrollFactor.set(0,0);
    subject.camera = culocam;
    add(subject);

	items = new FlxText(165, 250, 0, "ITEMS", 24);
	items.setFormat(Paths.font("PhantoMuff.ttf"), 20, 0xFFFFFFFF, "center");
	items.scrollFactor.set(0,0);
    items.camera = culocam;
    add(items);

	diffi = new FlxText(145, 470, 0, "DIFFICULTY", 24);
	diffi.setFormat(Paths.font("PhantoMuff.ttf"), 20, 0xFFFFFFFF, "center");
	diffi.scrollFactor.set(0,0);
    diffi.camera = culocam;
    add(diffi);

	blank.makeGraphic(FlxG.width,FlxG.height,0xFFFFFFFF);
    blank.camera = culocam;
	blank.scrollFactor.set(0,0);
	blank.alpha = 0;
    add(blank);

	scoreText = new FlxText(1000, 470, 0, "Score", 24);
    scoreText.setFormat(Paths.font("PhantoMuff.ttf"), 20, FlxColor.WHITE, "left");
    scoreText.scrollFactor.set(0, 0);
    scoreText.camera = culocam;
    add(scoreText);

	curSelected = lastSelected;
    iconmierda(curSelected);
}

function iconmierda(index:Int) {
    if (index < 0 || index >= songIcons.length) return;
    var name = songIcons[index];

    if (name == lastIcon) return;
    if (icon != null) {
        remove(icon);
        icon = null;
    }
    icon = new HealthIcon(name, true);
    icon.scrollFactor.set(0, 0);
    icon.setPosition(140, 84); 
	icon.flipX = true;
    icon.camera = culocam;
    insert(members.indexOf(blank),icon);
    lastIcon = name;
}

var dificulted:Int = 0;
function sele() {
    var song = FreeplaySonglist.get().songs[curSelected];
    PlayState.loadSong(song.name, song.difficulties[dificulted], false, false);
	FlxG.save.data.lastsong = song.name;
    FlxG.save.data.lastdificulted = song.difficulties[dificulted];
    FlxG.switchState(new PlayState());
}

function playPreview(index:Int) {
    if (index < 0 || index >= songs.length) return;
    var songName = songs[index];
    FlxG.sound.playMusic(Paths.inst(songName), 1, true);
}

var lastPlayed:Int = -1;
var br:Int = 0;
function update(){
    if (controls.BACK){
	back.animation.play('toc');
    back.animation.finishCallback = function(name:String) {
        if (name == "toc") {
	        FlxG.switchState(new MainMenuState());
	        }
       }
	}
	
    if (controls.ACCEPT) {
		if(br == 0){
		enter.animation.play('toc');
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound("menu/confirm"), 0.5);
	    FlxTween.tween(culocam, {zoom: 1.2}, 2, {
			ease: FlxEase.quintOut,
			onComplete: function() { 
                FlxTween.tween(culocam, {alpha: 0}, 4, {
					ease: FlxEase.quintOut, 
                    onComplete: function(_) {
					sele();
					}});
            }
		});
	    blank.alpha = 1;
		FlxTween.tween(blank, {alpha: 0}, 1);
		br++;		
		}
	}
    if (controls.UP_P) curSelected -= 1;
        else if (controls.DOWN_P) curSelected += 1;

	if (controls.LEFT_P) diff -= 1;
        else if (controls.RIGHT_P) diff += 1;

     if (curSelected < 0)curSelected = sprai.length - 1; 
        else if (curSelected >= sprai.length) curSelected = 0;

	if (diff < 0)diff = dif.length - 1; 
        else if (diff >= dif.length) diff = 0;

	culocam.scroll.y = FlxMath.lerp(culocam.scroll.y, sprai[curSelected].y -220, 0.2);

    for (i in 0...sprai.length) {
        if (i == curSelected) {
            sprai[i].x = FlxMath.lerp(sprai[i].x, 430, 0.2);
            sprai[i].scale.set(0.9, 0.9);
            sprai[i].alpha = 1;
        } else {
            sprai[i].x = FlxMath.lerp(sprai[i].x, 530, 0.2);
            sprai[i].alpha = 0.6;
            sprai[i].scale.set(0.7, 0.7);
        }
    }

    if (curSelected != lastPlayed) {
        playPreview(curSelected);
        lastPlayed = curSelected;
    }

for(objets in [disco, obj]){
    for (i in 0...objets.length) {
		disco[i].angle += 0.65;
		if (i == curSelected) {
			objets[i].alpha = 1;
			}else{
			objets[i].alpha = 0;	
			}
	}
}
	for (i in 0...dif.length) {
		if (i == diff) {
			dife[i].alpha = 1;
			dificulted = i;
			}else{
			dife[i].alpha = 0;	
			}
	}

	var song = FreeplaySonglist.get().songs[curSelected];

	scoreText.text = "Score: " + FunkinSave.getSongHighscore(song.name, song.difficulties[diff]).score;

    lastSelected = curSelected;
    iconmierda(curSelected);
	arrow.visible = (curSelected > 0);
	arrow2.visible = (curSelected < sprai.length - 1);

	if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;
}
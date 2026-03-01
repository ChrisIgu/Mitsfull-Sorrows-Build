var bg:FlxSprite;

function postCreate(){
    bg = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/intruder/bg"));
    bg.scale.set(1.5, 1.5);
    insert(0, bg);
    boyfriend.x += 220;
    boyfriend.y += 220;
    boyfriend.scale.set(1.2, 1.2);
    boyfriend.cameraOffset.set(-260,0);

    dad.x -= 120;
    dad.y += 130;
    dad.scale.set(0.85, 0.85);
    dad.cameraOffset.set(-10,100);
}

function create(){
   FlxG.camera.zoom = defaultCamZoom = 0.55;
   //FlxTween.num(defaultCamZoom, 0.55, 0.15, { ease: FlxEase.quadOut }, function(v){ defaultCamZoom = v;});
   //FlxTween.tween(FlxG.camera, {zoom: 0.55}, { ease: FlxEase.quadOut });
}

function onCameraMove(e:CamMoveEvent){FlxTween.num(defaultCamZoom, (e.strumLine == strumLines.members[0]) ? 0.8 : 0.55, 0.15, { ease: FlxEase.quadOut }, function(v){ defaultCamZoom = v;});}
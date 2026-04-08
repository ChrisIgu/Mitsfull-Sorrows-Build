function postCreate(){

    insert(0, num1 = new FlxSprite(-100,-220).loadGraphic(Paths.image("stages/intruderr/1")));
    num1.scale.set(1.2, 1.2);

    insert(0, num2 = new FlxSprite(370,-220).loadGraphic(Paths.image("stages/intruderr/2")));
    num2.scale.set(1.2, 1.2);

    insert(0, num3 = new FlxSprite(1550,-130).loadGraphic(Paths.image("stages/intruderr/3")));
    num3.scale.set(1.2, 1.2);

    insert(0, num4 = new FlxSprite(-90,-330).loadGraphic(Paths.image("stages/intruderr/4")));
    num4.scale.set(1.2, 1.2);

    insert(0, num5 = new FlxSprite(100,-330).loadGraphic(Paths.image("stages/intruderr/5")));
    num5.scale.set(1.2, 1.2);


    boyfriend.setPosition(boyfriend.x + 220, boyfriend.y + 265);
    boyfriend.cameraOffset.set(-260,0);

    dad.setPosition(dad.x + 300, dad.y + 130);
    dad.scale.set(0.75, 0.75);
    dad.cameraOffset.set(-10,100);
}

function create(){
   FlxG.camera.zoom = defaultCamZoom = 0.35;
   //FlxTween.num(defaultCamZoom, 0.55, 0.15, { ease: FlxEase.quadOut }, function(v){ defaultCamZoom = v;});
   //FlxTween.tween(FlxG.camera, {zoom: 0.55}, { ease: FlxEase.quadOut });
}

function onCameraMove(e:CamMoveEvent){FlxTween.num(defaultCamZoom, (e.strumLine == strumLines.members[0]) ? 0.8 : 0.55, 0.15, { ease: FlxEase.quadOut }, function(v){ defaultCamZoom = v;});}
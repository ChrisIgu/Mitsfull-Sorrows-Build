import flixel.math.FlxBasePoint;

var gfaysi = new Character(0, 0, 'gfaysi');

var movement = new FlxBasePoint();
var movecam:Bool = false;
var totalTime:Float = 0;
var phase:Float = -1;
var notepositiony:Float;
var notepositionplayerx:Array<Float> = [];
var notepositioncpux:Array<Float> = [];
var reset:Bool = false;
var gfanim:Bool = true;
var negro:FunkinSprite;

var saturation = new FunkinShader('
    #pragma header

    uniform float brightness;
    uniform float saturation;
    uniform float AAA;
    uniform float BBB;

    void main() {
        vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
        float f = (color.x+color.y+color.z) / AAA;
        color.xyz = brightness+f*(color.xyz*BBB);

        color.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;

        gl_FragColor = color;
    }
');

var scroll = new FunkinShader('
//SHADERTOY PORT FIX
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
#define time iTime
//SHADERTOY PORT FIX

// https://www.shadertoy.com/view/WtGGRt

void mainImage()
{
    // Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord/iResolution.xy;

    const float timeMulti = 0.2;
    
    const float xSpeed = -0.050;
    const float ySpeed = 0.00;

    
    float time = iTime * timeMulti;
    
    // no floor makes it squiqqly
    float xCoord = floor(fragCoord.x + time * xSpeed * iResolution.x);
    float yCoord = floor(fragCoord.y + time * ySpeed * iResolution.y);
    
    vec2 coord = vec2(xCoord, yCoord);
    coord = mod(coord, iResolution.xy);
 
    
    
	vec2 uv = coord/iResolution.xy;
    // Time varying pixel color
    //vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    float col = texture(iChannel0, uv).x;


    vec3 color = vec3(col);
    
    
    
    // Output to screen
    fragColor = vec4(color,1.0) * texture(iChannel0, uv) + texture(iChannel0, uv);
}
');

var blangro = new FunkinShader('
#pragma header

uniform float grayAmount; // 0.0 = color normal, 1.0 = blanco y negro

void main() {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    vec3 finalColor = mix(color.rgb, vec3(gray), grayAmount);
    
    gl_FragColor = vec4(finalColor, color.a);
}
');

function postCreate(){
    FlxG.cameras.add(huddelamierdaaaa = new HudCamera(0, 0, 1280, 770, 1), false).bgColor = 0;
    huddelamierdaaaa.zoom = 0.9;
    huddelamierdaaaa.downscroll = Options.downscroll;

    comboGroup.setPosition(comboGroup.x + 900, comboGroup.y + 200);

    camGame.addShader(saturation);
    camGame.addShader(blangro);
    huddelamierdaaaa.addShader(blangro);

    blangro.grayAmount = 0;

    saturation. AAA = 0.20; //contraste de los sprites
    saturation. BBB = 0.25; //iluminacion de los sprites
    saturation.brightness = 0;
    saturation.saturation = 0;

    add(negro = new FunkinSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000));
    negro.camera = camHUD;

    for(strum in [cpu, player]){
        for (i in 0...4) {
            strum.members[i].camera = huddelamierdaaaa;
            (strum == player) ? strum.members[i].x += 100 : strum.members[i].x -= 100;
            FlxTween.cancelTweensOf(strum.members[i]);
            strum.members[i].y += 30;
            strum.members[i].alpha = 0;
            notepositiony = strum.members[i].y;
        }
    }

    for (i in 0...player.length) {
        notepositionplayerx.push(player.members[i].x);
    }

    for (i in 0...cpu.length) {
        notepositioncpux.push(cpu.members[i].x);
    }

    for(sprite in [boyfriend, dad]){
        sprite.setPosition(sprite.x + (sprite == boyfriend ? 360 : 340), sprite.y + (sprite == boyfriend ? 265 : 180));
        sprite.cameraOffset.set((sprite == boyfriend ? -340 : 150), (sprite == boyfriend ? -250 : 300));
        if(sprite == boyfriend) sprite.alpha = 0;
    }

    dad.scale.set(0.75, 0.75);
    dad.alpha = 0;

    insert(0, gfaysi);
    gfaysi.setPosition(1050, 365);
    gfaysi.flipX = boyfriend.flipX;

    var coords:Array<Array<Int>> = [ [-100, -220], [370, -220], [1550, -130], [-90, -130], [150, 200], [150, -100], [-50, -350], [0, 660]];

    for(i in 1...10){
        var sprite = "num" + i;
        if(i <= 7){
            insert(0, sprite = new FunkinSprite(coords[i - 1][0], coords[i - 1][1]).loadGraphic(Paths.image("stages/intruderr/" + i)));
            if(i == 4) sprite.shader = scroll;
            if(i == 5 || i == 6) sprite.scrollFactor.set(0.5, 0.8);
            sprite.scale.set(1.2, 1.2);
        }else{
            insert(0, sprite = new FunkinSprite(0, (i == 8) ? 0 : coords[7][1]).makeGraphic(FlxG.width, 60, 0xFF000000));
            sprite.camera = camHUD;
        }
    }

    FlxG.camera.zoom = defaultCamZoom = 1.8;

    for (obj in [scoreTxt, missesTxt, accuracyTxt, iconP1, iconP2, healthBar, healthBarBG]) obj.alpha = 0;
    movecam = false;
}

function onStartSong(){
    FlxTween.tween(negro, { alpha: 0 }, 1, {ease: FlxEase.smoothStepInOut});
    FlxTween.tween(FlxG.camera, { zoom: 1.5 }, 11.8, {
        ease: FlxEase.smoothStepInOut,

        onComplete: function(_) {

            defaultCamZoom = 1;
            FlxTween.tween(boyfriend.cameraOffset, { x: 500 , y: 320}, 1.9, {
                ease: FlxEase.smoothStepInOut
            });

            for (i in 0...4) {
                FlxTween.tween(player.members[i], { alpha: 1 }, 1, {
                    ease: FlxEase.smoothStepInOut
                });
            }

            FlxTween.tween(FlxG.camera, { zoom: 1 }, 2, {ease: FlxEase.smoothStepInOut});
        }
    });
}

function stepHit(){
    if(curStep >= 193 && phase == -1){
        phase = 0;

        defaultCamZoom = 1.4;
        FlxTween.tween(boyfriend.cameraOffset, {x: 300}, 1, {
            ease: FlxEase.smoothStepInOut
        });

        FlxTween.tween(FlxG.camera, { zoom: 1.4 }, 1.5, {ease: FlxEase.smoothStepInOut});
    
    }

    if(curStep >= 220 && phase == 0){
        phase = 1;
        dad.alpha = 1;
        defaultCamZoom = 1;
        gfaysi.idleSuffix = "-alt";
        gfanim = false;
        gfaysi.playAnim("sustico", false);
        new FlxTimer().start(0.5, _ -> gfanim = true);

        FlxTween.tween(boyfriend.cameraOffset, {x: -200, y: 200}, 1, {
            ease: FlxEase.smoothStepInOut
        });

        for (i in 0...4) {
            FlxTween.tween(cpu.members[i], { alpha: 1 }, 1, {
                ease: FlxEase.smoothStepInOut
            });
        }

        FlxTween.tween(FlxG.camera, { zoom: 1 }, 1.5, {ease: FlxEase.smoothStepInOut});
    }

    if(curStep >= 256 && phase == 1){
        phase = 2;
        defaultCamZoom = 0.6;
        FlxTween.tween(boyfriend.cameraOffset, {x: 0, y: 300}, 1.5, {ease: FlxEase.smoothStepInOut});
        FlxTween.tween(FlxG.camera, { zoom: 0.6 }, 2, {ease: FlxEase.smoothStepInOut});
    }

    if(curStep >= 384 && phase == 2){
        phase = 2.5;
        movecam = true;
        camGame.alpha = 0;
    }

    if(curStep >= 416 && phase == 2.5){
        phase = 3;
        camGame.alpha = 1;
    }

    if(curStep >= 878 && phase == 3){
        phase = 4;
        movecam = false;

        //defaultCamZoom = 1.2;
        FlxTween.tween(boyfriend.cameraOffset, {x: 100, y: 350}, 1, {
            ease: FlxEase.smoothStepInOut
        });

        //FlxTween.tween(FlxG.camera, { zoom: 1.2 }, 1.5, {ease: FlxEase.smoothStepInOut});
        FlxTween.num(defaultCamZoom, 1.2, 1.5, { ease: FlxEase.smoothStepInOut }, function(v){ defaultCamZoom = v;});

        FlxTween.num(blangro.grayAmount, 1, 2, { ease: FlxEase.smoothStepInOut }, function(v){ blangro.grayAmount = v;});

        FlxTween.num(blangro.grayAmount, 1, 2, { ease: FlxEase.smoothStepInOut }, function(v){ blangro.grayAmount = v;});

        FlxTween.num(saturation. AAA, 0.50, 2, { ease: FlxEase.smoothStepInOut }, function(v){ saturation. AAA = v;});
    }

    if(curStep >= 910 && phase == 4){
        phase = 5;
        movecam = true;

        FlxTween.tween(boyfriend.cameraOffset, {x: 0, y: 300}, 1, {
            ease: FlxEase.smoothStepInOut
        });

        FlxTween.num(blangro.grayAmount, 0, 0.5, { ease: FlxEase.smoothStepInOut }, function(v){ blangro.grayAmount = v;});

        FlxTween.num(saturation. AAA, 0.20, 2, { ease: FlxEase.smoothStepInOut }, function(v){ saturation. AAA = v;});
    }

    if(curStep >= 944 && phase == 5){
        phase = 5.1;
        FlxG.camera.flash(0xFFFFFFFF, 1);
    }

    if(curStep >= 1200 && phase == 5.1){
        phase = 5.2;
        camGame.alpha = 0;
    }

    if(curStep >= 1218 && phase == 5.2){
        phase = 6;
        camGame.alpha = 1;
    }

    if(curStep == 2336 || curStep == 2342 || curStep == 2368 || curStep == 2374 || curStep == 2400 || curStep == 2406 || curStep == 2432 || curStep == 2438) FlxTween.num(1.1, 0.9, 0.4, { ease: FlxEase.quadOut }, function(v){ huddelamierdaaaa.zoom = v;});
    if(curStep == 2950 || curStep == 2954 || curStep == 2958 || curStep == 2966) FlxTween.num(1, 0.9, 0.4, { ease: FlxEase.quadOut }, function(v){ huddelamierdaaaa.zoom = v;});
    if(curStep == 3662){
        FlxTween.num(1.1, 0.9, 2, { ease: FlxEase.quadOut }, function(v){ huddelamierdaaaa.zoom = v;});
        defaultCamZoom = 3;
        FlxTween.num(FlxG.camera.zoom, 3, 2, { ease: FlxEase.circIn }, function(v){ 
            FlxG.camera.zoom = v;
        });
        FlxTween.tween(dad.cameraOffset, {y: -320}, 2, {ease: FlxEase.circIn});

        FlxTween.tween(negro, { alpha: 1 }, 2, {ease: FlxEase.smoothStepInOut});
        FlxTween.tween(huddelamierdaaaa, { alpha: 0 }, 2, {ease: FlxEase.smoothStepInOut});
    }

    if(curStep == 2336 || curStep == 2400){
        movecam = false;
        FlxG.camera.zoom = defaultCamZoom = 0.6;
    }
    if(curStep == 2342 || curStep == 2406) {
        FlxG.camera.zoom = defaultCamZoom = 0.8;
        FlxTween.num(FlxG.camera.zoom, 0.65, 4, { ease: FlxEase.circIn }, function(v){ 
            FlxG.camera.zoom = defaultCamZoom = v;
        });
    }
    if(curStep == 2368 || curStep == 2432){
        FlxG.camera.zoom = defaultCamZoom = 0.8;
    }
    if(curStep == 2374 || curStep == 2438) {
        FlxG.camera.zoom = defaultCamZoom = 1.2;
        FlxTween.num(FlxG.camera.zoom, 0.65, 2, { ease: FlxEase.circIn }, function(v){ 
            FlxG.camera.zoom = defaultCamZoom = v;
        });
    }

    if(curStep >= 2464 && !movecam) movecam = true;
}

function beatHit(){
    if(curBeat % 4 == 0 && (curBeat >= 55 && curBeat < 96)){
        zooming(1);
    }else if(curBeat % 4 == 0 && (curBeat >= 104 && curBeat < 168)){
        zooming(0.95);
    }else if(curBeat % 2 == 0 && (curBeat >= 172 && curBeat < 219)){
        zooming(0.95);
    }else if(curBeat % 2 == 0 && (curBeat >= 228 && curBeat < 235)){
        zooming(0.95);
    }else if(curBeat % 4 == 0 && (curBeat >= 236 && curBeat < 300)){
        zooming(1);
    }else if(curBeat % 4 == 0 && (curBeat >= 304 && curBeat < 364)){
        zooming(1);
    }else if(curBeat % 2 == 0 && (curBeat >= 368 && curBeat < 433)){
        zooming(1);
    }else if(curBeat % 8 == 0 && (curBeat >= 436 && curBeat < 581)){
        zooming(0.95);
    }else if(curBeat % 1 == 0 && (curBeat >= 616 && curBeat < 647)){
        zooming(1.05);
    }else if(curBeat % 2 == 0 && (curBeat >= 648 && curBeat < 711)){
        zooming(1);
    }else if(curBeat % 4 == 0 && (curBeat >= 712 && curBeat < 775)){
        zooming(0.95);
    }else if(curBeat % 4 == 0 && ((curBeat >= 776 && curBeat < 803) || (curBeat >= 808 && curBeat < 839))){
        zooming(1);
    }else if(curBeat % 2 == 0 && (curBeat >= 840 && curBeat < 907)){
        zooming(1);
    }

    if(curBeat == 364 || curBeat == 365 || curBeat == 804 || curBeat == 805) FlxTween.num(1.1, 0.9, 0.4, { ease: FlxEase.quadOut }, function(v){ huddelamierdaaaa.zoom = v;});
}

function zooming(power:Float) {
    huddelamierdaaaa.zoom = power;
    FlxTween.tween(huddelamierdaaaa, { zoom: 0.9 }, 0.6, {ease: FlxEase.quadOut});
    //FlxTween.num(power, 0.9, 0.6, { ease: FlxEase.quadOut }, function(v){ huddelamierdaaaa.zoom = v;});
}


function onPlayerHit(event) {
    if(gfanim) {
        gfaysi.playAnim(boyfriend.getAnimName(), true);
    }
}

function onPlayerMiss(event) {
    if(gfanim) {
        gfaysi.playAnim(boyfriend.getAnimName(), false);
    }
}

function update(elapsed:Float) {
    totalTime += elapsed;
    scroll.iTime = totalTime;

    var currentAnim = boyfriend.getAnimName();

    trace("zoom: " + huddelamierdaaaa.zoom + ", curStep: " + curStep + ", curBeat: " + curBeat);

    if(boyfriend.getAnimName() != "idle" && boyfriend.getAnimName() != "idle-alt" && gfanim) {
        if(gfaysi.getAnimName() != currentAnim) {
            gfaysi.playAnim(boyfriend.getAnimName(), true);
        }
    }

    if(curStep >= 944 && curStep <= 1203) {
        reset = false;
        
        for (strumLine in [cpu, player]) {
            for (i in 0...strumLine.length) {
                var receptor = strumLine.members[i];
                receptor.alpha = 1;
                receptor.setPosition(receptor.x + Math.cos(totalTime * 2 + i) * 0.5, 100 + Math.sin(totalTime * 3 + i) * 10);
                receptor.angle = Math.sin(totalTime * 2 + i) * 10;
            }
        }
        camGame.angle = Math.sin(totalTime * 2) * 5;
        huddelamierdaaaa.angle = Math.sin(totalTime * 2) * 5;

    } else if (curStep >= 1204 && !reset) {
        reset = true;

        FlxTween.tween(camGame, {angle: 0}, 1, {ease: FlxEase.smoothStepInOut});
        FlxTween.tween(huddelamierdaaaa, {angle: 0}, 1, {ease: FlxEase.smoothStepInOut});

        for (i in 0...cpu.length) {
            FlxTween.tween(cpu.members[i], {x: notepositioncpux[i], y: notepositiony, angle: 0}, 1, {ease: FlxEase.smoothStepInOut});
        }

        for (i in 0...player.length) {
            FlxTween.tween(player.members[i], {x: notepositionplayerx[i], y: notepositiony, angle: 0}, 1, {ease: FlxEase.smoothStepInOut});
        }
    }
}

function onCameraMove(e:CamMoveEvent){
    if(movecam){
        switch (strumLines.members[curCameraTarget].characters[0].getAnimName()) {
            case "singLEFT", "singLEFT-alt": movement.set(-90, 0);
                FlxG.camera.angle = lerp(FlxG.camera.angle, -1.5, 0.055);
            case "singDOWN", "singDOWN-alt": movement.set(0, 90);
                FlxG.camera.angle = lerp(FlxG.camera.angle, 0, 0.055);
            case "singUP", "singUP-alt": movement.set(0, -90);
                FlxG.camera.angle = lerp(FlxG.camera.angle, 0, 0.055);
            case "singRIGHT", "singRIGHT-alt": movement.set(90, 0);
                FlxG.camera.angle = lerp(FlxG.camera.angle, 1.5, 0.055);
            default: movement.set(0, 0);
                FlxG.camera.angle = lerp(FlxG.camera.angle, 0, 0.01);
        }
        e.position.x += movement.x;
        e.position.y += movement.y;
        FlxTween.num(defaultCamZoom, (e.strumLine == strumLines.members[0]) ? 0.8 : 0.55, 0.15, { ease: FlxEase.quadOut }, function(v){ defaultCamZoom = v;});
    }
}

function onDadHit(){
    camGame.shake(0.005,0.2, null, true, null);
    huddelamierdaaaa.shake(0.004,0.2, null, true, null);
}
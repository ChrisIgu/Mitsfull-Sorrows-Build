var movecam:Bool = false;
var totalTime:Float = 0;
var phase:Int = -1;

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

function postCreate(){
    camGame.addShader(saturation);
    FlxG.cameras.remove(camHUD, false);

    FlxG.cameras.add(huddelamierdaaaa = new HudCamera(0, 0, 1280, 770, 1), false).bgColor = 0;
    huddelamierdaaaa.zoom = 0.9;
    huddelamierdaaaa.downscroll = Options.downscroll;

    FlxG.cameras.add(camHUD, false);

    comboGroup.setPosition(comboGroup.x + 900, comboGroup.y + 200);

    saturation. AAA = 0.20; //contraste de los sprites
    saturation. BBB = 0.25; //iluminacion de los sprites
    saturation.brightness = 0;
    saturation.saturation = 0;

    for(strum in [player, cpu]){
        for (i in 0...4) {
            strum.members[i].camera = huddelamierdaaaa;
            (strum == player) ? strum.members[i].x += 100 : strum.members[i].x -= 100;
            FlxTween.cancelTweensOf(strum.members[i]);
            strum.members[i].y += 30;
            strum.members[i].alpha = 0;
        }
    }

    var coords:Array<Array<Int>> = [ [-100, -220], [370, -220], [1550, -130], [-90, -130], [150, 200], [150, -150], [-50, -350], [0, 660]];

    for(i in 1...10){
        var sprite = "num" + i;
        if(i <= 7){
            insert(0, sprite = new FunkinSprite(coords[i - 1][0], coords[i - 1][1]).loadGraphic(Paths.image("stages/intruderr/" + i)));
            if(i == 4) sprite.shader = scroll;
            if(i == 5) sprite.scrollFactor.set(0.5, 0.8);
            sprite.scale.set(1.2, 1.2);
        }else{
            insert(0, sprite = new FunkinSprite(0, (i == 8) ? 0 : coords[7][1]).makeGraphic(FlxG.width, 60, 0xFF000000));
            sprite.camera = camHUD;
        }
    }

    for(sprite in [boyfriend, dad]){
        sprite.setPosition(sprite.x + (sprite == boyfriend ? 360 : 340), sprite.y + (sprite == boyfriend ? 265 : 180));
        sprite.cameraOffset.set((sprite == boyfriend ? -340 : 150), (sprite == boyfriend ? -250 : 250));
    }

    dad.scale.set(0.75, 0.75);
    dad.alpha = 0;

    FlxG.camera.zoom = defaultCamZoom = 1.8;
}

function onStartSong(){
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
}

function update(elapsed:Float){
    totalTime += elapsed;
    scroll.iTime = totalTime;
}

function onCameraMove(e:CamMoveEvent){if(movecam){ FlxTween.num(defaultCamZoom, (e.strumLine == strumLines.members[0]) ? 0.8 : 0.55, 0.15, { ease: FlxEase.quadOut }, function(v){ defaultCamZoom = v;});}}
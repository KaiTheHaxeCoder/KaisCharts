import objects.Bar;
import Main;
import psychlua.LuaUtils;
import backend.Conductor;

var noteColors = [0xF86CFF, 0x4382FF, 0x00FF33, 0xFF5900];

function onSpawnNote(note) {
    if (note != null) {
        if (note.isSustainNote)
        {
            note.makeGraphic(100, 64, FlxColor.WHITE);
            note.offsetX = 13;
            note.offsetY = -40;
        }
        else
            note.makeGraphic(150, 32, FlxColor.WHITE);
        if (note.noteType == 'Hurt Note')
            note.color = FlxColor.RED;
        else
            note.color = noteColors[note.noteData];
    }
}

var middleScroll:Bool;
var oppNotes:Bool;
var splashOp:Float;
var camBop:Bool;

var rgb:Bool;
var fpsVisible:Bool;

var downscroll:Bool;

function onCreate()
{
    middleScroll = ClientPrefs.data.middleScroll;
    oppNotes = ClientPrefs.data.opponentStrums;
    splashOp = ClientPrefs.data.splashAlpha;
    camBop = ClientPrefs.data.camZooms;
    downscroll = ClientPrefs.data.downScroll;
    ClientPrefs.data.middleScroll = true;
    ClientPrefs.data.opponentStrums = false;
    ClientPrefs.data.splashAlpha = 0;
    ClientPrefs.data.camZooms = false;
    ClientPrefs.data.downScroll = true; 

    rgb = PlayState.SONG.disableNoteRGB;
    PlayState.SONG.disableNoteRGB = true;

    fpsVisible = Main.fpsVar.visible;
    Main.fpsVar.visible = false;
}

var noteBackdrop:FlxSprite;
var bars:Array<FlxSprite> = new Array();

var health:Bar;
var time:Bar;

var songPercent:Float = 0;

function onCreatePost()
{
    game.camGame.visible = false;
    game.comboGroup.visible = false;
    game.scoreTxt.visible = false;
    game.timeBar.visible = false;
    game.timeTxt.visible = false;
    game.healthBar.visible = false;
    game.iconP1.visible = false;
    game.iconP2.visible = false;

    noteBackdrop = new FlxSprite();
    noteBackdrop.makeGraphic(500, FlxG.height, FlxColor.BLACK);
    noteBackdrop.screenCenter();
    noteBackdrop.alpha = 0.5;
    game.uiGroup.add(noteBackdrop);

    if (game.strumLineNotes != null) {
        var i = 0;
        for (strumNote in game.strumLineNotes) 
        {
            strumNote.visible = false;
            if (i > 3)
            {
                var bar:FlxSprite = new FlxSprite(strumNote.x + 5, strumNote.y);
                bar.makeGraphic(100, 16, FlxColor.WHITE);
                bars.push(bar);
                game.uiGroup.add(bar);
            }
            i = i + 1;
        }
    }

    health = new Bar(0, 0, 'healthBar', function() {return game.health;}, 0, 2);
    health.screenCenter();
    health.y = 60;

    health.bg.visible = false;
    health.rightBar.visible = false;

    time = new Bar(0, 0, 'bar', function() {return songPercent;}, 0, 1);
    time.y = FlxG.height - 8;

    time.bg.visible = false;
    time.rightBar.visible = false;

    game.uiGroup.add(health);
    game.uiGroup.add(time);

    if (!ClientPrefs.data.downScroll)
        game.camHUD.setScale(1, -1);

    game.addTextToDebug('hi', FlxColor.WHITE);
}

function onUpdate(elapsed:Float) {
    for (bar in bars) {
        if (bar.scale.x > 1.0) {
            var newScale = FlxMath.lerp(bar.scale.x, 1.0, elapsed * 15); 
            bar.scale.set(newScale, newScale);
        }
    }

    var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.data.noteOffset);
	songPercent = (curTime / FlxG.sound.music.length);
}

function noteTap(sprite:FlxSprite, lane:Int)
{
    sprite.scale.set(1.2, 1.2);
    sprite.color = noteColors[lane];
}

function onGhostTap(k:Int)
{
    noteTap(bars[k], k);
}

function goodNoteHit(note:Note)
{    if (note != null && !note.isSustainNote) 
    {
        var lane = note.noteData;
        
        if (bars[lane] != null) 
        {
            noteTap(bars[lane], lane);
        }
    }
}

function onKeyRelease(k:Int)
{
    bars[k].scale.set(1, 1);
    bars[k].color = FlxColor.WHITE;
}

function onDestroy()
{
    ClientPrefs.data.middleScroll = middleScroll;
    ClientPrefs.data.opponentStrums = oppNotes;
    ClientPrefs.data.splashAlpha = splashOp;
    ClientPrefs.data.camZooms = camBop;
    ClientPrefs.data.downScroll = downscroll;

    PlayState.SONG.disableNoteRGB = rgb;
    Main.fpsVar.visible = ClientPrefs.data.showFPS;
}
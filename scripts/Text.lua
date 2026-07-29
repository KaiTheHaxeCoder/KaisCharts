local function round(x)
  return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

function makeCoolText(tag, text, x, y)
    makeLuaText(tag, text, 0 , x, y)
    setTextSize(tag, 24)
    setObjectCamera(tag, 'other')
    setTextFont(tag, 'cool.ttf')
    setProperty(tag .. '.antialiasing', true)
    addLuaText(tag)
end

function onCreate()
    makeCoolText('fps', 'FPS: 0', 15, 15)
    makeCoolText('misses', 'Misses: 0', 15, 60)
    makeCoolText('accuracy', 'Accuracy: 0', 15, 105)
end

function onCreatePost()
    makeCoolText('nowplaying', 'Now Playing:\n' .. songName, 0, -60)
    setTextSize('nowplaying', 48)
    screenCenter('nowplaying', 'x')
    doTweenY('tween1', 'nowplaying', 60, 0.25, 'sineInOut')
end

function onUpdate(elapsed)
    setTextString('fps', 'FPS: ' .. getPropertyFromClass('Main', 'fpsVar.currentFPS'))
    setProperty('countdownReady.visible', false)
    setProperty('countdownSet.visible', false)
    setProperty('countdownGo.visible', false)
end


function goodNoteHit(id, noteData, noteType, isSustainNote)
    setTextString('accuracy', 'Accuracy: ' .. (round(rating * 10000) / 100) .. "%")
end

function noteMiss(id, noteData, noteType, isSustainNote)
    setTextString('misses', 'Misses: ' .. misses)
    setTextString('accuracy', 'Accuracy: ' .. (round(rating * 10000) / 100) .. "%")
end

function onSongStart()
    doTweenY('tween2', 'nowplaying', -60, 0.25, 'sineInOut')
end

function onTweenCompleted(tag)
    if tag == 'tween2' then
        removeLuaText('nowplaying', true)
    end

    if string.match(tag, "^c") then
        doTweenAlpha(tag .. 'tween-out', tag, 0, 0.15, 'cubicInOut')
    end
end

function makeCountdownText(text)
    tag = 'c' .. text
    makeCoolText(tag, text, 0, 0)
    setTextSize(tag, 256)
    screenCenter(tag)
    setProperty(tag .. '.alpha', 0)
    doTweenAlpha(tag, tag, 1, 0.15, 'cubicInOut')
    startTimer(tag, 0.15)
end

function onCountdownTick(counter)
    if counter == 0 then
        makeCountdownText('3')
    end
    if counter == 1 then
        makeCountdownText('2')
    end
    if counter == 2 then
        makeCountdownText('1')
    end
    if counter == 3 then
        makeCountdownText('GO!')
    end
end
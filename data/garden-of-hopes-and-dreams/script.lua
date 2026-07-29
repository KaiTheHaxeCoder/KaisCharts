function onStepHit()
    if curStep == 64 then
        doTweenZoom('zoom', 'hud', 2, 3, 'sineInOut')
    end
    if curStep == 88 then
        doTweenZoom('zoom', 'hud', 1, 1, 'sineInOut')
    end
    if curStep == 96 then
        doTweenZoom('zoom', 'hud', 1, 0.1, 'elasticIn')
    end

    if curStep == 126 then
        doTweenZoom('zoom', 'hud', 2, 3, 'sineInOut')
    end
    if curStep == 152 then
        doTweenZoom('zoom', 'hud', 1, 1, 'sineInOut')
    end
    if curStep == 160 then
        doTweenZoom('zoom', 'hud', 1, 0.1, 'elasticIn')
    end
end
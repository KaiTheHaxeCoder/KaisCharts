function onCreate()
    local bgPath = 'images/backgrounds/' .. songName .. '.png'
    
    if checkFileExists(bgPath) then
        makeLuaSprite('songBG', 'backgrounds/' .. songName)
    else
        makeLuaSprite('songBG', '', 0, 0)
        makeGraphic('songBG', 1280, 720, '808080')
    end

    screenCenter('songBG')
    setObjectCamera('songBG', 'hud')
    addLuaSprite('songBG', true)
end
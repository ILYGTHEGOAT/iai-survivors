function love.conf(t)
    t.identity = "ia_survivors_semestre1"
    t.version = "11.4"
    t.window.title = "IA Survivors — Semestre 1"
    t.window.width = 1280
    t.window.height = 720
    t.window.minwidth = 640
    t.window.minheight = 360
    t.window.resizable = true
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = 1
    t.window.msaa = 4
    t.window.highdpi = true
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.thread = false
    t.modules.video = false
    t.window.icon = nil
end

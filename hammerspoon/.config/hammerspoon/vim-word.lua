-- ============================================================
-- VIM MODE: Modal editing for Microsoft Word
-- ============================================================

local vimMode = hs.hotkey.modal.new()

-- ============================================================
-- MODE INDICATOR (single letter, bottom-right of Word window)
-- ============================================================

local indicator = hs.canvas.new({x = 0, y = 0, w = 24, h = 24})
indicator:insertElement({
    type = "rectangle",
    roundedRectRadii = {xRadius = 4, yRadius = 4},
    fillColor = {red = 0.15, green = 0.15, blue = 0.15, alpha = 0.85},
    strokeColor = {red = 0.4, green = 0.4, blue = 0.4, alpha = 0.6},
    strokeWidth = 1,
    frame = {x = 0, y = 0, w = "100%", h = "100%"},
})
indicator:insertElement({
    type = "text",
    text = "N",
    textFont = "Menlo-Bold",
    textSize = 14,
    textColor = {red = 0.4, green = 0.8, blue = 1.0, alpha = 1},
    textAlignment = "center",
    frame = {x = 0, y = 3, w = "100%", h = "100%"},
})
indicator:level(hs.canvas.windowLevels.overlay)
indicator:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)

local indicatorTimer = nil

local function positionIndicator()
    local app = hs.application.get("com.microsoft.Word")
    if not app then return end
    local win = app:focusedWindow()
    if not win then return end
    local f = win:frame()
    indicator:frame({x = f.x + f.w - 34, y = f.y + f.h - 34, w = 24, h = 24})
end

local function setIndicatorText(letter, color)
    indicator[2].text = letter
    indicator[2].textColor = color
end

local function showIndicator(letter, color)
    setIndicatorText(letter, color)
    positionIndicator()
    indicator:show()
    if not indicatorTimer then
        indicatorTimer = hs.timer.doEvery(0.5, positionIndicator)
    end
end

local function hideIndicator()
    indicator:hide()
    if indicatorTimer then
        indicatorTimer:stop()
        indicatorTimer = nil
    end
end

-- ============================================================
-- CORE FUNCTIONS
-- ============================================================

local function isWord()
    local app = hs.application.frontmostApplication()
    if not app then return false end
    return app:bundleID() == "com.microsoft.Word"
end

local function enterVim()
    if not isWord() then return end
    vimMode:enter()
    showIndicator("N", {red = 0.4, green = 0.8, blue = 1.0, alpha = 1})
end

local function exitVim()
    vimMode:exit()
    showIndicator("I", {red = 0.4, green = 0.9, blue = 0.4, alpha = 1})
    hs.timer.doAfter(2, function()
        if not isWord() then
            hideIndicator()
        end
    end)
end

-- Enter normal mode: Escape or Ctrl+[ (ONLY in Word)
local escWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    if not isWord() then return false end

    local keyCode = event:getKeyCode()
    local flags = event:getFlags()

    if keyCode == 53 and flags:containExactly({}) then
        enterVim()
        return true
    end

    if keyCode == 33 and flags:containExactly({"ctrl"}) then
        enterVim()
        return true
    end

    return false
end):start()

-- ============================================================
-- EXIT TO INSERT MODE
-- ============================================================

vimMode:bind({}, "i", function() exitVim() end)

vimMode:bind({}, "a", function()
    exitVim()
    hs.eventtap.keyStroke({}, "right", 0)
end)

vimMode:bind({"shift"}, "i", function()
    exitVim()
    hs.eventtap.keyStroke({"cmd"}, "left", 0)
end)

vimMode:bind({"shift"}, "a", function()
    exitVim()
    hs.eventtap.keyStroke({"cmd"}, "right", 0)
end)

vimMode:bind({}, "o", function()
    hs.eventtap.keyStroke({"cmd"}, "right", 0)
    hs.eventtap.keyStroke({}, "return", 0)
    exitVim()
end)

vimMode:bind({"shift"}, "o", function()
    hs.eventtap.keyStroke({"cmd"}, "left", 0)
    hs.eventtap.keyStroke({}, "return", 0)
    hs.eventtap.keyStroke({}, "up", 0)
    exitVim()
end)

-- ============================================================
-- BASIC MOTIONS (with repeat on hold)
-- ============================================================

local function left() hs.eventtap.keyStroke({}, "left", 0) end
local function down() hs.eventtap.keyStroke({}, "down", 0) end
local function up() hs.eventtap.keyStroke({}, "up", 0) end
local function right() hs.eventtap.keyStroke({}, "right", 0) end

vimMode:bind({}, "h", left, nil, left)
vimMode:bind({}, "j", down, nil, down)
vimMode:bind({}, "k", up, nil, up)
vimMode:bind({}, "l", right, nil, right)

-- ============================================================
-- WORD MOTIONS (with repeat on hold)
-- ============================================================

local function wordRight() hs.eventtap.keyStroke({"alt"}, "right", 0) end
local function wordLeft() hs.eventtap.keyStroke({"alt"}, "left", 0) end
local function wordEnd()
    hs.eventtap.keyStroke({"alt"}, "right", 0)
    hs.eventtap.keyStroke({}, "left", 0)
end

vimMode:bind({}, "w", wordRight, nil, wordRight)
vimMode:bind({}, "b", wordLeft, nil, wordLeft)
vimMode:bind({}, "e", wordEnd, nil, wordEnd)

-- ============================================================
-- LINE MOTIONS
-- ============================================================

vimMode:bind({}, "0", function() hs.eventtap.keyStroke({"cmd"}, "left", 0) end)
vimMode:bind({"shift"}, "4", function() hs.eventtap.keyStroke({"cmd"}, "right", 0) end)
vimMode:bind({"shift"}, "6", function() hs.eventtap.keyStroke({"cmd"}, "left", 0) end)

-- ============================================================
-- DOCUMENT MOTIONS
-- ============================================================

vimMode:bind({"shift"}, "g", function() hs.eventtap.keyStroke({"cmd"}, "down", 0) end)

-- gg — go to top (double-tap g)
local gPressed = false
local gTimer = nil
vimMode:bind({}, "g", function()
    if gPressed then
        hs.eventtap.keyStroke({"cmd"}, "up", 0)
        gPressed = false
        if gTimer then gTimer:stop() end
    else
        gPressed = true
        gTimer = hs.timer.doAfter(0.3, function() gPressed = false end)
    end
end)

-- ============================================================
-- HALF-PAGE SCROLL (with repeat on hold)
-- ============================================================

local function pageDown() hs.eventtap.keyStroke({}, "pagedown", 0) end
local function pageUp() hs.eventtap.keyStroke({}, "pageup", 0) end

vimMode:bind({"ctrl"}, "d", pageDown, nil, pageDown)
vimMode:bind({"ctrl"}, "u", pageUp, nil, pageUp)

-- ============================================================
-- EDITING (with repeat on hold)
-- ============================================================

local function delForward() hs.eventtap.keyStroke({}, "forwarddelete", 0) end
local function delBack() hs.eventtap.keyStroke({}, "delete", 0) end

vimMode:bind({}, "x", delForward, nil, delForward)
vimMode:bind({"shift"}, "x", delBack, nil, delBack)

-- dd — delete line
vimMode:bind({}, "d", function()
    hs.eventtap.keyStroke({"cmd"}, "left", 0)
    hs.eventtap.keyStroke({"cmd", "shift"}, "right", 0)
    hs.eventtap.keyStroke({}, "forwarddelete", 0)
    hs.eventtap.keyStroke({}, "forwarddelete", 0)
end)

-- yy — yank line to system clipboard
vimMode:bind({}, "y", function()
    hs.eventtap.keyStroke({"cmd"}, "left", 0)
    hs.eventtap.keyStroke({"cmd", "shift"}, "right", 0)
    hs.eventtap.keyStroke({"cmd"}, "c", 0)
    hs.eventtap.keyStroke({}, "right", 0)
end)

-- p / P — paste
vimMode:bind({}, "p", function()
    hs.eventtap.keyStroke({}, "right", 0)
    hs.eventtap.keyStroke({"cmd"}, "v", 0)
end)
vimMode:bind({"shift"}, "p", function()
    hs.eventtap.keyStroke({"cmd"}, "v", 0)
end)

-- ============================================================
-- UNDO / REDO
-- ============================================================

vimMode:bind({}, "u", function() hs.eventtap.keyStroke({"cmd"}, "z", 0) end)
vimMode:bind({"ctrl"}, "r", function() hs.eventtap.keyStroke({"cmd", "shift"}, "z", 0) end)

-- ============================================================
-- SEARCH
-- ============================================================

vimMode:bind({}, "/", function()
    hs.eventtap.keyStroke({"cmd"}, "f", 0)
    exitVim()
end)

-- ============================================================
-- VISUAL-ISH: Select with repeat on hold
-- ============================================================

local function selLeft() hs.eventtap.keyStroke({"shift"}, "left", 0) end
local function selDown() hs.eventtap.keyStroke({"shift"}, "down", 0) end
local function selUp() hs.eventtap.keyStroke({"shift"}, "up", 0) end
local function selRight() hs.eventtap.keyStroke({"shift"}, "right", 0) end

vimMode:bind({"shift"}, "h", selLeft, nil, selLeft)
vimMode:bind({"shift"}, "j", selDown, nil, selDown)
vimMode:bind({"shift"}, "k", selUp, nil, selUp)
vimMode:bind({"shift"}, "l", selRight, nil, selRight)

-- ============================================================
-- EXIT VIM MODE WHEN LEAVING WORD
-- ============================================================

hs.application.watcher.new(function(name, event, app)
    if event == hs.application.watcher.deactivated then
        if app and app:bundleID() == "com.microsoft.Word" then
            exitVim()
            hideIndicator()
        end
    end
end):start()

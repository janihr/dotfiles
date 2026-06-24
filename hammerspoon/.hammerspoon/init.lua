-- ============================================================
-- GNOME-like Window Management for macOS
-- ============================================================

local hyper = {"alt"}
local hyperShift = {"alt", "shift"}
local hyperCtrl = {"alt", "ctrl"}

-- ============================================================
-- HELPERS: Screens sorted by physical position (left → right)
-- ============================================================

local function screensSortedByX()
    local screens = hs.screen.allScreens()
    table.sort(screens, function(a, b)
        return a:frame().x < b:frame().x
    end)
    return screens
end

local function screenIndex(screen)
    local screens = screensSortedByX()
    for i, s in ipairs(screens) do
        if s:id() == screen:id() then return i end
    end
    return 1
end

local function screenToLeft(screen)
    local screens = screensSortedByX()
    local idx = screenIndex(screen)
    if idx > 1 then return screens[idx - 1] end
    return nil
end

local function screenToRight(screen)
    local screens = screensSortedByX()
    local idx = screenIndex(screen)
    if idx < #screens then return screens[idx + 1] end
    return nil
end

-- ============================================================
-- HELPERS: Window state detection
-- ============================================================

local function isApprox(a, b, tolerance)
    tolerance = tolerance or 10
    return math.abs(a - b) < tolerance
end

local function isTiledLeft(win)
    local f = win:frame()
    local s = win:screen():frame()
    return isApprox(f.x, s.x) and isApprox(f.y, s.y)
        and isApprox(f.w, s.w / 2) and isApprox(f.h, s.h)
end

local function isTiledRight(win)
    local f = win:frame()
    local s = win:screen():frame()
    return isApprox(f.x, s.x + s.w / 2) and isApprox(f.y, s.y)
        and isApprox(f.w, s.w / 2) and isApprox(f.h, s.h)
end

local function isMaximized(win)
    local f = win:frame()
    local s = win:screen():frame()
    return isApprox(f.x, s.x) and isApprox(f.y, s.y)
        and isApprox(f.w, s.w) and isApprox(f.h, s.h)
end

local function tileLeft(win, screen)
    local s = screen:frame()
    win:setFrame({x = s.x, y = s.y, w = s.w / 2, h = s.h})
end

local function tileRight(win, screen)
    local s = screen:frame()
    win:setFrame({x = s.x + s.w / 2, y = s.y, w = s.w / 2, h = s.h})
end

-- ============================================================
-- TILING: Tile with monitor overflow (Alt+Shift+H/J/K/L)
-- ============================================================

-- Tile left / overflow to previous monitor (Alt+Shift+H)
hs.hotkey.bind(hyperShift, "h", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    if isTiledLeft(win) then
        local prevScreen = screenToLeft(win:screen())
        if prevScreen then
            win:moveToScreen(prevScreen, false, false)
            tileRight(win, prevScreen)
        end
    else
        tileLeft(win, win:screen())
    end
end)

-- Tile right / overflow to next monitor (Alt+Shift+L)
hs.hotkey.bind(hyperShift, "l", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    if isTiledRight(win) then
        local nextScreen = screenToRight(win:screen())
        if nextScreen then
            win:moveToScreen(nextScreen, false, false)
            tileLeft(win, nextScreen)
        end
    else
        tileRight(win, win:screen())
    end
end)

-- Maximize / overflow to monitor above (Alt+Shift+K)
hs.hotkey.bind(hyperShift, "k", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    if isMaximized(win) then
        local aboveScreen = win:screen():toNorth()
        if aboveScreen then
            win:moveToScreen(aboveScreen, false, false)
            win:maximize()
        end
    else
        win:maximize()
    end
end)

-- Restore / center window (Alt+Shift+J)
hs.hotkey.bind(hyperShift, "j", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local screen = win:screen():frame()
    local w = screen.w * 0.6
    local h = screen.h * 0.7
    win:setFrame({
        x = screen.x + (screen.w - w) / 2,
        y = screen.y + (screen.h - h) / 2,
        w = w, h = h
    })
end)

-- ============================================================
-- TILING: Quarter windows (Alt+Ctrl+U/I/J/K)
-- ============================================================

-- Top-left quarter (Alt+Ctrl+U)
hs.hotkey.bind(hyperCtrl, "u", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local s = win:screen():frame()
    win:setFrame({x = s.x, y = s.y, w = s.w / 2, h = s.h / 2})
end)

-- Top-right quarter (Alt+Ctrl+I)
hs.hotkey.bind(hyperCtrl, "i", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local s = win:screen():frame()
    win:setFrame({x = s.x + s.w / 2, y = s.y, w = s.w / 2, h = s.h / 2})
end)

-- Bottom-left quarter (Alt+Ctrl+J)
hs.hotkey.bind(hyperCtrl, "j", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local s = win:screen():frame()
    win:setFrame({x = s.x, y = s.y + s.h / 2, w = s.w / 2, h = s.h / 2})
end)

-- Bottom-right quarter (Alt+Ctrl+K)
hs.hotkey.bind(hyperCtrl, "k", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local s = win:screen():frame()
    win:setFrame({x = s.x + s.w / 2, y = s.y + s.h / 2, w = s.w / 2, h = s.h / 2})
end)

-- ============================================================
-- FOCUS: Focus window by direction (Alt+H/J/K/L)
-- ============================================================

hs.hotkey.bind(hyper, "h", function()
    local win = hs.window.focusedWindow()
    if win then win:focusWindowWest(nil, false, false) end
end)

hs.hotkey.bind(hyper, "l", function()
    local win = hs.window.focusedWindow()
    if win then win:focusWindowEast(nil, false, false) end
end)

hs.hotkey.bind(hyper, "k", function()
    local win = hs.window.focusedWindow()
    if win then win:focusWindowNorth(nil, false, false) end
end)

hs.hotkey.bind(hyper, "j", function()
    local win = hs.window.focusedWindow()
    if win then win:focusWindowSouth(nil, false, false) end
end)

-- ============================================================
-- WORKSPACES: Switch & move windows (Alt+1..9 / Alt+Shift+1..9)
-- ============================================================

local function getSpaces()
    local screen = hs.screen.mainScreen()
    return hs.spaces.spacesForScreen(screen:getUUID())
end

-- Switch to workspace
for i = 1, 9 do
    hs.hotkey.bind(hyper, tostring(i), function()
        local spaces = getSpaces()
        if spaces[i] then
            hs.spaces.gotoSpace(spaces[i])
        end
    end)
end

-- Move window to workspace and follow
for i = 1, 9 do
    hs.hotkey.bind(hyperShift, tostring(i), function()
        local win = hs.window.focusedWindow()
        if not win then return end
        local spaces = getSpaces()
        if spaces[i] then
            hs.spaces.moveWindowToSpace(win:id(), spaces[i])
            hs.spaces.gotoSpace(spaces[i])
        end
    end)
end

-- ============================================================
-- EXTRAS
-- ============================================================

-- Close focused window (Alt+Q)
hs.hotkey.bind(hyper, "q", function()
    local win = hs.window.focusedWindow()
    if win then win:close() end
end)

-- Reload config (Alt+R)
hs.hotkey.bind(hyper, "r", function()
    hs.reload()
end)

hs.alert.show("GNOME-Mode loaded ✓")

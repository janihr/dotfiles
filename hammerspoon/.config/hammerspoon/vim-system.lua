-- vim-system.lua
-- KindaVim-like Vim Emulation for Hammerspoon

local vim = {}
vim.mode = "insert"
vim.count = ""
vim.pending = ""

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

vim.excludedApps = {
    "Terminal", "iTerm2", "Alacritty", "kitty",
    "WezTerm", "Code", "Neovide", "MacVim",
}

vim.scrollAmount = 15

-- ============================================================================
-- UI INDICATOR (Menu Bar)
-- ============================================================================

vim.indicator = hs.menubar.new()

local function updateIndicator()
    local labels = {
        normal = { text = " N ", bg = "#FF8800" },
        insert = { text = " I ", bg = "#00CC00" },
        visual = { text = " V ", bg = "#CC00FF" },
        disabled = { text = " — ", bg = "#666666" },
    }
    local info = labels[vim.mode] or labels.insert
    vim.indicator:setTitle(hs.styledtext.new(info.text, {
        color = { hex = "#FFFFFF" },
        backgroundColor = { hex = info.bg },
        font = { name = "Menlo", size = 12 },
    }))
end

local function showModeAlert(mode)
    hs.alert.closeAll()
    hs.alert.show("-- " .. string.upper(mode) .. " --", 0.4)
end

-- ============================================================================
-- HELPERS
-- ============================================================================

local function key(mods, k)
    vim.eventtap:stop()
    hs.eventtap.keyStroke(mods, k, 0)
    vim.eventtap:start()
end

local function typeChar(char)
    vim.eventtap:stop()
    hs.eventtap.keyStrokes(char)
    vim.eventtap:start()
end

local function getCount()
    local c = tonumber(vim.count)
    vim.count = ""
    return c or 1
end

local function motion(mods, k, count)
    mods = mods or {}
    if vim.mode == "visual" then
        local hasShift = false
        for _, m in ipairs(mods) do
            if m == "shift" then
                hasShift = true
            end
        end
        if not hasShift then
            local newMods = { "shift" }
            for _, m in ipairs(mods) do
                table.insert(newMods, m)
            end
            mods = newMods
        end
    end
    for _ = 1, count do
        key(mods, k)
    end
end

-- ============================================================================
-- MODE TRANSITIONS
-- ============================================================================

function vim.enterNormal()
    vim.mode = "normal"
    vim.count = ""
    vim.pending = ""
    updateIndicator()
    showModeAlert("Normal")
end

function vim.enterInsert()
    vim.mode = "insert"
    vim.count = ""
    vim.pending = ""
    updateIndicator()
    showModeAlert("Insert")
end

function vim.enterVisual()
    vim.mode = "visual"
    vim.count = ""
    vim.pending = ""
    updateIndicator()
    showModeAlert("Visual")
end

-- ============================================================================
-- OPERATOR PENDING
-- ============================================================================

local function handleOperatorPending(char, count)
    local op = vim.pending
    vim.pending = ""

    if op == "d" then
        if char == "d" then
            key({ "cmd" }, "left")
            key({ "shift", "cmd" }, "right")
            key({ "shift" }, "right")
            key({}, "delete")
        elseif char == "w" then
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({}, "delete")
        elseif char == "e" then
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({}, "delete")
        elseif char == "b" then
            for _ = 1, count do key({ "alt", "shift" }, "left") end
            key({}, "delete")
        elseif char == "$" then
            key({ "shift", "cmd" }, "right")
            key({}, "delete")
        elseif char == "0" or char == "^" then
            key({ "shift", "cmd" }, "left")
            key({}, "delete")
        elseif char == "i" then
            vim.pending = "di"
            return true
        elseif char == "a" then
            vim.pending = "da"
            return true
        elseif char == "G" then
            key({ "shift", "cmd" }, "down")
            key({}, "delete")
        elseif char == "g" then
            vim.pending = "dg"
            return true
        end
        return true

    elseif op == "dg" then
        if char == "g" then
            key({ "shift", "cmd" }, "up")
            key({}, "delete")
        end
        return true

    elseif op == "di" then
        if char == "w" then
            key({ "alt" }, "left")
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({}, "delete")
        end
        return true

    elseif op == "da" then
        if char == "w" then
            key({ "alt" }, "left")
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({ "shift" }, "right")
            key({}, "delete")
        end
        return true

    elseif op == "c" then
        if char == "c" then
            key({ "cmd" }, "left")
            key({ "shift", "cmd" }, "right")
            key({}, "delete")
            vim.enterInsert()
        elseif char == "w" then
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({}, "delete")
            vim.enterInsert()
        elseif char == "e" then
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({}, "delete")
            vim.enterInsert()
        elseif char == "b" then
            for _ = 1, count do key({ "alt", "shift" }, "left") end
            key({}, "delete")
            vim.enterInsert()
        elseif char == "$" then
            key({ "shift", "cmd" }, "right")
            key({}, "delete")
            vim.enterInsert()
        elseif char == "0" or char == "^" then
            key({ "shift", "cmd" }, "left")
            key({}, "delete")
            vim.enterInsert()
        elseif char == "i" then
            vim.pending = "ci"
            return true
        elseif char == "a" then
            vim.pending = "ca"
            return true
        end
        return true

    elseif op == "ci" then
        if char == "w" then
            key({ "alt" }, "left")
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({}, "delete")
            vim.enterInsert()
        end
        return true

    elseif op == "ca" then
        if char == "w" then
            key({ "alt" }, "left")
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({ "shift" }, "right")
            key({}, "delete")
            vim.enterInsert()
        end
        return true

    elseif op == "y" then
        if char == "y" then
            key({ "cmd" }, "left")
            key({ "shift", "cmd" }, "right")
            key({ "cmd" }, "c")
            key({}, "right")
        elseif char == "w" then
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({ "cmd" }, "c")
            key({}, "left")
        elseif char == "e" then
            for _ = 1, count do key({ "alt", "shift" }, "right") end
            key({ "cmd" }, "c")
            key({}, "left")
        elseif char == "$" then
            key({ "shift", "cmd" }, "right")
            key({ "cmd" }, "c")
            key({}, "left")
        elseif char == "0" or char == "^" then
            key({ "shift", "cmd" }, "left")
            key({ "cmd" }, "c")
            key({}, "right")
        end
        return true

    elseif op == "g" then
        if char == "g" then
            if vim.mode == "visual" then
                key({ "shift", "cmd" }, "up")
            else
                key({ "cmd" }, "up")
            end
        end
        return true

    elseif op == "r" then
        key({ "shift" }, "right")
        typeChar(char)
        key({}, "left")
        return true
    end

    return true
end

-- ============================================================================
-- NORMAL / VISUAL KEY HANDLER
-- ============================================================================

local function handleNormalKey(char, flags)
    if vim.pending ~= "" then
        return handleOperatorPending(char, getCount())
    end

    -- Count prefix
    if char:match("^[1-9]$") or (char == "0" and vim.count ~= "") then
        vim.count = vim.count .. char
        return true
    end

    local count = getCount()

    -- ── MOTIONS ──
    if char == "h" then
        motion({}, "left", count)
    elseif char == "j" then
        motion({}, "down", count)
    elseif char == "k" then
        motion({}, "up", count)
    elseif char == "l" then
        motion({}, "right", count)
    elseif char == "w" then
        motion({ "alt" }, "right", count)
    elseif char == "b" then
        motion({ "alt" }, "left", count)
    elseif char == "e" then
        motion({ "alt" }, "right", count)
    elseif char == "0" then
        motion({ "cmd" }, "left", 1)
    elseif char == "^" then
        motion({ "cmd" }, "left", 1)
    elseif char == "$" then
        motion({ "cmd" }, "right", 1)
    elseif char == "G" then
        if vim.mode == "visual" then
            key({ "shift", "cmd" }, "down")
        else
            key({ "cmd" }, "down")
        end
    elseif char == "g" then
        vim.pending = "g"
    elseif char == "{" then
        motion({}, "up", count * 5)
    elseif char == "}" then
        motion({}, "down", count * 5)

    -- ── OPERATORS ──
    elseif char == "d" then
        if vim.mode == "visual" then
            key({}, "delete")
            vim.enterNormal()
        else
            vim.pending = "d"
        end
    elseif char == "c" then
        if vim.mode == "visual" then
            key({}, "delete")
            vim.enterInsert()
        else
            vim.pending = "c"
        end
    elseif char == "y" then
        if vim.mode == "visual" then
            key({ "cmd" }, "c")
            key({}, "right")
            vim.enterNormal()
        else
            vim.pending = "y"
        end
    elseif char == "r" then
        vim.pending = "r"

    -- ── SINGLE-KEY ACTIONS ──
    elseif char == "x" then
        for _ = 1, count do key({}, "forwarddelete") end
    elseif char == "X" then
        for _ = 1, count do key({}, "delete") end
    elseif char == "s" then
        key({ "shift" }, "right")
        key({}, "delete")
        vim.enterInsert()
    elseif char == "S" then
        key({ "cmd" }, "left")
        key({ "shift", "cmd" }, "right")
        key({}, "delete")
        vim.enterInsert()
    elseif char == "D" then
        key({ "shift", "cmd" }, "right")
        key({}, "delete")
    elseif char == "C" then
        key({ "shift", "cmd" }, "right")
        key({}, "delete")
        vim.enterInsert()
    elseif char == "Y" then
        key({ "cmd" }, "left")
        key({ "shift", "cmd" }, "right")
        key({ "cmd" }, "c")
        key({}, "right")
    elseif char == "p" then
        key({ "cmd" }, "v")
    elseif char == "P" then
        key({}, "left")
        key({ "cmd" }, "v")
    elseif char == "u" then
        for _ = 1, count do key({ "cmd" }, "z") end
    elseif char == "J" then
        key({ "cmd" }, "right")
        key({}, "forwarddelete")
        key({}, "space")

    -- ── MODE SWITCHES ──
    elseif char == "i" then
        vim.enterInsert()
    elseif char == "I" then
        key({ "cmd" }, "left")
        vim.enterInsert()
    elseif char == "a" then
        key({}, "right")
        vim.enterInsert()
    elseif char == "A" then
        key({ "cmd" }, "right")
        vim.enterInsert()
    elseif char == "o" then
        key({ "cmd" }, "right")
        key({}, "return")
        vim.enterInsert()
    elseif char == "O" then
        key({ "cmd" }, "left")
        key({}, "return")
        key({}, "up")
        vim.enterInsert()
    elseif char == "v" then
        if vim.mode == "visual" then
            key({}, "right")
            vim.enterNormal()
        else
            vim.enterVisual()
        end
    elseif char == "V" then
        key({ "cmd" }, "left")
        key({ "shift", "cmd" }, "right")
        vim.enterVisual()

    -- ── SEARCH ──
    elseif char == "/" then
        key({ "cmd" }, "f")
        vim.enterInsert()
    elseif char == "n" then
        key({ "cmd" }, "g")
    elseif char == "N" then
        key({ "cmd", "shift" }, "g")
    elseif char == "*" then
        key({ "alt" }, "left")
        key({ "alt", "shift" }, "right")
        key({ "cmd" }, "e")
        key({ "cmd" }, "g")
    end

    return true
end

-- ── Ctrl combinations in normal mode ──
local function handleCtrlKey(char)
    if char == "d" then
        for _ = 1, vim.scrollAmount do key({}, "down") end
        return true
    elseif char == "u" then
        for _ = 1, vim.scrollAmount do key({}, "up") end
        return true
    elseif char == "f" then
        key({}, "pagedown")
        return true
    elseif char == "b" then
        key({}, "pageup")
        return true
    elseif char == "r" then
        key({ "cmd", "shift" }, "z")
        return true
    end
    return false
end

-- ============================================================================
-- MAIN EVENT TAP
-- ============================================================================

vim.eventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
    local keyCode = event:getKeyCode()
    local flags = event:getFlags()
    local char = event:getCharacters()

    -- Always pass through Cmd combinations
    if flags.cmd then
        return false
    end

    -- Escape → Normal mode
    if keyCode == 53 then
        if vim.mode ~= "normal" then
            vim.enterNormal()
        else
            vim.pending = ""
            vim.count = ""
        end
        return true
    end

    -- Ctrl+[ as escape
    if flags.ctrl and keyCode == 33 then
        if vim.mode ~= "normal" then
            vim.enterNormal()
        end
        return true
    end

    -- Insert mode: pass everything through
    if vim.mode == "insert" then
        return false
    end

    -- Normal / Visual mode
    if vim.mode == "normal" or vim.mode == "visual" then
        if flags.ctrl and char then
            return handleCtrlKey(char)
        end

        -- Pass through Alt combinations (for window manager hotkeys)
        if flags.alt or flags.ctrl then
            return false
        end

        if char and char ~= "" then
            return handleNormalKey(char, flags)
        end
    end

    return false
end)

-- ============================================================================
-- APP WATCHER (auto-disable for terminals/editors)
-- ============================================================================

vim.appWatcher = hs.application.watcher.new(function(appName, eventType, appObj)
    if eventType == hs.application.watcher.activated then
        if not appName then return end

        local excluded = false
        for _, name in ipairs(vim.excludedApps) do
            if appName:find(name, 1, true) then
                excluded = true
                break
            end
        end

        if excluded then
            vim.eventtap:stop()
            vim.mode = "disabled"
            updateIndicator()
        else
            if not vim.eventtap:isEnabled() then
                vim.eventtap:start()
                vim.enterInsert()
            end
        end
    end
end)

-- ============================================================================
-- START
-- ============================================================================

vim.eventtap:start()
vim.appWatcher:start()
vim.enterInsert()

hs.alert.show("VimMode loaded", 2)

return vim

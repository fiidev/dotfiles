-- ==============================================================================
--  ✦ HYPRLAND CONFIG (100% LUA) ✦
--  Customized for CachyOS + Original Shell Keybinds + Pywal Glass Rice
-- ==============================================================================

local home = os.getenv("HOME")

-- ── 1. PYWAL COLORS DYNAMIC LOADER ──────────────────────────────────────────
local colors_file = home .. "/.cache/wal/colors-hyprland.lua"
local colors = {}
local f = io.open(colors_file, "r")
if f then
    f:close()
    colors = dofile(colors_file)
else
    colors = {
        color5 = "rgb(5170C1)",
        color8 = "rgb(5a5c6f)",
    }
end

-- ── 2. ENVIRONMENT VARIABLES ────────────────────────────────────────────────
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("ELECTRON_ENABLE_WAYLAND", "1")

-- ── 3. MONITORS ─────────────────────────────────────────────────────────────
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
})
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- ── 4. AUTOSTART ────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("swaybg -i " .. home .. "/walls/night-city.jpg -m fill")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("batsignal -b -w 30 -c 20 -d 10")
    hl.exec_cmd(home .. "/.config/hypr/scripts/glass-cursor-tracker.py")
    hl.exec_cmd("swaync")
end)

-- ── 5. CORE CONFIG (LOOK & FEEL, INPUT, GAPS) ───────────────────────────────
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 1,
        layout = "dwindle",
        resize_on_border = false,
        allow_tearing = false,
        col = {
            active_border = { colors = { "rgba(ffffffcc)", "rgba(ffffff14)" }, angle = 45 },
            inactive_border = { colors = { "rgba(ffffff33)", "rgba(ffffff08)" }, angle = 45 },
        },
    },
    decoration = {
        rounding = 22,
        rounding_power = 2,
        active_opacity = 0.86,
        inactive_opacity = 0.74,
        shadow = {
            enabled = true,
            range = 35,
            render_power = 4,
            color = "rgba(00000045)",
        },
        blur = {
            enabled = true,
            size = 4,
            passes = 2,
            new_optimizations = true,
            popups = false,
            ignore_opacity = true,
            xray = false,
            vibrancy = 0.30,
            noise = 0.01,
            contrast = 1.02,
            brightness = 1.02,
        },
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        mfact = 0.5,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },
    input = {
        kb_layout = "us",
        kb_options = "shift:both_capslock",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
    },
})

-- ── 6. ANIMATIONS (JELLY SPRING BOUNCE) ────────────────────────────────────
-- Physical Spring for macOS Tahoe Elastic / Jelly Bounce
hl.curve("jelly", { type = "spring", mass = 1, stiffness = 190, dampening = 13.5 })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

-- Windows Animation
hl.animation({ leaf = "windows", enabled = true, speed = 4.5, spring = "jelly" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.2, spring = "jelly", style = "popin 78%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "quick", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.5, spring = "jelly" })

-- Layers & Notifications (Liquid Glass Jelly Bounce!)
hl.animation({ leaf = "layers", enabled = true, speed = 4.8, spring = "jelly" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4.8, spring = "jelly", style = "popin 70%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "quick", style = "popin 85%" })

-- Fade & Workspaces
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "quick" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.5, spring = "jelly" })

hl.layer_rule({ match = { namespace = "^(rofi)$" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "^(waybar)$" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "^(swaync-control-center)$" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "^(swaync-notification-window)$" }, blur = true, ignore_alpha = 0 })

-- ── 8. KEYBINDINGS (ORIGINAL SHELL COMPATIBLE) ──────────────────────────────

-- Application Launchers
hl.bind("SUPER + space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))

-- Apple-style Emoji Picker (Win + .)
hl.bind("SUPER + period", hl.dsp.exec_cmd("rofimoji --action type copy --use-icons"), { description = "Emoji Picker" })

-- Clipboard History
hl.bind("SUPER + V", hl.dsp.exec_cmd(home .. "/.config/rofi/scripts/clipboard.sh"))

-- Wallpaper Switcher (Grid + Pywal)
hl.bind("SUPER + W", hl.dsp.exec_cmd(home .. "/.config/rofi/scripts/wallpaper-picker.sh"))

-- Window Management (Original Shell)
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + SHIFT + T", hl.dsp.window.float({ action = "toggle" }))

-- Focus Navigation (Arrows & Vim Keys)
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))

-- Window Movement (Arrows & Vim Keys)
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

-- Workspace Navigation (1 - 9)
for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- Next / Previous Workspace Navigation
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + U", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + I", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + Tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("ALT + Tab", hl.dsp.focus({ window = "next" }))

-- Mouse Wheel Navigation
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Touchpad Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Move/Resize Windows with Mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Manual Window Sizing
hl.bind("SUPER + minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + equal", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })

-- Screenshots
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 --clipboard-only"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 --clipboard-only"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprpicker -a"))

-- Control Center (SwayNC)
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t -sw"), { description = "Toggle Control Center" })

-- Rice Utilities
hl.bind("SUPER + G", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/focus-mode.sh"))
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd(home .. "/.config/rofi/scripts/shader-picker.sh"))
hl.bind("ALT + R", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/wf-record-toggle.sh"))
hl.bind("SUPER + slash", hl.dsp.exec_cmd(home .. "/.config/rofi/scripts/keybinds.sh"))
hl.bind("SUPER + F1", hl.dsp.exec_cmd(home .. "/.config/rofi/scripts/keybinds.sh"))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(home .. "/.config/rofi/scripts/power-menu.sh"))

-- Waybar Control
hl.bind("SUPER + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar || waybar"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("pkill waybar && waybar"))

-- Audio Controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

-- Brightness Controls
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Security & Power
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("ALT + S", hl.dsp.exec_cmd("sh -c 'hyprlock & sleep 0.5 && systemctl suspend'"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exit())
hl.bind("ALT + E", hl.dsp.exec_cmd("hyprctl dispatch exit"))

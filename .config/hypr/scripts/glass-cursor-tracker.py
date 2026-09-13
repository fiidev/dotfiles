#!/usr/bin/env python3
import os
import sys
import time
import math
import json
import socket
import signal
import traceback

LOG_FILE = '/tmp/glass-cursor-tracker.log'
def log(msg):
    with open(LOG_FILE, 'a') as f:
        f.write(f'{time.strftime("%H:%M:%S")} {msg}\n')

log("Starting daemon...")

PID_FILE = '/tmp/glass-cursor-tracker.pid'
try:
    if os.path.exists(PID_FILE):
        with open(PID_FILE, 'r') as pf:
            content = pf.read().strip()
            if content:
                old_pid = int(content)
                if old_pid != os.getpid():
                    try:
                        os.kill(old_pid, 0)
                        log(f"Already running with PID {old_pid}, exiting.")
                        sys.exit(0)
                    except OSError:
                        pass
    with open(PID_FILE, 'w') as pf:
        pf.write(str(os.getpid()))
except Exception as e:
    log(f"PID check error: {e}")

def cleanup(*args):
    log("Cleanup signal received, exiting.")
    try:
        if os.path.exists(PID_FILE):
            os.remove(PID_FILE)
    except Exception:
        pass
    sys.exit(0)

signal.signal(signal.SIGINT, cleanup)
signal.signal(signal.SIGTERM, cleanup)
signal.signal(signal.SIGHUP, signal.SIG_IGN)

xdg = os.getenv('XDG_RUNTIME_DIR')
sig = os.getenv('HYPRLAND_INSTANCE_SIGNATURE')
if not xdg or not sig:
    log("XDG_RUNTIME_DIR or HYPRLAND_INSTANCE_SIGNATURE missing!")
    sys.exit(1)

sock_path = f'{xdg}/hypr/{sig}/.socket.sock'
log(f"Connected to socket: {sock_path}")

def hypr_cmd(cmd: str) -> str:
    try:
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
            s.settimeout(0.08)
            s.connect(sock_path)
            s.sendall(cmd.encode())
            data = b''
            while True:
                chunk = s.recv(4096)
                if not chunk:
                    break
                data += chunk
            return data.decode(errors='ignore')
    except Exception as e:
        return ''

last_win_check = 0.0
win_box = None
last_angle = -1
last_cursor = (-1, -1)
idle_count = 0

try:
    while True:
        now = time.time()

        if now - last_win_check > 0.35:
            last_win_check = now
            win_raw = hypr_cmd('j/activewindow')
            if win_raw:
                try:
                    wdata = json.loads(win_raw)
                    if 'at' in wdata and 'size' in wdata and wdata['at'] and wdata['size']:
                        wx, wy = wdata['at']
                        ww, wh = wdata['size']
                        win_box = (wx + ww / 2.0, wy + wh / 2.0)
                    else:
                        win_box = None
                except Exception:
                    win_box = None
            else:
                win_box = None

        if win_box:
            cur_raw = hypr_cmd('cursorpos')
            if cur_raw and ',' in cur_raw:
                try:
                    parts = cur_raw.split(',')
                    mx, my = float(parts[0]), float(parts[1])
                    
                    if (mx, my) != last_cursor:
                        last_cursor = (mx, my)
                        idle_count = 0
                        
                        cx, cy = win_box
                        dx = mx - cx
                        dy = my - cy
                        
                        angle = int((math.degrees(math.atan2(dy, dx)) + 270) % 360)
                        
                        diff = abs(angle - last_angle)
                        if diff > 180:
                            diff = 360 - diff
                            
                        if diff >= 4:
                            last_angle = angle
                            eval_str = f'eval hl.config({{ general = {{ col = {{ active_border = {{ colors = {{ "rgba(ffffffff)", "rgba(ffffff88)", "rgba(8ca8ff33)", "rgba(ffffff0a)" }}, angle = {angle} }} }} }} }})'
                            hypr_cmd(eval_str)
                    else:
                        idle_count += 1
                except Exception:
                    pass

        if idle_count > 25:
            time.sleep(0.1)
        else:
            time.sleep(0.033)
except Exception as e:
    log(f"Crash: {e}\n{traceback.format_exc()}")

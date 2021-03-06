#!/bin/env python3
#
# Python Bar for i3
#
# Uses i3py.py -> https://github.com/ziberna/i3-py
# Based in wsbar.py en examples dir
#
# © 2015 Daniel Jankowski

import time
import os

import i3ipc


DELIMITER = ''
DELIMITER_SLIM = ''# ''

ACTIVE_FG = '#BDBDBD'
ACTIVE_BG = '#1D1D1D'

INACTIVE_FG = '#5D5D5D'
INACTIVE_BG = '#1D1D1D'

AFTER_BG = '#1D1D1D'
BEFORE_BG = '#1D1D1D'

WIN_FG = '#BDBDBD'
WIN_BG = '#1D1D1D'

BG = '#00000000'

class i3ws(object):
    
    def __init__(self, state=None):
        self.socket = i3ipc.Connection()
        
        workspaces = self.socket.get_workspaces()
        outputs = self.socket.get_outputs()
        self.generate(workspaces)

        self.socket.on("workspace", self.change)
        self.socket.on("window", self.change)
        self.socket.main()

    def reload():
        self.socket.main_quit()
        main()

    def change(self, i3, event):
        if event.change in ('focus', 'init', 'empty', 'urgent', 'title'):
            self.generate(self.socket.get_workspaces())

    def get_title(self, workspaces):
        try:
            tree = self.socket.get_tree()
            focused = tree.find_focused()
            for w in workspaces:
                if focused.name != None:
                    if focused.name == w['name']:
                        return ''
                else:
                    return ''
        except Exception as e:
            return ''
        return focused.name + ' '


    def generate(self, workspaces):
        out = ''
        for i in range(len(workspaces)):
            w = workspaces[i]
            if i == 0 and i == len(workspaces) -1:
                if w['focused'] == True:
                    out += '%{F' + BEFORE_BG + '}%{B' + ACTIVE_BG + '}' + DELIMITER \
                            + '%{F' + ACTIVE_FG + '}%{B' + ACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + ACTIVE_BG + '}%{B' + AFTER_BG + '}' + DELIMITER \
                                + '%{F' + INACTIVE_BG + '}%{B' + AFTER_BG + '}%{F#454a4f}%{B' + WIN_BG +'}' + '%{F' + WIN_FG + '}%{B' + WIN_BG + '} ' + str(self.get_title(workspaces)) + '%{F' + WIN_BG + '}%{B' + BG + '}' + DELIMITER
                else:
                    out += '%{F' + BEFORE_BG + '}%{B' + INACTIVE_BG + '}' + DELIMITER \
                            + '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + INACTIVE_FG + '}%{B' + AFTER_BG + '}' + DELIMITER \
                                + '%{F' + INACTIVE_BG + '}%{B' + AFTER_BG + '}%{F#454a4f}%{B' + WIN_BG +'}' + '%{F' + WIN_FG + '}%{B' + WIN_BG + '} ' + str(self.get_title(workspaces)) + '%{F' + WIN_BG + '}%{B' + BG + '}' + DELIMITER
            elif i == 0:
                if w['focused'] == True:
                    out += '%{F' + BEFORE_BG + '}%{B' + ACTIVE_BG + '}' + DELIMITER \
                            + '%{F' + ACTIVE_FG + '}%{B' + ACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + ACTIVE_BG + '}%{B' + INACTIVE_BG + '}'
                else:
                    if workspaces[i+1]['focused']:
                        out += '%{F' + BEFORE_BG + '}%{B' + INACTIVE_BG + '}' + DELIMITER \
                                + '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + INACTIVE_BG + '}%{B' + ACTIVE_BG + '}' 
                    else:
                        out += '%{F' + BEFORE_BG + '}%{B' + INACTIVE_BG + '}' + DELIMITER \
                                + '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' 
            else:
                if w['focused'] == True:
                    if i != len(workspaces)-1:
                        out += '%{F' + ACTIVE_FG + '}%{B' + ACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + ACTIVE_BG + '}%{B' + INACTIVE_BG + '}' 
                    else:
                        out += '%{F' + ACTIVE_FG + '}%{B' + ACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + ACTIVE_BG + '}%{B' + AFTER_BG + '}' \
                                + '%{F' + INACTIVE_BG + '}%{B' + AFTER_BG + '}%{F#454a4f}%{B' + WIN_BG +'}' + '%{F' + WIN_FG + '}%{B' + WIN_BG + '} ' + str(self.get_title(workspaces)) + '%{F' + WIN_BG + '}%{B' + BG + '}' 
                else:
                    if i+1 <= len(workspaces)-1:
                        if workspaces[i+1]['focused']:
                            out += '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + INACTIVE_BG + '}%{B' + ACTIVE_BG + '}' 
                        else:
                            out += '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' 
                    else: # last item
                        out += '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' + w['name'].split(':')[1] + ' %{F' + INACTIVE_BG + '}%{B' + AFTER_BG + '}' + DELIMITER \
                                + '%{F' + INACTIVE_BG + '}%{B' + AFTER_BG + '}%{F#454a4f}%{B' + WIN_BG +'}' + '%{F' + WIN_FG + '}%{B' + WIN_BG + '} ' + str(self.get_title(workspaces)) + '%{F' + WIN_BG + '}%{B' + BG + '}' + DELIMITER
        
        # For panel fifo
        #TODO: Better method to write to fifo
        cmd = 'echo "WSP' + out + '"'
        os.system(cmd)

    def quit(self):
        self.subscription.close()

if __name__ == '__main__':
    ws = i3ws()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print('') 
    finally:
        ws.quit()

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

import i3


DELIMITER = ''
DELIMITER_SLIM = ''# ''

ACTIVE_FG = '#1D1D1D'
ACTIVE_BG = '#8c9440'

INACTIVE_FG = '#1D1D1D'
INACTIVE_BG = '#b5bd68'

AFTER_BG = '#454a4f'
BEFORE_BG = '#b5bd68'

class i3ws(object):
    
    def __init__(self, state=None):
        self.socket = i3.Socket()
        
        workspaces = self.socket.get('get_workspaces')
        outputs = self.socket.get('get_outputs')
        self.generate(workspaces)
        
        callback = lambda data, event, _: self.change(data, event)
        self.subscription = i3.Subscription(callback, 'workspace')
    
    def change(self, event, workspaces):
        if 'change' in event:
            self.generate(workspaces)
   
    def generate(self, workspaces):
        out = ''
        for i in range(len(workspaces)):
            w = workspaces[i]
            if i == 0 and i == len(workspaces) -1:
                if w['focused'] == True:
                    out += '%{F' + BEFORE_BG + '}%{B' + ACTIVE_BG + '}' + DELIMITER \
                            + '%{F' + ACTIVE_FG + '}%{B' + ACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + ACTIVE_BG + '}%{B' + AFTER_BG + '}' + DELIMITER
                else:
                    out += '%{F' + BEFORE_BG + '}%{B' + INACTIVE_BG + '}' + DELIMITER \
                            + '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + INACTIVE_FG + '}%{B' + AFTER_BG + '}' + DELIMITER
            elif i == 0:
                if w['focused'] == True:
                    out += '%{F' + BEFORE_BG + '}%{B' + ACTIVE_BG + '}' + DELIMITER \
                            + '%{F' + ACTIVE_FG + '}%{B' + ACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + ACTIVE_BG + '}%{B' + INACTIVE_BG + '}' + DELIMITER
                else:
                    if workspaces[i+1]['focused']:
                        out += '%{F' + BEFORE_BG + '}%{B' + INACTIVE_BG + '}' + DELIMITER \
                                + '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + INACTIVE_BG + '}%{B' + ACTIVE_BG + '}' + DELIMITER
                    else:
                        out += '%{F' + BEFORE_BG + '}%{B' + INACTIVE_BG + '}' + DELIMITER \
                                + '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' + DELIMITER_SLIM
            else:
                if w['focused'] == True:
                    if i != len(workspaces)-1:
                        out += '%{F' + ACTIVE_FG + '}%{B' + ACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + ACTIVE_BG + '}%{B' + INACTIVE_BG + '}' + DELIMITER
                    else:
                        out += '%{F' + ACTIVE_FG + '}%{B' + ACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + ACTIVE_BG + '}%{B' + AFTER_BG + '}' + DELIMITER
                else:
                    if i+1 <= len(workspaces)-1:
                        if workspaces[i+1]['focused']:
                            out += '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + INACTIVE_BG + '}%{B' + ACTIVE_BG + '}' + DELIMITER
                        else:
                            out += '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '}' + DELIMITER_SLIM
                    else:
                        out += '%{F' + INACTIVE_FG + '}%{B' + INACTIVE_BG + '} ' + w['name'].split(':')[1] + ' %{F' + INACTIVE_BG + '}%{B' + AFTER_BG + '}' + DELIMITER
        #print(out)
        
        # For panel fifo
        #TODO: Better method to write to fifo
        cmd = 'echo WSP' + out
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

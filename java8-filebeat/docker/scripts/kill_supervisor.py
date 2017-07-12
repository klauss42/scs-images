#!/usr/bin/env python

# Supervisord example event listener: http://supervisord.org/events.html#example-event-listener-implementation
# Example of listener that kills supervisord: https://blog.zhaw.ch/icclab/process-management-in-docker-containers/

import os
import signal
import sys


def write_stdout(s):
    # only eventlistener protocol messages may be sent to stdout
    sys.stdout.write(s)
    sys.stdout.flush()

def write_stderr(s):
    sys.stderr.write(s)
    sys.stderr.flush()

def main():
    while True:
        # transition from ACKNOWLEDGED to READY
        write_stdout('READY\n')

        # read header line and print it to stderr
        line = sys.stdin.readline()
        write_stderr('Event header: ' + line)

        # read event payload and print it to stderr
        headers = dict([ x.split(':') for x in line.split() ])
        data = sys.stdin.read(int(headers['len']))
        write_stderr('Event data:   ' + data + '\n')

        datadict = dict([ x.split(':') for x in data.split() ])

        processname = datadict.get('processname', '')
        if processname.startswith('java'):
            write_stderr('Killing supervisord after java process exit ...\n')
            try:
                pidfile = open('/supervisord.pid', 'r')
                pid = int(pidfile.readline())
                os.kill(pid, signal.SIGQUIT)
                sys.exit
            except Exception as e:
                write_stderr('Could not kill supervisor: ' + e.strerror + '\n')

        # transition from READY to ACKNOWLEDGED
        write_stdout('RESULT 2\nOK')

if __name__ == '__main__':
    main()

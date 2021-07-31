"""
A skeleton program that i Usually start with.
"""
from signal import signal, SIGTERM, SIGHUP, pause

def safe_exit(signum, frame):
    exit(1)
    
signal(SIGTERM, safe_exit)
signal(SIGHUP, safe_exit)

try:

    pause()

except KeyboardInterrupt:
    pass

finally:
    pass

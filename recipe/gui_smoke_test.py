"""Start pumaGUI headless and check that it is still running after 10 seconds.

pumaGUI ends in QApplication::exec() and never returns on its own, so staying
up is the success case. Exiting early means it failed to start, for example
because a DLL or a Qt plugin is missing.
"""
import os
import subprocess
import sys

env = dict(os.environ, QT_QPA_PLATFORM="offscreen")
proc = subprocess.Popen(["pumaGUI"], env=env)
try:
    returncode = proc.wait(timeout=10)
except subprocess.TimeoutExpired:
    proc.kill()
    proc.wait()
    sys.exit(0)
print(f"pumaGUI exited early with code {returncode}", file=sys.stderr)
sys.exit(1)

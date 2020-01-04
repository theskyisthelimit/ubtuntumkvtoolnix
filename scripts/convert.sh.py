#!/usr/bin/env python
import os
import sys
import subprocess
import logging

# Setup logger
log_filename = os.path.join(os.path.dirname(sys.argv[0]), 'cleanup.log')
logging.basicConfig(
    filename=log_filename,
    level=logging.INFO,
    format='[%(asctime)s] %(levelname)s - %(message)s'
)
log = logging.getLogger("Converter")

# Retrieve Required Variables for Sonarr/Radarr
if os.environ.get('sonarr_eventtype') == "Test":
    sys.exit(0)
elif 'sonarr_eventtype' in os.environ:
    sourceFile = os.environ.get('sonarr_episodefile_sourcepath')
    sourceFolder = os.environ.get('sonarr_episodefile_sourcefolder')
elif 'radarr_eventtype' in os.environ:
    sourceFile = os.environ.get('radarr_moviefile_sourcepath')
    sourceFolder = os.environ.get('radarr_moviefile_sourcefolder')
else:
    log.error("Error")
    log.error(sourceFile)
    log.error(sourceFolder)
    sys.exit(0)

log.info(sourceFile)

script = "/bin/bash /Media/scripts/convert.sh"
process = subprocess.Popen(script + " " + sourceFile, shell=True)
quit()

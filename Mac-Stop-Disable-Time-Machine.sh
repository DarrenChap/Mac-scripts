#!/bin/sh
# ----- Legal: ----
# Sample scripts are not supported under any N-able support program or service.
# The sample scripts are provided AS IS without warranty of any kind.
# N-able expressly disclaims all implied warranties including, warranties
# of merchantability or of fitness for a particular purpose.
# In no event shall N-able or any other party be liable for damages arising
# out of the use of or inability to use the sample scripts.
# ----- /Legal ----


# Stop any running backup before disabling Time Machine
tmutil stopbackup

# Disable Time Machine - prevents new backups and stops the schedule until started manually
tmutil disable

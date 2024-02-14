@echo off
echo Running Python script...
python dataparser.py

echo Running JavaScript script 1...
node addstats.js

echo Running JavaScript script 2...
node addTeamStats.js

echo All scripts have been executed.
pause
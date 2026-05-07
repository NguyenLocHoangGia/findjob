@echo off
cd /d "%~dp0"
chcp 65001 >nul
set JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 %JAVA_TOOL_OPTIONS%
java -jar target\findjob_tt-0.0.1-SNAPSHOT.jar

@echo off
cd /d "%~dp0"
chcp 65001 >nul
set MAVEN_OPTS=-Dfile.encoding=UTF-8 %MAVEN_OPTS%
call mvnw.cmd spring-boot:run

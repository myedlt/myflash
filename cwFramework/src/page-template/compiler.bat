@echo off
color 2f
title MXML文件编译器 by: 肖平
mode con cols=80 lines=40
echo ********************************************************************************
echo *                     编译生成的swf位于mxml文件所在文件夹下                    *
echo *                                                by: 肖平   %date%  *
echo ******************************************************************************** 
echo 注意：使用本程序前先确保已设置了flex sdk环境变量!
:begin
echo.
set filename=
set /p filename=请输入要编译的mxml文件名（绝对路径或相对路径）:
echo.
mxmlc %filename%
echo.
set m=
set /p m=按任意键继续, 退出请按 1 :
if "%m%"=="1" goto end
goto begin
:end
exit
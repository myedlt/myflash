@echo off
title 添加Flah信任文件
echo #########################################################
echo  添加Flah信任文件路径(myTrustFile.cfg),解决安全沙箱问题!
echo #########################################################
if not exist C:\"Documents and Settings"\%username%\"Application Data"\Macromedia\"Flash Player"\#Security\FlashPlayerTrust md C:\"Documents and Settings"\%username%\"Application Data"\Macromedia\"Flash Player"\#Security\FlashPlayerTrust
copy myTrustFile.cfg C:\"Documents and Settings"\%username%\"Application Data"\Macromedia\"Flash Player"\#Security\FlashPlayerTrust
pause
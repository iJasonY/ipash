#! bin/bash
#Author:iJasonY
#Update Date:2017.02.15

projectName=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'` #获取项目名称
archiveDir=~/Desktop/dailybuild/$projectName  #最后xcarchive和ipa文件的存放目录
fileNameStr=$projectName-$(date +%Y-%m-%d_%H.%M.%S) #文件名
xcarchivePath=$archiveDir/$fileNameStr.xcarchive #xcarchive文件路径
ipapath=$archiveDir/$fileNameStr.ipa #ipa文件路径

# echo "$projectName - $xcarchivePath -  - $fileNameStr "


# 清理工程
xcodebuild clean -workspace $projectName.xcworkspace -scheme $projectName -configuration Release && \

# echo "+++++++++++++++++ clean success+++++++++++++++++"

# archive
xcodebuild archive -workspace $projectName.xcworkspace -scheme $projectName -archivePath $xcarchivePath && \

# echo "+++++++++++++++++ archive success in $archiveDir +++++++++++++++++"

# ipa
xcodebuild -exportArchive -archivePath $xcarchivePath -exportPath $ipapath -exportFormat ipa -exportProvisioningProfile "iOS Team Provisioning Profile: *" -verbose

# echo "+++++++++++++++++ export ipa success in $archiveDir +++++++++++++++++"

# 判断编译结果
if test $? -eq 0
then
echo "~~~~~~~~~~~~~~~~~~~编译成功~~~~~~~~~~~~~~~~~~~"
open $archiveDir
else
echo "~~~~~~~~~~~~~~~~~~~编译失败~~~~~~~~~~~~~~~~~~~"
exit 1
fi
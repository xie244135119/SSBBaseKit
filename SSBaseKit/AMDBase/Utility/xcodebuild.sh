#!/bin/sh

#  xcodebuild.sh
#  FrameWork
#
#  Created by SunSet on 16/10/14.
#  Copyright © 2016年 SunSet. All rights reserved.


#  1.0版本 xcodebuild.sh -p AppTradeAssistant -c Debug
#  2.0版本<融合xworkspace> 命令不变
#


#工程绝对路径
#cd $1
project_path=$(pwd)
#build文件夹路径
build_path=${project_path}/build
#最后ipa地址
ipa_path=${project_path}/build/ipa-build

#工程配置文件路径
#project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
#编译的Target
#build_target=$project_name

workspace_name=$(ls | grep xcworkspace | awk -F.xcworkspace '{print $1}')
build_workspace=${workspace_name}.xcworkspace

#编译的configuration，默认为Release
build_config=Debug
#编译的Scheme 默认
build_scheme=$workspace_name;

#获取参数中的Target
param_pattern=":s:p:nc:o:t:ws:"
while getopts $param_pattern optname
do
case "$optname" in
"s")
tmp_optname=$optname
tmp_optarg=$OPTARG
build_scheme=$tmp_optarg
;;
"p")
tmp_optname=$optname
tmp_optarg=$OPTARG
#build_target=$tmp_optarg
build_scheme=$tmp_optarg
;;
"c")
tmp_optname=$optname
tmp_optarg=$OPTARG
build_config=$tmp_optarg
;;
"t")
# tmp_optind=$OPTIND
tmp_optname=$optname
tmp_optarg=$OPTARG
;;

# OPTIND=$OPTIND-1
# if getopts $param_pattern optname ;then
# echo  "Error argument value for option $tmp_optname"
# exit 2
# fi
# # OPTIND=$tmp_optind

# build_target=$tmp_optarg
# ;;
"?")
echo "Error! Unknown option $OPTARG"
exit 2
;;
":")
echo "Error! No argument value for option $OPTARG"
exit 2
;;
*)
# Should not occur
echo "Error! Unknown error while processing options"
exit 2
;;
esac
done



#cd $project_path
#echo clean start ...
##删除bulid目录
#if  [ -d ${build_path} ];then
##rm -rf ${build_path}
#echo clean build_path success.
#fi
##清理工程
#xcodebuild clean || exit


########-------V1.0分割线--------

#echo building.....+$build_scheme
#编译工程
#xcodebuild -target $build_target  -configuration $build_config  \
# -scheme ${build_scheme} \
ONLY_ACTIVE_ARCH=NO \
TARGETED_DEVICE_FAMILY=1 \
# DEPLOYMENT_LOCATION=YES CONFIGURATION_BUILD_DIR=${project_path}/build/Release-iphoneos  || exit

#打包
#cd $build_path
#
#if [[ -d ./ipa-build ]]; then
##删除ipa-build文件
#rm -rf ipa-build
#fi
#cd $build_path
## rm -r ipa-build
#mkdir -p ipa-build/Payload
#cp -R ./$build_config-iphoneos/${build_scheme}.app ./ipa-build/Payload/
#cd ipa-build
#zip -r ${build_scheme}.ipa *
#
#echo "文件地址:"+${build_path}/ipa-build/${build_scheme}.ipa

########-----分割线--------



####-----V2.0版本-----
exportpath=$ipa_path
archivepath=${project_path}/build/$build_config-iphoneos/$build_scheme.xcarchive
xcodebuild archive -workspace $build_workspace  -scheme $build_scheme  -configuration $build_config  -archivePath $archivepath

exportplstpath=${project_path}/AppMicroDistribution/Classes/AMDBase/Utility/XcodeBuildExportOptions.plist
xcodebuild -exportArchive -archivePath $archivepath -exportPath $exportpath -exportOptionsPlist $exportplstpath
####V




#获取项目版本号
project_infoplist_path=${project_path}/${build_scheme}/Info.plist
#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${project_infoplist_path})
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${project_infoplist_path})
#取bundle Identifier前缀
bundlePrefix=$(/usr/libexec/PlistBuddy -c "print CFBundleIdentifier" `find . -name "*-Info.plist"` | awk -F$ '{print $1}')


#自动上传到蒲公英
#API调用方身份
_api_key="c5d6bea4ecdd76041fd87dd0b7e2e773"
#用户身份<有量公司>
uKey="73605723e13be10ca670782500f6f58c"
#appKey <不同App使用的应用号>
appKey="6e7d224c9be701bc69495db52af7ada0"
case $build_scheme in
"AppMicroDistribution") #有量微分销
appKey="0bcb31de6ee9d1b257b18cade467be1b"
;;
"AppSupplyDistribution")    #佰酿美酒
appKey="2ec6d039ea3109402d4ebb374609dc6f"
;;
"AppYlEnterprise")      #中通优选
appKey="e186810d4788a2c193aaac9a58c01b86"
;;
"AppTradeAssistant")    #买卖助理
appKey="6e7d224c9be701bc69495db52af7ada0"
;;
esac


#安装方式1：公开，2：密码安装，3：邀请安装。默认为1公开
installType=2
password="123456"
#版本更新内容
updateDescription="$build_config 版本:V${bundleVersion}"
#内容
filepath=$ipa_path/$build_scheme.ipa
#自动上传
curl -F "file=@${filepath}" -F "uKey=${uKey}" -F "_api_key=${_api_key}" -F "updateDescription=${updateDescription}" https://qiniu-storage.pgyer.com/apiv1/app/upload






#!/bin/bash

#Global Parameters
#OP can be "move" or "copy"
OP='copy'
#Target Google Driver name of rclone
REMOTENAME='google-stevens'
#Target Google Drive Folder
REMOTEFOLDER='/IOTProject-Backup'
#Log files
LOGFILE="${HOME}/gdrive/rclone.log"

#For China Baidu cloud disk
#BDlocalFolder="${HOME}/gdrive/888888_usernameOfBaidu"
#BDprefixOptional='/apps/baidu_shurufa'
#BDuncompleteExt='.BaiduPCS-Go-downloading'

#For Aria2
ArialocalFolder="${HOME}/gdrive/aria2"
AriaprefixOptional=''
AriauncompleteExt='.aria2'

#Auto upload function
#Support 4 parameters:
# 1.Source folder of local 
# 2.Filename extension of uncompleted task
# 3.Remove some folder name in path. Avoid to create too many folder on Google drive. (For Baidu only)
# 4.Operation: copy or move
function UploadToGoogle() {
    find $1 -type f|grep -v .*${2}$|while read path;
    do
        if ! [ -f "${path}${2}" ]
        then
            remotepath=${path%/*}
            remotepath=${remotepath#*${1}}
            remotepath=${remotepath#*${3}}
            rclone $4 -v "$path" ${REMOTENAME}:${REMOTEFOLDER}"${remotepath}"/ --log-file ${LOGFILE} 
        fi
    done
    rclone rmdirs "${1}" --leave-root
}


#UploadToGoogle $BDlocalFolder $BDuncompleteExt $BDprefixOptional $OP
UploadToGoogle $ArialocalFolder $AriauncompleteExt $AriaprefixOptional $OP
 

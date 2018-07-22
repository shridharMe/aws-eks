#!/bin/bash
set -e
while getopts "r:s:e:m:" opt; do
   case $opt in
    r) runcmd="$OPTARG"
      ;;
    s) squadname="$OPTARG"
      ;;
    e) envname="$OPTARG"
      ;;
    m) modulename="$OPTARG"
      ;;
    \?) echo "Invalid option -$OPTARG" >&2
       ;;
  esac
done

if [ -z ${runcmd} ] || [ -z ${squadname} ] || [ -z ${envname} ] || [ -z ${modulename} ] ; then
    printf "\n"
    printf "Please provide squad and env and terraform command \n\n"
    printf "./provision.sh -s devops -e dev -r init -m vpc \n"
    printf "valid squad values is devops \n"
    printf "\n"
elif [ "${squadname}" != "devops" ]; then
    printf "\n"
    printf "!!! invalid squad entry !!! \n"
    printf "valid squad values is  devops \n"

elif [ "${runcmd}" != "init" ] && [  "${runcmd}" != "plan" ] && [  "${runcmd}" != "apply" ]  && [  "${runcmd}" != "destroy" ]; then
    printf "\n"
    printf "!!! invalid terrafrom command entry !!! \n"
    printf "Valid terrafrom command to run this script is:  init,plan,apply or destroy \n"  
else
    cd ${modulename}/
    if [ ${runcmd} == "init" ];then
       rm -rf .terraform/
       yes yes |  TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd}  
    
    elif [ ${runcmd} == "destroy" ];then 
       TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} -var-file="variables/$squadname/$envname.tfvars" -var "terraform_user_arn=${TERRAFORM_USER_ARN}" -force
     elif [ ${runcmd} == "apply" ];then 
        TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} -var-file="variables/$squadname/$envname.tfvars" -var "terraform_user_arn=${TERRAFORM_USER_ARN}" -auto-approve  
    else
       TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} -var-file="variables/$squadname/$envname.tfvars" -var "terraform_user_arn=${TERRAFORM_USER_ARN}"
    fi
    cd $WORKSPACE
fi
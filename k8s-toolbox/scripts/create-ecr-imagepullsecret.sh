#!/bin/bash

#
# Create a Kubernetes registry secret for an AWS ECR region
# Requires AWS CLI: https://aws.amazon.com/cli/
# Requires kubectl: https://coreos.com/kubernetes/docs/latest/configure-kubectl.html
#

# 
# This secret can be used with 'imagePullSecret' for Kubernetes
#
# ...
# spec:
#   containers:
#   - name: busybox
#     image: busybox:latest
#   imagePullSecrets:
#   - name: us-west-2-ecr-registry
#...
#

#
# When Kubernetes 1.3.0+ is released this approach should not be necessary
# This patch will allow Kubernetes to automatically cache cross-region AWS ECR tokens
# https://github.com/kubernetes/kubernetes/pull/24369
#

ACCOUNT=""
SECRET_NAME=""
NAMESPACE="default"
REGION=ap-southeast-2
EMAIL=secret@myob.com
RC=0
HIGHRC=0

usage (){
echo "usage: $0 -a <aws account id> -s <secret name> [ -n  <namespace>  -r <region> ]"
exit 1
}


#+--------------------------------------------------------------------------+
#| highrc:                                                                  |
#| This code will retain the highest return code returned from executed     |
#|  selected functions.  The highest return code will be displayed upon     |
#|  completion of the this script.  The return code will also be returned   |
#|  via exit, thus providing workload with a more accurate return code value|
#+--------------------------------------------------------------------------+

highrc()  {

 test "$HIGHRC"
 if  [ $? -ne 0 ]
 then
      HIGHRC=$RC
 elif [ $RC -gt $HIGHRC ]
 then
      HIGHRC=$RC
 fi

}

#+--------------------------------------------------------------------------+
#| checkrc:                                                                 |
#| This function will check the return code and abort the script if the rc  |
#| is non zero.                                                             |
#+--------------------------------------------------------------------------+
checkrc()  {

 if  [ $HIGHRC -ne 0 ]
 then
   echo "Non-zero return code encountered - aborting script.\n"
   echo "`basename $0` aborted - rc: $HIGHRC"
   exit $HIGHRC
 fi

}


# ensures script dependencies are available
check_deps() {
    cmds_missing=0
    for cmd in kubectl aws; do
        if [[ -z $(which $cmd) ]]; then
            cmds_missing=1
            echo "Dependency missing: $cmd"
        fi
    done
    [[ $cmds_missing -gt 0 ]] && exit 1
}


#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------


check_deps

# parse cmdline args
while getopts ":a:n:r:s:" opt; do
    case "${opt}" in
      a)  export ACCOUNT=$OPTARG
          ;;
      n)  export NAMESPACE=$OPTARG
          ;;
      r)  export REGION=$OPTARG
          ;;
      s)  export SECRET_NAME=$OPTARG
          ;;
      *)
          usage
          ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${ACCOUNT}" ] || [ -z "${SECRET_NAME}" ]; then
    usage
fi


#
# Fetch token (which will expire in 12 hours)
#

TOKEN=`aws ecr --region=$REGION get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`
RC=$?
highrc
checkrc

#
# Create or repleace registry secret
#
kubectl delete secret --ignore-not-found $SECRET_NAME --namespace ${NAMESPACE}
kubectl create secret docker-registry $SECRET_NAME --namespace ${NAMESPACE} \
 --docker-server=https://${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com \
 --docker-username=AWS \
 --docker-password="${TOKEN}" \
 --docker-email="${EMAIL}"
RC=$?
highrc
checkrc

exit 0

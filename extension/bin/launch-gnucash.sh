#!/bin/sh

(
    pass show aws-access-key-id &&
        pass show aws-secret-access-key &&
        echo us-east-1 &&
        echo text
) | aws configure &&
DOT_SSH_CONFIG_FILE=$(mktemp ${HOME}/.ssh/config.d/XXXXXXXX) &&
    SECURITY_GROUP=$(uuidgen) &&
    KEY_NAME=$(uuidgen) &&
    KEY_FILE=$(mktemp ${HOME}/.ssh/XXXXXXXX.id_rsa) &&
    rm -f ${KEY_FILE} &&
    cleanup(){
        echo CLEANING UP &&
            bash &&
            rm -f ${DOT_SSH_CONFIG_FILE} ${KEY_FILE} ${KEY_FILE}.pub &&
            aws \
                ec2 \
                wait \
                instance-terminated \
                --instance-ids $(aws \
                    ec2 \
                    terminate-instances \
                    --instance-ids $(aws ec2 describe-instances --filters Name=tag:moniker,Values=lieutenant Name=instance-state-name,Values=running --query "Reservations[0].Instances[*].InstanceId" --output text) \
                    --query "TerminatingInstances[*].InstanceId" \
                    --output text) &&
            aws ec2 delete-security-group --group-name ${SECURITY_GROUP} &&
            aws ec2 delete-key-pair --key-name ${KEY_NAME} &&
            rm -rf /opt/cloud9/workspace/lieutenant
    } &&
    trap cleanup EXIT &&
    ssh-keygen -f ${KEY_FILE} -C "temporary lieutenant-ec2" -P "" &&
    aws \
        ec2 \
        wait \
        instance-running \
        --instance-ids $(aws \
            ec2 \
            run-instances \
            --image-id ami-55ef662f \
            --security-group-ids $(aws ec2 create-security-group --group-name ${SECURITY_GROUP} --description "security group for the lieutenant environment in EC2" --query "GroupId" --output text) \
            --count 1 \
            --instance-type t2.micro \
            --key-name $(aws ec2 import-key-pair --key-name ${KEY_NAME} --public-key-material "$(cat ${KEY_FILE}.pub)" --query "KeyName" --output text) \
            --placement AvailabilityZone=$(aws ec2 describe-volumes --filters Name=tag:moniker,Values=lieutenant --query "Volumes[*].AvailabilityZone" --output text) \
            --tag-specifications "ResourceType=instance,Tags=[{Key=moniker,Value=lieutenant}]" \
            --query "Instances[0].InstanceId" \
            --output text) &&
    echo CREATED INSTANCE AND IT IS RUNNING &&
    DEVICE=$(aws \
        ec2 \
        attach-volume \
        --device /dev/sdh \
        --volume-id $(aws ec2 describe-volumes --filters Name=tag:moniker,Values=lieutenant --query "Volumes[*].VolumeId" --output text) \
        --instance-id $(aws ec2 describe-instances --filters Name=tag:moniker,Values=lieutenant Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].InstanceId" --output text) \
        --query "Device" \
        --output text) &&
    echo DEVICE ATTACHED &&
    aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP} --protocol tcp --port 22 --cidr 0.0.0.0/0 &&
    IP_ADDRESS=$(aws ec2 describe-instances --filter Name=tag:moniker,Values=lieutenant Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].PublicIpAddress" --output text) &&
    (cat > ${DOT_SSH_CONFIG_FILE} <<EOF
Host lieutenant-ec2
HostName ${IP_ADDRESS}
User ec2-user
IdentityFile ${KEY_FILE}
EOF
    ) &&
    echo SSH CONFIGURED 1 &&
    while [ -z "$(ssh-keyscan ${IP_ADDRESS})" ]
    do
        echo SCANNING ... ${IP_ADDRESS} &&
            sleep 3s
    done &&
    ssh-keyscan ${IP_ADDRESS} >> ${HOME}/.ssh/known_hosts &&
    echo SSH CONFIGURED 2 &&    
    ssh lieutenant-ec2 sudo mkdir /data &&
    echo MADE DATA DIRECTORY 1 &&
    ssh lieutenant-ec2 sudo mount ${DEVICE} /data &&
    echo MOUNTED 1 &&
    echo "find /dev/disk/by-uuid/ -mindepth 1 | while read FILE; do [ \$(readlink -f \${FILE}) == \"${DEVICE}\" ] && basename \${FILE} ; done | while read UUID; do echo \"UUID=\${UUID}       /data   ext4    defaults,nofail        0       2\" | sudo tee --append /etc/fstab ; done" | ssh lieutenant-ec2 sh &&
    echo FSTABBED &&
    mkdir /opt/cloud9/workspace/lieutenant &&
    echo MADE DATA DIRECTORY 2 &&
    sshfs -o allow_other lieutenant-ec2:/data ${HOME}/workspace/lieutenant &&
    echo MOUNTED 2 &&
    /usr/bin/gnucash /opt/cloud9/workspace/lieutenant/gnucash/gnucash.gnucash &&
    echo DONE
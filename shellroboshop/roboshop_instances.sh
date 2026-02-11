#!/bin/bash
sg_id="sg-0d63af36e18f90251"
iam_id="ami-0220d79f3f480ecf5"
DOMAIN_NAME="yashwanthaarem.in"
ZONE_ID="Z017691837EJOVFVM6G3X"

for instance in $@
 do 
 INSTANCE_ID=$(aws ec2 run-instances \
 --image-id $ami_id \
 --instance-type t3.micro \
 --security-group-ids $sg_id\ 
 --associate-public-ip-address \
 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
 --query 'Instances[0].InstanceId' \
 --output text)




    if[ frontend=="$instance" ]; then
    IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[].Instances[].PublicIpAddress' --output text)
    RECORD_NAME="$DOMAIN_NAME"
    else
    IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[].Instances[].PrivateIpAddress' --output text)
    RECORD_NAME="$instance.$DOMAIN_NAME"
    fi


    echo "Address $IP"

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
    "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "'$RECORD_NAME'",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [
          {
            "Value": "'$IP'"
          }
                ]
        }
        }
    ]
    }
    '


done

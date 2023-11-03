#!/bin/bash

instance_ids=$(aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId]' --output text)
region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

echo "Instances and IAM roles in the region $region are:"
for instance_id in $instance_ids; do
 instance_name=$(aws ec2 describe-instances --instance-ids $instance_id --region $region --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value]' --output text)
 iam_role_name=$(aws ec2 describe-instances --instance-ids $instance_id --region $region --query 'Reservations[].Instances[].[IamInstanceProfile]' --output text)
  
 if [ -z "$iam_role_name" ]; then
    iam_role_name="No IAM role attached"
 else
    iam_role_name=$(echo $iam_role_name | sed 's/.*arn:aws:iam::.*:instance-profile\/\(.*\))/\1/')
 fi
  
 echo "Instance ID: $instance_id, Instance Name: $instance_name, IAM Role Name: $iam_role_name"
done
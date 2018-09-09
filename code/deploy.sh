#!/usr/bin/env bash

tar -cjf latest.tar.bz2 public
MD5=`openssl md5 -binary latest.tar.bz2 | base64`
aws s3 sync scripts s3://jez-cloud-workshop/
aws s3api put-object --bucket jez-cloud-workshop --key latest.tar.bz2 --body latest.tar.bz2 --metadata md5chksum=$MD5

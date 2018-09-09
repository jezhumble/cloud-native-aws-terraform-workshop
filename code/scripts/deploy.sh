LATEST_MD5=`aws s3api head-object --bucket jez-cloud-workshop --key latest.tar.bz2 --output text --query '{MD:Metadata}' | cut -f 2`
CURRENT_MD5=`openssl md5 -binary /var/www/latest.tar.bz2 | base64`
if [[ $LATEST_MD5 != $CURRENT_MD5 ]]
then
    STAMP=$(date +%Y%m%d%I%M%S)
    aws s3 cp s3://jez-cloud-workshop/latest.tar.bz2 /var/www/
    cd /var/www
    mkdir $STAMP
    tar -xjf latest.tar.bz2 -C$STAMP --strip-components 1
    composer install --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader --working-dir /var/www/$STAMP
    ln -sfT $STAMP html
fi

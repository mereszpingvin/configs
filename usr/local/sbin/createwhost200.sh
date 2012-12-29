#!/bin/bash

#echo "Enter a domain name : "
#read dname
echo "Starting the add user script:"
    MYUSER=$(pwgen -0A 6 1)
    MYSQLPW=$(pwgen 10 1)
    MYFTPW=$(pwgen 8 1)
echo "New user name: $MYUSER"
echo "Adding new user..."
    useradd -g 100 -G 100 -s /bin/false -d /var/www/users/$MYUSER/var/www/users/$MYUSER/ $MYUSER
echo "Done"
echo "Create webroot, .tmp and CGI-BIN directory..."
    mkdir -p /var/www/users/$MYUSER/var/www/users/$MYUSER/{cgi-bin,wwwroot,wwwroot/.tmp/sessions,wwwroot/.tmp/wsdl,wwwroot/.tmp/upload,wwwroot/$1}
echo "Done"
echo "Copy and modify the default php-wrapper, and php.ini files..."
    sed -e 's/changeme/'$MYUSER'/g' /var/www/users/default/var/www/users/default/cgi-bin/php5default-wrapper > /var/www/users/$MYUSER/var/www/users/$MYUSER/cgi-bin/php5-wrapper
    sed -e 's/changeme/'$MYUSER'/g' /var/www/users/default/var/www/users/default/cgi-bin/php5default.ini > /var/www/users/$MYUSER/var/www/users/$MYUSER/cgi-bin/php5.ini
echo "Done"
echo "Set execute bit the wrapper file..."
    chmod +x /var/www/users/$MYUSER/var/www/users/$MYUSER/cgi-bin/php5-wrapper
echo "Done"
echo "Change directory owner"
    chown -R $MYUSER:users /var/www/users/$MYUSER/var/www/users/$MYUSER/
echo "Done"
echo "Adding new MySQL user, and create default database..."
    SQL="CREATE DATABASE IF NOT EXISTS $MYUSER;
    GRANT USAGE ON *.* TO '$MYUSER'@'%' IDENTIFIED BY '$MYSQLPW';
    GRANT SELECT , INSERT , UPDATE , DELETE , CREATE , DROP , INDEX , ALTER , CREATE TEMPORARY TABLES , CREATE VIEW , SHOW VIEW , CREATE ROUTINE, ALTER ROUTINE, EXECUTE ON $MYUSER.* TO '$MYUSER'@'%';
    FLUSH PRIVILEGES;"
    mysql -uroot -pGik2uHGM5cfYpb -e "$SQL"
echo "Done"
echo "Get UID..."
    IDU=$(id -u $MYUSER)
echo "Done"
echo "Create FTP account..."
     FTPQ="use isabella
     INSERT INTO ftpquotalimits (name,quota_type,per_session,limit_type,bytes_in_avail,bytes_out_avail,bytes_xfer_avail,files_in_avail,files_out_avail,files_xfer_avail) VALUES ('$MYUSER', 'user', 'true', 'hard', '209715200', '0', '0', '0', '0', '0');
     INSERT INTO ftpuser (id,userid,passwd,uid,gid,homedir,shell,count,accessed,modified) VALUES (NULL, '$MYUSER', '$MYFTPW', $IDU, 100, '/var/www/users/$MYUSER/var/www/users/$MYUSER/wwwroot', '/sbin/nologin', 0, '', '');"
     mysql -uroot -pGik2uHGM5cfYpb -e "$FTPQ"
echo "Done"
echo "Creating webserver config..."
count=120
counter=`expr $count + 1`
    sed -e 's/changedomain/'$1'/g' -e 's/default/'$MYUSER'/g' /usr/local/sbin/default.tmpl > /etc/apache2/vhosts.d/"$counter"_"$1".conf
echo "Done"
echo "Restarting apache2..."
    /etc/init.d/apache2 reload
echo "Done"

echo "Sending mail..."
sed -e 's/azonosito/'$MYUSER'/g' -e 's/dmn/'$1'/g' -e 's/mysqlpass/'$MYSQLPW'/g' -e 's/ftppasswd/'$MYFTPW'/g' /usr/local/sbin/news200.tmpl > /usr/local/sbin/content200.html
(
echo "From: daemon@mereszpingv.in"
echo "To: admin@mereszpingv.in, ajanlatkeres@mintalap.hu"
echo "MIME-Version: 1.0";
echo "Content-Type: text/html";
echo "Content-Disposition: inline";
echo "Subject: $MYUSER azonositoju 200MB-os tarhely elkeszult";
cat /usr/local/sbin/content200.html;
) | /usr/sbin/sendmail -t
rm -f /usr/local/sbin/content200.html
echo "Done"
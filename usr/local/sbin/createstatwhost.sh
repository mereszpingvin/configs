#!/bin/bash

#echo "Enter a domain name : "
#read dname
echo "Starting the add user script:"
    MYUSER=$(pwgen -0A 6 1)
    MYFTPW=$(pwgen 8 1)
echo "New user name: $MYUSER"
echo "Adding new user..."
    useradd -g 100 -G 100 -s /bin/false -d /var/www/users/statdomain/$MYUSER/ $MYUSER
echo "Done"
echo "Create webroot directory..."
    mkdir -p /var/www/users/statdomain/$MYUSER/wwwroot/$1/
echo "Done"
echo "Change directory owner"
    chown -R $MYUSER:users /var/www/users/statdomain/$MYUSER/wwwroot/
echo "Done"
echo "Get UID..."
    IDU=`id -u $MYUSER`
echo "Done"
echo "Create FTP account..."
     FTPQ="use isabella
     INSERT INTO ftpquotalimits (name,quota_type,per_session,limit_type,bytes_in_avail,bytes_out_avail,bytes_xfer_avail,files_in_avail,files_out_avail,files_xfer_avail) VALUES ('$MYUSER', 'user', 'true', 'hard', '525428800', '0', '0', '0', '0', '0');
     INSERT INTO ftpuser (id,userid,passwd,uid,gid,homedir,shell,count,accessed,modified) VALUES (NULL, '$MYUSER', '$MYFTPW', $IDU, 100, '/var/www/users/statdomain/$MYUSER/wwwroot', '/sbin/nologin', 0, '', '');"
     mysql -uroot -pGik2uHGM5cfYpb -e "$FTPQ"
echo "Done"
echo "Creating webserver config..."
count=120
counter=`expr $count + 1`
    sed -e 's/changedomain/'$1'/g' -e 's/default/'$MYUSER'/g' /usr/local/sbin/default_stat.tmpl > /etc/apache2/vhosts.d/"$counter"_"$1".conf
echo "Done"
echo "Restarting apache2..."
    /etc/init.d/apache2 reload
echo "Done"
echo "Sending mail..."
sed -e 's/azonosito/'$MYUSER'/g' -e 's/dmn/'$1'/g' -e 's/ftppasswd/'$MYFTPW'/g' /usr/local/sbin/newsstat50.tmpl > /usr/local/sbin/contentstat50.html
(
echo "From: daemon@mereszpingv.in"
echo "To: admin@mereszpingv.in, ajanlatkeres@mintalap.hu"
echo "MIME-Version: 1.0";
echo "Content-Type: text/html";
echo "Content-Disposition: inline";
echo "Subject: $MYUSER azonositoju 50MB-os statikus tarhely elkeszult";
cat /usr/local/sbin/contentstat50.html;
) | /usr/sbin/sendmail -t
rm -f /usr/local/sbin/contentstat50.html
echo "Done"
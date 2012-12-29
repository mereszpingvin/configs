#!/bin/bash

echo "Creating webserver config..."
count=120
counter=`expr $count + 1`
    sed -e 's/changedomain/'$1'/g' -e 's/url/'$2'/g' /usr/local/sbin/default_redirect.tmpl > /etc/apache2/vhosts.d/"$counter"_"$1".conf
echo "Done"
echo "Restarting apache2..."
    /etc/init.d/apache2 reload
echo "Done"
echo "Sending mail..."
sed -e 's/dname/'$1'/g' -e 's/URL/'$2'/g' -e 's/ftppasswd/'$MYFTPW'/g' /usr/local/sbin/newsstat50.tmpl > /usr/local/sbin/contentstat50.html
(
echo "From: daemon@mereszpingv.in"
echo "To: admin@mereszpingv.in"
echo "MIME-Version: 1.0";
echo "Content-Type: text/html";
echo "Content-Disposition: inline";
echo "Subject: $1 domain nev atiranyitasa megtortent";
cat /usr/local/sbin/contentstat50.html;
) | /usr/sbin/sendmail -t
rm -f /usr/local/sbin/contentstat50.html
echo "Done"
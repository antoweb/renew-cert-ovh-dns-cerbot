#!/bin/bash

today=$(date '+%Y-%m-%d')
ovhcredentialfile="<YOUR OVH CREDENTIALS FILE OVH-DNS-PLUGION CERTBOT FULL ABSOLUTE PATH>"
domain="<DOMAIN CERT TO DO/RENEW>"
certpath="<FULL ABSOLUTE PATH CONTAINING  CERT FILE>"
certkeypath"<FULL ABSOLUTE PATH CONTAINING KEY CERT FILE>"
certname="<CERT FILE NAME>"
certkey="<CERT KEY FULL NAME>"
folder_to_archive="<FOLDE TO ARCHIVE OLD CERTS>"
certemail="<EMAIL TO RECEIVE EXPIRATIO CERT ALERT FROM CERTBOT>"
mailsender="<EMAIL FROM>"
mailto="<EMAIL TO SEND ALERTS>"
telegramconffile="<YOUR TELEGRAM CONFIG FILE>"

#Doing backup to actual cert and key
mkdir -p $folder_to_archive/$today
/usr/bin/cp $certpath/$certname $folder_to_archive/$today/$certname
/usr/bin/cp $certkeypath/$certkey $folder_to_archive/$today/$certkey


#generate new cert and key
/usr/bin/certbot certonly --non-interactive --agree-tos --email $certemail --dns-ovh --dns-ovh-credentials $ovhcredentialfile --dns-ovh-propagation-seconds 60 -d *.$domain

        #Check last command failed in that case sending email
        RETVAL=$?
                if [ ${RETVAL} -ne 0 ]
                then
                echo "ERRORE: EXIT_STATUS=\"${RETVAL}\", MESSAGGIO= Error generating cert see attachment" | mail -s "Error generating cert" -A /var/log/letsencrypt/letsencrypt.log -r $mailsender $mailto
                else

                /usr/local/bin/telegram-send --config $telegramconffile "Generation of cert *.$domain OK"
                fi
#Copy new cert to postfix, dovecot and web mail panel and restart services

> $certpath/$certname
> $certkeypath/$certkey

cat /etc/letsencrypt/live/$domain/fullchain.pem > $certpath/$certname
cat /etc/letsencrypt/live/$domain//privkey.pem > $certkeypath/$certkey


systemctl restart postfix
        #Check last command failed in that case sending email
        RETVAL=$?
                if [ ${RETVAL} -ne 0 ]
                then
                echo "ERRORE: EXIT_STATUS=\"${RETVAL}\", MESSAGGIO= Error restarting postfix after copying new cert *.$domain see attachment"  | mail -s "Error restarting postfix " -A /var/log/mail.err -r $mailsender $mailto
                else

                /usr/local/bin/telegram-send --config $telegramconffile "Restart postfix after copying new cert *.$domain OK"
                fi


systemctl restart dovecot > /temp/restart_dovecot.log 2>&1

        #Check last command failed in that case sending email
        RETVAL=$?
                if [ ${RETVAL} -ne 0 ]
                then
                echo "ERRORE: EXIT_STATUS=\"${RETVAL}\", MESSAGGIO= Error restarting dovecot after copying new cert *.$domain see attachment"  | mail -s "Error restarting dovecot " -A /temp/restart_dovecot.log -r $mailsender $mailto
                else

                /usr/local/bin/telegram-send --config $telegramconffile "Restart dovecot after copying new cert *.$domain OK"
                fi

systemctl restart nginx

        #Check last command failed in that case sending email
        RETVAL=$?
                if [ ${RETVAL} -ne 0 ]
                then
                echo "ERRORE: EXIT_STATUS=\"${RETVAL}\", MESSAGGIO= Error restarting nginx after copying new cert *.$domain see attachment"  | mail -s "Error restarting nginx " -A /var/log/nginx/mail.$domain-error.log -r $mailsender $mailto
                else

                /usr/local/bin/telegram-send --config $telegramconffile "Restart nginx after copying new cert *.$domain OK"
                fi

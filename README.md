# renew-cert-ovh-dns-cerbot
This script comes with absolutely no warranty, check all lines before execute it, your environment may be different

Script to renew a certificate troutgh certbot aand och domain automatically (dns challenge)

This script allow to renew automatically a ovh domain trought certbot and cerbot-dns-ovh-plugin, see: https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal&tab=wildcard (instruction)
plugin certbot-dns-och doc: https://certbot-dns-ovh.readthedocs.io/en/stable/#
You can use any other provider if is compatible (script must be modified), see list: https://eff-certbot.readthedocs.io/en/latest/using.html#dns-plugins

Script requirements:
- OVH Domain
- certbot and certbot-dns-ovh installed and configured: see https://certbot-dns-ovh.readthedocs.io/en/stable/#
  quick info: you have to generate token in ovh api here: EU --> https://eu.api.ovh.com/createToken/ US --> https://ca.api.ovh.com/createToken/
  configure credentials like /root/certbot-ovh-crednetials.ini see documentation linked above
- This script send also telegram notification (not mandatory) you have to install and configure telegram-send, doc: https://github.com/rahiel/telegram-send
- Postfix installed and capable to send email itself or trough mail relay es: https://www.linode.com/docs/guides/postfix-smtp-debian7/

Usage instructions:
Download script renew-cert-ovh-dns-cerbot.sh
chmod +x renew-cert-ovh-dns-cerbot.sh

Please valorise all variables in first lines

```
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
telegramconffile="<YOUR TELEGRAM CONFIG FILE  
```

Cron the script every 3 months like this:  
```
00 00 28 3,6,9,12 * root <FULL ABSOLUTE PATH OF THIS SCRIPT>
```

PAYPAL DONTAION  
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/sistemistaitaliano/1)

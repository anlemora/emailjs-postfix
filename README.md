### NOTE: This tutorial is not complete, it still misses the multiple domain certificate usage.

# emailjs-postfix
Setting up emailjs config for usage with Postfix.

## Steps

#### Login to root.
`sudo su -`

#### Install packages.
`apt-get install mysql-server postfix postfix-mysql dovecot-core dovecot-imapd dovecot-lmtpd dovecot-mysql`

#### Create a new app user to hold the necessary ssl files
`adduser app`
>You don't need to fill the user detais, but the password

#### Give sudo access to the app user
`usermod -aG sudo app`

#### Upload the ssl files to the app user
From your local machine:  
`scp -r ssl_folder root@<yourserverip>:`

The folder will be uploaded to your server at `/root/ssl_folder`

#### Move the files to the app home folder and change the owner
`mv /root/ssl_folder /home/app/encryption`  
`chown app:app /home/app/encryption`

#### Configure MySQL
`mysql_secure_installation`
>Use a strong password for root and disable everything else.

#### Create the database for mailing.
`mysqladmin -p create servermail`

#### Run the DBMailConfig.sql script as root.
`mysql -u root -p servermail < DBMailConfig.sql`

#### Create a copy of the default configuration and one of the master configuration.
`cp /etc/postfix/main.cf /etc/postfix/main.cf.orig`  
`cp /etc/postfix/master.cf /etc/postfix/master.cf.orig`

#### Replace `/etc/postfix/main.cf` and `/etc/postfix/master.cf` with the ones in this repo.

#### Copy all the `mysql-virtual` files from this repo into `/etc/postfix/`.

#### Restart Postfix.
`service postfix restart`

#### Create copies of Dovecot's config files.
    cp /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.orig
    cp /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.orig
    cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.orig
    cp /etc/dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext.orig
    cp /etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf.orig
    cp /etc/dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf.orig

#### Replace each of the following files with the ones in this repo.
    /etc/dovecot/dovecot.conf
    /etc/dovecot/dovecot-sql.conf.ext
    /etc/dovecot/conf.d/10-auth.conf
    /etc/dovecot/conf.d/10-mail.conf
    /etc/dovecot/conf.d/10-master.conf
    /etc/dovecot/conf.d/10-ssl.conf
    /etc/dovecot/conf.d/auth-sql.conf.ext

#### Create vmail user and group.
`groupadd -g 5000 vmail`  
`useradd -g vmail -u 5000 vmail -d /var/mail`

#### Configure vmail folder permissions and owner for vmail user.
`chmod -R 2775 /var/mail/`  
`chown -R vmail:vmail /var/mail`

#### Create a folder inside `/var/mail/vhosts/` for each domain registered in the DB.
`mkdir -p /var/mail/vhosts/unahil.com`

#### Change owner and permissions for dovecot folder.
`chown -R vmail:dovecot /etc/dovecot`  
`chmod -R o-rwx /etc/dovecot` 

#### Restart dovecot.
`service dovecot restart`

### NOTE: This tutorial is not complete, it still misses the users initial setup, certificates uploading and multiple domain certificate usage.

# emailjs-postfix
Setting up emailjs config for usage with Postfix.

## Steps

#### 1. Login to root.
`sudo su -`

#### 2. Install packages.

`apt-get install mysql-server postfix postfix-mysql dovecot-core dovecot-imapd dovecot-lmtpd dovecot-mysql`

#### 3. Configure MySQL
`mysql_secure_installation`
>Use a strong password for root and disable everything else.

#### 4. Create the database for mailing.
`mysqladmin -p create servermail`

#### 5. Run the DBMailConfig.sql script as root.
`mysql -u root -p servermail < DBMailConfig.sql`

#### 6. Create a copy of the default configuration and one of the master configuration.
`cp /etc/postfix/main.cf /etc/postfix/main.cf.orig`
`cp /etc/postfix/master.cf /etc/postfix/master.cf.orig`

#### 7. Replace `/etc/postfix/main.cf` and `/etc/postfix/master.cf` with the ones in this repo.

#### 8. Copy all the `mysql-virtual` files from this repo into `/etc/postfix/`.

#### 9. Restart Postfix.
`service postfix restart`

#### 10. Create copies of Dovecot's config files.
    cp /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.orig
    cp /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.orig
    cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.orig
    cp /etc/dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext.orig
    cp /etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf.orig
    cp /etc/dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf.orig

#### 11. Replace each of the following files with the ones in this repo.
    /etc/dovecot/dovecot.conf
    /etc/dovecot/dovecot-sql.conf.ext
    /etc/dovecot/conf.d/10-auth.conf
    /etc/dovecot/conf.d/10-mail.conf
    /etc/dovecot/conf.d/10-master.conf
    /etc/dovecot/conf.d/10-ssl.conf
    /etc/dovecot/conf.d/auth-sql.conf.ext

#### 14. Create vmail user and group.
`groupadd -g 5000 vmail`  
`useradd -g vmail -u 5000 vmail -d /var/mail`

#### 13. Configure vmail folder permissions and owner for vmail user.
`chmod -R 2775 /var/mail/`  
`chown -R vmail:vmail /var/mail`

#### 14. Create a folder inside `/var/mail/vhosts/` for each domain registered in the DB.
`mkdir -p /var/mail/vhosts/unahil.com`

#### 15. Change owner and permissions for dovecot folder.
`chown -R vmail:dovecot /etc/dovecot`  
`chmod -R o-rwx /etc/dovecot` 

#### 16. Restart dovecot.
`service dovecot restart`


    
    
  

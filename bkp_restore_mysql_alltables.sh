#!/bin/bash
#Copyright itwm.info.
#Developed by Clube da Tecnologia.
#dev        :Guilherme Pacheco
#created    :07/02/2015

#edited by: Guilherme Pacheco	
#edit	  : 29/12/2018

#sysdate = date "+%d/%m/%y - %H:%M:%S"
ask(){
   echo ""
   echo "Press ENTER to back"   
   echo ""
   read BACK   
}

read_secret()
{
	# Disable echo.
    stty -echo

    # Set up trap to ensure echo is enabled before exiting if the script
    # is terminated while echo is disabled.
    trap 'stty echo' EXIT

    # Read secret.
    read "$@"

    # Enable echo.
    stty echo
    trap - EXIT

    # Print a newline because the newline entered by the user after
    # entering the passcode is not echoed. This ensures that the
    # next line of output begins at a new line.
    echo
}
mysqllogin()
{
#Script to as user em password, this is secure.
echo "MySql User..."
read MYSQLUSER
echo "Put your password..."
read_secret PASS
}
bkpalldatabases(){
	sudo mysqldump -u $MYSQLUSER --password=$PASS --all-databases > all_databases.sql
}
restorealldatabases(){
	mysql --user=$MYSQLUSER --password=$PASS --comments  < all_databases.sql
}
mysqllogin
while true
do
   clear
   echo ""
   echo "...::::Backup Restore Mysql Databases:::..."
   echo ""
   echo "0 - Exit."
   echo "1 - Backup all databases."
   echo "2 - Restore all databases."
   echo "3 - Show all MySQL users."
   echo "4 - Change MySQL user password."
   echo "5 - Mirroing the tables to other remote host."
   echo "6 - MySQL log file."
   echo "7 - Restart Mysql."
   echo "8 - All running Mysql server process status."
   echo "9 - Check Mysql version."
   echo "10 - All Flushes."
   echo "\n: "
   read op
 
   case $op in
      1) while true; do
            clear
            bkpalldatabases
            ask
 
            while [ -n "$BACK" ]; do
               clear
               bkpalldatabases
               ask
            done
 
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
 
      2) while true; do
            clear
            restorealldatabases
            ask
 
            while [ -n "$BACK" ]; do
               clear
               restorealldatabases
               ask
            done
 
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
 
      3) while true; do
            clear
            echo ""
            sudo mysql --user $MYSQLUSER --password=$PASS -e "select Host, User, password_last_changed, account_locked from mysql.user"
            ask
    
            while [ -n "$BACK" ]; do
                clear
				echo ""
				sudo mysql --user $MYSQLUSER --password=$PASS -e "select Host, User, password_last_changed, account_locked from mysql.user"
				ask
            done
             
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
	4) while true; do
            clear
            sudo mysqladmin -u $MYSQLUSER -p$PASS password
            ask
    
            while [ -n "$BACK" ]; do
               clear
               echo ""
               sudo mysqladmin -u $MYSQLUSER -p$PASS password
               ask
            done
             
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
	5) while true; do
            clear
            echo "Type the localhost database to mirroring"
            read DATABASENAME
			echo "Type the remotehost database to mirroring"
            read REMOTEDATABASENAME
            echo "Type the remotehost IPV4"
            read REMOTEIPV
            echo "Type the remotehost MySQL yser"
            read REMOTEUSER
            echo "The next is the remote host user password"
            mysqldump --user $MYSQLUSER --password=$PASS $DATABASENAME | mysql -h $REMOTEIPV -u $REMOTEUSER -p $REMOTEDATABASENAME
            ask
    
            while [ -n "$BACK" ]; do
				clear
				echo "Type the localhost database to mirroring"
				read DATABASENAME
				echo "Type the remotehost database to mirroring"
				read REMOTEDATABASENAME
				echo "Type the remotehost IPV4"
				read REMOTEIPV
				echo "Type the remotehost MySQL yser"
				read REMOTEUSER
				echo "The next is the remote host user password"
				mysqldump --user $MYSQLUSER --password=$PASS $DATABASENAME | mysql -h $REMOTEIPV -u $REMOTEUSER -p $REMOTEDATABASENAME
				ask
            done
             
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
        6) while true; do
			   clear
               echo "0 - Exit."
			   echo "1 - Just errors"
			   echo "2 - Just Warnings"
			   echo "3 - Just Notes"
			   echo "4 - All log"
			   read sixop
 
			   case $sixop in
				  1) while true; do
						clear
						cat /var/log/mysql/error.log | grep "Error"
						ask
			 
						while [ -n "$BACK" ]; do
						   clear
							cat /var/log/mysql/error.log | grep "Error"
							ask
						done
			 
						if [ -z "$BACK" ]; then
						   break
						fi
					done
					;;
					2) while true; do
						clear
						cat /var/log/mysql/error.log | grep "Warning"
						ask
			 
						while [ -n "$BACK" ]; do
						   clear
							cat /var/log/mysql/error.log | grep "Warning"
							ask
						done
			 
						if [ -z "$BACK" ]; then
						   break
						fi
					done
					;;
					3) while true; do
						clear
						cat /var/log/mysql/error.log | grep "Note"
						ask
			 
						while [ -n "$BACK" ]; do
						   clear
							cat /var/log/mysql/error.log | grep "Note"
							ask
						done
			 
						if [ -z "$BACK" ]; then
						   break
						fi
					done
					;;
					3) while true; do
						clear
						cat /var/log/mysql/error.log
						ask
			 
						while [ -n "$BACK" ]; do
						   clear
							cat /var/log/mysql/error.log
							ask
						done
			 
						if [ -z "$BACK" ]; then
						   break
						fi
					done
					;;
				0) clear ; echo "" ; echo "Ending" ; sleep 1; clear; break
				;;
				*) echo "" ; echo "Invalid Option" ; sleep 1 ; echo ""
				;;
				esac
    
            while [ -n "$BACK" ]; do
               clear
               echo ""
               cat /var/log/mysql/error.log | grep "Warning"
               ask
            done
             
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
	7) while true; do
            clear
            echo "Stoping..."
            sudo service mysql stop
            echo "Stoped"
            echo "Starting..."
            sudo service mysql start
            echo "Started"
            ask
    
            while [ -n "$BACK" ]; do
               clear
                echo "Stoping..."
				sudo service mysql stop
				echo "Stoped"
				echo "Starting..."
				sudo service mysql start
				echo "Started"
               ask
            done
             
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
    8) while true; do
            clear
            mysqladmin -u $MYSQLUSER --password=$PASS -p processlist
            ask
    
            while [ -n "$BACK" ]; do
               clear
                
				mysqladmin -u $MYSQLUSER --password=$PASS -p processlist
               ask
            done
             
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
    9) while true; do
            clear
            mysqladmin -u $MYSQLUSER --password=$PASS version
            ask
    
            while [ -n "$BACK" ]; do
               clear
				mysqladmin -u $MYSQLUSER --password=$PASS version
               ask
            done
             
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
	10) while true; do
            clear
            echo "Flushing..."
            mysqladmin -u $MYSQLUSER --password=$PASS flush-hosts flush-tables flush-threads flush-logs flush-privileges flush-status
            echo "Flush done!"
            ask
    
            while [ -n "$BACK" ]; do
               clear
                
				mysqladmin -u $MYSQLUSER --password=$PASS version
               ask
            done
             
            if [ -z "$BACK" ]; then
               break
            fi
         done
         ;;
      0) clear ; echo "" ; echo "Ending Program" ; sleep 1; clear; break
         ;;
 
      *) echo "" ; echo "Invalid Option" ; sleep 1 ; echo ""
         ;;
   esac
done


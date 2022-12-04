#!/bin/bash
set -x

#Global variables declared:
name=Ayush
s3=upgrad-ayush

#Update of the package details and the package list
update_package() {
        sudo apt update -y
        echo "Package update is completed!"
        sleep 5
}

#Install the apache2 package
install_apache2() {
        echo "Checking apache2 existing installation...."
        process=`dpkg --get-selections | grep apache | wc -l`
        if [ $process -eq 0 ]
        then
                echo "Installing Apache!"
                sudo apt-get install apache2
        else
                echo "Apache2 is already installed!"
        fi
}

#Ensure that the apache2 service is running
check_apache2(){
        echo "Check if apache2 is up!"
        process=`service --status-all | grep apache2 | wc -l`
        sleep 3
        if [ $process != 0 ]; then
                echo "Apache2 is up and running!"
        else
                echo "Apache2 is down, initiating start!"
                sudo service apache2 start
        fi
}

#Ensure that the apache2 service is enabled
enable_apache2() {
        process=`systemctl status apache2.service| grep enabled | wc -l`
        sleep 3
        if [ $count != 0 ]; then
                echo "Apache2 is already enabled!"
        else
                echo "Apache2 is not enabled, initiating service enablement"
        sudo systemctl enable apache2.service
        fi
}

#Tar archive of apache2 access logs and error logs
archive_logs() {
        echo "Taring apache2 logs.."
        timestamp=$(date '+%d%m%Y-%H%M%S')
        tar -cvf /tmp/$name-httpd-logs-$timestamp.tar /var/log/apache2/*.log
        aws s3 cp /tmp/$name-httpd-logs-$timestamp.tar s3://$s3/$name-httpd-logs-$timestamp.tar
}

#Bookkeeping
book_keeping() {
        inventory_file="/var/www/html/inventory.html"
        if [ -f "$inventory_file" ]; then
                echo "$inventory_file exists!"
        else
                echo "Creating $inventory_file"
                echo "Log Type              Date Created                    Type        Size" >> $inventory_file
        fi
        size=`du -sh /tmp/$name-httpd-logs-$timestamp.tar | awk  '{print $1}'`
        echo "httpd-logs            $timestamp                 tar         $size" >> $inventory_file
}

#CronJob
cron_job() {
        cron_file="/etc/cron.d/automation"
        if [ -f "$cron_file" ]; then
            echo "$cron_file exists."
        else
                echo "Creating $cron_file"
                echo "0 11 * * * root sh /root/Automation_Project/automation.sh" >> $cron_file
        fi
}

#Task2 Steps:
update_package
install_apache2
check_apache2
enable_apache2
archive_logs
book_keeping
cron_job

#Automation Project

->Upgrad Assignment(DevOps Module)

This script carries out the subsequent tasks:

1. Perform a package update.
2. If the apache2 package is not already installed, then install it.
3. Check to see if the apache2 service is enabled.
4. Make sure the apache2 service is running.
5. The access logs and error logs from the apache2 directory located in /var/log/apache2/ should be created as a tar archive and put into the /tmp/ directory.
6. The script needs to copy the archive to the s3 bucket and execute the AWS CLI command.

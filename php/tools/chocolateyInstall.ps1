write-host 'Please make sure you have CGI installed in IIS'
Install-ChocolateyPackage 'php' 'msi' "/passive INSTALLDIR=$($env:SystemDrive)\php ADDLOCAL=cgi,ext_php_mysqli,iis4CGI,iis4FastCGI,ext_php_mysql,ext_php_xsl,ext_php_ldap,ext_php_curl" 'http://windows.php.net/downloads/releases/php-5.3.6-nts-Win32-VC9-x86.msi'


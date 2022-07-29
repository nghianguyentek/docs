# Setup PHP

- [macOS](#macos)

## macOS

### 1. Check if PHP is in your machine or not

```shell
php --version
```

### 2. Installing PHP through Homebrew

```
brew install php
```

### 3. Sign code

```shell
codesign -v -s "nn1211" -f --keychain /Library/Keychains/System.keychain /usr/local/opt/php/lib/httpd/modules/libphp.so
```

### 4. Edit httpd.conf with root privilege

```shell
sudo vim /etc/apache2/httpd.conf
```

httpd.config

```
LoadModule php_module /usr/local/opt/php/lib/httpd/modules/libphp.so "nn1211"
<FilesMatch .php$>
    SetHandler application/x-httpd-php
</FilesMatch>
```

### 5. Restart Apache Server

```shell
sudo apachectl restart
```

### 6. Compose a test file

```shell
cd /Library/WebServer/Documents/
sudo vim hello.php
```

hello.php

```php
<!DOCTYPE html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width; initial-scale=1">
  <title>Hello PHP</title>
 </head>
 <body>
 <?php echo '<p>Hello PHP!</p>'; ?> 
 </body>
</html>
```

### 7. View the result

Open a browser and go to `http://localhost/hello.php`
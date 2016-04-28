# NiceCatch Setup
----
## Set Up Database
1. Create a new database and record its login information
2. Connect to the database and import the nicecatch-db-backup.sql file

## Set up API
1. the "web" folder is your `public_html` folder. Copy its contents into your public\_html folder.
2. Change the database settings in `web/nc-db-settings.php` to reflect the correct db information
3. in the "web" folder there should be a .htaccess file. It may not have copied since it is a hidden file. Copy it over to your public_html folder.
4. Change the .htaccess file to point to your api by chaning the path. Use an absolute path here (the htaccess file is shown below, indicating what to change)
5. If you run into any issues, make sure you're using https (if on Clemson's servers). Otherwise, check the article linked below to make sure everything is set up properly.


    <IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule api/v1/(.*)$ /Users/CHANGE THIS/web/api/v1/api.php?request=$1     [QSA,NC,L]
    </IfModule>

## Changing the API
This is a RESTful API.
A tutorial on RESTful APIs can be found [here](http://www.restapitutorial.com)
A tutorial on how I created this can be found [here](http://coreymaynard.com/blog/creating-a-restful-api-with-php/)

The endpoints are controlled by the `/api/v1/class.NiceCatchAPI.php` file
The Models that support the endpoints can be found in /models
* class.Database.php (for accessing db)
* class.Location.php (for handling building/room actions)
* class.Person.php (for managing all information about a person)
* class.Report.php (for working with reports. This uses the Location and Person classes)

**A (mostly) complete documentation for accessing the api can be found in HTML form at** `/api/api-doc.html`
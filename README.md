[![](https://images.microbadger.com/badges/image/cgrima/i-librarian.svg)](https://microbadger.com/images/cgrima/i-librarian "Get your own image badge on microbadger.com")


This is a Dockerfile for [I, Librarian][1]. Now using php7. Please, Look at the following instructions.

**Prerequisites**
----------
If you do not already have an [I, Librarian][1] library, you must download a blank library folder to initiate the library on the host before to run the container. To do so, from within the location you want the library  (you might need to install the *xz-utils* package):

```
wget -O i-librarian.tar.xz http://i-librarian.net/downloads/I,-Librarian-3.4-Linux.tar.xz
unxz i-librarian.tar.xz && tar -xvf i-librarian.tar library && rm i-librarian.tar
```
Then, change their ownership:

```
sudo chown -R www-data:www-data library
sudo chown root:root library/.htaccess
```
**Run the container (start [I, Librarian][1])**
-------------
    sudo docker run -d -p 8080:80 -v {LIBRARY_PATH}:/library -v /etc/localtime:/etc/localtime:ro --name=i-librarian grimy55/i-librarian

where `{LIBRARY_PATH}` is the path to your library location on the host

**Connect to [I, Librarian][1]**
---------
open *http://localhost:8080* on your web browser 

*Troubleshoot*
---------
To avoid rights and permissions issues with the library folder:

- Make sure the **uid:gid** is **33:33** for the **user:group** called **www-data:www-data** on your host. For Linux distributions like Fedora, you may have to create this user and group with the right ids:

```
sudo groupadd -g 33 www-data && sudo useradd -g 33 -u 33 www-data
```

- If still not working, try to add the `--privileged=true` option to the docker run command.

  [1]: http://i-librarian.net/

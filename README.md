This is a Dockerfile for [I, Librarian][1]. Please, Look at the following instructions.

**Prerequisites**
----------
If you do not already have an [I, Librarian][1] library, you must download a blank library folder to initiate the library on the host before to run the container. To do so, from within the location you want the library  (you might need to install the *xz-utils* package):

    wget -O i-librarian.tar.xz http://i-librarian.net/downloads/I,-Librarian-3.4-Linux.tar.xz
    unxz i-librarian.tar.xz && tar -xvf i-librarian.tar library && rm i-librarian.tar

Then, change their ownership:

    sudo chown -R www-data:www-data library
    sudo chown root:root library/.htaccess

**Run the container (start [I, Librarian][1])**
-------------
    sudo docker run -d -p 8080:80 -v {LIBRARY_PATH}:/library -v /etc/localtime:/etc/localtime:ro --name=i-librarian grimy55/i-librarian

where {LIBRARY_PATH} is the path to your library location on the host

**Connect to [I, Librarian][1]**
---------
open *http://localhost:8080* on your web browser 

  [1]: http://i-librarian.net/

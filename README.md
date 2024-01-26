
This is a Dockerfile for [I, Librarian](http://i-librarian.net/). Please, Look at the following instructions.

# Prerequisites

If you do not already have an [I, Librarian](http://i-librarian.net/) database, you must create a blank library folder `${DATA_PATH}` to initiate the library on the host before to run the container, and set up its ownership correctly.
```bash
mkdir ${DATA_PATH}
sudo chown 33:33 ${DATA_PATH}
```

# Run the container

## On the command line

```
sudo docker run -d -p 8080:80 \
            -v ${DATA_PATH}:/app/data \
            -v /etc/localtime:/etc/localtime:ro \
            --name=i-librarian \
            cgrima/i-librarian
```

## Docker-compose

Create your docker-compose.yml file such as

```
version: "2"

services:

  app:
    image: cgrima/i-librarian
    privileged: true
    ports:
      - "8080:80"
    volumes:
      - ${DATA_PATH}:/app/data
      - /etc/localtime:/etc/localtime:ro
```

Then, start docker-compose

```
docker-compose up -d
```

# Access your I-librarian instance

Open [http://localhost:8080](http://localhost:8080) on your web browser and follow instructions.

# Migration from [I, Librarian](http://i-librarian.net/) 4.10 to 5.*

Note: The 4.10 database folder was called `library`. It is called `data` in 5.*.

1. Stop your 4.10 [I, Librarian](http://i-librarian.net/) container, i.e. `docker-compose stop i-librarian`
2. Backup your 4.10 `library/` folder.
3. Remove your 4.10 [I, Librarian](http://i-librarian.net/) container, i.e. `docker-compose rm i-librarian`.
4. Rebuild the [I, Librarian](http://i-librarian.net/) image from latest source, i.e. `docker-copomse up -d`.
5. Build and Launch your new 5.* [I, Librarian](http://i-librarian.net/) container following one of the statements above but add you former 4.10 database folder as volume, 
i.e. `-v ${LIBRARY_PATH}:/app/library`.
6. Connect to [http://localhost:8080](http://localhost:8080) and follow the migration instructions (the library folder to migrate is `/app/library`).

# Update
Simply stop, pull the new version, and launch your container again. With docker compose:
```
docker compose down
docker compose pull
docker compose up -d
```

# Troubleshoot

If you have rights/permissions issues with the library folder try to add the `--privileged=true` option to the docker run command.

### Requirements:
- Docker
- Docker Compose
- Git

### Using:

- Make a copy of `.env_sample` called `.env`
- Change the values in `.env` to match your settings. (IE: Update AppID for whatever dedicated server you're running)
- Make a copy of `server_example.cfg` called `server.cfg` and change settings as necessary
- Make a copy of `mount_example.cfg` called `mount.cfg` and change as necessary
- Setup your maps/addon dirs. The default is inside the project directory (./gmod_maps and ./gmod_addons)
- Make a copy of `start-server_example.sh` called `start-server.sh` You shouldn't probably need to change anything in here, but if need be edit to your needs.
- Run `docker-compose up -d --build` to build the server image with the specified settings/files, and bring the server up. Any subsequent changes to:
     - Envvars prefixed with GAME
     - Port
     - Files such as mount.cfg/server.cfg/start-server.sh, directories, etc

Will require a rebuild with `docker-compose build --no-cache` (We force no cache since we always want updated files, etc)

### Credits:

- Valve (SteamCMD, etc)
- Suchipi (https://github.com/suchipi/gmod-server-docker) (Forked repository and edited)
